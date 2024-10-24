package tests
import "core:testing"
import "core:fmt"
import m "../"

@(test)
test_str_less_than_32_ser :: proc(t: ^testing.T) {

    value := "hello world"
    data, err := m.pack_into_bytes(value, {  })
    defer delete(data)


    slice_eq(t, data[:], []u8{171, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100})

}


@(test)
test_str_less_than_32_de :: proc(t: ^testing.T) {
    bytes := [?]u8{171, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100}
    res, err := m.unpack_from_bytes(bytes[:])

    testing.expect_value(t, err, nil)
    expected := "hello world"
    testing.expect_value(t, res.(string), expected)
	m.object_delete(res)
}


@(test)
test_str_less_than_32_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{171, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100}
    out: string
    err := m.unpack_into_from_bytes(bytes[:], &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (string)("hello world"))
	delete(out)
}

@(test)
test_str_less_than_256_ser :: proc(t: ^testing.T) {

    value := "hello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello world"
    data, err := m.pack_into_bytes(value, {  })
    defer delete(data)


    slice_eq(t, data[:], []u8{217, 110, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100})

}


@(test)
test_str_less_than_256_de :: proc(t: ^testing.T) {
    bytes := [?]u8{217, 110, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100}
    res, err := m.unpack_from_bytes(bytes[:])

    testing.expect_value(t, err, nil)
    expected := "hello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello world"
    testing.expect_value(t, res.(string), expected)

	m.object_delete(res)
}


@(test)
test_str_less_than_256_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{217, 110, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100}
    out: string
    err := m.unpack_into_from_bytes(bytes[:], &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (string)("hello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello world"))
	delete(out)
}

@(test)
test_str_above_256_ser :: proc(t: ^testing.T) {

    value := "hello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello world"
    data, err := m.pack_into_bytes(value, {  })
    defer delete(data)


    slice_eq(t, data[:], []u8{218, 1, 19, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100})

}


@(test)
test_str_above_256_de :: proc(t: ^testing.T) {
    bytes := [?]u8{218, 1, 19, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100}
    res, err := m.unpack_from_bytes(bytes[:])

    testing.expect_value(t, err, nil)
    expected := "hello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello world"
    testing.expect_value(t, res.(string), expected)
	m.object_delete(res)
}


@(test)
test_str_above_256_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{218, 1, 19, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100}
    out: string
    err := m.unpack_into_from_bytes(bytes[:], &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (string)("hello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello world"))

	delete(out)
}
