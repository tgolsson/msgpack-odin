package msgpack

import "base:intrinsics"

import "core:encoding/endian"
import "core:reflect"
import "core:fmt"
import "core:math"
import "core:sort"
import "core:time"

// @TODO[TSolberg]:
//   Handle endianness.
//   Differentiate bytes?
//   Accept allocators


bin :: distinct u8
binary :: distinct []bin

PackerFlags :: enum {
	StableMaps = 0,
}

PackerFlags_Set :: bit_set[PackerFlags]
Packer :: struct {
	buf:   [dynamic]u8,
	flags: PackerFlags_Set,
}

write_byte :: proc(p: ^Packer, byte: u8) {
	append_elem(&p.buf, byte)
}

write_bytes :: proc(p: ^Packer, bytes: []u8) {
	append_elems(&p.buf, ..bytes)
}

write_nbytes :: proc(p: ^Packer, bytes: [$N]u8) {
	for v, _ in bytes {
		append(&p.buf, v)
	}
}

write_nbytes_r :: proc(p: ^Packer, bytes: [$N]u8) {
	#reverse for v, _ in bytes {
		append(&p.buf, v)
	}
}


write_nbytes_head :: proc(p: ^Packer, head: u8, bytes: [$N]u8) {
	write_byte(p, head)
	write_nbytes(p, bytes)
}

write_nbytes_head_r :: proc(p: ^Packer, head: u8, bytes: [$N]u8) {
	write_byte(p, head)
	write_nbytes_r(p, bytes)
}

NEEDS_SWAP :: endian.PLATFORM_BYTE_ORDER == .Little
write_multibyte :: write_nbytes_r when NEEDS_SWAP else write_nbytes
write_multibyte_head :: write_nbytes_head_r when NEEDS_SWAP else write_nbytes_head

write_bytes_2 :: proc(p: ^Packer, bytes: ..u8) {
	append_elems(&p.buf, ..bytes)
}

write_nil :: proc(p: ^Packer) {
	write_bytes(p, {0xc0})
}

// NOTE: TSolberg: this isn't right...
write_rawptr :: proc(p: ^Packer, n: rawptr) {
	if n == nil {
		write_bytes(p, {0xc0})
	} else {
		panic("attempting to write rawptr value, don't know how to proceed.")
	}
}

write_number :: proc(p: ^Packer, num: $T) where intrinsics.type_is_integer(T) {


	if num >= 0 {
		num := u64(num)
		switch num {
		case 0 ..= 127:
			write_byte(p, u8(num))

		case 128 ..< 256:
			write_byte(p, 0xCC)
			write_byte(p, u8(num))
		case 256 ..< (1 << 16):
			write_byte(p, 0xCD)
			write_multibyte(p, transmute([2]u8)u16(num))

		case (1 << 16) ..< (1 << 32):
			write_byte(p, 0xCE)
			write_multibyte(p, transmute([4]u8)u32(num))
		case u64(1 << 32) ..= u64(1 << 64 - 1):
			write_byte(p, 0xCF)
			write_multibyte(p, transmute([8]u8)num)
		}
	} else {
		num := i64(num)
		switch num {

		case -32 ..< 0:
			write_byte(p, u8(0b11100000) | u8(num) & 0b11111)
		case -128 ..< 0:
			write_byte(p, 0xd0)
			write_byte(p, (u8)(i8(num)))
		case -32768 ..< 0:
			write_byte(p, 0xd1)
			write_multibyte(p, transmute([2]u8)i16(num))
		case -(1 << 31) ..< 0:
			write_byte(p, 0xd2)
			write_multibyte(p, transmute([4]u8)i32(num))
		case -(1 << 63) ..< 0:
			write_byte(p, 0xD3)
			write_multibyte(p, transmute([8]u8)num)
		}
	}
}

write_generic_float :: proc(p: ^Packer, num: $T) where intrinsics.type_is_float(T) {
	if abs(num) <= math.F32_MAX {
		write_byte(p, 0xCA)
		write_multibyte(p, transmute([4]u8)f32(num))
	} else {
		write_byte(p, 0xCB)
		write_multibyte(p, transmute([8]u8)f64(num))
	}
}

write_bool :: proc(p: ^Packer, v: bool) {
	write_bytes(p, {0xc3} if v else {0xc2})
}

