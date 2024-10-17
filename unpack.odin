package msgpack

import "base:intrinsics"
import "base:runtime"
import "core:encoding/endian"
import "core:fmt"
import "core:math"
import "core:mem"
import "core:reflect"
import "core:slice"
import "core:sort"
import "core:strings"
import "core:time"

Unpacker :: struct {
	data:   [^]u8,
	offset: u64,
}

read_byte :: proc(u: ^Unpacker) -> u8 {
	u.offset += 1
	return u.data[u.offset - 1]
}

read_multibyte :: read_nbytes_r when NEEDS_SWAP else read_nbytes

read_nbytes :: proc(u: ^Unpacker, $bytes: u64) -> [bytes]u8 {
	out: [bytes]u8
	copy(out[:], u.data[u.offset:u.offset + bytes])
	u.offset += bytes
	return out
}

read_nbytes_r :: proc(u: ^Unpacker, $bytes: u64) -> [bytes]u8 {
	out := read_nbytes(u, bytes)
	slice.reverse(out[:])
	return out
}

read_number :: proc(u: ^Unpacker, $T: typeid) -> T {
	res := read_multibyte(u, size_of(T))
	return transmute(T)(res)
}


read_size :: proc(u: ^Unpacker, width: u64) -> u64 {
	size: u64 = 0
	for i in 0 ..< width {
		size = size << 8 | u64(u.data[u.offset + i])
	}

	u.offset += width
	return size
}

read_map :: proc(u: ^Unpacker, size: int) -> (Object, Error) {
	out := make(map[ObjectKey]Object)
	for _ in 0 ..< size {
		key: ObjectKey
		value: Object
		err: Error
		key, err = read_key(u)
		if err != nil {
			delete(out)
			return nil, err
		}

		value, err = read(u)
		if err != nil {
			delete(out)
		}

		map_insert(&out, key, value)
	}

	return out, nil
}

read_string :: proc(u: ^Unpacker, size: int) -> (string, Error) {
	bytes := u.data[u.offset:u.offset + u64(size)]
	u.offset += u64(size)

	return string(bytes), nil
}

read_bin :: proc(u: ^Unpacker, size: int) -> ([]bin, Error) {
	bytes := u.data[u.offset:u.offset + u64(size)]
	u.offset += u64(size)

	return transmute([]bin)bytes[:], nil
}

read_array :: proc(u: ^Unpacker, size: int) -> ([]Object, Error) {

	out := make([]Object, size)
	for i in 0 ..< size {
		o, err := read(u)
		if err != nil {
			return nil, err
		}
		out[i] = o
	}

	return out, nil
}


read_uint :: proc(u: ^Unpacker, tag: u8) -> (Object, Error) {
	size: u64 = 0

	switch {
	case tag == 0xCC:
		size = read_size(u, 1)
	case tag == 0xCD:
		size = read_size(u, 2)
	case tag == 0xCE:
		size = read_size(u, 4)
	case tag == 0xCF:
		size = read_size(u, 8)
	}

	return size, nil
}

read_float :: proc(u: ^Unpacker, tag: u8) -> (Object, Error) {
	switch {
	case tag == 0xCA:
		bits := read_size(u, 4)
		return transmute(f32)u32(bits), nil
	case tag == 0xCB:
		bits := read_size(u, 8)
		return transmute(f64)bits, nil
	}

	return nil, nil
}

read_sint :: proc(u: ^Unpacker, tag: u8) -> (Object, Error) {
	size: Object

	switch {
	case tag == 0xD0:
		return i64(transmute(i8)u8(read_size(u, 1))), nil
	case tag == 0xD1:
		return i64(transmute(i16)u16(read_size(u, 2))), nil
	case tag == 0xD2:
		return i64(transmute(i32)u32(read_size(u, 4))), nil
	case tag == 0xD3:
		return transmute(i64)read_size(u, 8), nil
	}

	// TODO
	return transmute(i64)size.(u64), nil
}

