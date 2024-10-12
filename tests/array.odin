package tests
import "core:testing"
import "core:fmt"
import m "../"

@(test)
test_str_array_0_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    arg := [0]string{}; m.write(&p, arg[:])

    slice_eq(t, p.buf[:], []u8{144})
    delete(p.buf)
}

@(test)
test_u16_array_0_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    arg := [0]u16{  }; m.write(&p, arg[:])

    slice_eq(t, p.buf[:], []u8{144})
    delete(p.buf)
}

@(test)
test_float_array_0_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    arg := [0]f32{  }; m.write(&p, arg[:])

    slice_eq(t, p.buf[:], []u8{144})
    delete(p.buf)
}

@(test)
test_str_array_5_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    arg := [5]string{"x", "x", "x", "x", "x"}; m.write(&p, arg[:])

    slice_eq(t, p.buf[:], []u8{149, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120})
    delete(p.buf)
}

@(test)
test_u16_array_5_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    arg := [5]u16{ 16384, 16384, 16384, 16384, 16384 }; m.write(&p, arg[:])

    slice_eq(t, p.buf[:], []u8{149, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0})
    delete(p.buf)
}

@(test)
test_float_array_5_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    arg := [5]f32{ 1.5, 1.5, 1.5, 1.5, 1.5 }; m.write(&p, arg[:])

    slice_eq(t, p.buf[:], []u8{149, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0})
    delete(p.buf)
}

@(test)
test_str_array_20_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    arg := [20]string{"x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x"}; m.write(&p, arg[:])

    slice_eq(t, p.buf[:], []u8{220, 0, 20, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120, 161, 120})
    delete(p.buf)
}

@(test)
test_u16_array_20_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    arg := [20]u16{ 16384, 16384, 16384, 16384, 16384, 16384, 16384, 16384, 16384, 16384, 16384, 16384, 16384, 16384, 16384, 16384, 16384, 16384, 16384, 16384 }; m.write(&p, arg[:])

    slice_eq(t, p.buf[:], []u8{220, 0, 20, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0, 205, 64, 0})
    delete(p.buf)
}

@(test)
test_float_array_20_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    arg := [20]f32{ 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5 }; m.write(&p, arg[:])

    slice_eq(t, p.buf[:], []u8{220, 0, 20, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0, 202, 63, 192, 0, 0})
    delete(p.buf)
}

