package msgpack

import "base:intrinsics"
import "base:runtime"
import "core:bufio"
import "core:bytes"
import "core:encoding/endian"
import "core:io"
import "core:mem"
import "core:reflect"
import "core:slice"
import "core:strings"
import "core:time"

Unpacker :: struct {
	r:            io.Reader,
	reader:       ^bufio.Reader,
	allocator:    runtime.Allocator,
	bytes_reader: ^bytes.Reader,
}

Unpack_Error :: union {
	io.Error,
	Unexpected,
	Invalid_Parameter,
	Slice_Length_Mismatch,
	Unhandled_Tag,
	runtime.Allocator_Error,
}

// Note: this will allocate a reader on the allocator, that has to be freed.
unpacker_from_bytes :: proc(b: []u8, allocator := context.allocator) -> Unpacker {
	reader := new(bytes.Reader, allocator)
	stream := bytes.reader_init(reader, b)
	io_reader := io.to_reader(stream)

	u := unpacker_from_reader(io_reader, allocator)
	u.bytes_reader = reader

	return u
}

unpacker_from_reader :: proc(reader: io.Reader, allocator := context.allocator) -> Unpacker {
	buffered_reader := new(bufio.Reader)
	bufio.reader_init(buffered_reader, reader, allocator = allocator)

	return Unpacker{reader, buffered_reader, allocator, nil}
}

unpacker_destroy :: proc(u: Unpacker) {
	if u.bytes_reader != nil {
		free(u.bytes_reader)
	}
	bufio.reader_destroy(u.reader)
	free(u.reader)
}

unpack_into_from_bytes :: proc(
	b: []u8,
	ptr: ^$T,
	allocator := context.allocator,
) -> (
	err: Unpack_Error,
) {
	u := unpacker_from_bytes(b, allocator)
	defer unpacker_destroy(u)

	return read_into(&u, ptr)
}

unpack_into_from_reader :: proc(
	reader: io.Reader,
	ptr: ^$T,
	temp_allocator := context.allocator,
) -> (
	err: Unpack_Error,
) {
	u := unpacker_from_reader(reader, temp_allocator)
	defer unpacker_destroy(u)

	return read_into(&u, ptr)
}

unpack_from_bytes :: proc(
	b: []u8,
	allocator := context.allocator,
) -> (
	obj: Object,
	err: Unpack_Error,
) {
	u := unpacker_from_bytes(b, allocator)
	defer unpacker_destroy(u)

	return read(&u)
}

unpack_from_reader :: proc(
	reader: io.Reader,
	allocator := context.allocator,
) -> (
	obj: Object,
	err: Unpack_Error,
) {
	unpacker := unpacker_from_reader(reader, allocator)
	return read(&unpacker)
}

read_byte :: proc(u: ^Unpacker) -> (b: u8, err: Unpack_Error) {
	ioerr: io.Error
	b, ioerr = bufio.reader_read_byte(u.reader)
	if intrinsics.expect(ioerr != .None, false) {
		err = ioerr
	}

	return b, err
}

read_bytes :: proc(u: ^Unpacker, $bytes: u64) -> (out: [bytes]u8, err: Unpack_Error) {
	n: u64 = 0
	for n < bytes {
		nn, ioerr := bufio.reader_read(u.reader, out[n:])
		n += u64(nn)
		if ioerr != .None {
			err = ioerr
			break
		}
	}

	return out, err
}

read_bytes_into_slice :: proc(u: ^Unpacker, out: []u8) -> (err: Unpack_Error) {
	n: int = 0
	for n < len(out) {
		nn, ioerr := bufio.reader_read(u.reader, out[n:])
		n += nn
		if ioerr != .None {
			err = ioerr
			break
		}
	}

	return err
}

read_number_swapped :: proc(u: ^Unpacker, $T: typeid) -> (number: T, err: Unpack_Error) {
	number = transmute(T)read_bytes(u, size_of(T)) or_return
	when NEEDS_SWAP {
		when T != u8 && T != i8 {
			number = intrinsics.byte_swap(number)
		}
	}

	return number, nil
}

read_size :: proc(u: ^Unpacker, width: u64) -> (size: u64, err: Unpack_Error) {
	for i in 0 ..< width {
		b := read_byte(u) or_return
		size = size << 8 | u64(b)
	}

	return
}

