package tests
import "core:testing"
import "core:fmt"
import m "../"

import "core:time"
@(test)
test_timestamp_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0)
    p: m.Packer = { store, {  } }

    value := time.unix(171798691, 69)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{215, 255, 0, 0, 1, 20, 10, 61, 112, 163})
    delete(p.buf)
}


@(test)
test_timestamp_de :: proc(t: ^testing.T) {
    bytes := [?]u8{215, 255, 0, 0, 1, 20, 10, 61, 112, 163}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: m.Object = time.unix(171798691, 69)
    testing.expectf(t, m.object_equals(&res, &expected), "mismatch: %v !=  %v", res, expected)
    m.object_delete(res)
}

@(test)
test_timestamp_no_ns_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0)
    p: m.Packer = { store, {  } }

    value := time.unix(171798691, 0)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{214, 255, 10, 61, 112, 163})
    delete(p.buf)
}


@(test)
test_timestamp_no_ns_de :: proc(t: ^testing.T) {
    bytes := [?]u8{214, 255, 10, 61, 112, 163}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: m.Object = time.unix(171798691, 0)
    testing.expectf(t, m.object_equals(&res, &expected), "mismatch: %v !=  %v", res, expected)
    m.object_delete(res)
}

