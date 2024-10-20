package msgpack

import "base:intrinsics"
import "base:runtime"
import "core:bufio"
import "core:encoding/endian"
import "core:fmt"
import "core:io"
import "core:math"
import "core:mem"
import "core:reflect"
import "core:slice"
import "core:sort"
import "core:strings"
import "core:time"

PackerFlags :: enum {
	StableMaps = 0,
	UnionNames = 1,
	EnumNames  = 2,
}

PackerFlags_Set :: bit_set[PackerFlags]

Packer :: struct {
	writer:         io.Writer,
	bw:             bufio.Writer,
	flags:          PackerFlags_Set,
	temp_allocator: runtime.Allocator,
	string_builder: ^strings.Builder,
}

NEEDS_SWAP :: endian.PLATFORM_BYTE_ORDER == .Little

packer_for_bytes :: proc(
	flags: PackerFlags_Set,
	allocator := context.allocator,
	temp_allocator := context.temp_allocator,
) -> (
	p: Packer,
	err: Pack_Error,
) {
	b := new(strings.Builder, allocator) or_return
	defer if err != nil {
		free(b)
	}

	strings.builder_init(b, 0, 100, allocator) or_return
	packer := packer_for_builder(b, flags, temp_allocator)
	packer.string_builder = b
	return packer, nil
}

packer_for_builder :: proc(
	builder: ^strings.Builder,
	flags: PackerFlags_Set,
	temp_allocator := context.temp_allocator,
) -> Packer {
	writer := strings.to_writer(builder)
	return packer_for_writer(writer, flags, temp_allocator)
}

packer_for_writer :: proc(
	writer: io.Writer,
	flags: PackerFlags_Set,
	temp_allocator := context.temp_allocator,
) -> Packer {
	buffered_writer: bufio.Writer
	bufio.writer_init(&buffered_writer, writer, allocator = temp_allocator)
	packer := Packer{writer, buffered_writer, flags, temp_allocator, nil}
	return packer
}

pack_into_bytes :: proc(
	v: any,
	flags: PackerFlags_Set,
	allocator := context.allocator,
	temp_allocator := context.temp_allocator,
	loc := #caller_location,
) -> (
	bytes: []u8,
	err: Pack_Error,
) {
	packer := packer_for_bytes(flags, allocator, temp_allocator) or_return
	defer free(packer.string_builder)
	defer if err != nil do strings.builder_destroy(packer.string_builder)
	{
		defer bufio.writer_destroy(&packer.bw)
		defer bufio.writer_flush(&packer.bw)

		pack_any(&packer, v) or_return
	}
	return packer.string_builder.buf[:], nil
}

pack_into_builder :: proc(
	builder: ^strings.Builder,
	v: any,
	flags: PackerFlags_Set,
	temp_allocator := context.temp_allocator,
	loc := #caller_location,
) -> (
	err: Pack_Error,
) {
	packer := packer_for_builder(builder, flags, temp_allocator)
	defer free(packer.string_builder)
	defer if err != nil do strings.builder_destroy(packer.string_builder)
	defer bufio.writer_destroy(&packer.bw)
	defer bufio.writer_flush(&packer.bw)

	return pack_any(&packer, v)
}

pack_into_writer :: proc(
	writer: io.Writer,
	v: any,
	flags: PackerFlags_Set,
	temp_allocator := context.temp_allocator,
	loc := #caller_location,
) -> (
	err: Pack_Error,
) {
	packer := packer_for_writer(writer, flags, temp_allocator)
	defer bufio.writer_destroy(&packer.bw)
	defer bufio.writer_flush(&packer.bw)

	return pack_any(&packer, v)
}

Pack_Error :: union {
	io.Error,
	Invalid_Parameter,
	runtime.Allocator_Error,
}

pack_any :: proc(p: ^Packer, value: any) -> (err: Pack_Error) {
	v := value

	if v == nil || v.id == nil {
		return Invalid_Parameter{"v was nil or its type was nil"}
	}

	v = reflect.any_base(v)
	ti := type_info_of(v.id)
	if ti.id == rawptr {
		return Invalid_Parameter{"valuie is "}
	}

	if reflect.is_pointer(ti) {
		data := any{(^rawptr)(v.data)^, ti.variant.(reflect.Type_Info_Pointer).elem.id}
		return pack_any_ptr(p, data)
	} else {
		data := any{(rawptr)(v.data), value.id}
		return pack_any_ptr(p, data)
	}
}