read_map :: proc(u: ^Unpacker, size: int) -> (item: Object, err: Unpack_Error) {
	out := make(map[ObjectKey]Object, 0, u.allocator)
	defer if err != nil {
		delete(out)
	}

	for _ in 0 ..< size {

		key: ObjectKey

		value: Object
		key = read_key(u) or_return
		value = read(u) or_return

		map_insert(&out, key, value)
	}

	return out, nil
}

read_string :: proc(u: ^Unpacker, size: int) -> (value: string, err: Unpack_Error) {
	buffer := make([]u8, size, u.allocator)
	defer if err != nil {
		delete(buffer)
	}
	read_bytes_into_slice(u, buffer[:]) or_return

	s := string(buffer[:])
	return s, nil
}

read_bin :: proc(u: ^Unpacker, size: int) -> (value: []bin, err: Unpack_Error) {
	buffer := make([]u8, size, u.allocator)
	read_bytes_into_slice(u, buffer[:]) or_return

	return transmute([]bin)buffer, nil
}

read_array :: proc(u: ^Unpacker, size: int) -> (item: []Object, err: Unpack_Error) {
	out := make([]Object, size, u.allocator)
	defer if err != nil {
		delete(out)
	}

	for i in 0 ..< size {
		o := read(u) or_return
		out[i] = o
	}

	return out, nil
}


read_uint :: proc(u: ^Unpacker, tag: Uint) -> (item: Object, err: Unpack_Error) {
	switch tag.width {
	case 1:
		return u64(read_number_swapped(u, u8) or_return), nil
	case 2:
		return u64(read_number_swapped(u, u16) or_return), nil
	case 4:
		return u64(read_number_swapped(u, u32) or_return), nil
	case 8:
		return u64(read_number_swapped(u, u64) or_return), nil
	}

	unreachable()
}

read_float :: proc(u: ^Unpacker, tag: Float) -> (item: Object, err: Unpack_Error) {
	if tag.is_double {
		return read_number_swapped(u, f64)
	} else {
		return read_number_swapped(u, f32)
	}
}

read_sint :: proc(u: ^Unpacker, tag: Int) -> (item: Object, err: Unpack_Error) {
	switch tag.width {
	case 1:
		return i64(read_number_swapped(u, i8) or_return), nil
	case 2:
		return i64(read_number_swapped(u, i16) or_return), nil
	case 4:
		return i64(read_number_swapped(u, i32) or_return), nil
	case 8:
		return i64(read_number_swapped(u, i64) or_return), nil
	}

	unreachable()
}

read_timestamp_ext1 :: proc(b: []u8) -> time.Time {
	defer delete(b)

	count := len(b)
	t: time.Time

	switch count {
	case 4:
		// 32-bit unix-seconds
		seconds, _ := endian.get_u32(b[:4], .Big)
		t = time.unix(i64(seconds), 0)
	case 8:
		data, _ := endian.get_u64(b[:8], .Big)
		ns := i64(data >> 34)
		seconds := i64(data & 0x3FFFFFFFF)
		t = time.unix(seconds, ns)
	case 12:
		nsec, _ := endian.get_u32(b, .Big)
		sec, _ := endian.get_u64(b[4:], .Big)
		t = time.unix(i64(sec), i64(nsec))
	}

	return t
}

read_ext :: proc(u: ^Unpacker, type: i8, size: int) -> (item: Object, err: Unpack_Error) {
	bytes := make([]u8, size, u.allocator)
	defer if err != nil {
		delete(bytes)
	}

	read_bytes_into_slice(u, bytes) or_return

	if type == -1 {
		return read_timestamp_ext1(bytes), nil
	} else {
		delete(bytes)
		err = Unexpected{"a known ext", "unknown ext"}
	}

	return
}

