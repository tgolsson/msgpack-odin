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
