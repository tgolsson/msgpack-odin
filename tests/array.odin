package tests
import "core:testing"
import "core:fmt"
import m "../"

@(test)
test_str_array_0_ser :: proc(t: ^testing.T) {

    value := [0]string{}
    data, err := m.pack_into_bytes(value, {  })
    defer delete(data)


    slice_eq(t, data[:], []u8{144})

}


@(test)
test_str_array_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{144}
    res, err := m.unpack_from_bytes(bytes[:])

    testing.expect_value(t, err, nil)
    inner := [0]m.Object{}; expected: m.Object = inner[:]
    testing.expectf(t, m.object_equals(&res, &expected), "mismatch: %v !=  %v", res, expected)
    m.object_delete(res)
}


@(test)
test_str_array_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{144}
    out: [0]string
    err := m.unpack_into_from_bytes(bytes[:], &out)


    testing.expect_value(t, err, nil)
    v := [0]string{}; slice_eq(t, v[:], out[:])
}

@(test)
test_u16_array_0_ser :: proc(t: ^testing.T) {

    value := [0]u16{}
    data, err := m.pack_into_bytes(value, {  })
    defer delete(data)


    slice_eq(t, data[:], []u8{144})

}


@(test)
test_u16_array_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{144}
    res, err := m.unpack_from_bytes(bytes[:])

    testing.expect_value(t, err, nil)
    inner := [0]m.Object{}; expected: m.Object = inner[:]
    testing.expectf(t, m.object_equals(&res, &expected), "mismatch: %v !=  %v", res, expected)
    m.object_delete(res)
}


@(test)
test_u16_array_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{144}
    out: [0]u16
    err := m.unpack_into_from_bytes(bytes[:], &out)


    testing.expect_value(t, err, nil)
    v := [0]u16{}; slice_eq(t, v[:], out[:])
}

@(test)
test_f32_array_0_ser :: proc(t: ^testing.T) {

    value := [0]f32{}
    data, err := m.pack_into_bytes(value, {  })
    defer delete(data)


    slice_eq(t, data[:], []u8{144})

}


@(test)
test_f32_array_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{144}
    res, err := m.unpack_from_bytes(bytes[:])

    testing.expect_value(t, err, nil)
    inner := [0]m.Object{}; expected: m.Object = inner[:]
    testing.expectf(t, m.object_equals(&res, &expected), "mismatch: %v !=  %v", res, expected)
    m.object_delete(res)
}


@(test)
test_f32_array_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{144}
    out: [0]f32
    err := m.unpack_into_from_bytes(bytes[:], &out)


    testing.expect_value(t, err, nil)
    v := [0]f32{}; slice_eq(t, v[:], out[:])
}

@(test)
test_str_array_5_ser :: proc(t: ^testing.T) {

    value := [5]string{"x", "x", "x", "x", "x"}
    data, err := m.pack_into_bytes(value, {  })
    defer delete(data)


    slice_eq(t, data[:], []u8{149, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120})

}


@(test)
test_str_array_5_de :: proc(t: ^testing.T) {
    bytes := [?]u8{149, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120}
    res, err := m.unpack_from_bytes(bytes[:])

    testing.expect_value(t, err, nil)
    inner := [5]m.Object{"x", "x", "x", "x", "x"}; expected: m.Object = inner[:]
    testing.expectf(t, m.object_equals(&res, &expected), "mismatch: %v !=  %v", res, expected)
    m.object_delete(res)
}


@(test)
test_str_array_5_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{149, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120}
    out: [5]string
    err := m.unpack_into_from_bytes(bytes[:], &out)


    testing.expect_value(t, err, nil)
    v := [5]string{"x", "x", "x", "x", "x"}; slice_eq(t, v[:], out[:])
}

@(test)
test_u16_array_5_ser :: proc(t: ^testing.T) {

    value := [5]u16{1<<14, 1<<14, 1<<14, 1<<14, 1<<14}
    data, err := m.pack_into_bytes(value, {  })
    defer delete(data)


    slice_eq(t, data[:], []u8{149, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0})

}


@(test)
test_u16_array_5_de :: proc(t: ^testing.T) {
    bytes := [?]u8{149, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0}
    res, err := m.unpack_from_bytes(bytes[:])

    testing.expect_value(t, err, nil)
    inner := [5]m.Object{m.Object(u64(1 << 14)), m.Object(u64(1 << 14)), m.Object(u64(1 << 14)), m.Object(u64(1 << 14)), m.Object(u64(1 << 14))}; expected: m.Object = inner[:]
    testing.expectf(t, m.object_equals(&res, &expected), "mismatch: %v !=  %v", res, expected)
    m.object_delete(res)
}


@(test)
test_u16_array_5_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{149, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0}
    out: [5]u16
    err := m.unpack_into_from_bytes(bytes[:], &out)


    testing.expect_value(t, err, nil)
    v := [5]u16{1<<14, 1<<14, 1<<14, 1<<14, 1<<14}; slice_eq(t, v[:], out[:])
}

@(test)
test_f32_array_5_ser :: proc(t: ^testing.T) {

    value := [5]f32{1.5, 1.5, 1.5, 1.5, 1.5}
    data, err := m.pack_into_bytes(value, {  })
    defer delete(data)


    slice_eq(t, data[:], []u8{149, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0})

}


@(test)
test_f32_array_5_de :: proc(t: ^testing.T) {
    bytes := [?]u8{149, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0}
    res, err := m.unpack_from_bytes(bytes[:])

    testing.expect_value(t, err, nil)
    inner := [5]m.Object{m.Object(f32(1.5)), m.Object(f32(1.5)), m.Object(f32(1.5)), m.Object(f32(1.5)), m.Object(f32(1.5))}; expected: m.Object = inner[:]
    testing.expectf(t, m.object_equals(&res, &expected), "mismatch: %v !=  %v", res, expected)
    m.object_delete(res)
}


