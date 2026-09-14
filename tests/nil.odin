package tests

import "core:testing"
import "core:fmt"
import m "../"
import "core:strings"
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
