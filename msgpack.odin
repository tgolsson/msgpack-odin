package msgpack

import "base:intrinsics"

import "core:sort"
import "core:time"

// @TODO[TSolberg]:
//   Handle endianness.
//   Differentiate bytes?
//   Accept allocators


bin :: distinct u8
binary :: distinct []u8

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
		case u64(1 << 32) ..< u64(1 << 63):
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

import "core:math"

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
	sec := u64(v._nsec / 1000_000_000)
	nsecs := u64(v._nsec) - sec * 1000_000_000
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

Unpacker :: struct {
	data:   [^]u8,
	offset: u64,
}


read :: proc(u: ^Unpacker) -> Object {
	tag := u.data[u.offset]
	u.offset += 1

	switch {
	case tag & 0xE0 == 0xA0:
		size := u64(tag & 0x1F)
		bytes := u.data[u.offset:u.offset+size]
		u.offset += size

		return string(bytes)

	case tag & 0x80 == 0:
		// positive fixint
	case tag & 0xE0 == 0xE0:
		// negative fixint
	case tag & 0xF0 == 0x90:
		// fixarray
	case tag & 0xF0 == 0x80:
		// fixmap
	}

	switch tag {

	case 0xC0: // nil
	case 0xc2, 0xc3:
	case  0xCC,  0xCD,  0xCE, 0xCF:
		// unsigned int
	case  0xD0,  0xD1,  0xD2, 0xD3:
		// signed int
	case  0xCA,  0xCB:
		// float
	case  0xD9, 0xDA, 0xDB:
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

	return time.Time{}
}
