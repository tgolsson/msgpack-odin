package tests
import "core:testing"
import "core:fmt"
import m "../"

@(test)
test_map_empty_ser :: proc(t: ^testing.T) {

    value := map[u8]u8{}
    data, err := m.pack_into_bytes(value, {  })
    defer delete(data)

    delete(value)
    slice_eq(t, data[:], []u8{128})

}


@(test)
test_map_empty_de :: proc(t: ^testing.T) {
    bytes := [?]u8{128}
    res, err := m.unpack_from_bytes(bytes[:])

    testing.expect_value(t, err, nil)
    expected: m.Object = map[m.ObjectKey]m.Object { }
    testing.expectf(t, m.object_equals(&res, &expected), "mismatch: %v !=  %v", res, expected)
    m.object_delete(res); delete(expected.(map[m.ObjectKey]m.Object))
}


@(test)
test_map_empty_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{128}
    out: map[u8]u8
    err := m.unpack_into_from_bytes(bytes[:], &out)


    testing.expect_value(t, err, nil)
    v := map[u8]u8{}; map_eq(t, out, v)
}

@(test)
test_map_int_to_int_ser :: proc(t: ^testing.T) {

    value := map[u8]u8{0  = 10}
    data, err := m.pack_into_bytes(value, {  })
    defer delete(data)

    delete(value)
    slice_eq(t, data[:], []u8{129, 0, 10})

}


@(test)
test_map_int_to_int_de :: proc(t: ^testing.T) {
    bytes := [?]u8{129, 0, 10}
    res, err := m.unpack_from_bytes(bytes[:])

    testing.expect_value(t, err, nil)
    expected: m.Object = map[m.ObjectKey]m.Object { u64(0) = u64(10) }
    testing.expectf(t, m.object_equals(&res, &expected), "mismatch: %v !=  %v", res, expected)
    m.object_delete(res); delete(expected.(map[m.ObjectKey]m.Object))
}


@(test)
test_map_int_to_int_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{129, 0, 10}
    out: map[u8]u8
    err := m.unpack_into_from_bytes(bytes[:], &out)

    testing.expect_value(t, err, nil)
    v := map[u8]u8{0  = 10}; map_eq(t, out, v)
	delete(v)
	delete(out)
}

@(test)
test_map_str_str_ser :: proc(t: ^testing.T) {
    value := map[string]string{"foo" = "bar"}
    data, err := m.pack_into_bytes(value, {  })
    defer delete(data)

    delete(value)
    slice_eq(t, data[:], []u8{129, 163, 102, 111, 111, 163, 98, 97, 114})

}


@(test)
test_map_str_str_de :: proc(t: ^testing.T) {
    bytes := [?]u8{129, 163, 102, 111, 111, 163, 98, 97, 114}
    res, err := m.unpack_from_bytes(bytes[:])

    testing.expect_value(t, err, nil)
    expected: m.Object = map[m.ObjectKey]m.Object { "foo" = "bar" }
    testing.expectf(t, m.object_equals(&res, &expected), "mismatch: %v !=  %v", res, expected)
    m.object_delete(res); delete(expected.(map[m.ObjectKey]m.Object))
}


@(test)
test_map_str_str_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{129, 163, 102, 111, 111, 163, 98, 97, 114}
    out: map[string]string
    err := m.unpack_into_from_bytes(bytes[:], &out)

    testing.expect_value(t, err, nil)
    v := map[string]string{"foo" = "bar"}; map_eq(t, out, v)
	delete(v)

	for k, v in out {
		delete(k)
		delete(v)
	}
	delete(out)
}

@(test)
test_map_str_bytes_ser :: proc(t: ^testing.T) {
    bd := [?]m.bin{1, 2, 3}
    value := map[string][]m.bin{"foo" = bd[:]}
    data, err := m.pack_into_bytes(value, {  })
    defer delete(data)

    delete(value)
    slice_eq(t, data[:], []u8{129, 163, 102, 111, 111, 196, 3, 1, 2, 3})

}


