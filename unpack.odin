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
import "core:time"
import "core:strings"

Unpacker :: struct {
	data:   [^]u8,
	offset: u64,
}

read_byte  :: proc(u: ^Unpacker) -> u8 {
	u.offset += 1
	return u.data[u.offset - 1]
}

read_multibyte :: read_nbytes_r when NEEDS_SWAP else read_nbytes

read_nbytes :: proc(u: ^Unpacker, $bytes: u64) -> [bytes]u8 {
	out: [bytes]u8
	copy(out[:], u.data[u.offset:u.offset+bytes])
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

read_string :: proc(u: ^Unpacker, size: int) -> (string, Error) {
	// size: u64 = 0

	// switch {
	// case tag & 0xE0 == 0xA0:
	// 	// fixstr
	// 	size = u64(tag & 0x1F)
	// case tag == 0xD9:
	// 	size = read_size(u, 1)
	// case tag == 0xDA:
	// 	size = read_size(u, 2)
	// case tag == 0xDB:
	// 	size = read_size(u, 4)
	// }

	bytes := u.data[u.offset:u.offset + u64(size)]
	u.offset += u64(size)

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
	tag := decode_tag(u)

	// switch {
	// case tag & 0x80 == 0:
	// 	// positive fixint
	// 	return u64(tag & 0x7F), nil
	// case tag & 0xE0 == 0xA0:
	// 	// fixstr
	// 	return read_string(u, tag)

	// case tag & 0xF0 == 0x80:
	// 	// fixmap
	// 	return nil, Unexpected{"a key-type", "a fixmap"}


	// case tag & 0xE0 == 0xE0:
	// 	// negative fixint
	// 	return i64(-32 - -i8(tag & 0x1F)), nil

	// case tag & 0xF0 == 0x90:
	// 	// fixarray
	// 	return nil, Unexpected{"a key-type", "a fixarray"}
	// }

	// switch tag {

	// case 0xC0: // nil
	// case 0xc2, 0xc3:
	// case 0xCC, 0xCD, 0xCE, 0xCF:
	// 	// unsigned int
	// case 0xD0, 0xD1, 0xD2, 0xD3:
	// 	// signed int
	// case 0xCA, 0xCB:
	// 	// float
	// case 0xD9, 0xDA, 0xDB:
	// 	// str
	// case 0xC4, 0xC5, 0xC6:
	// 	// bin
	// case 0xDC, 0xDD:
	// 	// array
	// case 0xDE, 0xDF:
	// 	// map

	// case 0xD4, 0xD5, 0xD6, 0xD7, 0xD8:
	// 	// fixext
	// case 0xC7, 0xC8, 0xC9:
	// 	// ext
	// }

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
		return read_string(u, 0) // TODO

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
		return read_string(u, 0) // TODO

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

assign_num :: proc(v: any, t: typeid, value: $T) where intrinsics.type_is_numeric(T) {
	data := v.data
	switch t {
	case i8: (^i8)(v.data)^ = i8(value)
	case i16: (^i16)(v.data)^ = i16(value)
	case i32: (^i32)(v.data)^ = i32(value)
	case i64: (^i64)(v.data)^ = i64(value)
	case u8: (^u8)(v.data)^ = u8(value)
	case u16: (^u16)(v.data)^ = u16(value)
	case u32: (^u32)(v.data)^ = u32(value)
	case u64: (^u64)(v.data)^ = u64(value)
	case int: (^int)(v.data)^ = int(value)
	case f32: (^f32)(v.data)^ = f32(value)
	case f64: (^f64)(v.data)^ = f64(value)
	}
}

assign_str :: proc(v: any, t: typeid, value: $T) {
	when T == string {
		switch t {
		case string: (^string)(v.data)^ = value
		case cstring: (^cstring)(v.data)^ = strings.unsafe_string_to_cstring(value)
		}
	} else when T == cstring {
		switch t {
		case string: (^string)(v.data)^ = string(value)
		case cstring: (^cstring)(v.data)^ = value
		}
	}
}


read_into :: proc(u: ^Unpacker, t: any) -> Error {
	v := t

	if v == nil || v.id == nil {
		return Invalid_Parameter{ "v was nil or its type was nil"}
	}

	v = reflect.any_base(v)
	ti := type_info_of(v.id)
	if !reflect.is_pointer(ti) || ti.id == rawptr {
		return Invalid_Parameter{ "t is not a pointer"}
	}

	data := any{(^rawptr)(v.data)^, ti.variant.(reflect.Type_Info_Pointer).elem.id}

	return read_into_value(u, data)
}

read_map_into :: proc(u: ^Unpacker, v: any, info: runtime.Type_Info_Map, length: u64  ) -> Error {
	key_type := info.key.id
	value_type := info.value.id

	out_map := [0]u8{}
	for index in 0..<length {


	}

	return nil
}


read_struct_into :: proc(u: ^Unpacker, v: any, info: runtime.Type_Info_Struct, length: u64  ) -> Error {

	return nil
}

read_into_value :: proc(u: ^Unpacker, t: any) -> Error {
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
		case 1: assign_num(v, v.id, read_number(u, u8))
		case 2: assign_num(v, v.id, read_number(u, u16))
		case 4: assign_num(v, v.id, read_number(u, u32))
		case 8: assign_num(v, v.id, read_number(u, u64))
		}
	case Int:
		switch variant.width {
 		case 1: assign_num(v, v.id, read_number(u, i8))
		case 2: assign_num(v, v.id, read_number(u, i16))
		case 4: assign_num(v, v.id, read_number(u, i32))
		case 8: assign_num(v, v.id, read_number(u, i64))
		}
	case Bool:
		if v.id == bool {
		 	(^bool)(v.data)^ = variant.value
		} else {
			return Unexpected { "a bool", "not a bool" }
		}

	case Nil:
		// TODO
	case Map:
		length := u64(variant.length)

		#partial switch info in ti.variant {
		case runtime.Type_Info_Map:
			read_map_into(u, v, info, length)
		case runtime.Type_Info_Struct:
			read_struct_into(u, v, info, length)
		case:
		    panic(fmt.aprintf("unhandled target for map: %v", info))
		}

	case Bin:
	case Ext:
	case Float:

	case Array: // fixarray
		length := variant.length
		maybe := ti

		#partial switch info in maybe.variant {
			case runtime.Type_Info_Array:
			if length != info.count {
				return Slice_Length_Mismatch {
					info.count, length
				}
			}

			for i in 0..<length {
				dest := uintptr(v.data) + uintptr(int(i) * info.elem_size)
				read_into_value(u, any{rawptr(dest), info.elem.id}) or_return
			}

		case runtime.Type_Info_Slice:
    		d := cast(^mem.Raw_Slice)v.data
			if length != d.len / info.elem_size {
				return Slice_Length_Mismatch {
					d.len / info.elem_size, length
				}
			}

			for i in 0..<length {
				dest := uintptr(d.data) + uintptr(int(i) * info.elem_size)
				read_into_value(u, any{rawptr(dest), info.elem.id}) or_return
			}
		case:
		panic(fmt.aprintfln("foobar: %v", info))
		}

	}

	// switch tag {
	// case 0xC0:
	// 	// nil. XXXX
	// 	// return Nil{}, nil

	// case 0xC2, 0xC3:
	// 	maybe := ti.id

	// case 0xCC, 0xCD, 0xCE, 0xCF: // uint
	// 	ok := read_uint(u, tag) or_return

	// 	maybe := ti.id
	// 	assign_num(v, maybe, ok.(u64))

	// case 0xD0, 0xD1, 0xD2, 0xD3:
	// 	ok := read_sint(u, tag) or_return

	// 	maybe := ti.id
	// 	assign_num(v, maybe, ok.(i64))

	// case 0xCA, 0xCB:
	// 	ok := read_float(u, tag) or_return

	// 	maybe := ti.id
	// 	fmt.println("read float", ok, maybe)
	// 	#partial switch f in ok {
	// 	case f32: 		assign_num(v, maybe, f)
	// 	case f64: 		assign_num(v, maybe, f)
	// 	case: unreachable()
	// 	}

	// case 0xD9, 0xDA, 0xDB:
	// 	// str
	// 	// return read_string(u, tag)

	// case 0xC4, 0xC5, 0xC6: // bin
	// 	data := read_bin(u, tag) or_return
	// 	maybe := ti.id
	// 	if maybe == []bin {
	// 		(^[]bin)(v.data)^ = data
	// 	}

	// case 0xDC, 0xDD:
	// 	// array
	// 	// return read_array(u, tag)

	// case 0xDE, 0xDF:
	// 	// map
	// 	// return read_map(u, tag)

	// case 0xD4, 0xD5, 0xD6, 0xD7, 0xD8:
	// 	// fixext
	// 	// return read_fixext(u, tag)

	// case 0xC7, 0xC8, 0xC9:
	// 	// ext
	// 	// return read_ext(u, tag)
	// }

	return nil
}
