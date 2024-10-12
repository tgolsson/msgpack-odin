package tests
import "core:testing"
import "core:fmt"
import m "../"

@(test)
test_str_less_than_32_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, "hello world")

    slice_eq(t, p.buf[:], []u8{171, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100})
    delete(p.buf)
}

@(test)
test_unpack_str_less_than_32_output :: proc(t: ^testing.T) {
    store := [?]u8{171, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100}
    u: m.Unpacker = { raw_data(store[:]), 0 }
    res := m.read(&u)

    testing.expect_value(t, res.(string), "hello world")

}

@(test)
test_str_less_than_256_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, "hello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello world")

    slice_eq(t, p.buf[:], []u8{217, 110, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100})
    delete(p.buf)
}

@(test)
test_str_above_256_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, "hello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello worldhello world")

    slice_eq(t, p.buf[:], []u8{218, 1, 19, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100})
    delete(p.buf)
}