@(test)
test_map_str_bytes_de :: proc(t: ^testing.T) {
    bytes := [?]u8{129, 163, 102, 111, 111, 196, 3, 1, 2, 3}
    res, err := m.unpack_from_bytes(bytes[:])

    testing.expect_value(t, err, nil)
    bd := [?]m.bin{1, 2, 3}; expected: m.Object = map[m.ObjectKey]m.Object { "foo" = bd[:] }
    testing.expectf(t, m.object_equals(&res, &expected), "mismatch: %v !=  %v", res, expected)
    m.object_delete(res); delete(expected.(map[m.ObjectKey]m.Object))
}


@(test)
test_map_str_bytes_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{129, 163, 102, 111, 111, 196, 3, 1, 2, 3}
    out: map[string][]m.bin
    err := m.unpack_into_from_bytes(bytes[:], &out)

    bd := [?]m.bin{1, 2, 3}
    testing.expect_value(t, err, nil)
    v := map[string][]m.bin{"foo" = bd[:]}; map_slice_eq(t, out, v)
	delete(v)
	for k, v in out {
		delete(k)
		delete(v)
	}
	delete(out)
}

@(test)
test_map_str_array_ser :: proc(t: ^testing.T) {
    bd := [?]u16{1, 2, 3}
    value := map[string][]u16{"foo" = bd[:]}
    data, err := m.pack_into_bytes(value, {  })
    defer delete(data)

    delete(value)
    slice_eq(t, data[:], []u8{129, 163, 102, 111, 111, 147, 1, 2, 3})

}


@(test)
test_map_str_array_de :: proc(t: ^testing.T) {
    bytes := [?]u8{129, 163, 102, 111, 111, 147, 1, 2, 3}
    res, err := m.unpack_from_bytes(bytes[:])

    testing.expect_value(t, err, nil)
    bd := [?]m.Object{u64(1), u64(2), u64(3)}; expected: m.Object = map[m.ObjectKey]m.Object { "foo" = bd[:] }
    testing.expectf(t, m.object_equals(&res, &expected), "mismatch: %v !=  %v", res, expected)
    m.object_delete(res); delete(expected.(map[m.ObjectKey]m.Object))
}


@(test)
test_map_str_array_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{129, 163, 102, 111, 111, 147, 1, 2, 3}
    out: map[string][]u16
    err := m.unpack_into_from_bytes(bytes[:], &out)

    bd := [?]u16{1, 2, 3}
    testing.expect_value(t, err, nil)
    v := map[string][]u16{"foo" = bd[:]}; map_slice_eq(t, out, v)
	delete(v)

	for k, _ in out {
		delete(k)
	}
	delete(out)
}

@(test)
test_map_str_float2_ser :: proc(t: ^testing.T) {

    value := map[string]f32{"b" = 2.2, "a" = 1.1, }
    data, err := m.pack_into_bytes(value, { .StableMaps })
    defer delete(data)

    delete(value)
    slice_eq(t, data[:], []u8{130, 161, 97, 202, 63, 140, 204, 205, 161, 98, 202, 64, 12, 204, 205})

}


@(test)
test_map_str_float2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{130, 161, 97, 202, 63, 140, 204, 205, 161, 98, 202, 64, 12, 204, 205}
    res, err := m.unpack_from_bytes(bytes[:])

    testing.expect_value(t, err, nil)
    expected: m.Object = map[m.ObjectKey]m.Object {"a" = f32(1.1), "b" = f32(2.2), }
    testing.expectf(t, m.object_equals(&res, &expected), "mismatch: %v !=  %v", res, expected)
    m.object_delete(res); delete(expected.(map[m.ObjectKey]m.Object))
}


@(test)
test_map_str_float2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{130, 161, 97, 202, 63, 140, 204, 205, 161, 98, 202, 64, 12, 204, 205}
    out: map[string]f32
    err := m.unpack_into_from_bytes(bytes[:], &out)

    testing.expect_value(t, err, nil)
    v := map[string]f32{"b" = 2.2, "a" = 1.1, }; map_eq(t, out, v)
	delete(v)

	for k, _ in out {
		delete(k)
	}
	delete(out)
}

@(test)
test_map_str_float5_ser :: proc(t: ^testing.T) {

    value := map[string]f32{"e" = 5.1, "d" = 4.5, "c" = 3.4, "b" = 2.3, "a" = 1.1, }
    data, err := m.pack_into_bytes(value, { .StableMaps })
    defer delete(data)

    delete(value)
    slice_eq(t, data[:], []u8{133, 161, 97, 202, 63, 140, 204, 205, 161, 98, 202, 64, 19, 51, 51, 161, 99, 202, 64, 89, 153, 154, 161, 100, 202, 64, 144, 0, 0, 161, 101, 202, 64, 163, 51, 51})

}