read_key :: proc(u: ^Unpacker) -> (item: ObjectKey, err: Unpack_Error) {
	// XXXX[TS]: This is mostly copied from below.
	tag := decode_tag(u) or_return

	#partial switch variant in tag {
	case Str:
		str := read_string(u, int(variant.length)) or_return
		return ObjectKey(str), nil

	case Positive_Fixint:
		return ObjectKey(u64(variant.value)), nil

	case Negative_Fixint:
		return ObjectKey(i64(variant.value)), nil

	case Uint:
		switch variant.width {
		case 1:
			return u64(read_number_swapped(u, u8) or_return), nil
		case 2:
			return u64(read_number_swapped(u, u16) or_return), nil
		case 4:
			return u64(read_number_swapped(u, u32) or_return), nil
		case 8:
			return u64(read_number_swapped(u, u64) or_return), nil
		}
	case Int:
		switch variant.width {
		case 1:
			return i64(read_number_swapped(u, i8) or_return), nil
		case 2:
			return i64(read_number_swapped(u, i16) or_return), nil
		case 4:
			return i64(read_number_swapped(u, i32) or_return), nil
		case 8:
			return i64(read_number_swapped(u, i64) or_return), nil
		}

	case Float:
		if variant.is_double {
			return ObjectKey(read_number_swapped(u, f64) or_return), nil
		} else {
			return ObjectKey(read_number_swapped(u, f32) or_return), nil
		}

	case Bool:
		return ObjectKey(variant.value), nil

	case:
		panic("xxx")
	// return nil, Unexpected{"a valid key type", tag_name(tag)}
	}

	unreachable()
}

read :: proc(u: ^Unpacker) -> (item: Object, err: Unpack_Error) {
	tag := decode_tag(u) or_return

	switch variant in tag {
	case Positive_Fixint:
		return u64(variant.value), nil
	case Map:
		return read_map(u, int(variant.length))
	case Array:
		return read_array(u, int(variant.length))
	case Str:
		return read_string(u, variant.length)
	case Nil:
		return nil, nil
	case Bool:
		return variant.value, nil
	case Bin:
		return read_bin(u, variant.length)
	case Ext:
		return read_ext(u, variant.type, variant.length)
	case Float:
		return read_float(u, variant)
	case Uint:
		return read_uint(u, variant)
	case Int:
		return read_sint(u, variant)
	case Negative_Fixint:
		return i64(variant.value), nil
	}

	return nil, Unhandled_Tag{tag}
}

assign_num :: proc(v: any, t: typeid, value: $T) where intrinsics.type_is_numeric(T) {
	data := v.data
	switch t {
	case i8:
		(^i8)(v.data)^ = i8(value)
	case i16:
		(^i16)(v.data)^ = i16(value)
	case i32:
		(^i32)(v.data)^ = i32(value)
	case i64:
		(^i64)(v.data)^ = i64(value)
	case u8:
		(^u8)(v.data)^ = u8(value)
	case u16:
		(^u16)(v.data)^ = u16(value)
	case u32:
		(^u32)(v.data)^ = u32(value)
	case u64:
		(^u64)(v.data)^ = u64(value)
	case int:
		(^int)(v.data)^ = int(value)
	case f32:
		(^f32)(v.data)^ = f32(value)
	case f64:
		(^f64)(v.data)^ = f64(value)
	}
}

assign_str :: proc(v: any, t: typeid, value: $T) {
	when T == string {
		switch t {
		case string:
			(^string)(v.data)^ = value
		case cstring:
			(^cstring)(v.data)^ = strings.unsafe_string_to_cstring(value)
		}
	} else when T == cstring {
		switch t {
		case string:
			(^string)(v.data)^ = string(value)
		case cstring:
			(^cstring)(v.data)^ = value
		}
	}
}

read_into :: proc(u: ^Unpacker, t: any) -> Unpack_Error {
	v := t

	if v == nil || v.id == nil {
		return Invalid_Parameter{"v was nil or its type was nil"}
	}

	v = reflect.any_base(v)
	ti := type_info_of(v.id)
	if !reflect.is_pointer(ti) || ti.id == rawptr {
		return Invalid_Parameter{"t is not a pointer"}
	}

	data := any{(^rawptr)(v.data)^, ti.variant.(reflect.Type_Info_Pointer).elem.id}

	return read_into_value(u, data)
}

