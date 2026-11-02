package tests

import m "../"
import "core:mem"
import "core:testing"

Distinct_U32 :: distinct u32
Distinct_I64 :: distinct i64
Distinct_F32 :: distinct f32
Distinct_F64 :: distinct f64
Distinct_String :: distinct string

Distinct_Numbers :: struct {
	id:    Distinct_U32,
	delta: Distinct_I64,
	x:     Distinct_F32,
	y:     Distinct_F64,
	after: i32,
}

Distinct_Named :: struct {
	name:  Distinct_String,
	after: i32,
}

@(test)
test_distinct_number_fields_round_trip :: proc(t: ^testing.T) {
	value := Distinct_Numbers{7, -3, 1.5, 0.1, 42}
	for flags in ([]m.PackerFlags_Set{{}, {.FieldNames}}) {
		data, pack_err := m.pack_into_bytes(value, flags)
		defer delete(data)
		testing.expect_value(t, pack_err, nil)

		decoded: Distinct_Numbers
		unpack_err := m.unpack_into_from_bytes(data, &decoded)
		testing.expect_value(t, unpack_err, nil)
		testing.expect_value(t, decoded, value)
	}
}

@(test)
test_distinct_string_field_round_trips :: proc(t: ^testing.T) {
	value := Distinct_Named{"robot", 42}
	data, pack_err := m.pack_into_bytes(value, {.FieldNames})
	defer delete(data)
	testing.expect_value(t, pack_err, nil)

	decoded: Distinct_Named
	defer delete(string(decoded.name))
	unpack_err := m.unpack_into_from_bytes(data, &decoded)
	testing.expect_value(t, unpack_err, nil)
	testing.expect_value(t, decoded, value)
}

@(test)
test_f64_keeps_precision :: proc(t: ^testing.T) {
	value := [3]f64{0.1, 1.0 / 3.0, 0.3884336230241873}
	data, pack_err := m.pack_into_bytes(value, {})
	defer delete(data)
	testing.expect_value(t, pack_err, nil)

	decoded: [3]f64
	unpack_err := m.unpack_into_from_bytes(data, &decoded)
	testing.expect_value(t, unpack_err, nil)
	testing.expect_value(t, decoded, value)
}

@(test)
test_f64_exact_in_f32_packs_as_f32 :: proc(t: ^testing.T) {
	data, pack_err := m.pack_into_bytes(f64(0.5), {})
	defer delete(data)
	testing.expect_value(t, pack_err, nil)
	slice_eq(t, data, []u8{0xca, 0x3f, 0x00, 0x00, 0x00})
}

@(test)
test_unpack_named_keys_with_unpacker_allocator :: proc(t: ^testing.T) {
	value := Foo{1, 2}
	data, pack_err := m.pack_into_bytes(value, {.FieldNames})
	defer delete(data)
	testing.expect_value(t, pack_err, nil)

	backing: [64 * 1024]u8
	arena: mem.Arena
	mem.arena_init(&arena, backing[:])

	decoded: Foo
	unpack_err := m.unpack_into_from_bytes(data, &decoded, mem.arena_allocator(&arena))
	testing.expect_value(t, unpack_err, nil)
	testing.expect_value(t, decoded, value)
}
