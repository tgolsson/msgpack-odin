package tests
import "core:testing"
import "core:fmt"
import m "../"

import "core:time"

@(test)
test_timestamp_ser :: proc(t: ^testing.T) {

    value := time.unix(171798691, 69)
    data, err := m.pack_into_bytes(value, {  })
    defer delete(data)


    slice_eq(t, data[:], []u8{215, 255, 0, 0, 1, 20, 10, 61, 112, 163})

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
test_timestamp_ptr_ser :: proc(t: ^testing.T) {

    value := time.unix(171798691, 69)
    data, err := m.pack_into_bytes(&value, {  })
    defer delete(data)


    slice_eq(t, data[:], []u8{215, 255, 0, 0, 1, 20, 10, 61, 112, 163})

}


@(test)
test_timestamp_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{215, 255, 0, 0, 1, 20, 10, 61, 112, 163}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: time.Time
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (time.Time)(time.unix(171798691, 69)))
}

@(test)
test_timestamp_no_ns_ser :: proc(t: ^testing.T) {

    value := time.unix(171798691, 0)
    data, err := m.pack_into_bytes(value, {  })
    defer delete(data)


    slice_eq(t, data[:], []u8{214, 255, 10, 61, 112, 163})

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


@(test)
test_timestamp_no_ns_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{214, 255, 10, 61, 112, 163}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: time.Time
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (time.Time)(time.unix(171798691, 0)))
}