write_str :: proc(p: ^Packer, v: string) {
	data := transmute([]u8)v
	switch len(v) {
	case 0 ..< (1 << 5):
		write_bytes_2(p, 0b10100000 | u8(len(v)))

	case (1 << 5) ..< (1 << 8):
		write_bytes_2(p, 0xd9, u8(len(v)))

	case (1 << 8) ..< (1 << 16):
		bytes := transmute([2]u8)u16(len(v))
		write_bytes_2(p, 0xda, bytes[1], bytes[0])

	case (1 << 16) ..< (1 << 32):
		bytes := transmute([4]u8)u32(len(v))
		write_bytes_2(p, 0xdb, bytes[3], bytes[2], bytes[1], bytes[0])
	}

	write_bytes(p, data)
}

write_bin :: proc(p: ^Packer, v: []bin) {
	data := transmute([]u8)v
	switch len(v) {

	case 0 ..< (1 << 8):
		write_bytes_2(p, 0xc4, u8(len(v)))

	case (1 << 8) ..< (1 << 16):
		bytes := transmute([2]u8)u16(len(v))
		write_bytes_2(p, 0xc5, bytes[1], bytes[0])

	case (1 << 16) ..< (1 << 32):
		bytes := transmute([4]u8)u32(len(v))
		write_bytes_2(p, 0xc6, bytes[3], bytes[2], bytes[1], bytes[0])
	}

	write_bytes(p, data)
}


write_bin_fixed :: proc(p: ^Packer, v: [$N]bin) {
	v := v
	write_bin(p, v[:])
}

write_array :: proc(p: ^Packer, v: []$T) where T != bin {
	switch len(v) {

	case 0 ..< (1 << 4):
		write_bytes_2(p, 0b10010000 | u8(len(v)))

	case (1 << 4) ..< (1 << 16):
		bytes := transmute([2]u8)u16(len(v))
		write_bytes_2(p, 0xdc, bytes[1], bytes[0])

	case (1 << 16) ..< (1 << 32):
		bytes := transmute([4]u8)u32(len(v))
		write_bytes_2(p, 0xdd, bytes[3], bytes[2], bytes[1], bytes[0])
	}

	for item in v {
		write(p, item)
	}
}


write_array_fixed :: proc(p: ^Packer, v: [$N]$T) where T != bin {
	v := v
	write_array(p, v[:])
}


write_map :: proc(p: ^Packer, v: map[$K]$V) {
	switch len(v) {

	case 0 ..< (1 << 4):
		write_bytes_2(p, 0b10000000 | u8(len(v)))

	case (1 << 4) ..< (1 << 16):
		bytes := transmute([2]u8)u16(len(v))
		write_bytes_2(p, 0xde, bytes[1], bytes[0])

	case (1 << 16) ..< (1 << 32):
		bytes := transmute([4]u8)u32(len(v))
		write_bytes_2(p, 0xdf, bytes[3], bytes[2], bytes[1], bytes[0])
	}

	if .StableMaps in p.flags {
		assert(intrinsics.type_is_ordered(K), ".StableMaps requires that keys are orderable.")

		keys := make([]K, len(v))
		defer delete(keys)

		offset := 0
		for k in v {
			keys[offset] = k
			offset += 1
		}

		// @NOTE[TSolberg]: A bit greedy, but assuming
		sort.quick_sort(keys)


		for k in keys {
			write(p, k)
			write(p, v[k])
		}
	} else {
		for k, item in v {
			write(p, k)
			write(p, item)
		}
	}
}