read_timestamp_ext1 :: proc(b: []u8) -> time.Time {
	count := len(b)

	switch count {
	case 4:
		// 32-bit unix-seconds

		seconds, _ := endian.get_u32(b[:4], .Big)
		return time.unix(i64(seconds), 0)
	case 8:
		data, _ := endian.get_u64(b[:8], .Big)
		ns := i64(data >> 34)
		seconds := i64(data & 0x3FFFFFFFF)
		return time.unix(seconds, ns)
	case 12:
		nsec, _ := endian.get_u32(b, .Big)
		sec, _ := endian.get_u64(b[4:], .Big)
		return time.unix(i64(sec), i64(nsec))
	}

	panic("unreachable")
}

read_fixext :: proc(u: ^Unpacker, type: i8, size: int) -> (Object, Error) {
	bytes := u.data[u.offset:u.offset + u64(size)]
	u.offset += u64(size)

	if type == -1 {
		return read_timestamp_ext1(bytes), nil
	} else {
		return nil, Unexpected{"a known ext", "unknown ext"}
	}
}


read_ext :: proc(u: ^Unpacker, type: i8, size: int) -> (Object, Error) {
	bytes := u.data[u.offset:u.offset + u64(size)]
	u.offset += u64(size)
	if i8(type) == -1 {
		return read_timestamp_ext1(bytes), nil
	} else {
		return "asd", nil
	}
}


read_key :: proc(u: ^Unpacker) -> (ObjectKey, Error) {
	// XXXX[TS]: This is mostly copied from below.
	tag := decode_tag(u)

	#partial switch variant in tag {
	case Str:
		str, err := read_string(u, int(variant.length))
		if err != nil {
			return nil, err
		}
		return ObjectKey(str), nil

	case Positive_Fixint:
		return ObjectKey(u64(variant.value)), nil

	case Negative_Fixint:
		return ObjectKey(i64(variant.value)), nil

	case Uint:
		switch variant.width {
		case 1:
			return u64(read_number(u, u8)), nil
		case 2:
			return u64(read_number(u, u16)), nil
		case 4:
			return u64(read_number(u, u32)), nil
		case 8:
			return u64(read_number(u, u64)), nil
		}
	case Int:
		switch variant.width {
		case 1:
			return i64(read_number(u, i8)), nil
		case 2:
			return i64(read_number(u, i16)), nil
		case 4:
			return i64(read_number(u, i32)), nil
		case 8:
			return i64(read_number(u, i64)), nil
		}

	case Float:
		if variant.is_double {
			return ObjectKey(read_number(u, f64)), nil
		} else {
			return ObjectKey(read_number(u, f32)), nil
		}

	case Bool:
		return ObjectKey(variant.value), nil

	case:
		return nil, Unexpected{"a valid key type", fmt.tprintf("%v", variant)}
	}

	unreachable()
}