@(test)
test_f32_array_5_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{149, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0}
    out: [5]f32
    err := m.unpack_into_from_bytes(bytes[:], &out)


    testing.expect_value(t, err, nil)
    v := [5]f32{1.5, 1.5, 1.5, 1.5, 1.5}; slice_eq(t, v[:], out[:])
}

@(test)
test_str_array_20_ser :: proc(t: ^testing.T) {

    value := [20]string{"x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x"}
    data, err := m.pack_into_bytes(value, {  })
    defer delete(data)


    slice_eq(t, data[:], []u8{220, 0, 20, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120})

}


@(test)
test_str_array_20_de :: proc(t: ^testing.T) {
    bytes := [?]u8{220, 0, 20, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120}
    res, err := m.unpack_from_bytes(bytes[:])

    testing.expect_value(t, err, nil)
    inner := [20]m.Object{"x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x"}; expected: m.Object = inner[:]
    testing.expectf(t, m.object_equals(&res, &expected), "mismatch: %v !=  %v", res, expected)
    m.object_delete(res)
}


@(test)
test_str_array_20_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{220, 0, 20, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120}
    out: [20]string
    err := m.unpack_into_from_bytes(bytes[:], &out)


    testing.expect_value(t, err, nil)
    v := [20]string{"x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x"}; slice_eq(t, v[:], out[:])
}

@(test)
test_u16_array_20_ser :: proc(t: ^testing.T) {

    value := [20]u16{1<<14, 1<<14, 1<<14, 1<<14, 1<<14, 1<<14, 1<<14, 1<<14, 1<<14, 1<<14, 1<<14, 1<<14, 1<<14, 1<<14, 1<<14, 1<<14, 1<<14, 1<<14, 1<<14, 1<<14}
    data, err := m.pack_into_bytes(value, {  })
    defer delete(data)


    slice_eq(t, data[:], []u8{220, 0, 20, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0})

}


@(test)
test_u16_array_20_de :: proc(t: ^testing.T) {
    bytes := [?]u8{220, 0, 20, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0}
    res, err := m.unpack_from_bytes(bytes[:])

    testing.expect_value(t, err, nil)
    inner := [20]m.Object{m.Object(u64(1 << 14)), m.Object(u64(1 << 14)), m.Object(u64(1 << 14)), m.Object(u64(1 << 14)), m.Object(u64(1 << 14)), m.Object(u64(1 << 14)), m.Object(u64(1 << 14)), m.Object(u64(1 << 14)), m.Object(u64(1 << 14)), m.Object(u64(1 << 14)), m.Object(u64(1 << 14)), m.Object(u64(1 << 14)), m.Object(u64(1 << 14)), m.Object(u64(1 << 14)), m.Object(u64(1 << 14)), m.Object(u64(1 << 14)), m.Object(u64(1 << 14)), m.Object(u64(1 << 14)), m.Object(u64(1 << 14)), m.Object(u64(1 << 14))}; expected: m.Object = inner[:]
    testing.expectf(t, m.object_equals(&res, &expected), "mismatch: %v !=  %v", res, expected)
    m.object_delete(res)
}


@(test)
test_u16_array_20_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{220, 0, 20, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0}
    out: [20]u16
    err := m.unpack_into_from_bytes(bytes[:], &out)


    testing.expect_value(t, err, nil)
    v := [20]u16{1<<14, 1<<14, 1<<14, 1<<14, 1<<14, 1<<14, 1<<14, 1<<14, 1<<14, 1<<14, 1<<14, 1<<14, 1<<14, 1<<14, 1<<14, 1<<14, 1<<14, 1<<14, 1<<14, 1<<14}; slice_eq(t, v[:], out[:])
}

@(test)
test_f32_array_20_ser :: proc(t: ^testing.T) {

    value := [20]f32{1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5}
    data, err := m.pack_into_bytes(value, {  })
    defer delete(data)


    slice_eq(t, data[:], []u8{220, 0, 20, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0})

}


@(test)
test_f32_array_20_de :: proc(t: ^testing.T) {
    bytes := [?]u8{220, 0, 20, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0}
    res, err := m.unpack_from_bytes(bytes[:])

    testing.expect_value(t, err, nil)
    inner := [20]m.Object{m.Object(f32(1.5)), m.Object(f32(1.5)), m.Object(f32(1.5)), m.Object(f32(1.5)), m.Object(f32(1.5)), m.Object(f32(1.5)), m.Object(f32(1.5)), m.Object(f32(1.5)), m.Object(f32(1.5)), m.Object(f32(1.5)), m.Object(f32(1.5)), m.Object(f32(1.5)), m.Object(f32(1.5)), m.Object(f32(1.5)), m.Object(f32(1.5)), m.Object(f32(1.5)), m.Object(f32(1.5)), m.Object(f32(1.5)), m.Object(f32(1.5)), m.Object(f32(1.5))}; expected: m.Object = inner[:]
    testing.expectf(t, m.object_equals(&res, &expected), "mismatch: %v !=  %v", res, expected)
    m.object_delete(res)
}


@(test)
test_f32_array_20_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{220, 0, 20, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0}
    out: [20]f32
    err := m.unpack_into_from_bytes(bytes[:], &out)


    testing.expect_value(t, err, nil)
    v := [20]f32{1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5}; slice_eq(t, v[:], out[:])
}