pack_any_ptr :: proc(p: ^Packer, value: any) -> (err: Pack_Error) {
	write(p, value)

	return nil
}

pack_number :: proc(p: ^Packer, num: $T) -> (err: Pack_Error) {
	num := num
	when T != u8 && T != i8 {
		num = intrinsics.byte_swap(num)
	}

	bytes: [size_of(T)]u8 = transmute([size_of(T)]u8)num
	bufio.writer_write(&p.bw, bytes[:]) or_return
	return nil
}


write_byte :: #force_inline proc(p: ^Packer, b: u8) -> Pack_Error {
	return bufio.writer_write_byte(&p.bw, b)
}

write_bytes :: #force_inline proc(p: ^Packer, bytes: []u8) -> Pack_Error {
	_, err := bufio.writer_write(&p.bw, bytes)
	return err
}

write_nbytes :: #force_inline proc(p: ^Packer, bytes: [$N]u8) {
	bytes := bytes
	write_bytes(p, bytes[:])
}

write_nbytes_r :: #force_inline proc(p: ^Packer, bytes: [$N]u8) {
	bytes := bytes
	slice.reverse(bytes[:])

	write_nbytes(p, bytes)
}

write_nbytes_head :: proc(p: ^Packer, head: u8, bytes: [$N]u8) {
	write_byte(p, head)
	write_nbytes(p, bytes)
}

write_nbytes_head_r :: proc(p: ^Packer, head: u8, bytes: [$N]u8) {
	write_byte(p, head)
	write_nbytes_r(p, bytes)
}

write_bytes_2 :: proc(p: ^Packer, bytes: ..u8) {
	write_bytes(p, bytes)
}

write_multibyte :: write_nbytes_r when NEEDS_SWAP else write_nbytes
write_multibyte_head :: write_nbytes_head_r when NEEDS_SWAP else write_nbytes_head

write_number_swapped :: #force_inline proc(p: ^Packer, tag: Tag, number: $T) -> (err: Pack_Error) {
	number := number
	when T != u8 && T != i8 {
		number = intrinsics.byte_swap(number)
	}

	encode_tag(p, tag)
	bytes := transmute([size_of(T)]u8)number
	_, err = bufio.writer_write(&p.bw, bytes[:])

	return
}


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
	if num < math.F32_MAX {
		write_number_swapped(p, Float{false}, f32(num))
	} else {
		write_number_swapped(p, Float{true}, f64(num))
	}
}

write_bool :: proc(p: ^Packer, v: bool) {
	write_bytes(p, {0xc3} if v else {0xc2})
}

