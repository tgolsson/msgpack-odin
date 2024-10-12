package tests
import "core:testing"
import "core:fmt"
import m "../"

@(test)
test_map_int_to_int_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    arg := map[u8]u8{0  = 10}; m.write(&p, arg); delete(arg)

    slice_eq(t, p.buf[:], []u8{129, 0, 10})
    delete(p.buf)
}

@(test)
test_map_str_to_str_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    arg := map[string]string{"foo" = "bar"}; m.write(&p, arg); delete(arg)

    slice_eq(t, p.buf[:], []u8{129, 163, 102, 111, 111, 163, 98, 97, 114})
    delete(p.buf)
}

@(test)
test_map_str_to_bytes_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    arg := map[string][3]m.bin{"foo" = [3]m.bin{1,2,3}}; m.write(&p, arg); delete(arg)

    slice_eq(t, p.buf[:], []u8{129, 163, 102, 111, 111, 196, 3, 1, 2, 3})
    delete(p.buf)
}

@(test)
test_map_str_to_array_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    arg := map[string][3]u16{"foo" = [3]u16{1,2,3}}; m.write(&p, arg); delete(arg)

    slice_eq(t, p.buf[:], []u8{129, 163, 102, 111, 111, 147, 1, 2, 3})
    delete(p.buf)
}

@(test)
test_map_multiple_to_float2_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, { .StableMaps } }
    arg := map[string]f32{"b" = 2.2, "a" = 1.1, }; m.write(&p, arg); delete(arg)

    slice_eq(t, p.buf[:], []u8{130, 161, 97, 202, 63, 140, 204, 205, 161, 98, 202, 64, 12, 204, 205})
    delete(p.buf)
}

@(test)
test_map_multiple_to_float5_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, { .StableMaps } }
    arg := map[string]f32{"e" = 5.1, "d" = 4.5, "c" = 3.4, "b" = 2.3, "a" = 1.1, }; m.write(&p, arg); delete(arg)

    slice_eq(t, p.buf[:], []u8{133, 161, 97, 202, 63, 140, 204, 205, 161, 98, 202, 64, 19, 51, 51, 161, 99, 202, 64, 89, 153, 154, 161, 100, 202, 64, 144, 0, 0, 161, 101, 202, 64, 163, 51, 51})
    delete(p.buf)
}

@(test)
test_map_multiple_to_float6_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, { .StableMaps } }
    arg := map[string]f32{"f" = 1.3, "e" = 5.1, "d" = 4.5, "c" = 3.4, "b" = 2.3, "a" = 1.1, }; m.write(&p, arg); delete(arg)

    slice_eq(t, p.buf[:], []u8{134, 161, 97, 202, 63, 140, 204, 205, 161, 98, 202, 64, 19, 51, 51, 161, 99, 202, 64, 89, 153, 154, 161, 100, 202, 64, 144, 0, 0, 161, 101, 202, 64, 163, 51, 51, 161, 102, 202, 63, 166, 102, 102})
    delete(p.buf)
}