write_ext :: proc(p: ^Packer, type: i8, size: u32) {
	switch size {
	case 1:
		write_bytes(p, {0xd4, transmute(u8)type})
	case 2:
		write_bytes(p, {0xd5, transmute(u8)type})
	case 4:
		write_bytes(p, {0xd6, transmute(u8)type})
	case 8:
		write_bytes(p, {0xd7, transmute(u8)type})
	case 16:
		write_bytes(p, {0xd8, transmute(u8)type})
	case 0 ..< (1 << 8):
		write_bytes(p, {0xc7, u8(size), transmute(u8)type})
	case (1 << 8) ..< (1 << 16):
		bytes := transmute([2]u8)u16(size)
		write_bytes(p, {0xc8, bytes[1], bytes[0], transmute(u8)type})
	case (1 << 16) ..= (1 << 32 - 1):
		bytes := transmute([4]u8)u32(size)
		write_bytes(p, {0xc9, bytes[3], bytes[2], bytes[1], bytes[0], transmute(u8)type})
	}
}
write_timestamp_ext1 :: proc(p: ^Packer, v: time.Time) {
	unix_nanos := time.time_to_unix_nano(v)
	sec := u64(unix_nanos / 1000_000_000)
	nsecs := u64(unix_nanos) - sec * 1000_000_000
	// before 2514-05-03~?
	if (sec >> 34) == 0 {
		data64 := (nsecs << 34) | sec
		// before 2106-02-07~ and nanos == 0?
		if (data64 & 0xffffffff00000000) == 0 {
			write_ext(p, -1, 4)
			bytes := transmute([4]u8)u32(data64)
			write_bytes(p, {bytes[3], bytes[2], bytes[1], bytes[0]})
		} else {
			// Most likely we have nanos...
			write_ext(p, -1, 8)
			bytes := transmute([8]u8)intrinsics.byte_swap(data64)
			write_bytes(p, bytes[:])
		}
	} else {
		// Most likely we have nanos...
		write_ext(p, -1, 12)
		nanos := transmute([4]u8)intrinsics.byte_swap(u32(nsecs))
		sec := transmute([8]u8)intrinsics.byte_swap(sec)
		write_bytes(p, nanos[:])
		write_bytes(p, sec[:])
	}

}

import "base:runtime"

begin_map :: proc(p: ^Packer, length: u32) {
	switch length {
	case 0 ..< (1 << 4):
		write_byte(p, 0b10000000 | u8(length))
	case (1 << 4) ..< (1 << 16):
		write_byte(p, 0xde)
		write_nbytes_r(p, transmute([2]u8)u16(length))
	case (1 << 16) ..= ((1 << 32) - 1):
		write_byte(p, 0xdf)
		write_nbytes_r(p, transmute([4]u8)length)
	}
}

begin_array :: proc(p: ^Packer, length: u32) {

	switch length {
	case 0 ..< (1 << 4):
		write_byte(p, 0b10010000 | u8(length))
	case (1 << 4) ..< (1 << 16):
		write_byte(p, 0xdc)
		write_nbytes_r(p, transmute([2]u8)u16(length))
	case (1 << 16) ..= ((1 << 32) - 1):
		write_byte(p, 0xdd)
		write_nbytes_r(p, transmute([4]u8)length)

	}
}

import "core:mem"
import "core:slice"

