package tests
import "core:testing"
import "core:fmt"
import m "../"

@(test)
test_map_int_to_int_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0)
    p: m.Packer = { store, {  } }

    value := map[u8]u8{0  = 10}
    m.write(&p, value)
    delete(value)
    slice_eq(t, p.buf[:], []u8{129, 0, 10})
    delete(p.buf)
}


@(test)
test_map_int_to_int_de :: proc(t: ^testing.T) {
    bytes := [?]u8{129, 0, 10}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: m.Object = map[m.ObjectKey]m.Object { u64(0) = u64(10) }
    testing.expectf(t, m.object_equals(&res, &expected), "mismatch: %v !=  %v", res, expected)
    m.object_delete(res); delete(expected.(map[m.ObjectKey]m.Object))
}

@(test)
test_map_str_str_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0)
    p: m.Packer = { store, {  } }

    value := map[string]string{"foo" = "bar"}
    m.write(&p, value)
    delete(value)
    slice_eq(t, p.buf[:], []u8{129, 163, 102, 111, 111, 163, 98, 97, 114})
    delete(p.buf)
}


@(test)
test_map_str_str_de :: proc(t: ^testing.T) {
    bytes := [?]u8{129, 163, 102, 111, 111, 163, 98, 97, 114}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: m.Object = map[m.ObjectKey]m.Object { "foo" = "bar" }
    testing.expectf(t, m.object_equals(&res, &expected), "mismatch: %v !=  %v", res, expected)
    m.object_delete(res); delete(expected.(map[m.ObjectKey]m.Object))
}

@(test)
test_map_str_bytes_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0)
    p: m.Packer = { store, {  } }
    bd := [?]m.bin{1, 2, 3}
    value := map[string][]m.bin{"foo" = bd[:]}
    m.write(&p, value)
    delete(value)
    slice_eq(t, p.buf[:], []u8{129, 163, 102, 111, 111, 196, 3, 1, 2, 3})
    delete(p.buf)
}


@(test)
test_map_str_bytes_de :: proc(t: ^testing.T) {
    bytes := [?]u8{129, 163, 102, 111, 111, 196, 3, 1, 2, 3}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    bd := [?]m.bin{1, 2, 3}; expected: m.Object = map[m.ObjectKey]m.Object { "foo" = bd[:] }
    testing.expectf(t, m.object_equals(&res, &expected), "mismatch: %v !=  %v", res, expected)
    m.object_delete(res); delete(expected.(map[m.ObjectKey]m.Object))
}

@(test)
test_map_str_array_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0)
    p: m.Packer = { store, {  } }
    bd := [?]u16{1, 2, 3}
    value := map[string][]u16{"foo" = bd[:]}
    m.write(&p, value)
    delete(value)
    slice_eq(t, p.buf[:], []u8{129, 163, 102, 111, 111, 147, 1, 2, 3})
    delete(p.buf)
}


@(test)
test_map_str_array_de :: proc(t: ^testing.T) {
    bytes := [?]u8{129, 163, 102, 111, 111, 147, 1, 2, 3}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    bd := [?]m.Object{u64(1), u64(2), u64(3)}; expected: m.Object = map[m.ObjectKey]m.Object { "foo" = bd[:] }
    testing.expectf(t, m.object_equals(&res, &expected), "mismatch: %v !=  %v", res, expected)
    m.object_delete(res); delete(expected.(map[m.ObjectKey]m.Object))
}

@(test)
test_map_str_float2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0)
    p: m.Packer = { store, { .StableMaps } }

    value := map[string]f32{"b" = 2.2, "a" = 1.1, }
    m.write(&p, value)
    delete(value)
    slice_eq(t, p.buf[:], []u8{130, 161, 97, 202, 63, 140, 204, 205, 161, 98, 202, 64, 12, 204, 205})
    delete(p.buf)
}


@(test)
test_map_str_float2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{130, 161, 97, 202, 63, 140, 204, 205, 161, 98, 202, 64, 12, 204, 205}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: m.Object = map[m.ObjectKey]m.Object {"a" = f32(1.1), "b" = f32(2.2), }
    testing.expectf(t, m.object_equals(&res, &expected), "mismatch: %v !=  %v", res, expected)
    m.object_delete(res); delete(expected.(map[m.ObjectKey]m.Object))
}

@(test)
test_map_str_float5_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0)
    p: m.Packer = { store, { .StableMaps } }

    value := map[string]f32{"e" = 5.1, "d" = 4.5, "c" = 3.4, "b" = 2.3, "a" = 1.1, }
    m.write(&p, value)
    delete(value)
    slice_eq(t, p.buf[:], []u8{133, 161, 97, 202, 63, 140, 204, 205, 161, 98, 202, 64, 19, 51, 51, 161, 99, 202, 64, 89, 153, 154, 161, 100, 202, 64, 144, 0, 0, 161, 101, 202, 64, 163, 51, 51})
    delete(p.buf)
}


@(test)
test_map_str_float5_de :: proc(t: ^testing.T) {
    bytes := [?]u8{133, 161, 97, 202, 63, 140, 204, 205, 161, 98, 202, 64, 19, 51, 51, 161, 99, 202, 64, 89, 153, 154, 161, 100, 202, 64, 144, 0, 0, 161, 101, 202, 64, 163, 51, 51}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: m.Object = map[m.ObjectKey]m.Object {"a" = f32(1.1), "b" = f32(2.3), "c" = f32(3.4), "d" = f32(4.5), "e" = f32(5.1), }
    testing.expectf(t, m.object_equals(&res, &expected), "mismatch: %v !=  %v", res, expected)
    m.object_delete(res); delete(expected.(map[m.ObjectKey]m.Object))
}

@(test)
test_map_str_float6_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0)
    p: m.Packer = { store, { .StableMaps } }

    value := map[string]f32{"f" = 1.3, "e" = 5.1, "d" = 4.5, "c" = 3.4, "b" = 2.3, "a" = 1.1, }
    m.write(&p, value)
    delete(value)
    slice_eq(t, p.buf[:], []u8{134, 161, 97, 202, 63, 140, 204, 205, 161, 98, 202, 64, 19, 51, 51, 161, 99, 202, 64, 89, 153, 154, 161, 100, 202, 64, 144, 0, 0, 161, 101, 202, 64, 163, 51, 51, 161, 102, 202, 63, 166, 102, 102})
    delete(p.buf)
}


@(test)
test_map_str_float6_de :: proc(t: ^testing.T) {
    bytes := [?]u8{134, 161, 97, 202, 63, 140, 204, 205, 161, 98, 202, 64, 19, 51, 51, 161, 99, 202, 64, 89, 153, 154, 161, 100, 202, 64, 144, 0, 0, 161, 101, 202, 64, 163, 51, 51, 161, 102, 202, 63, 166, 102, 102}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: m.Object = map[m.ObjectKey]m.Object {"a" = f32(1.1), "b" = f32(2.3), "c" = f32(3.4), "d" = f32(4.5), "e" = f32(5.1), "f" = f32(1.3), }
    testing.expectf(t, m.object_equals(&res, &expected), "mismatch: %v !=  %v", res, expected)
    m.object_delete(res); delete(expected.(map[m.ObjectKey]m.Object))
}

