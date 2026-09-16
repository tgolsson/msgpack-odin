package tests

import m "../"
import "core:testing"
// XXXX: Not generated tests.

@(test)
test_nil_ser :: proc(t: ^testing.T) {
	p, buf := make_packer()
	defer m.destroy_packer(&p)
	defer free(p.string_builder)
	defer delete(p.string_builder.buf)

	value := rawptr(nil)
	m.write(&p, value)
	m.flush_packer(&p)

	slice_eq(t, buf.buf[:], []u8{192})
}


@(test)
test_nil_de :: proc(t: ^testing.T) {
	bytes := [?]u8{192}
	res, err := m.unpack_from_bytes(bytes[:])

	testing.expect_value(t, err, nil)
	if res != nil {
		testing.expectf(t, false, "expected nil, got %v", res)
	}
}


@(test)
test_nil_de_into :: proc(t: ^testing.T) {
	bytes := [?]u8{192}

	out: rawptr
	err := m.unpack_into_from_bytes(bytes[:], &out)


	testing.expect_value(t, err, nil)
	testing.expect_value(t, out, nil)
}

@(test)
test_nil_de_into_zeroes_supported_destinations :: proc(t: ^testing.T) {
	defer free_all(context.temp_allocator)

	bytes := [?]u8{192}

	number := i32(42)
	err := m.unpack_into_from_bytes(bytes[:], &number)
	testing.expect_value(t, err, nil)
	testing.expect_value(t, number, i32(0))

	flag := true
	err = m.unpack_into_from_bytes(bytes[:], &flag)
	testing.expect_value(t, err, nil)
	testing.expect_value(t, flag, false)

	text := "stale"
	err = m.unpack_into_from_bytes(bytes[:], &text)
	testing.expect_value(t, err, nil)
	testing.expect_value(t, text, "")

	Color :: enum {
		Zero,
		Red,
		Green,
	}
	color := Color.Green
	err = m.unpack_into_from_bytes(bytes[:], &color)
	testing.expect_value(t, err, nil)
	testing.expect_value(t, color, Color.Zero)

	Item :: struct {
		value: i32,
	}
	item := Item{42}
	err = m.unpack_into_from_bytes(bytes[:], &item)
	testing.expect_value(t, err, nil)
	testing.expect_value(t, item, Item{})

	items := [2]i32{42, 43}
	err = m.unpack_into_from_bytes(bytes[:], &items)
	testing.expect_value(t, err, nil)
	testing.expect_value(t, items, [2]i32{})

	Hello :: struct {}
	Goodbye :: struct {
		value: i32,
	}
	Example :: union {
		Hello,
		Goodbye,
	}
	example := Example(Goodbye{42})
	err = m.unpack_into_from_bytes(bytes[:], &example)
	testing.expect_value(t, err, nil)
	testing.expect_value(t, example, Example(nil))

	ptr_value := i32(42)
	ptr: ^i32 = &ptr_value
	err = m.unpack_into_from_bytes(bytes[:], &ptr)
	testing.expect_value(t, err, nil)
	testing.expect_value(t, ptr, (^i32)(nil))

	slice := make([]i32, 2, context.temp_allocator)
	slice[0] = 42
	slice[1] = 43
	err = m.unpack_into_from_bytes(bytes[:], &slice)
	testing.expect_value(t, err, nil)
	testing.expect_value(t, len(slice), 0)

	dyn_values := make([dynamic]i32, 2, context.temp_allocator)
	dyn_values[0] = 42
	dyn_values[1] = 43
	err = m.unpack_into_from_bytes(bytes[:], &dyn_values)
	testing.expect_value(t, err, nil)
	testing.expect_value(t, len(dyn_values), 0)

	map_value := make(map[u8]u8, 1, context.temp_allocator)
	map_value[1] = 2
	err = m.unpack_into_from_bytes(bytes[:], &map_value)
	testing.expect_value(t, err, nil)
	testing.expect_value(t, len(map_value), 0)
}

@(test)
test_rawptr_nonnnil_no_flag :: proc(t: ^testing.T) {
	// non-nil rawptr without RawptrAsNumber → msgpack nil
	p, buf := make_packer()
	defer m.destroy_packer(&p)
	defer free(p.string_builder)
	defer delete(p.string_builder.buf)

	value := rawptr(uintptr(42))
	m.write(&p, value)
	m.flush_packer(&p)

	slice_eq(t, buf.buf[:], []u8{0xc0})
}

@(test)
test_rawptr_nil_as_number :: proc(t: ^testing.T) {
	// nil rawptr with RawptrAsNumber → u64(0)
	p, buf := make_packer({.RawptrAsNumber})
	defer m.destroy_packer(&p)
	defer free(p.string_builder)
	defer delete(p.string_builder.buf)

	value := rawptr(nil)
	m.write(&p, value)
	m.flush_packer(&p)

	slice_eq(t, buf.buf[:], []u8{0x00})
}

@(test)
test_rawptr_nonnil_as_number :: proc(t: ^testing.T) {
	// non-nil rawptr with RawptrAsNumber → u64(42) as fixint
	p, buf := make_packer({.RawptrAsNumber})
	defer m.destroy_packer(&p)
	defer free(p.string_builder)
	defer delete(p.string_builder.buf)

	value := rawptr(uintptr(42))
	m.write(&p, value)
	m.flush_packer(&p)

	slice_eq(t, buf.buf[:], []u8{0x2a})
}