write :: proc(p: ^Packer, data: any) {
	ti := runtime.type_info_base(type_info_of(data.id))
	a := any{data.data, ti.id}

	switch info in ti.variant {
	case runtime.Type_Info_Named, runtime.Type_Info_Enum, runtime.Type_Info_Bit_Field:
		unreachable()


	case runtime.Type_Info_Pointer,
		runtime.Type_Info_Multi_Pointer, runtime.Type_Info_Procedure:
		if (^rawptr)(data.data)^ == nil {
			write_nil(p)
		}

	case runtime.Type_Info_Integer:
    	switch data.id {
		case i8: write_number(p, a.(i8))
		case i16: write_number(p, a.(i16))
		case i32: write_number(p, a.(i32))
		case i64: write_number(p, a.(i64))
		case int: write_number(p, a.(int))
		case u8: write_number(p, a.(u8))
		case u16: write_number(p, a.(u16))
		case u32: write_number(p, a.(u32))
		case u64: write_number(p, a.(u64))
		}

	case runtime.Type_Info_Rune,
		runtime.Type_Info_Complex,
		runtime.Type_Info_Quaternion,
		runtime.Type_Info_Enumerated_Array,
		runtime.Type_Info_Dynamic_Array,
		runtime.Type_Info_Parameters,
		runtime.Type_Info_Union,
		runtime.Type_Info_Bit_Set,
		runtime.Type_Info_Simd_Vector,
		runtime.Type_Info_Relative_Pointer,
		runtime.Type_Info_Relative_Multi_Pointer,
		runtime.Type_Info_Matrix,
		runtime.Type_Info_Soa_Pointer,
		runtime.Type_Info_Type_Id,
		runtime.Type_Info_Any:
		unreachable()

	case runtime.Type_Info_Slice:
		d := cast(^mem.Raw_Slice)data.data
		if info.elem.id == bin {
			switch d.len {

			case 0 ..< (1 << 8):
				write_bytes_2(p, 0xc4, u8(d.len))

			case (1 << 8) ..< (1 << 16):
				bytes := transmute([2]u8)u16(d.len)
				write_bytes_2(p, 0xc5, bytes[1], bytes[0])

			case (1 << 16) ..< (1 << 32):
				bytes := transmute([4]u8)u32(d.len)
				write_bytes_2(p, 0xc6, bytes[3], bytes[2], bytes[1], bytes[0])
			}

			write_bytes(p, slice.bytes_from_ptr(d.data, d.len))
		} else {

			begin_array(p, u32(d.len))

			for i in 0 ..< d.len {
				data := uintptr(d.data) + uintptr(i * info.elem_size)
				write(p, any{rawptr(data), info.elem.id})
			}
		}
		case runtime.Type_Info_Array:
		if info.elem.id == bin {
			switch info.count {

			case 0 ..< (1 << 8):
				write_bytes_2(p, 0xc4, u8(info.count))

			case (1 << 8) ..< (1 << 16):
				bytes := transmute([2]u8)u16(info.count)
				write_bytes_2(p, 0xc5, bytes[1], bytes[0])

			case (1 << 16) ..< (1 << 32):
				bytes := transmute([4]u8)u32(info.count)
				write_bytes_2(p, 0xc6, bytes[3], bytes[2], bytes[1], bytes[0])
			}

			write_bytes(p, slice.bytes_from_ptr(data.data, info.count))
		} else {
			begin_array(p, u32(info.count))

			for i in 0 ..< info.count {
				data := uintptr(data.data) + uintptr(i * info.elem_size)
				write(p, any{rawptr(data), info.elem.id})
			}
		}

		case runtime.Type_Info_Boolean:
		    write_bool(p, a.(bool))

		case runtime.Type_Info_String:
		    switch s in data {
			case string:
				write_str(p, s)
			case cstring:
				write_str(p, string(s))
			}

		case runtime.Type_Info_Float:
    		switch data.id {
			case f32:
				write_generic_float(p, a.(f32))
			case f64:
				write_generic_float(p, a.(f64))
			}

		case runtime.Type_Info_Struct:
        	if data.id == time.Time {
				write_timestamp_ext1(p, data.(time.Time))
			} else {
				begin_map(p, u32(info.field_count))
				for name, i in info.names[:info.field_count] {
					id := info.types[i].id
					data := rawptr(uintptr(data.data) + info.offsets[i])
					the_value := any{data, id}
					write_str(p, name)

					// TODO
					// if info.usings[i] && name == "_" {
					// 	write_struct_fields(p, the_value, opt)
					// } else {
					write(p, the_value)
					//}
				}
			}
		case runtime.Type_Info_Map:
    	m := (^mem.Raw_Map)(data.data)
		if info.map_info == nil {
// TODO
		}
			map_cap := uintptr(runtime.map_cap(m^))
			ks, vs, hs, _, _ := runtime.map_kvh_data_dynamic(m^, info.map_info)

		count_valid := 0
		    for bucket_index in 0..<map_cap {
				runtime.map_hash_is_valid(hs[bucket_index]) or_continue
				count_valid += 1
			}
		begin_map(p, u32(count_valid))
    		if .StableMaps not_in p.flags {
				i := 0
				for bucket_index in 0..<map_cap {
					runtime.map_hash_is_valid(hs[bucket_index]) or_continue

					key   := rawptr(runtime.map_cell_index_dynamic(ks, info.map_info.ks, bucket_index))
					value := rawptr(runtime.map_cell_index_dynamic(vs, info.map_info.vs, bucket_index))

					write(p, any{key, info.key.id})
					write(p, any{value, info.value.id})
				}
			} else {
				Entry :: struct($T: typeid)  {
					key: T,
					value: any,
				}

				output_sorted :: proc(p: ^Packer, map_cap: uintptr, info: runtime.Type_Info_Map, ks: uintptr, vs: uintptr, hs: [^]runtime.Map_Hash, key_conv: proc(ptr: uintptr) -> $T) {
					sorted := make([dynamic]Entry(T), 0, map_cap, context.temp_allocator)
					for bucket_index in 0..<map_cap {
						runtime.map_hash_is_valid(hs[bucket_index]) or_continue

						key := key_conv(runtime.map_cell_index_dynamic(ks, info.map_info.ks, bucket_index))
						value := rawptr(runtime.map_cell_index_dynamic(vs, info.map_info.vs, bucket_index))

						append(&sorted, Entry(T){
							key = key,
							value = any{value, info.value.id},
						})
					}

					slice.sort_by(sorted[:], proc(i, j: Entry(T)) -> bool { return i.key < j.key  })


					for s, i in sorted {
						write(p, s.key)
						write(p, s.value)
					}

				}
				switch info.key.id {
				case string:
					uintptr_to_string :: proc(ptr: uintptr) -> string {
						bytes := (^[]byte)(ptr)
						return string(bytes^)
					}
					output_sorted(p, map_cap, info, ks, vs, hs, uintptr_to_string)

				case cstring:
					uintptr_to_string :: proc(ptr: uintptr) -> string {
						bytes := (^cstring)(ptr)
						return string(bytes^)
					}
					output_sorted(p, map_cap, info, ks, vs, hs, uintptr_to_string)

				case i8:
					uintptr_to_i8 :: proc(ptr: uintptr) -> i8 {
						bytes := (^i8)(ptr)
						return i8(bytes^)
					}
					output_sorted(p, map_cap, info, ks, vs, hs, uintptr_to_i8)

				}

			}
		case:
		panic(fmt.aprintf("unhandled case: %v", info))
	}
}