read_map_into :: proc(
	u: ^Unpacker,
	v: any,
	info: runtime.Type_Info_Map,
	length: u64,
) -> (
	err: Unpack_Error,
) {
	raw_map := (^runtime.Raw_Map)(v.data)

	if raw_map.allocator.procedure == nil {
		raw_map.allocator = context.allocator
	}

	defer if err != nil {
		_ = runtime.map_free_dynamic(raw_map^, info.map_info)
	}

	runtime.map_reserve_dynamic(raw_map, info.map_info, uintptr(length)) or_return

	key_type := info.key.id
	value_type := info.value.id

	key_temp := mem.alloc_bytes_non_zeroed(
		info.key.size,
		info.key.align,
		context.temp_allocator,
	) or_return
	defer mem.free(raw_data(key_temp), context.temp_allocator)
	key_value := any{raw_data(key_temp), key_type}


	value_temp := mem.alloc_bytes_non_zeroed(
		info.value.size,
		info.value.align,
		context.temp_allocator,
	) or_return
	defer mem.free(raw_data(value_temp), context.temp_allocator)
	value_value := any{raw_data(value_temp), value_type}

	for i in 0 ..< length {
		mem.zero_slice(key_temp[:])
		mem.zero_slice(value_temp[:])
		read_into_value(u, key_value) or_return
		read_into_value(u, value_value) or_return

		set_ptr := runtime.__dynamic_map_set_without_hash(
			raw_map,
			info.map_info,
			key_value.data,
			value_value.data,
		)
	}


	raw_map.len = uintptr(length)
	return err
}


read_struct_into :: proc(
	u: ^Unpacker,
	v: any,
	info: runtime.Type_Info_Struct,
	length: u64,
) -> Unpack_Error {
	for i in 0 ..< length {
		key := read_key(u) or_return

		field_type: ^runtime.Type_Info
		field_offset: uintptr

		field_name, ok := key.(string)
		if ok {
			defer delete(field_name)
			field_info := reflect.struct_field_by_name(v.id, field_name)

			field_offset = field_info.offset
			field_type = field_info.type
		} else {
			field_index := key.(u64)
			field_offset = uintptr(info.offsets[field_index])
			field_type = info.types[field_index]
		}


		field_data := rawptr(uintptr(v.data) + uintptr(field_offset))
		field_any := any {
			data = field_data,
			id   = field_type.id,
		}
		field_type_info := type_info_of(field_type.id)
		read_into_value(u, field_any) or_return
	}

	return nil
}

read_union_into :: proc(
	u: ^Unpacker,
	v: any,
	info: runtime.Type_Info_Union,
	length: u64,
) -> Unpack_Error {

	key, err := read_key(u)
	defer object_key_delete(key)
	if err != nil {
		return err
	}

	variant_info: ^runtime.Type_Info
	found_tag: i64

	#partial switch variant in key {
	case u64:
		tag := i64(variant)
		if !info.no_nil {

		}
		variant_info = info.variants[tag - 1]
		found_tag = tag

	case string:
		variant_name := variant
		for variant, i in info.variants {
			tag := i64(i)
			if !info.no_nil {
				tag += 1
			}

			#partial switch vti in variant.variant {
			case reflect.Type_Info_Named:
				if vti.name == variant_name {
					found_tag = tag
					variant_info = variant
				}

			case:
				builder := strings.builder_make(context.temp_allocator)
				defer strings.builder_destroy(&builder)

				reflect.write_type(&builder, variant)
				type_name := strings.to_string(builder)

				if type_name == variant_name {
					variant_info = variant
					found_tag = tag
				}
			}
		}
	}

	if variant_info != nil {
		reflect.set_union_variant_raw_tag(v, found_tag)
		read_into_value(u, any{v.data, variant_info.id}) or_return
	}
	return nil
}

read_bytes_into :: proc(
	u: ^Unpacker,
	v: any,
	info: ^runtime.Type_Info,
	length: int,
) -> (
	err: Unpack_Error,
) {
	// bytes are guaranteed to be homogenous, so no need to delegate per-item etc.
	#partial switch info in info.variant {
	case runtime.Type_Info_Array:
		target_length := info.count
		if length != target_length {
			return Slice_Length_Mismatch{target_length, length}
		}

		slice := ([^]byte)(v.data)[:length]
		read_bytes_into_slice(u, slice) or_return

	case runtime.Type_Info_Slice:
		raw_slice := (^mem.Raw_Slice)(v.data)

		slice := make([]byte, length, u.allocator)
		defer if err != nil do delete(slice)
		read_bytes_into_slice(u, slice) or_return
		raw_slice^ = transmute(mem.Raw_Slice)slice

	case runtime.Type_Info_Dynamic_Array:
		raw_dynamic_array := (^mem.Raw_Dynamic_Array)(v.data)

		slice := make([]byte, length, u.allocator) or_return
		defer if err != nil { delete(slice, u.allocator) }

		read_bytes_into_slice(u, slice) or_return

		raw_dynamic_array.data = raw_data(slice)
		raw_dynamic_array.len = length
		raw_dynamic_array.cap = length
		raw_dynamic_array.allocator = u.allocator

	case:
		return Unexpected{"a bin", "not a bin"}
	}

	return err
}