write_str :: proc(p: ^Packer, v: string) {
	data := transmute([]u8)v

	encode_tag(p, Str{len(v)})
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

pack_array_specialized :: proc(
	p: ^Packer,
	$T: typeid,
	base_ptr: rawptr,
	count: int,
) -> (
	err: Pack_Error,
) {
	for i in 0 ..< count {
		data := uintptr(base_ptr) + uintptr(i * size_of(T))
		when T == f32 || T == f64 {
			write_generic_float(p, ((^T)(data))^)
		} else {
			write_number(p, ((^T)(data))^)
		}
	}

	return nil
}


pack_struct :: proc(
	p: ^Packer,
	info: runtime.Type_Info_Struct,
	base_ptr: rawptr,
) -> (
	err: Pack_Error,
) {
	begin_map(p, u32(info.field_count))

	for name, i in info.names[:info.field_count] {
		write_str(p, name)
		id := info.types[i].id
		data := rawptr(uintptr(base_ptr) + info.offsets[i])
		the_value := any{data, id}
		// TODO
		// if info.usings[i] && name == "_" {
		// 	write_struct_fields(p, the_value, opt)
		// } else {
		write(p, the_value) or_return
		//}
	}

	return nil
}

write :: proc(p: ^Packer, data: any) -> (err: Pack_Error) {
	ti := runtime.type_info_base(type_info_of(data.id))
	a := any{data.data, ti.id}

	switch info in ti.variant {
	case runtime.Type_Info_Named, runtime.Type_Info_Enum, runtime.Type_Info_Bit_Field:
		unreachable()


	case runtime.Type_Info_Pointer, runtime.Type_Info_Multi_Pointer, runtime.Type_Info_Procedure:
		if (^rawptr)(data.data)^ == nil {
			write_nil(p)
		}
	case runtime.Type_Info_Integer:
		switch data.id {
		case i8:
			write_number(p, a.(i8))
		case i16:
			write_number(p, a.(i16))
		case i32:
			write_number(p, a.(i32))
		case i64:
			write_number(p, a.(i64))
		case int:
			write_number(p, a.(int))
		case u8:
			write_number(p, a.(u8))
		case u16:
			write_number(p, a.(u16))
		case u32:
			write_number(p, a.(u32))
		case u64:
			write_number(p, a.(u64))
		}
	case runtime.Type_Info_Union:
		v := data
		id := reflect.union_variant_typeid(v)
		if v.data == nil || id == nil {
			encode_tag(p, Nil{})
			return
		}

		encode_tag(p, Map{length = 1})
		vti := reflect.union_variant_type_info(v)
		if .UnionNames in p.flags {
			#partial switch vt in vti.variant {
			case reflect.Type_Info_Named:
				write_str(p, vt.name)

			case:
				builder := strings.builder_make(p.temp_allocator) or_return

				defer strings.builder_destroy(&builder)
				reflect.write_type(&builder, vti)
				write_str(p, strings.to_string(builder))
			}
		} else {
			write_number(p, reflect.get_union_variant_raw_tag(v))
		}
		return write(p, any{v.data, vti.id})

	case runtime.Type_Info_Rune,
	     runtime.Type_Info_Complex,
	     runtime.Type_Info_Quaternion,
	     runtime.Type_Info_Enumerated_Array,
	     runtime.Type_Info_Parameters,
	     runtime.Type_Info_Bit_Set,
	     runtime.Type_Info_Simd_Vector,
	     runtime.Type_Info_Relative_Pointer,
	     runtime.Type_Info_Relative_Multi_Pointer,
	     runtime.Type_Info_Matrix,
	     runtime.Type_Info_Soa_Pointer,
	     runtime.Type_Info_Type_Id,
	     runtime.Type_Info_Any:
		unreachable()
	case runtime.Type_Info_Dynamic_Array:
		da := cast(^mem.Raw_Dynamic_Array)data.data
		if info.elem.id == bin {
			tag := Bin{da.len}
			encode_tag(p, tag)

			s := slice.from_ptr(cast(^u8)data.data, da.len)
			bufio.writer_write(&p.bw, s) or_return
		} else {
			begin_array(p, u32(da.len))


			switch info.elem.id {
			case i8:
				pack_array_specialized(p, i8, da.data, da.len)
			case i16:
				pack_array_specialized(p, i16, da.data, da.len)
			case i32:
				pack_array_specialized(p, i32, da.data, da.len)
			case i64:
				pack_array_specialized(p, i64, da.data, da.len)
			case u8:
				pack_array_specialized(p, u8, da.data, da.len)
			case u16:
				pack_array_specialized(p, u16, da.data, da.len)
			case u32:
				pack_array_specialized(p, u32, da.data, da.len)
			case u64:
				pack_array_specialized(p, u64, da.data, da.len)
			case f32:
				pack_array_specialized(p, f32, da.data, da.len)
			case f64:
				pack_array_specialized(p, f64, da.data, da.len)
			case:
				for i in 0 ..< da.len {
					data := uintptr(da.data) + uintptr(i * info.elem_size)
					write(p, any{rawptr(data), info.elem.id})
				}
			}
		}
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

			switch info.elem.id {
			case i8:
				pack_array_specialized(p, i8, d.data, d.len)
			case i16:
				pack_array_specialized(p, i16, d.data, d.len)
			case i32:
				pack_array_specialized(p, i32, d.data, d.len)
			case i64:
				pack_array_specialized(p, i64, d.data, d.len)
			case u8:
				pack_array_specialized(p, u8, d.data, d.len)
			case u16:
				pack_array_specialized(p, u16, d.data, d.len)
			case u32:
				pack_array_specialized(p, u32, d.data, d.len)
			case u64:
				pack_array_specialized(p, u64, d.data, d.len)
			case f32:
				pack_array_specialized(p, f32, d.data, d.len)
			case f64:
				pack_array_specialized(p, f64, d.data, d.len)
			case:
				for i in 0 ..< d.len {
					data := uintptr(d.data) + uintptr(i * info.elem_size)
					write(p, any{rawptr(data), info.elem.id})
				}
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

			switch info.elem.id {
			case i8:
				pack_array_specialized(p, i8, data.data, info.count)
			case i16:
				pack_array_specialized(p, i16, data.data, info.count)
			case i32:
				pack_array_specialized(p, i32, data.data, info.count)
			case i64:
				pack_array_specialized(p, i64, data.data, info.count)
			case u8:
				pack_array_specialized(p, u8, data.data, info.count)
			case u16:
				pack_array_specialized(p, u16, data.data, info.count)
			case u32:
				pack_array_specialized(p, u32, data.data, info.count)
			case u64:
				pack_array_specialized(p, u64, data.data, info.count)
			case f32:
				pack_array_specialized(p, f32, data.data, info.count)
			case f64:
				pack_array_specialized(p, f64, data.data, info.count)
			case:
				for i in 0 ..< info.count {
					data := uintptr(data.data) + uintptr(i * info.elem_size)
					write(p, any{rawptr(data), info.elem.id})
				}
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
		if data.id == f32 {
			write_generic_float(p, a.(f32))
		} else {
			write_generic_float(p, a.(f64))
		}

	case runtime.Type_Info_Struct:
		if data.id == time.Time {
			write_timestamp_ext1(p, data.(time.Time))
		} else {
			pack_struct(p, info, data.data) or_return
		}
	case runtime.Type_Info_Map:
		m := (^mem.Raw_Map)(data.data)
		if info.map_info == nil {
			// TODO
		}
		map_cap := uintptr(runtime.map_cap(m^))
		ks, vs, hs, _, _ := runtime.map_kvh_data_dynamic(m^, info.map_info)

		count_valid := 0
		for bucket_index in 0 ..< map_cap {
			runtime.map_hash_is_valid(hs[bucket_index]) or_continue
			count_valid += 1
		}
		begin_map(p, u32(count_valid))
		if .StableMaps not_in p.flags {
			i := 0
			for bucket_index in 0 ..< map_cap {
				runtime.map_hash_is_valid(hs[bucket_index]) or_continue

				key := rawptr(runtime.map_cell_index_dynamic(ks, info.map_info.ks, bucket_index))
				value := rawptr(runtime.map_cell_index_dynamic(vs, info.map_info.vs, bucket_index))

				write(p, any{key, info.key.id})
				write(p, any{value, info.value.id})
			}
		} else {
			Entry :: struct($T: typeid) {
				key:   T,
				value: any,
			}

			output_sorted :: proc(
				p: ^Packer,
				map_cap: uintptr,
				info: runtime.Type_Info_Map,
				ks: uintptr,
				vs: uintptr,
				hs: [^]runtime.Map_Hash,
				key_conv: proc(ptr: uintptr) -> $T,
			) {
				sorted := make([dynamic]Entry(T), 0, map_cap, context.temp_allocator)
				for bucket_index in 0 ..< map_cap {
					runtime.map_hash_is_valid(hs[bucket_index]) or_continue

					key := key_conv(
						runtime.map_cell_index_dynamic(ks, info.map_info.ks, bucket_index),
					)
					value := rawptr(
						runtime.map_cell_index_dynamic(vs, info.map_info.vs, bucket_index),
					)

					append(&sorted, Entry(T){key = key, value = any{value, info.value.id}})
				}

				slice.sort_by(sorted[:], proc(i, j: Entry(T)) -> bool {return i.key < j.key})


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

	return
}