read_into :: proc(u: ^Unpacker, t: any) -> Error {
	v := t

	if v == nil || v.id == nil {
		return Invalid_Parameter{}
	}

	v = reflect.any_base(v)

	ti := type_info_of(v.id)
	if !reflect.is_pointer(ti) || ti.id == rawptr {
		return Invalid_Parameter{}
	}

	data := any{(^rawptr)(v.data)^, ti.variant.(reflect.Type_Info_Pointer).elem.id}

	tag := u.data[u.offset]
	u.offset += 1

	switch {
	case tag & 0x80 == 0:
		// positive fixint

		// return u64(tag & 0x7F), nil
	case tag & 0xE0 == 0xA0:
		// fixstr
		// return read_string(u, tag)

	case tag & 0xF0 == 0x80:
		// fixmap
		// return read_map(u, tag)

	case tag & 0xE0 == 0xE0:
		// negative fixint
		// return i64(-32 - -i8(tag & 0x1F)), nil

	case tag & 0xF0 == 0x90:
		// fixarray
		// return read_array(u, tag)
	}

	switch tag {
	case 0xC0:
		// nil. XXXX
		// return Nil{}, nil

	case 0xC2:
		maybe := ti.variant.(runtime.Type_Info_Pointer).elem.id
		if maybe == bool {
			v.(^bool)^ = false
		}

	case 0xC3:
		maybe := ti.variant.(runtime.Type_Info_Pointer).elem.id
		if maybe == bool {
			v.(^bool)^ = true
		}

	case 0xCC, 0xCD, 0xCE, 0xCF:
		// unsigned int
		// return read_uint(u, tag)

	case 0xD0, 0xD1, 0xD2, 0xD3:
		// signed int
		// return read_sint(u, tag)

	case 0xCA, 0xCB:
		// float
		// return read_float(u, tag)

	case 0xD9, 0xDA, 0xDB:
		// str
		// return read_string(u, tag)

	case 0xC4, 0xC5, 0xC6:
		// bin
		// return read_bin(u, tag)

	case 0xDC, 0xDD:
		// array
		// return read_array(u, tag)

	case 0xDE, 0xDF:
		// map
		// return read_map(u, tag)

	case 0xD4, 0xD5, 0xD6, 0xD7, 0xD8:
		// fixext
		// return read_fixext(u, tag)

	case 0xC7, 0xC8, 0xC9:
		// ext
		// return read_ext(u, tag)
	}

	return nil
}

Nil :: struct {}

ObjectKey :: union {
	bool,
	u64,
	i64,
	f32,
	f64,
	string,
}

Ext :: struct {
	type: i8,
	size: u32,
}

Object :: union {
	Nil,
	bool,
	u64,
	i64,
	f32,
	f64,
	string,
	[]bin,
	[]Object,
	map[ObjectKey]Object,
	time.Time,
	Ext,
}

Unexpected :: struct {
	wanted, found: string,
}

Unhandled_Tag :: struct {
	tag: u8,
}

Invalid_Parameter :: struct {}

Error :: union {
	Unexpected,
	Unhandled_Tag,
	Invalid_Parameter,
}

