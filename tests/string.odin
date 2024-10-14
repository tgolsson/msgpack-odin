package tests
import "core:testing"
import "core:fmt"
import m "../"

@(test)
test_str_less_than_32_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := "hello world"
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{171, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100})
    delete(p.buf)
}


@(test)
test_str_less_than_32_de :: proc(t: ^testing.T) {
    bytes := [?]u8{171, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected := "hello world"
    testing.expect_value(t, res.(string), expected)

}

@(test)
test_str_less_than_256_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := "hello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello world"
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{217, 110, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100})
    delete(p.buf)
}


@(test)
test_str_less_than_256_de :: proc(t: ^testing.T) {
    bytes := [?]u8{217, 110, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected := "hello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello world"
    testing.expect_value(t, res.(string), expected)

}

@(test)
test_str_above_256_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := "hello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello world"
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{218, 1, 19, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100})
    delete(p.buf)
}


@(test)
test_str_above_256_de :: proc(t: ^testing.T) {
    bytes := [?]u8{218, 1, 19, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected := "hello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello world"
    testing.expect_value(t, res.(string), expected)

}