read :: proc(u: ^Unpacker) -> (Object, Error) {
	tag := decode_tag(u)
	// XXXX: we handle these separately in a blanks switch as they
	// require bitmasking, while the "non-bitmasked" fields below can
	// use a regular switch.
	switch variant in tag {
	case Positive_Fixint:
		return u64(variant.value), nil
	case Map:
		return read_map(u, int(variant.length))
	case Array:
		return read_array(u, int(variant.length))
	case Str:
		return read_string(u, variant.length) // TODO
	case Nil:
		return nil, nil
	case Bool:
		return variant.value, nil
	case Bin:
		return read_bin(u, variant.length)
	case Ext:
		return read_ext(u, variant.type, variant.length)
	case Float:
		if variant.is_double {
			return read_number(u, f64), nil
		} else {
			return read_number(u, f32), nil
		}
	case Uint:
		switch variant.width {
		case 1:
			return u64(read_number(u, u8)), nil
		case 2:
			return u64(read_number(u, u16)), nil
		case 4:
			return u64(read_number(u, u32)), nil
		case 8:
			return u64(read_number(u, u64)), nil
		}
	case Int:
		switch variant.width {
		case 1:
			return i64(read_number(u, i8)), nil
		case 2:
			return i64(read_number(u, i16)), nil
		case 4:
			return i64(read_number(u, i32)), nil
		case 8:
			return i64(read_number(u, i64)), nil
		}
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


read_into :: proc(u: ^Unpacker, t: any) -> Error {
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
	err: Error,
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
) -> Error {
	for i in 0 ..< length {
		key, err := read_key(u)
		if err != nil {
			return err
		}

		field_name := key.(string)
		field_info := reflect.struct_field_by_name(v.id, field_name)
		field_offset := field_info.offset
		field_type := field_info.type
		field_data := rawptr(uintptr(v.data) + field_offset)
		field_any := any {
			data = field_data,
			id   = field_type.id,
		}
		field_type_info := type_info_of(field_type.id)
		err = read_into_value(u, field_any)
		if err != nil {
			return err
		}
	}

	return nil
}

import "core:io"

read_bytes_into :: proc(
	u: ^Unpacker,
	v: any,
	info: ^runtime.Type_Info,
	length: int,
) -> (
	err: Error,
) {
	// bytes are guaranteed to be homogenous, so no need to delegate per-item etc.
	#partial switch info in info.variant {
	case runtime.Type_Info_Array:
		target_length := info.count
		if length != target_length {
			return Slice_Length_Mismatch{target_length, length}
		}

		slice := ([^]byte)(v.data)[:length]
		copy(slice[:length], u.data[u.offset:u.offset + u64(length)])
		u.offset += u64(length)

	case runtime.Type_Info_Slice:
		raw_slice := (^mem.Raw_Slice)(v.data)
		target_length := raw_slice.len / info.elem_size

		bytes := u.data[u.offset:u.offset + u64(length)]
		raw_slice^ = transmute(mem.Raw_Slice)bytes
		u.offset += u64(length)

	case runtime.Type_Info_Dynamic_Array:
		raw_dynamic_array := (^mem.Raw_Dynamic_Array)(v.data)
		target_length := raw_dynamic_array.len / info.elem_size

		buf := strings.builder_make(0, length) or_return
		defer if err != nil {strings.builder_destroy(&buf)}
		copy(buf.buf[:], u.data[u.offset:u.offset + u64(length)])
		u.offset += u64(length)

		raw_dynamic_array.data = raw_data(buf.buf[:])
		raw_dynamic_array.len = length
		raw_dynamic_array.cap = length
		raw_dynamic_array.allocator = context.allocator


	case:
		fmt.eprintf("foobar: %v\n", info)
		return Unexpected{"a bin", "not a bin"}
	}

	return err
}

read_array_into :: proc(
	u: ^Unpacker,
	v: any,
	info: ^runtime.Type_Info,
	length: int,
) -> (
	err: Error,
) {
	#partial switch info in info.variant {
	case runtime.Type_Info_Array:
		target_length := info.count
		if length != target_length {
			return Slice_Length_Mismatch{target_length, length}
		}

		for i in 0 ..< length {
			elem := any{rawptr(uintptr(v.data) + uintptr(i * info.elem_size)), info.elem.id}
			err = read_into_value(u, elem)
			if err != nil {
				return err
			}
		}

	case runtime.Type_Info_Slice:
		raw_slice := (^mem.Raw_Slice)(v.data)
		target_length := raw_slice.len

		if length > target_length {
			return Slice_Length_Mismatch{target_length, length}
		}

		for i in 0 ..< length {
			elem := any {
				rawptr(uintptr(raw_slice.data) + uintptr(i * info.elem_size)),
				info.elem.id,
			}
			read_into_value(u, elem) or_return

		}

	case runtime.Type_Info_Dynamic_Array:
		raw_dynamic_array := (^mem.Raw_Dynamic_Array)(v.data)
		target_length := raw_dynamic_array.len

		if length > target_length {
			new_data := make([]byte, length * info.elem_size)
			mem.copy(raw_data(new_data), raw_dynamic_array.data, target_length * info.elem_size)
			raw_dynamic_array.data = raw_data(new_data)
			raw_dynamic_array.len = length
			raw_dynamic_array.cap = length
		}

		for i in 0 ..< length {
			elem := any {
				rawptr(uintptr(raw_dynamic_array.data) + uintptr(i * info.elem_size)),
				info.elem.id,
			}
			read_into_value(u, elem) or_return

		}

	case:
		return Unexpected{"an array, slice, or dynamic array", "not an array-like type"}
	}

	return err
}