read_array_into_specialized :: proc(
	u: ^Unpacker,
	base_ptr: rawptr,
	$T: typeid,
	length: int,
) -> (
	err: Unpack_Error,
) {
	base := uintptr(base_ptr)
	ti := typeid_of(T)
	for i in 0 ..< length {
		elem := any{rawptr(base), ti}

		next_elem := decode_tag(u) or_return

		#partial switch variant in next_elem {
		case Positive_Fixint:
			assign_num(elem, T, variant.value)
		case Negative_Fixint:
			assign_num(elem, T, variant.value)
		case Uint:
			assign_num(elem, T, (read_uint(u, variant) or_return).(u64))
		case Int:
			assign_num(elem, T, (read_sint(u, variant) or_return).(i64))
		case Float:
			f := read_float(u, variant) or_return
			if variant.is_double {
				assign_num(elem, T, f.(f64))
			} else {
				assign_num(elem, T, f.(f32))
			}

		case:
			return Unhandled_Tag{next_elem}
		}

		base += size_of(T)
	}

	return nil
}

read_array_into_specialized_dispatch :: proc(
	u: ^Unpacker,
	v: any,
	info: ^runtime.Type_Info,
	length: int,
) -> (
	did: bool,
	err: Unpack_Error,
) {
	base_ptr: rawptr
	elem_info: ^runtime.Type_Info

	#partial switch info in info.variant {
	case runtime.Type_Info_Array:
		target_length := info.count
		if length != target_length {
			return false, Slice_Length_Mismatch{target_length, length}
		}

		base_ptr = v.data
		elem_info = info.elem

	case runtime.Type_Info_Slice:
		raw_slice := (^mem.Raw_Slice)(v.data)
		target_length := raw_slice.len

		if length > raw_slice.len / info.elem_size {
			data := mem.alloc_bytes_non_zeroed(
				info.elem.size * length,
				info.elem.align,
				allocator = u.allocator,
			) or_return

			defer if err != nil {mem.free_bytes(data, allocator = u.allocator)}
			da := mem.Raw_Dynamic_Array{raw_data(data), length, length, u.allocator}

			base_ptr = da.data
			raw_slice.data = da.data
			raw_slice.len = da.len
		}

		base_ptr = raw_slice.data
		elem_info = info.elem

	case runtime.Type_Info_Dynamic_Array:
		d := cast(^mem.Raw_Dynamic_Array)v.data
		if length > d.len {
			runtime.__dynamic_array_resize(d, info.elem_size, info.elem.align, length)
		}

		base_ptr = d.data
		elem_info = info.elem

	case:
		return false, Unexpected{"an array, slice, or dynamic array", "not an array-like type"}
	}

	switch elem_info.id {
	case i8:
		read_array_into_specialized(u, base_ptr, i8, length) or_return
	case i16:
		read_array_into_specialized(u, base_ptr, i16, length) or_return
	case i32:
		read_array_into_specialized(u, base_ptr, i32, length) or_return
	case i64:
		read_array_into_specialized(u, base_ptr, i64, length) or_return
	case u8:
		read_array_into_specialized(u, base_ptr, u8, length) or_return
	case u16:
		read_array_into_specialized(u, base_ptr, u16, length) or_return
	case u32:
		read_array_into_specialized(u, base_ptr, u32, length) or_return
	case u64:
		read_array_into_specialized(u, base_ptr, u64, length) or_return
	case f32:
		read_array_into_specialized(u, base_ptr, f32, length) or_return
	case f64:
		read_array_into_specialized(u, base_ptr, f64, length) or_return
	case:
		return false, nil
	}

	return true, nil
}