@(test)
test_map_str_float5_de :: proc(t: ^testing.T) {
    bytes := [?]u8{133, 161, 97, 202, 63, 140, 204, 205, 161, 98, 202, 64, 19, 51, 51, 161, 99, 202, 64, 89, 153, 154, 161, 100, 202, 64, 144, 0, 0, 161, 101, 202, 64, 163, 51, 51}
    res, err := m.unpack_from_bytes(bytes[:])

    testing.expect_value(t, err, nil)
    expected: m.Object = map[m.ObjectKey]m.Object {"a" = f32(1.1), "b" = f32(2.3), "c" = f32(3.4), "d" = f32(4.5), "e" = f32(5.1), }
    testing.expectf(t, m.object_equals(&res, &expected), "mismatch: %v !=  %v", res, expected)
    m.object_delete(res); delete(expected.(map[m.ObjectKey]m.Object))
}


@(test)
test_map_str_float5_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{133, 161, 97, 202, 63, 140, 204, 205, 161, 98, 202, 64, 19, 51, 51, 161, 99, 202, 64, 89, 153, 154, 161, 100, 202, 64, 144, 0, 0, 161, 101, 202, 64, 163, 51, 51}
    out: map[string]f32
    err := m.unpack_into_from_bytes(bytes[:], &out)

    testing.expect_value(t, err, nil)
    v := map[string]f32{"e" = 5.1, "d" = 4.5, "c" = 3.4, "b" = 2.3, "a" = 1.1, }; map_eq(t, out, v)
	delete(v)

	for k, _ in out {
		delete(k)
	}
	delete(out)
}

@(test)
test_map_str_float6_ser :: proc(t: ^testing.T) {

    value := map[string]f32{"f" = 1.3, "e" = 5.1, "d" = 4.5, "c" = 3.4, "b" = 2.3, "a" = 1.1, }
    data, err := m.pack_into_bytes(value, { .StableMaps })
    defer delete(data)

    delete(value)
    slice_eq(t, data[:], []u8{134, 161, 97, 202, 63, 140, 204, 205, 161, 98, 202, 64, 19, 51, 51, 161, 99, 202, 64, 89, 153, 154, 161, 100, 202, 64, 144, 0, 0, 161, 101, 202, 64, 163, 51, 51, 161, 102, 202, 63, 166, 102, 102})

}


@(test)
test_map_str_float6_de :: proc(t: ^testing.T) {
    bytes := [?]u8{134, 161, 97, 202, 63, 140, 204, 205, 161, 98, 202, 64, 19, 51, 51, 161, 99, 202, 64, 89, 153, 154, 161, 100, 202, 64, 144, 0, 0, 161, 101, 202, 64, 163, 51, 51, 161, 102, 202, 63, 166, 102, 102}
    res, err := m.unpack_from_bytes(bytes[:])

    testing.expect_value(t, err, nil)
    expected: m.Object = map[m.ObjectKey]m.Object {"a" = f32(1.1), "b" = f32(2.3), "c" = f32(3.4), "d" = f32(4.5), "e" = f32(5.1), "f" = f32(1.3), }
    testing.expectf(t, m.object_equals(&res, &expected), "mismatch: %v !=  %v", res, expected)
    m.object_delete(res); delete(expected.(map[m.ObjectKey]m.Object))
}

@(test)
test_map_str_float6_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{134, 161, 97, 202, 63, 140, 204, 205, 161, 98, 202, 64, 19, 51, 51, 161, 99, 202, 64, 89, 153, 154, 161, 100, 202, 64, 144, 0, 0, 161, 101, 202, 64, 163, 51, 51, 161, 102, 202, 63, 166, 102, 102}
    out: map[string]f32
    err := m.unpack_into_from_bytes(bytes[:], &out)

    testing.expect_value(t, err, nil)
    v := map[string]f32{"f" = 1.3, "e" = 5.1, "d" = 4.5, "c" = 3.4, "b" = 2.3, "a" = 1.1, }; map_eq(t, out, v)
	delete(v)
	for k, _ in out {
		delete(k)
	}
	delete(out)
}
