package tests

import "core:testing"
import "core:fmt"
import m "../"

// XXXX: Not generated tests.

@(test)
test_nil_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := rawptr(nil)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{192})
    delete(p.buf)
}


@(test)
test_nil_de :: proc(t: ^testing.T) {
    bytes := [?]u8{192}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
	if res != nil {
		testing.expectf(t, false, "expected nil, got %v", res)
	}
}


@(test)
test_nil_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{192}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: rawptr
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, nil)
}