read_array_into :: proc(
	u: ^Unpacker,
	v: any,
	info: ^runtime.Type_Info,
	length: int,
) -> (
	err: Unpack_Error,
) {
	did := read_array_into_specialized_dispatch(u, v, info, length) or_return

	if did {
		return nil
	}

	#partial switch info in info.variant {
	case runtime.Type_Info_Array:
		if length != info.count {
			return Slice_Length_Mismatch{info.count, length}
		}

		for i in 0 ..< length {
			dest := uintptr(v.data) + uintptr(int(i) * info.elem_size)
			read_into_value(u, any{rawptr(dest), info.elem.id}) or_return
		}

	case runtime.Type_Info_Slice:
		d := cast(^mem.Raw_Slice)v.data
		if length < d.len / info.elem_size {
			for i in 0 ..< length {
				dest := uintptr(d.data) + uintptr(int(i) * info.elem_size)
				read_into_value(u, any{rawptr(dest), info.elem.id}) or_return
			}
		} else {
			data := mem.alloc_bytes_non_zeroed(
				info.elem.size * length,
				info.elem.align,
				allocator = u.allocator,
			) or_return
			defer if err != nil {mem.free_bytes(data, allocator = u.allocator)}
			da := mem.Raw_Dynamic_Array{raw_data(data), length, length, u.allocator}

			for i in 0 ..< length {
				dest := uintptr(da.data) + uintptr(int(i) * info.elem_size)
				read_into_value(u, any{rawptr(dest), info.elem.id}) or_return
			}

			raw := (^mem.Raw_Slice)(v.data)
			raw.data = da.data
			raw.len = da.len
		}

	case runtime.Type_Info_Dynamic_Array:
		d := cast(^mem.Raw_Dynamic_Array)v.data
		if length > d.len {
			runtime.__dynamic_array_resize(d, info.elem_size, info.elem.align, length)
		}

		for i in 0 ..< length {
			dest := uintptr(d.data) + uintptr(int(i) * info.elem_size)
			read_into_value(u, any{rawptr(dest), info.elem.id}) or_return
		}

	case:
		return Unexpected{"an array, slice, or dynamic array", "not an array-like type"}
	}

	return err
}

read_into_value :: proc(u: ^Unpacker, t: any) -> (err: Unpack_Error) {
	v := t
	ti := reflect.type_info_base(type_info_of(v.id))
	tag := decode_tag(u) or_return

	switch variant in tag {
	case Positive_Fixint:
		assign_num(v, v.id, variant.value)

	case Negative_Fixint:
		assign_num(v, v.id, variant.value)

	case Str:
		str := read_string(u, variant.length) or_return
		assign_str(v, v.id, str)

	case Uint:
		number := (read_uint(u, variant) or_return).(u64)
		assign_num(v, v.id, number)

	case Int:
		number := (read_sint(u, variant) or_return).(i64)
		assign_num(v, v.id, number)

	case Bool:
		if v.id == bool {
			(^bool)(v.data)^ = variant.value
		} else {
			return Unexpected{"a bool", "not a bool"}
		}

	case Nil:
	// TODO: not sure how to handle consistently.
	case Map:
		length := u64(variant.length)

		#partial switch info in ti.variant {
		case runtime.Type_Info_Map:
			read_map_into(u, v, info, length) or_return
		case runtime.Type_Info_Struct:
			read_struct_into(u, v, info, length) or_return
		case runtime.Type_Info_Union:
			read_union_into(u, v, info, length) or_return
		case:
			unreachable()
		}

	case Bin:
		length := variant.length
		read_bytes_into(u, v, ti, length) or_return

	case Ext:
		if variant.type == -1 {
			bytes := make([]u8, variant.length, u.allocator)
			read_bytes_into_slice(u, bytes) or_return

			if v.id == time.Time {
				(^time.Time)(v.data)^ = read_timestamp_ext1(bytes)
			} else {
				delete(bytes)
				return Unexpected{"a time.Time", "not a time.Time"}
			}
		}
	case Float:
		if variant.is_double {
			assign_num(v, v.id, read_number_swapped(u, f64) or_return)
		} else {
			assign_num(v, v.id, read_number_swapped(u, f32) or_return)
		}
	case Array:
		read_array_into(u, v, ti, variant.length) or_return
	}

	return err
}