read_into_value :: proc(u: ^Unpacker, t: any) -> (err: Error) {
	v := t
	ti := reflect.type_info_base(type_info_of(v.id))
	tag := decode_tag(u)

	switch variant in tag {
	case Positive_Fixint:
		assign_num(v, v.id, variant.value)

	case Negative_Fixint:
		assign_num(v, v.id, variant.value)

	case Str:
		str := read_string(u, variant.length) or_return
		assign_str(v, v.id, str)
	case Uint:
		switch variant.width {
		case 1:
			assign_num(v, v.id, read_number(u, u8))
		case 2:
			assign_num(v, v.id, read_number(u, u16))
		case 4:
			assign_num(v, v.id, read_number(u, u32))
		case 8:
			assign_num(v, v.id, read_number(u, u64))
		}
	case Int:
		switch variant.width {
		case 1:
			assign_num(v, v.id, read_number(u, i8))
		case 2:
			assign_num(v, v.id, read_number(u, i16))
		case 4:
			assign_num(v, v.id, read_number(u, i32))
		case 8:
			assign_num(v, v.id, read_number(u, i64))
		}
	case Bool:
		if v.id == bool {
			(^bool)(v.data)^ = variant.value
		} else {
			return Unexpected{"a bool", "not a bool"}
		}

	case Nil:
	// TODO
	case Map:
		length := u64(variant.length)

		#partial switch info in ti.variant {
		case runtime.Type_Info_Map:
			read_map_into(u, v, info, length) or_return
		case runtime.Type_Info_Struct:
			read_struct_into(u, v, info, length) or_return
		case:
			return Unexpected{"a map", "not a map"}
		}

	case Bin:
		length := variant.length
		read_bytes_into(u, v, ti, length) or_return

	case Ext:
		if variant.type == -1 {
			bytes := u.data[u.offset:u.offset + u64(variant.length)]
			u.offset += u64(variant.length)

			if v.id == time.Time {
				(^time.Time)(v.data)^ = read_timestamp_ext1(bytes)
			} else {
				return Unexpected {
					"a time.Time", "not a time.Time"
				}
			}
		}
	case Float:
		if variant.is_double {
			assign_num(v, v.id, read_number(u, f64))
		} else {
			assign_num(v, v.id, read_number(u, f32))
		}
	case Array:
		// fixarray
		length := variant.length
		maybe := ti

		#partial switch info in maybe.variant {
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
					allocator = context.temp_allocator,
				) or_return
				defer if err != nil {mem.free_bytes(data, allocator = context.temp_allocator)}
				da := mem.Raw_Dynamic_Array{raw_data(data), length, length, context.temp_allocator}

				for i in 0 ..< length {
					dest := uintptr(da.data) + uintptr(int(i) * info.elem_size)
					read_into_value(u, any{rawptr(dest), info.elem.id}) or_return
				}

				raw := (^mem.Raw_Slice)(v.data)
				raw.data = da.data
				raw.len = da.len
			}

		case:
			panic(fmt.aprintfln("foobar: %v", info))
		}
	}

	return nil
}