Unpacker :: struct {
	data:   [^]u8,
	offset: u64,
}

read_size :: proc(u: ^Unpacker, width: u64) -> u64 {
	size: u64 = 0
	for i in 0 ..< width {
		size = size << 8 | u64(u.data[u.offset + i])
	}

	u.offset += width
	return size
}

read_map :: proc(u: ^Unpacker, tag: u8) -> (Object, Error) {
	size: u64 = 0
	switch {
	case tag & 0xF0 == 0x80:
		size = u64(tag & 0x0F)
	case tag == 0xDE:
		size = read_size(u, 2)
	case tag == 0xDF:
		size = read_size(u, 4)
	}


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

read_string :: proc(u: ^Unpacker, tag: u8) -> (string, Error) {
	size: u64 = 0

	switch {
	case tag & 0xE0 == 0xA0:
		// fixstr
		size = u64(tag & 0x1F)
	case tag == 0xD9:
		size = read_size(u, 1)
	case tag == 0xDA:
		size = read_size(u, 2)
	case tag == 0xDB:
		size = read_size(u, 4)
	}

	bytes := u.data[u.offset:u.offset + size]
	u.offset += size

	return string(bytes), nil
}

read_bin :: proc(u: ^Unpacker, tag: u8) -> ([]bin, Error) {

	size: u64 = 0

	switch {
	case tag == 0xC4:
		size = read_size(u, 1)
	case tag == 0xC5:
		size = read_size(u, 2)
	case tag == 0xC6:
		size = read_size(u, 4)
	}

	bytes := u.data[u.offset:u.offset + size]
	u.offset += size

	return transmute([]bin)bytes[:], nil
}

read_array :: proc(u: ^Unpacker, tag: u8) -> ([]Object, Error) {
	size: u64 = 0

	switch {
	case tag & 0xF0 == 0x90:
		size = u64(0x0F & tag)
	case tag == 0xDC:
		size = read_size(u, 2)
	case tag == 0xDD:
		size = read_size(u, 4)
	}

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

read_fixext :: proc(u: ^Unpacker, tag: u8) -> (Object, Error) {
	size: u64 = 0

	switch tag {
	case 0xD4:
		size = 1
	case 0xD5:
		size = 2
	case 0xD6:
		size = 4
	case 0xD7:
		size = 8
	case 0xD8:
		size = 16
	}

	type := u.data[u.offset]
	u.offset += 1

	bytes := u.data[u.offset:u.offset + size]
	u.offset += size

	if i8(type) == -1 {
		return read_timestamp_ext1(bytes), nil
	} else {
		return "asd", nil
	}
}


read_ext :: proc(u: ^Unpacker, tag: u8) -> (Object, Error) {
	size: u64 = 0

	switch tag {
	case 0xc7:
		size = read_size(u, 1)
	case 0xc8:
		size = read_size(u, 2)
	case 0xc9:
		size = read_size(u, 3)
	}

	type := u.data[u.offset]
	u.offset += 1

	bytes := u.data[u.offset:u.offset + size]
	u.offset += size

	if i8(type) == -1 {
		panic("foobar")
	} else {
		return "asd", nil
	}
}


read_key :: proc(u: ^Unpacker) -> (ObjectKey, Error) {
	// XXXX[TS]: This is mostly copied from below.
	tag := u.data[u.offset]
	u.offset += 1

	switch {
	case tag & 0x80 == 0:
		// positive fixint
		return u64(tag & 0x7F), nil
	case tag & 0xE0 == 0xA0:
		// fixstr
		return read_string(u, tag)

	case tag & 0xF0 == 0x80:
		// fixmap
		return nil, Unexpected{"a key-type", "a fixmap"}


	case tag & 0xE0 == 0xE0:
		// negative fixint
		return i64(-32 - -i8(tag & 0x1F)), nil

	case tag & 0xF0 == 0x90:
		// fixarray
		return nil, Unexpected{"a key-type", "a fixarray"}
	}

	switch tag {

	case 0xC0: // nil
	case 0xc2, 0xc3:
	case 0xCC, 0xCD, 0xCE, 0xCF:
		// unsigned int
	case 0xD0, 0xD1, 0xD2, 0xD3:
		// signed int
	case 0xCA, 0xCB:
		// float
	case 0xD9, 0xDA, 0xDB:
		// str
	case 0xC4, 0xC5, 0xC6:
		// bin
	case 0xDC, 0xDD:
		// array
	case 0xDE, 0xDF:
		// map

	case 0xD4, 0xD5, 0xD6, 0xD7, 0xD8:
		// fixext
	case 0xC7, 0xC8, 0xC9:
		// ext
	}

	return i64(10), nil
}

read :: proc(u: ^Unpacker) -> (Object, Error) {
	tag := u.data[u.offset]
	u.offset += 1

	// XXXX: we handle these separately in a blanks switch as they
	// require bitmasking, while the "non-bitmasked" fields below can
	// use a regular switch.
	switch {
	case tag & 0x80 == 0:
		// positive fixint
		return u64(tag & 0x7F), nil
	case tag & 0xE0 == 0xA0:
		// fixstr
		return read_string(u, tag)

	case tag & 0xF0 == 0x80:
		// fixmap
		return read_map(u, tag)

	case tag & 0xE0 == 0xE0:
		// negative fixint
		return i64(-32 - -i8(tag & 0x1F)), nil

	case tag & 0xF0 == 0x90:
		// fixarray
		return read_array(u, tag)
	}

	switch tag {
	case 0xC0:
		// nil. XXXX
		return Nil{}, nil

	case 0xC2:
		return false, nil

	case 0xC3:
		return true, nil

	case 0xCC, 0xCD, 0xCE, 0xCF:
		// unsigned int
		return read_uint(u, tag)

	case 0xD0, 0xD1, 0xD2, 0xD3:
		// signed int
		return read_sint(u, tag)

	case 0xCA, 0xCB:
		// float
		return read_float(u, tag)

	case 0xD9, 0xDA, 0xDB:
		// str
		return read_string(u, tag)

	case 0xC4, 0xC5, 0xC6:
		// bin
		return read_bin(u, tag)

	case 0xDC, 0xDD:
		// array
		return read_array(u, tag)

	case 0xDE, 0xDF:
		// map
		return read_map(u, tag)

	case 0xD4, 0xD5, 0xD6, 0xD7, 0xD8:
		// fixext
		return read_fixext(u, tag)

	case 0xC7, 0xC8, 0xC9:
		// ext
		return read_ext(u, tag)
	}

	return nil, Unhandled_Tag{tag}
}

object_equals :: proc(left: ^Object, right: ^Object) -> bool {
	switch l in left {
	case Nil:
		_, is_nil := right.(Nil)
		return is_nil

	case bool:
		r, is_bool := right.(bool)
		return is_bool && r == l

	case []bin:
		r, is_bin := right.([]bin)
		if !is_bin || len(l) != len(r) do return false

		for idx in 0 ..< len(l) {
			if l[idx] != r[idx] do return false
		}

		return true

	case []Object:
		rl, is_list := right.([]Object)
		if !is_list || is_list && len(rl) != len(l) {
			return false
		}

		for &lo, idx in l {
			if !object_equals(&lo, &rl[idx]) do return false
		}

		return true

	case string:
		rl, is_string := right.(string)
		if !is_string do return false

		return rl == l

	case u64:
		rl, is_u64 := right.(u64)
		if !is_u64 do return false

		return rl == l
	case i64:
		rl, is_i64 := right.(i64)
		if !is_i64 do return false

		return rl == l
	case f32:
		rl, is_f32 := right.(f32)
		if !is_f32 do return false

		return rl == l
	case f64:
		rl, is_f64 := right.(f64)
		if !is_f64 do return false

		return rl == l

	case map[ObjectKey]Object:
		rl, is_map := right.(map[ObjectKey]Object)
		if !is_map || len(l) != len(rl) do return false

		for key, &v in l {
			r, exist := rl[key]
			if !exist || !object_equals(&v, &r) do return false
		}

		return true

	case time.Time:
		r, is_time := right.(time.Time)
		if !is_time do return false

		return r == l

	case Ext:
		panic("as")
	}

	return false
}

object_delete :: proc(object: Object) {
	switch l in object {
	case Nil:
	case bool:
	case []bin:
	case []Object:
		for &lo in l {
			object_delete(lo)
		}

		delete(l)

	case string:
	case u64:
	case i64:
	case f32:
	case f64:
	case map[ObjectKey]Object:
		for key, &v in l {
			// object_key_delete(key)
			object_delete(v)
		}

		delete(l)

	case time.Time:
	case Ext:
	}
}
