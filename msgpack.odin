package msgpack

import "base:intrinsics"
import "base:runtime"
import "core:encoding/endian"
import "core:fmt"
import "core:io"
import "core:math"
import "core:reflect"
import "core:sort"
import "core:time"

// @TODO[TSolberg]:
//   Handle endianness.
//   Differentiate bytes?
//   Accept allocators

NEEDS_SWAP :: endian.PLATFORM_BYTE_ORDER == .Little

bin :: distinct u8
binary :: distinct []bin

// Nil :: struct {}

ObjectKey :: union {
	bool,
	u64,
	i64,
	f32,
	f64,
	string,
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
	wanted: string,
	found: string,
}

Unhandled_Tag :: struct {
	tag: Tag,
}

Invalid_Parameter :: struct {
	reason: string,
}

Slice_Length_Mismatch :: struct {
	target_length: int,
	source_length: int,
}

Error :: union {
	Unexpected,
	Unhandled_Tag,
	Invalid_Parameter,
	Slice_Length_Mismatch,
	runtime.Allocator_Error,
	io.Error,
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

object_key_delete :: proc(object: ObjectKey) {
	#partial switch l in object {
	case string: delete(l)
	}
}
object_delete :: proc(object: Object) {
	switch l in object {
	case Nil:
	case bool:
	case []bin:
		delete(l)
	case []Object:
		for &lo in l {
			object_delete(lo)
		}

		delete(l)
	case string:
		delete(transmute([]u8)l)
	case u64:
	case i64:
	case f32:
	case f64:
	case map[ObjectKey]Object:
		for key, &v in l {
			object_key_delete(key)
			object_delete(v)
		}

		delete(l)

	case time.Time:
	case Ext:
	}
}
