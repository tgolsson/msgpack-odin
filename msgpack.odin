package msgpack

import "base:intrinsics"

import "core:fmt"
import "core:math"
import "core:sort"
import "core:time"
import "core:encoding/endian"

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

write_bytes :: proc(p: ^Packer, bytes: []u8) {
	append_elems(&p.buf, ..bytes)
}

write_bytes_head :: proc(p: ^Packer, head: u8, bytes: ..u8) {
	append_elem(&p.buf, head)
	append_elems(&p.buf, ..bytes)
}

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
		bytes := transmute([8]u8)num
		switch num {
		case 0 ..= 127:
			write_bytes(p, {bytes[0]})

		case 128 ..< 256:
			write_bytes(p, {0xcc, u8(num)})
		case 256 ..< (1 << 16):
			write_bytes(p, {0xcd, bytes[1], bytes[0]})
		case (1 << 16) ..< (1 << 32):
			write_bytes(p, {0xce, bytes[3], bytes[2], bytes[1], bytes[0]})
		case u64(1 << 32) ..= u64(1 << 64 - 1):
			write_bytes(
				p,
				{
					0xcf,
					bytes[7],
					bytes[6],
					bytes[5],
					bytes[4],
					bytes[3],
					bytes[2],
					bytes[1],
					bytes[0],
				},
			)
		}
	} else {
		num := i64(num)
		bytes := transmute([8]u8)num
		switch num {

		case -32 ..< 0:
			write_bytes(p, {u8(0b11100000) | bytes[0] & 0b11111})

		case -128 ..< 0:
			write_bytes(p, {0xd0, bytes[0]})

		case -32768 ..< 0:
			write_bytes(p, {0xd1, bytes[1], bytes[0]})
		case -(1 << 31) ..< 0:
			write_bytes(p, {0xd2, bytes[3], bytes[2], bytes[1], bytes[0]})
		case -(1 << 63) ..< 0:
			write_bytes(
				p,
				{
					0xd3,
					bytes[7],
					bytes[6],
					bytes[5],
					bytes[4],
					bytes[3],
					bytes[2],
					bytes[1],
					bytes[0],
				},
			)
		}
	}
}

write_generic_float :: proc(p: ^Packer, num: $T) where intrinsics.type_is_float(T) {
	if abs(num) <= math.F32_MAX {
		bytes := transmute([4]u8)f32(num)
		write_bytes(p, {0xca, bytes[3], bytes[2], bytes[1], bytes[0]})
	} else {
		bytes := transmute([8]u8)f64(num)
		write_bytes(
			p,
			{0xcb, bytes[7], bytes[6], bytes[5], bytes[4], bytes[3], bytes[2], bytes[1], bytes[0]},
		)
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

write :: proc {
	write_number,
	write_bool,
	write_nil,
	write_rawptr,
	write_generic_float,
	write_str,
	write_bin,
	write_bin_fixed,
	write_array,
	write_array_fixed,
	write_map,
	write_timestamp_ext1,
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

Error :: union {
	Unexpected,
	Unhandled_Tag
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
	for _ in 0 ..<size {
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
	case 4: // 32-bit unix-seconds

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
	case tag & 0x80 == 0: // positive fixint
		return u64(tag & 0x7F), nil
	case tag & 0xE0 == 0xA0: // fixstr
		return read_string(u, tag)

	case tag & 0xF0 == 0x80: // fixmap
		return nil, Unexpected{"a key-type", "a fixmap"}


	case tag & 0xE0 == 0xE0: // negative fixint
		return i64(-32 - -i8(tag & 0x1F)), nil

	case tag & 0xF0 == 0x90: // fixarray
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
	case 0xC0: // nil. XXXX
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

	case 0xD4, 0xD5, 0xD6, 0xD7, 0xD8: // fixext
		return read_fixext(u, tag)

	case 0xC7, 0xC8, 0xC9: // ext
		return read_ext(u, tag)
	}

	return nil, Unhandled_Tag { tag }
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

		for idx in 0..<len(l){
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

object_delete :: proc(object: Object){
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
