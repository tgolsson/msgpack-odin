package tests
import "core:testing"
import "core:fmt"
import m "../"

import "core:time"
@(test)
test_timestamp_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    arg := time.Time { 1e9 * 171798691 + 69}; m.write(&p, arg)

    slice_eq(t, p.buf[:], []u8{215, 255, 0, 0, 1, 20, 10, 61, 112, 163})
    delete(p.buf)
}

@(test)
test_timestamp_no_ns_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    arg := time.Time { 1e9 * 171798691 + 0}; m.write(&p, arg)

    slice_eq(t, p.buf[:], []u8{214, 255, 10, 61, 112, 163})
    delete(p.buf)
}

