package tests
import "core:testing"
import "core:fmt"
import m "../"

slice_eq :: proc(t: ^testing.T, a: []u8, b: []u8) {
    testing.expectf(t, len(a) == len(b), "mismatch: %v != %v", a, b)
    for i in 0..<len(a) {
        testing.expectf(t, a[i] == b[i], "%v == %v fails at index %v (%v %v)", a, b, i, a[i], b[i])
    }
}
@(test)
test_nil_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p)

    slice_eq(t, p.buf[:], []u8{192})
    delete(p.buf)
}

@(test)
test_true_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, true)

    slice_eq(t, p.buf[:], []u8{195})
    delete(p.buf)
}

@(test)
test_false_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, false)

    slice_eq(t, p.buf[:], []u8{194})
    delete(p.buf)
}

@(test)
test_varint_126_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 126)

    slice_eq(t, p.buf[:], []u8{126})
    delete(p.buf)
}

@(test)
test_varint_127_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 127)

    slice_eq(t, p.buf[:], []u8{127})
    delete(p.buf)
}

@(test)
test_int_8_M2_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 254)

    slice_eq(t, p.buf[:], []u8{204, 254})
    delete(p.buf)
}

@(test)
test_int_8_M1_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 255)

    slice_eq(t, p.buf[:], []u8{204, 255})
    delete(p.buf)
}

@(test)
test_int_8_P0_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 256)

    slice_eq(t, p.buf[:], []u8{205, 1, 0})
    delete(p.buf)
}

@(test)
test_int_8_P1_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 257)

    slice_eq(t, p.buf[:], []u8{205, 1, 1})
    delete(p.buf)
}

@(test)
test_int_8_P2_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 258)

    slice_eq(t, p.buf[:], []u8{205, 1, 2})
    delete(p.buf)
}

@(test)
test_int_16_M2_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 65534)

    slice_eq(t, p.buf[:], []u8{205, 255, 254})
    delete(p.buf)
}

@(test)
test_int_16_M1_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 65535)

    slice_eq(t, p.buf[:], []u8{205, 255, 255})
    delete(p.buf)
}

@(test)
test_int_16_P0_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 65536)

    slice_eq(t, p.buf[:], []u8{206, 0, 1, 0, 0})
    delete(p.buf)
}

@(test)
test_int_16_P1_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 65537)

    slice_eq(t, p.buf[:], []u8{206, 0, 1, 0, 1})
    delete(p.buf)
}

@(test)
test_int_16_P2_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 65538)

    slice_eq(t, p.buf[:], []u8{206, 0, 1, 0, 2})
    delete(p.buf)
}

@(test)
test_int_32_M2_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 4294967294)

    slice_eq(t, p.buf[:], []u8{206, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_32_M1_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 4294967295)

    slice_eq(t, p.buf[:], []u8{206, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_32_P0_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 4294967296)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 1, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_32_P1_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 4294967297)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 1, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_32_P2_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 4294967298)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 1, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_8_M126_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -126)

    slice_eq(t, p.buf[:], []u8{208, 130})
    delete(p.buf)
}

@(test)
test_int_8_M127_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -127)

    slice_eq(t, p.buf[:], []u8{208, 129})
    delete(p.buf)
}

@(test)
test_int_8_M128_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -128)

    slice_eq(t, p.buf[:], []u8{208, 128})
    delete(p.buf)
}

@(test)
test_int_8_M129_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -129)

    slice_eq(t, p.buf[:], []u8{209, 255, 127})
    delete(p.buf)
}

@(test)
test_int_8_M130_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -130)

    slice_eq(t, p.buf[:], []u8{209, 255, 126})
    delete(p.buf)
}

@(test)
test_int_16_M32766_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -32766)

    slice_eq(t, p.buf[:], []u8{209, 128, 2})
    delete(p.buf)
}

@(test)
test_int_16_M32767_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -32767)

    slice_eq(t, p.buf[:], []u8{209, 128, 1})
    delete(p.buf)
}

@(test)
test_int_16_M32768_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -32768)

    slice_eq(t, p.buf[:], []u8{209, 128, 0})
    delete(p.buf)
}

@(test)
test_int_16_M32769_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -32769)

    slice_eq(t, p.buf[:], []u8{210, 255, 255, 127, 255})
    delete(p.buf)
}

@(test)
test_int_16_M32770_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -32770)

    slice_eq(t, p.buf[:], []u8{210, 255, 255, 127, 254})
    delete(p.buf)
}

@(test)
test_int_32_M2147483646_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2147483646)

    slice_eq(t, p.buf[:], []u8{210, 128, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_32_M2147483647_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2147483647)

    slice_eq(t, p.buf[:], []u8{210, 128, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_32_M2147483648_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2147483648)

    slice_eq(t, p.buf[:], []u8{210, 128, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_32_M2147483649_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2147483649)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 255, 127, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_32_M2147483650_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2147483650)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 255, 127, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_0_3_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 3)

    slice_eq(t, p.buf[:], []u8{3})
    delete(p.buf)
}

@(test)
test_int_0_n3_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -3)

    slice_eq(t, p.buf[:], []u8{253})
    delete(p.buf)
}

@(test)
test_int_0_2_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 2)

    slice_eq(t, p.buf[:], []u8{2})
    delete(p.buf)
}

@(test)
test_int_0_n2_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2)

    slice_eq(t, p.buf[:], []u8{254})
    delete(p.buf)
}

@(test)
test_int_0_1_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1)

    slice_eq(t, p.buf[:], []u8{1})
    delete(p.buf)
}

@(test)
test_int_0_n1_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1)

    slice_eq(t, p.buf[:], []u8{255})
    delete(p.buf)
}

@(test)
test_int_0_0_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 0)

    slice_eq(t, p.buf[:], []u8{0})
    delete(p.buf)
}

@(test)
test_int_0_n0_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 0)

    slice_eq(t, p.buf[:], []u8{0})
    delete(p.buf)
}

@(test)
test_int_1_4_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 4)

    slice_eq(t, p.buf[:], []u8{4})
    delete(p.buf)
}

@(test)
test_int_1_n4_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -4)

    slice_eq(t, p.buf[:], []u8{252})
    delete(p.buf)
}

@(test)
test_int_1_3_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 3)

    slice_eq(t, p.buf[:], []u8{3})
    delete(p.buf)
}

@(test)
test_int_1_n3_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -3)

    slice_eq(t, p.buf[:], []u8{253})
    delete(p.buf)
}

@(test)
test_int_1_2_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 2)

    slice_eq(t, p.buf[:], []u8{2})
    delete(p.buf)
}

@(test)
test_int_1_n2_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2)

    slice_eq(t, p.buf[:], []u8{254})
    delete(p.buf)
}

@(test)
test_int_1_1_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1)

    slice_eq(t, p.buf[:], []u8{1})
    delete(p.buf)
}

@(test)
test_int_1_n1_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1)

    slice_eq(t, p.buf[:], []u8{255})
    delete(p.buf)
}

@(test)
test_int_2_6_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 6)

    slice_eq(t, p.buf[:], []u8{6})
    delete(p.buf)
}

@(test)
test_int_2_n6_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -6)

    slice_eq(t, p.buf[:], []u8{250})
    delete(p.buf)
}

@(test)
test_int_2_5_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 5)

    slice_eq(t, p.buf[:], []u8{5})
    delete(p.buf)
}

@(test)
test_int_2_n5_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -5)

    slice_eq(t, p.buf[:], []u8{251})
    delete(p.buf)
}

@(test)
test_int_2_4_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 4)

    slice_eq(t, p.buf[:], []u8{4})
    delete(p.buf)
}

@(test)
test_int_2_n4_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -4)

    slice_eq(t, p.buf[:], []u8{252})
    delete(p.buf)
}

@(test)
test_int_2_3_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 3)

    slice_eq(t, p.buf[:], []u8{3})
    delete(p.buf)
}

@(test)
test_int_2_n3_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -3)

    slice_eq(t, p.buf[:], []u8{253})
    delete(p.buf)
}

@(test)
test_int_3_10_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 10)

    slice_eq(t, p.buf[:], []u8{10})
    delete(p.buf)
}

@(test)
test_int_3_n10_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -10)

    slice_eq(t, p.buf[:], []u8{246})
    delete(p.buf)
}

@(test)
test_int_3_9_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 9)

    slice_eq(t, p.buf[:], []u8{9})
    delete(p.buf)
}

@(test)
test_int_3_n9_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -9)

    slice_eq(t, p.buf[:], []u8{247})
    delete(p.buf)
}

@(test)
test_int_3_8_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 8)

    slice_eq(t, p.buf[:], []u8{8})
    delete(p.buf)
}

@(test)
test_int_3_n8_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -8)

    slice_eq(t, p.buf[:], []u8{248})
    delete(p.buf)
}

@(test)
test_int_3_7_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 7)

    slice_eq(t, p.buf[:], []u8{7})
    delete(p.buf)
}

@(test)
test_int_3_n7_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -7)

    slice_eq(t, p.buf[:], []u8{249})
    delete(p.buf)
}

@(test)
test_int_4_18_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 18)

    slice_eq(t, p.buf[:], []u8{18})
    delete(p.buf)
}

@(test)
test_int_4_n18_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -18)

    slice_eq(t, p.buf[:], []u8{238})
    delete(p.buf)
}

@(test)
test_int_4_17_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 17)

    slice_eq(t, p.buf[:], []u8{17})
    delete(p.buf)
}

@(test)
test_int_4_n17_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -17)

    slice_eq(t, p.buf[:], []u8{239})
    delete(p.buf)
}

@(test)
test_int_4_16_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 16)

    slice_eq(t, p.buf[:], []u8{16})
    delete(p.buf)
}

@(test)
test_int_4_n16_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -16)

    slice_eq(t, p.buf[:], []u8{240})
    delete(p.buf)
}

@(test)
test_int_4_15_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 15)

    slice_eq(t, p.buf[:], []u8{15})
    delete(p.buf)
}

@(test)
test_int_4_n15_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -15)

    slice_eq(t, p.buf[:], []u8{241})
    delete(p.buf)
}

@(test)
test_int_5_34_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 34)

    slice_eq(t, p.buf[:], []u8{34})
    delete(p.buf)
}

@(test)
test_int_5_n34_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -34)

    slice_eq(t, p.buf[:], []u8{208, 222})
    delete(p.buf)
}

@(test)
test_int_5_33_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 33)

    slice_eq(t, p.buf[:], []u8{33})
    delete(p.buf)
}

@(test)
test_int_5_n33_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -33)

    slice_eq(t, p.buf[:], []u8{208, 223})
    delete(p.buf)
}

@(test)
test_int_5_32_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 32)

    slice_eq(t, p.buf[:], []u8{32})
    delete(p.buf)
}

@(test)
test_int_5_n32_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -32)

    slice_eq(t, p.buf[:], []u8{224})
    delete(p.buf)
}

@(test)
test_int_5_31_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 31)

    slice_eq(t, p.buf[:], []u8{31})
    delete(p.buf)
}

@(test)
test_int_5_n31_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -31)

    slice_eq(t, p.buf[:], []u8{225})
    delete(p.buf)
}

@(test)
test_int_6_66_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 66)

    slice_eq(t, p.buf[:], []u8{66})
    delete(p.buf)
}

@(test)
test_int_6_n66_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -66)

    slice_eq(t, p.buf[:], []u8{208, 190})
    delete(p.buf)
}

@(test)
test_int_6_65_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 65)

    slice_eq(t, p.buf[:], []u8{65})
    delete(p.buf)
}

@(test)
test_int_6_n65_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -65)

    slice_eq(t, p.buf[:], []u8{208, 191})
    delete(p.buf)
}

@(test)
test_int_6_64_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 64)

    slice_eq(t, p.buf[:], []u8{64})
    delete(p.buf)
}

@(test)
test_int_6_n64_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -64)

    slice_eq(t, p.buf[:], []u8{208, 192})
    delete(p.buf)
}

@(test)
test_int_6_63_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 63)

    slice_eq(t, p.buf[:], []u8{63})
    delete(p.buf)
}

@(test)
test_int_6_n63_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -63)

    slice_eq(t, p.buf[:], []u8{208, 193})
    delete(p.buf)
}

@(test)
test_int_7_130_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 130)

    slice_eq(t, p.buf[:], []u8{204, 130})
    delete(p.buf)
}

@(test)
test_int_7_n130_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -130)

    slice_eq(t, p.buf[:], []u8{209, 255, 126})
    delete(p.buf)
}

@(test)
test_int_7_129_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 129)

    slice_eq(t, p.buf[:], []u8{204, 129})
    delete(p.buf)
}

@(test)
test_int_7_n129_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -129)

    slice_eq(t, p.buf[:], []u8{209, 255, 127})
    delete(p.buf)
}

@(test)
test_int_7_128_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 128)

    slice_eq(t, p.buf[:], []u8{204, 128})
    delete(p.buf)
}

@(test)
test_int_7_n128_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -128)

    slice_eq(t, p.buf[:], []u8{208, 128})
    delete(p.buf)
}

@(test)
test_int_7_127_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 127)

    slice_eq(t, p.buf[:], []u8{127})
    delete(p.buf)
}

@(test)
test_int_7_n127_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -127)

    slice_eq(t, p.buf[:], []u8{208, 129})
    delete(p.buf)
}

@(test)
test_int_8_258_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 258)

    slice_eq(t, p.buf[:], []u8{205, 1, 2})
    delete(p.buf)
}

@(test)
test_int_8_n258_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -258)

    slice_eq(t, p.buf[:], []u8{209, 254, 254})
    delete(p.buf)
}

@(test)
test_int_8_257_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 257)

    slice_eq(t, p.buf[:], []u8{205, 1, 1})
    delete(p.buf)
}

@(test)
test_int_8_n257_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -257)

    slice_eq(t, p.buf[:], []u8{209, 254, 255})
    delete(p.buf)
}

@(test)
test_int_8_256_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 256)

    slice_eq(t, p.buf[:], []u8{205, 1, 0})
    delete(p.buf)
}

@(test)
test_int_8_n256_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -256)

    slice_eq(t, p.buf[:], []u8{209, 255, 0})
    delete(p.buf)
}

@(test)
test_int_8_255_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 255)

    slice_eq(t, p.buf[:], []u8{204, 255})
    delete(p.buf)
}

@(test)
test_int_8_n255_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -255)

    slice_eq(t, p.buf[:], []u8{209, 255, 1})
    delete(p.buf)
}

@(test)
test_int_9_514_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 514)

    slice_eq(t, p.buf[:], []u8{205, 2, 2})
    delete(p.buf)
}

@(test)
test_int_9_n514_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -514)

    slice_eq(t, p.buf[:], []u8{209, 253, 254})
    delete(p.buf)
}

@(test)
test_int_9_513_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 513)

    slice_eq(t, p.buf[:], []u8{205, 2, 1})
    delete(p.buf)
}

@(test)
test_int_9_n513_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -513)

    slice_eq(t, p.buf[:], []u8{209, 253, 255})
    delete(p.buf)
}

@(test)
test_int_9_512_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 512)

    slice_eq(t, p.buf[:], []u8{205, 2, 0})
    delete(p.buf)
}

@(test)
test_int_9_n512_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -512)

    slice_eq(t, p.buf[:], []u8{209, 254, 0})
    delete(p.buf)
}

@(test)
test_int_9_511_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 511)

    slice_eq(t, p.buf[:], []u8{205, 1, 255})
    delete(p.buf)
}

@(test)
test_int_9_n511_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -511)

    slice_eq(t, p.buf[:], []u8{209, 254, 1})
    delete(p.buf)
}

@(test)
test_int_10_1026_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1026)

    slice_eq(t, p.buf[:], []u8{205, 4, 2})
    delete(p.buf)
}

@(test)
test_int_10_n1026_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1026)

    slice_eq(t, p.buf[:], []u8{209, 251, 254})
    delete(p.buf)
}

@(test)
test_int_10_1025_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1025)

    slice_eq(t, p.buf[:], []u8{205, 4, 1})
    delete(p.buf)
}

@(test)
test_int_10_n1025_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1025)

    slice_eq(t, p.buf[:], []u8{209, 251, 255})
    delete(p.buf)
}

@(test)
test_int_10_1024_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1024)

    slice_eq(t, p.buf[:], []u8{205, 4, 0})
    delete(p.buf)
}

@(test)
test_int_10_n1024_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1024)

    slice_eq(t, p.buf[:], []u8{209, 252, 0})
    delete(p.buf)
}

@(test)
test_int_10_1023_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1023)

    slice_eq(t, p.buf[:], []u8{205, 3, 255})
    delete(p.buf)
}

@(test)
test_int_10_n1023_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1023)

    slice_eq(t, p.buf[:], []u8{209, 252, 1})
    delete(p.buf)
}

@(test)
test_int_11_2050_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 2050)

    slice_eq(t, p.buf[:], []u8{205, 8, 2})
    delete(p.buf)
}

@(test)
test_int_11_n2050_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2050)

    slice_eq(t, p.buf[:], []u8{209, 247, 254})
    delete(p.buf)
}

@(test)
test_int_11_2049_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 2049)

    slice_eq(t, p.buf[:], []u8{205, 8, 1})
    delete(p.buf)
}

@(test)
test_int_11_n2049_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2049)

    slice_eq(t, p.buf[:], []u8{209, 247, 255})
    delete(p.buf)
}

@(test)
test_int_11_2048_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 2048)

    slice_eq(t, p.buf[:], []u8{205, 8, 0})
    delete(p.buf)
}

@(test)
test_int_11_n2048_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2048)

    slice_eq(t, p.buf[:], []u8{209, 248, 0})
    delete(p.buf)
}

@(test)
test_int_11_2047_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 2047)

    slice_eq(t, p.buf[:], []u8{205, 7, 255})
    delete(p.buf)
}

@(test)
test_int_11_n2047_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2047)

    slice_eq(t, p.buf[:], []u8{209, 248, 1})
    delete(p.buf)
}

@(test)
test_int_12_4098_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 4098)

    slice_eq(t, p.buf[:], []u8{205, 16, 2})
    delete(p.buf)
}

@(test)
test_int_12_n4098_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -4098)

    slice_eq(t, p.buf[:], []u8{209, 239, 254})
    delete(p.buf)
}

@(test)
test_int_12_4097_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 4097)

    slice_eq(t, p.buf[:], []u8{205, 16, 1})
    delete(p.buf)
}

@(test)
test_int_12_n4097_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -4097)

    slice_eq(t, p.buf[:], []u8{209, 239, 255})
    delete(p.buf)
}

@(test)
test_int_12_4096_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 4096)

    slice_eq(t, p.buf[:], []u8{205, 16, 0})
    delete(p.buf)
}

@(test)
test_int_12_n4096_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -4096)

    slice_eq(t, p.buf[:], []u8{209, 240, 0})
    delete(p.buf)
}

@(test)
test_int_12_4095_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 4095)

    slice_eq(t, p.buf[:], []u8{205, 15, 255})
    delete(p.buf)
}

@(test)
test_int_12_n4095_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -4095)

    slice_eq(t, p.buf[:], []u8{209, 240, 1})
    delete(p.buf)
}

@(test)
test_int_13_8194_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 8194)

    slice_eq(t, p.buf[:], []u8{205, 32, 2})
    delete(p.buf)
}

@(test)
test_int_13_n8194_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -8194)

    slice_eq(t, p.buf[:], []u8{209, 223, 254})
    delete(p.buf)
}

@(test)
test_int_13_8193_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 8193)

    slice_eq(t, p.buf[:], []u8{205, 32, 1})
    delete(p.buf)
}

@(test)
test_int_13_n8193_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -8193)

    slice_eq(t, p.buf[:], []u8{209, 223, 255})
    delete(p.buf)
}

@(test)
test_int_13_8192_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 8192)

    slice_eq(t, p.buf[:], []u8{205, 32, 0})
    delete(p.buf)
}

@(test)
test_int_13_n8192_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -8192)

    slice_eq(t, p.buf[:], []u8{209, 224, 0})
    delete(p.buf)
}

@(test)
test_int_13_8191_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 8191)

    slice_eq(t, p.buf[:], []u8{205, 31, 255})
    delete(p.buf)
}

@(test)
test_int_13_n8191_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -8191)

    slice_eq(t, p.buf[:], []u8{209, 224, 1})
    delete(p.buf)
}

@(test)
test_int_14_16386_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 16386)

    slice_eq(t, p.buf[:], []u8{205, 64, 2})
    delete(p.buf)
}

@(test)
test_int_14_n16386_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -16386)

    slice_eq(t, p.buf[:], []u8{209, 191, 254})
    delete(p.buf)
}

@(test)
test_int_14_16385_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 16385)

    slice_eq(t, p.buf[:], []u8{205, 64, 1})
    delete(p.buf)
}

@(test)
test_int_14_n16385_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -16385)

    slice_eq(t, p.buf[:], []u8{209, 191, 255})
    delete(p.buf)
}

@(test)
test_int_14_16384_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 16384)

    slice_eq(t, p.buf[:], []u8{205, 64, 0})
    delete(p.buf)
}

@(test)
test_int_14_n16384_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -16384)

    slice_eq(t, p.buf[:], []u8{209, 192, 0})
    delete(p.buf)
}

@(test)
test_int_14_16383_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 16383)

    slice_eq(t, p.buf[:], []u8{205, 63, 255})
    delete(p.buf)
}

@(test)
test_int_14_n16383_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -16383)

    slice_eq(t, p.buf[:], []u8{209, 192, 1})
    delete(p.buf)
}

@(test)
test_int_15_32770_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 32770)

    slice_eq(t, p.buf[:], []u8{205, 128, 2})
    delete(p.buf)
}

@(test)
test_int_15_n32770_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -32770)

    slice_eq(t, p.buf[:], []u8{210, 255, 255, 127, 254})
    delete(p.buf)
}

@(test)
test_int_15_32769_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 32769)

    slice_eq(t, p.buf[:], []u8{205, 128, 1})
    delete(p.buf)
}

@(test)
test_int_15_n32769_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -32769)

    slice_eq(t, p.buf[:], []u8{210, 255, 255, 127, 255})
    delete(p.buf)
}

@(test)
test_int_15_32768_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 32768)

    slice_eq(t, p.buf[:], []u8{205, 128, 0})
    delete(p.buf)
}

@(test)
test_int_15_n32768_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -32768)

    slice_eq(t, p.buf[:], []u8{209, 128, 0})
    delete(p.buf)
}

@(test)
test_int_15_32767_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 32767)

    slice_eq(t, p.buf[:], []u8{205, 127, 255})
    delete(p.buf)
}

@(test)
test_int_15_n32767_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -32767)

    slice_eq(t, p.buf[:], []u8{209, 128, 1})
    delete(p.buf)
}

@(test)
test_int_16_65538_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 65538)

    slice_eq(t, p.buf[:], []u8{206, 0, 1, 0, 2})
    delete(p.buf)
}

@(test)
test_int_16_n65538_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -65538)

    slice_eq(t, p.buf[:], []u8{210, 255, 254, 255, 254})
    delete(p.buf)
}

@(test)
test_int_16_65537_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 65537)

    slice_eq(t, p.buf[:], []u8{206, 0, 1, 0, 1})
    delete(p.buf)
}

@(test)
test_int_16_n65537_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -65537)

    slice_eq(t, p.buf[:], []u8{210, 255, 254, 255, 255})
    delete(p.buf)
}

@(test)
test_int_16_65536_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 65536)

    slice_eq(t, p.buf[:], []u8{206, 0, 1, 0, 0})
    delete(p.buf)
}

@(test)
test_int_16_n65536_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -65536)

    slice_eq(t, p.buf[:], []u8{210, 255, 255, 0, 0})
    delete(p.buf)
}

@(test)
test_int_16_65535_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 65535)

    slice_eq(t, p.buf[:], []u8{205, 255, 255})
    delete(p.buf)
}

@(test)
test_int_16_n65535_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -65535)

    slice_eq(t, p.buf[:], []u8{210, 255, 255, 0, 1})
    delete(p.buf)
}

@(test)
test_int_17_131074_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 131074)

    slice_eq(t, p.buf[:], []u8{206, 0, 2, 0, 2})
    delete(p.buf)
}

@(test)
test_int_17_n131074_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -131074)

    slice_eq(t, p.buf[:], []u8{210, 255, 253, 255, 254})
    delete(p.buf)
}

@(test)
test_int_17_131073_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 131073)

    slice_eq(t, p.buf[:], []u8{206, 0, 2, 0, 1})
    delete(p.buf)
}

@(test)
test_int_17_n131073_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -131073)

    slice_eq(t, p.buf[:], []u8{210, 255, 253, 255, 255})
    delete(p.buf)
}

@(test)
test_int_17_131072_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 131072)

    slice_eq(t, p.buf[:], []u8{206, 0, 2, 0, 0})
    delete(p.buf)
}

@(test)
test_int_17_n131072_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -131072)

    slice_eq(t, p.buf[:], []u8{210, 255, 254, 0, 0})
    delete(p.buf)
}

@(test)
test_int_17_131071_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 131071)

    slice_eq(t, p.buf[:], []u8{206, 0, 1, 255, 255})
    delete(p.buf)
}

@(test)
test_int_17_n131071_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -131071)

    slice_eq(t, p.buf[:], []u8{210, 255, 254, 0, 1})
    delete(p.buf)
}

@(test)
test_int_18_262146_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 262146)

    slice_eq(t, p.buf[:], []u8{206, 0, 4, 0, 2})
    delete(p.buf)
}

@(test)
test_int_18_n262146_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -262146)

    slice_eq(t, p.buf[:], []u8{210, 255, 251, 255, 254})
    delete(p.buf)
}

@(test)
test_int_18_262145_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 262145)

    slice_eq(t, p.buf[:], []u8{206, 0, 4, 0, 1})
    delete(p.buf)
}

@(test)
test_int_18_n262145_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -262145)

    slice_eq(t, p.buf[:], []u8{210, 255, 251, 255, 255})
    delete(p.buf)
}

@(test)
test_int_18_262144_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 262144)

    slice_eq(t, p.buf[:], []u8{206, 0, 4, 0, 0})
    delete(p.buf)
}

@(test)
test_int_18_n262144_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -262144)

    slice_eq(t, p.buf[:], []u8{210, 255, 252, 0, 0})
    delete(p.buf)
}

@(test)
test_int_18_262143_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 262143)

    slice_eq(t, p.buf[:], []u8{206, 0, 3, 255, 255})
    delete(p.buf)
}

@(test)
test_int_18_n262143_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -262143)

    slice_eq(t, p.buf[:], []u8{210, 255, 252, 0, 1})
    delete(p.buf)
}

@(test)
test_int_19_524290_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 524290)

    slice_eq(t, p.buf[:], []u8{206, 0, 8, 0, 2})
    delete(p.buf)
}

@(test)
test_int_19_n524290_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -524290)

    slice_eq(t, p.buf[:], []u8{210, 255, 247, 255, 254})
    delete(p.buf)
}

@(test)
test_int_19_524289_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 524289)

    slice_eq(t, p.buf[:], []u8{206, 0, 8, 0, 1})
    delete(p.buf)
}

@(test)
test_int_19_n524289_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -524289)

    slice_eq(t, p.buf[:], []u8{210, 255, 247, 255, 255})
    delete(p.buf)
}

@(test)
test_int_19_524288_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 524288)

    slice_eq(t, p.buf[:], []u8{206, 0, 8, 0, 0})
    delete(p.buf)
}

@(test)
test_int_19_n524288_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -524288)

    slice_eq(t, p.buf[:], []u8{210, 255, 248, 0, 0})
    delete(p.buf)
}

@(test)
test_int_19_524287_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 524287)

    slice_eq(t, p.buf[:], []u8{206, 0, 7, 255, 255})
    delete(p.buf)
}

@(test)
test_int_19_n524287_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -524287)

    slice_eq(t, p.buf[:], []u8{210, 255, 248, 0, 1})
    delete(p.buf)
}

@(test)
test_int_20_1048578_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1048578)

    slice_eq(t, p.buf[:], []u8{206, 0, 16, 0, 2})
    delete(p.buf)
}

@(test)
test_int_20_n1048578_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1048578)

    slice_eq(t, p.buf[:], []u8{210, 255, 239, 255, 254})
    delete(p.buf)
}

@(test)
test_int_20_1048577_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1048577)

    slice_eq(t, p.buf[:], []u8{206, 0, 16, 0, 1})
    delete(p.buf)
}

@(test)
test_int_20_n1048577_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1048577)

    slice_eq(t, p.buf[:], []u8{210, 255, 239, 255, 255})
    delete(p.buf)
}

@(test)
test_int_20_1048576_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1048576)

    slice_eq(t, p.buf[:], []u8{206, 0, 16, 0, 0})
    delete(p.buf)
}

@(test)
test_int_20_n1048576_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1048576)

    slice_eq(t, p.buf[:], []u8{210, 255, 240, 0, 0})
    delete(p.buf)
}

@(test)
test_int_20_1048575_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1048575)

    slice_eq(t, p.buf[:], []u8{206, 0, 15, 255, 255})
    delete(p.buf)
}

@(test)
test_int_20_n1048575_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1048575)

    slice_eq(t, p.buf[:], []u8{210, 255, 240, 0, 1})
    delete(p.buf)
}

@(test)
test_int_21_2097154_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 2097154)

    slice_eq(t, p.buf[:], []u8{206, 0, 32, 0, 2})
    delete(p.buf)
}

@(test)
test_int_21_n2097154_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2097154)

    slice_eq(t, p.buf[:], []u8{210, 255, 223, 255, 254})
    delete(p.buf)
}

@(test)
test_int_21_2097153_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 2097153)

    slice_eq(t, p.buf[:], []u8{206, 0, 32, 0, 1})
    delete(p.buf)
}

@(test)
test_int_21_n2097153_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2097153)

    slice_eq(t, p.buf[:], []u8{210, 255, 223, 255, 255})
    delete(p.buf)
}

@(test)
test_int_21_2097152_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 2097152)

    slice_eq(t, p.buf[:], []u8{206, 0, 32, 0, 0})
    delete(p.buf)
}

@(test)
test_int_21_n2097152_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2097152)

    slice_eq(t, p.buf[:], []u8{210, 255, 224, 0, 0})
    delete(p.buf)
}

@(test)
test_int_21_2097151_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 2097151)

    slice_eq(t, p.buf[:], []u8{206, 0, 31, 255, 255})
    delete(p.buf)
}

@(test)
test_int_21_n2097151_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2097151)

    slice_eq(t, p.buf[:], []u8{210, 255, 224, 0, 1})
    delete(p.buf)
}

@(test)
test_int_22_4194306_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 4194306)

    slice_eq(t, p.buf[:], []u8{206, 0, 64, 0, 2})
    delete(p.buf)
}

@(test)
test_int_22_n4194306_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -4194306)

    slice_eq(t, p.buf[:], []u8{210, 255, 191, 255, 254})
    delete(p.buf)
}

@(test)
test_int_22_4194305_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 4194305)

    slice_eq(t, p.buf[:], []u8{206, 0, 64, 0, 1})
    delete(p.buf)
}

@(test)
test_int_22_n4194305_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -4194305)

    slice_eq(t, p.buf[:], []u8{210, 255, 191, 255, 255})
    delete(p.buf)
}

@(test)
test_int_22_4194304_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 4194304)

    slice_eq(t, p.buf[:], []u8{206, 0, 64, 0, 0})
    delete(p.buf)
}

@(test)
test_int_22_n4194304_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -4194304)

    slice_eq(t, p.buf[:], []u8{210, 255, 192, 0, 0})
    delete(p.buf)
}

@(test)
test_int_22_4194303_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 4194303)

    slice_eq(t, p.buf[:], []u8{206, 0, 63, 255, 255})
    delete(p.buf)
}

@(test)
test_int_22_n4194303_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -4194303)

    slice_eq(t, p.buf[:], []u8{210, 255, 192, 0, 1})
    delete(p.buf)
}

@(test)
test_int_23_8388610_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 8388610)

    slice_eq(t, p.buf[:], []u8{206, 0, 128, 0, 2})
    delete(p.buf)
}

@(test)
test_int_23_n8388610_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -8388610)

    slice_eq(t, p.buf[:], []u8{210, 255, 127, 255, 254})
    delete(p.buf)
}

@(test)
test_int_23_8388609_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 8388609)

    slice_eq(t, p.buf[:], []u8{206, 0, 128, 0, 1})
    delete(p.buf)
}

@(test)
test_int_23_n8388609_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -8388609)

    slice_eq(t, p.buf[:], []u8{210, 255, 127, 255, 255})
    delete(p.buf)
}

@(test)
test_int_23_8388608_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 8388608)

    slice_eq(t, p.buf[:], []u8{206, 0, 128, 0, 0})
    delete(p.buf)
}

@(test)
test_int_23_n8388608_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -8388608)

    slice_eq(t, p.buf[:], []u8{210, 255, 128, 0, 0})
    delete(p.buf)
}

@(test)
test_int_23_8388607_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 8388607)

    slice_eq(t, p.buf[:], []u8{206, 0, 127, 255, 255})
    delete(p.buf)
}

@(test)
test_int_23_n8388607_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -8388607)

    slice_eq(t, p.buf[:], []u8{210, 255, 128, 0, 1})
    delete(p.buf)
}

@(test)
test_int_24_16777218_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 16777218)

    slice_eq(t, p.buf[:], []u8{206, 1, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_24_n16777218_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -16777218)

    slice_eq(t, p.buf[:], []u8{210, 254, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_24_16777217_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 16777217)

    slice_eq(t, p.buf[:], []u8{206, 1, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_24_n16777217_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -16777217)

    slice_eq(t, p.buf[:], []u8{210, 254, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_24_16777216_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 16777216)

    slice_eq(t, p.buf[:], []u8{206, 1, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_24_n16777216_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -16777216)

    slice_eq(t, p.buf[:], []u8{210, 255, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_24_16777215_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 16777215)

    slice_eq(t, p.buf[:], []u8{206, 0, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_24_n16777215_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -16777215)

    slice_eq(t, p.buf[:], []u8{210, 255, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_25_33554434_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 33554434)

    slice_eq(t, p.buf[:], []u8{206, 2, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_25_n33554434_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -33554434)

    slice_eq(t, p.buf[:], []u8{210, 253, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_25_33554433_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 33554433)

    slice_eq(t, p.buf[:], []u8{206, 2, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_25_n33554433_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -33554433)

    slice_eq(t, p.buf[:], []u8{210, 253, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_25_33554432_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 33554432)

    slice_eq(t, p.buf[:], []u8{206, 2, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_25_n33554432_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -33554432)

    slice_eq(t, p.buf[:], []u8{210, 254, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_25_33554431_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 33554431)

    slice_eq(t, p.buf[:], []u8{206, 1, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_25_n33554431_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -33554431)

    slice_eq(t, p.buf[:], []u8{210, 254, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_26_67108866_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 67108866)

    slice_eq(t, p.buf[:], []u8{206, 4, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_26_n67108866_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -67108866)

    slice_eq(t, p.buf[:], []u8{210, 251, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_26_67108865_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 67108865)

    slice_eq(t, p.buf[:], []u8{206, 4, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_26_n67108865_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -67108865)

    slice_eq(t, p.buf[:], []u8{210, 251, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_26_67108864_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 67108864)

    slice_eq(t, p.buf[:], []u8{206, 4, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_26_n67108864_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -67108864)

    slice_eq(t, p.buf[:], []u8{210, 252, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_26_67108863_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 67108863)

    slice_eq(t, p.buf[:], []u8{206, 3, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_26_n67108863_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -67108863)

    slice_eq(t, p.buf[:], []u8{210, 252, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_27_134217730_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 134217730)

    slice_eq(t, p.buf[:], []u8{206, 8, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_27_n134217730_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -134217730)

    slice_eq(t, p.buf[:], []u8{210, 247, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_27_134217729_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 134217729)

    slice_eq(t, p.buf[:], []u8{206, 8, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_27_n134217729_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -134217729)

    slice_eq(t, p.buf[:], []u8{210, 247, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_27_134217728_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 134217728)

    slice_eq(t, p.buf[:], []u8{206, 8, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_27_n134217728_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -134217728)

    slice_eq(t, p.buf[:], []u8{210, 248, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_27_134217727_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 134217727)

    slice_eq(t, p.buf[:], []u8{206, 7, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_27_n134217727_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -134217727)

    slice_eq(t, p.buf[:], []u8{210, 248, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_28_268435458_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 268435458)

    slice_eq(t, p.buf[:], []u8{206, 16, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_28_n268435458_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -268435458)

    slice_eq(t, p.buf[:], []u8{210, 239, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_28_268435457_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 268435457)

    slice_eq(t, p.buf[:], []u8{206, 16, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_28_n268435457_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -268435457)

    slice_eq(t, p.buf[:], []u8{210, 239, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_28_268435456_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 268435456)

    slice_eq(t, p.buf[:], []u8{206, 16, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_28_n268435456_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -268435456)

    slice_eq(t, p.buf[:], []u8{210, 240, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_28_268435455_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 268435455)

    slice_eq(t, p.buf[:], []u8{206, 15, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_28_n268435455_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -268435455)

    slice_eq(t, p.buf[:], []u8{210, 240, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_29_536870914_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 536870914)

    slice_eq(t, p.buf[:], []u8{206, 32, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_29_n536870914_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -536870914)

    slice_eq(t, p.buf[:], []u8{210, 223, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_29_536870913_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 536870913)

    slice_eq(t, p.buf[:], []u8{206, 32, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_29_n536870913_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -536870913)

    slice_eq(t, p.buf[:], []u8{210, 223, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_29_536870912_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 536870912)

    slice_eq(t, p.buf[:], []u8{206, 32, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_29_n536870912_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -536870912)

    slice_eq(t, p.buf[:], []u8{210, 224, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_29_536870911_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 536870911)

    slice_eq(t, p.buf[:], []u8{206, 31, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_29_n536870911_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -536870911)

    slice_eq(t, p.buf[:], []u8{210, 224, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_30_1073741826_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1073741826)

    slice_eq(t, p.buf[:], []u8{206, 64, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_30_n1073741826_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1073741826)

    slice_eq(t, p.buf[:], []u8{210, 191, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_30_1073741825_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1073741825)

    slice_eq(t, p.buf[:], []u8{206, 64, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_30_n1073741825_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1073741825)

    slice_eq(t, p.buf[:], []u8{210, 191, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_30_1073741824_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1073741824)

    slice_eq(t, p.buf[:], []u8{206, 64, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_30_n1073741824_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1073741824)

    slice_eq(t, p.buf[:], []u8{210, 192, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_30_1073741823_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1073741823)

    slice_eq(t, p.buf[:], []u8{206, 63, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_30_n1073741823_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1073741823)

    slice_eq(t, p.buf[:], []u8{210, 192, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_31_2147483650_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 2147483650)

    slice_eq(t, p.buf[:], []u8{206, 128, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_31_n2147483650_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2147483650)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 255, 127, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_31_2147483649_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 2147483649)

    slice_eq(t, p.buf[:], []u8{206, 128, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_31_n2147483649_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2147483649)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 255, 127, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_31_2147483648_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 2147483648)

    slice_eq(t, p.buf[:], []u8{206, 128, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_31_n2147483648_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2147483648)

    slice_eq(t, p.buf[:], []u8{210, 128, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_31_2147483647_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 2147483647)

    slice_eq(t, p.buf[:], []u8{206, 127, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_31_n2147483647_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2147483647)

    slice_eq(t, p.buf[:], []u8{210, 128, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_32_4294967298_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 4294967298)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 1, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_32_n4294967298_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -4294967298)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 254, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_32_4294967297_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 4294967297)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 1, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_32_n4294967297_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -4294967297)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 254, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_32_4294967296_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 4294967296)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 1, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_32_n4294967296_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -4294967296)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 255, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_32_4294967295_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 4294967295)

    slice_eq(t, p.buf[:], []u8{206, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_32_n4294967295_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -4294967295)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 255, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_33_8589934594_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 8589934594)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 2, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_33_n8589934594_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -8589934594)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 253, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_33_8589934593_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 8589934593)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 2, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_33_n8589934593_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -8589934593)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 253, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_33_8589934592_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 8589934592)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 2, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_33_n8589934592_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -8589934592)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 254, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_33_8589934591_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 8589934591)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 1, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_33_n8589934591_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -8589934591)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 254, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_34_17179869186_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 17179869186)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 4, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_34_n17179869186_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -17179869186)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 251, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_34_17179869185_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 17179869185)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 4, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_34_n17179869185_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -17179869185)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 251, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_34_17179869184_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 17179869184)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 4, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_34_n17179869184_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -17179869184)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 252, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_34_17179869183_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 17179869183)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 3, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_34_n17179869183_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -17179869183)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 252, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_35_34359738370_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 34359738370)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 8, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_35_n34359738370_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -34359738370)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 247, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_35_34359738369_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 34359738369)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 8, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_35_n34359738369_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -34359738369)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 247, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_35_34359738368_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 34359738368)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 8, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_35_n34359738368_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -34359738368)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 248, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_35_34359738367_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 34359738367)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 7, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_35_n34359738367_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -34359738367)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 248, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_36_68719476738_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 68719476738)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 16, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_36_n68719476738_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -68719476738)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 239, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_36_68719476737_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 68719476737)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 16, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_36_n68719476737_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -68719476737)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 239, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_36_68719476736_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 68719476736)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 16, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_36_n68719476736_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -68719476736)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 240, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_36_68719476735_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 68719476735)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 15, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_36_n68719476735_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -68719476735)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 240, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_37_137438953474_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 137438953474)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 32, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_37_n137438953474_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -137438953474)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 223, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_37_137438953473_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 137438953473)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 32, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_37_n137438953473_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -137438953473)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 223, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_37_137438953472_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 137438953472)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 32, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_37_n137438953472_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -137438953472)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 224, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_37_137438953471_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 137438953471)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 31, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_37_n137438953471_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -137438953471)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 224, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_38_274877906946_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 274877906946)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 64, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_38_n274877906946_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -274877906946)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 191, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_38_274877906945_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 274877906945)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 64, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_38_n274877906945_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -274877906945)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 191, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_38_274877906944_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 274877906944)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 64, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_38_n274877906944_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -274877906944)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 192, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_38_274877906943_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 274877906943)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 63, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_38_n274877906943_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -274877906943)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 192, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_39_549755813890_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 549755813890)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 128, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_39_n549755813890_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -549755813890)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 127, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_39_549755813889_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 549755813889)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 128, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_39_n549755813889_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -549755813889)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 127, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_39_549755813888_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 549755813888)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 128, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_39_n549755813888_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -549755813888)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 128, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_39_549755813887_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 549755813887)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 127, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_39_n549755813887_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -549755813887)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 128, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_40_1099511627778_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1099511627778)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 1, 0, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_40_n1099511627778_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1099511627778)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 254, 255, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_40_1099511627777_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1099511627777)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 1, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_40_n1099511627777_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1099511627777)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 254, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_40_1099511627776_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1099511627776)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 1, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_40_n1099511627776_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1099511627776)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_40_1099511627775_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1099511627775)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_40_n1099511627775_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1099511627775)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_41_2199023255554_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 2199023255554)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 2, 0, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_41_n2199023255554_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2199023255554)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 253, 255, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_41_2199023255553_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 2199023255553)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 2, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_41_n2199023255553_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2199023255553)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 253, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_41_2199023255552_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 2199023255552)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 2, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_41_n2199023255552_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2199023255552)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 254, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_41_2199023255551_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 2199023255551)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 1, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_41_n2199023255551_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2199023255551)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 254, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_42_4398046511106_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 4398046511106)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 4, 0, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_42_n4398046511106_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -4398046511106)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 251, 255, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_42_4398046511105_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 4398046511105)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 4, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_42_n4398046511105_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -4398046511105)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 251, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_42_4398046511104_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 4398046511104)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 4, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_42_n4398046511104_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -4398046511104)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 252, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_42_4398046511103_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 4398046511103)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 3, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_42_n4398046511103_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -4398046511103)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 252, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_43_8796093022210_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 8796093022210)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 8, 0, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_43_n8796093022210_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -8796093022210)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 247, 255, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_43_8796093022209_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 8796093022209)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 8, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_43_n8796093022209_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -8796093022209)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 247, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_43_8796093022208_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 8796093022208)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 8, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_43_n8796093022208_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -8796093022208)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 248, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_43_8796093022207_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 8796093022207)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 7, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_43_n8796093022207_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -8796093022207)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 248, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_44_17592186044418_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 17592186044418)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 16, 0, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_44_n17592186044418_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -17592186044418)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 239, 255, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_44_17592186044417_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 17592186044417)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 16, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_44_n17592186044417_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -17592186044417)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 239, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_44_17592186044416_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 17592186044416)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 16, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_44_n17592186044416_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -17592186044416)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 240, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_44_17592186044415_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 17592186044415)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 15, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_44_n17592186044415_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -17592186044415)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 240, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_45_35184372088834_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 35184372088834)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 32, 0, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_45_n35184372088834_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -35184372088834)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 223, 255, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_45_35184372088833_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 35184372088833)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 32, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_45_n35184372088833_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -35184372088833)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 223, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_45_35184372088832_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 35184372088832)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 32, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_45_n35184372088832_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -35184372088832)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 224, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_45_35184372088831_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 35184372088831)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 31, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_45_n35184372088831_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -35184372088831)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 224, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_46_70368744177666_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 70368744177666)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 64, 0, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_46_n70368744177666_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -70368744177666)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 191, 255, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_46_70368744177665_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 70368744177665)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 64, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_46_n70368744177665_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -70368744177665)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 191, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_46_70368744177664_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 70368744177664)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 64, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_46_n70368744177664_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -70368744177664)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 192, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_46_70368744177663_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 70368744177663)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 63, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_46_n70368744177663_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -70368744177663)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 192, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_47_140737488355330_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 140737488355330)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 128, 0, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_47_n140737488355330_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -140737488355330)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 127, 255, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_47_140737488355329_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 140737488355329)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 128, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_47_n140737488355329_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -140737488355329)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 127, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_47_140737488355328_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 140737488355328)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 128, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_47_n140737488355328_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -140737488355328)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 128, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_47_140737488355327_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 140737488355327)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 127, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_47_n140737488355327_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -140737488355327)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 128, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_48_281474976710658_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 281474976710658)

    slice_eq(t, p.buf[:], []u8{207, 0, 1, 0, 0, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_48_n281474976710658_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -281474976710658)

    slice_eq(t, p.buf[:], []u8{211, 255, 254, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_48_281474976710657_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 281474976710657)

    slice_eq(t, p.buf[:], []u8{207, 0, 1, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_48_n281474976710657_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -281474976710657)

    slice_eq(t, p.buf[:], []u8{211, 255, 254, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_48_281474976710656_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 281474976710656)

    slice_eq(t, p.buf[:], []u8{207, 0, 1, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_48_n281474976710656_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -281474976710656)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_48_281474976710655_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 281474976710655)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_48_n281474976710655_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -281474976710655)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_49_562949953421314_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 562949953421314)

    slice_eq(t, p.buf[:], []u8{207, 0, 2, 0, 0, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_49_n562949953421314_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -562949953421314)

    slice_eq(t, p.buf[:], []u8{211, 255, 253, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_49_562949953421313_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 562949953421313)

    slice_eq(t, p.buf[:], []u8{207, 0, 2, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_49_n562949953421313_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -562949953421313)

    slice_eq(t, p.buf[:], []u8{211, 255, 253, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_49_562949953421312_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 562949953421312)

    slice_eq(t, p.buf[:], []u8{207, 0, 2, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_49_n562949953421312_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -562949953421312)

    slice_eq(t, p.buf[:], []u8{211, 255, 254, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_49_562949953421311_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 562949953421311)

    slice_eq(t, p.buf[:], []u8{207, 0, 1, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_49_n562949953421311_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -562949953421311)

    slice_eq(t, p.buf[:], []u8{211, 255, 254, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_50_1125899906842626_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1125899906842626)

    slice_eq(t, p.buf[:], []u8{207, 0, 4, 0, 0, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_50_n1125899906842626_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1125899906842626)

    slice_eq(t, p.buf[:], []u8{211, 255, 251, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_50_1125899906842625_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1125899906842625)

    slice_eq(t, p.buf[:], []u8{207, 0, 4, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_50_n1125899906842625_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1125899906842625)

    slice_eq(t, p.buf[:], []u8{211, 255, 251, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_50_1125899906842624_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1125899906842624)

    slice_eq(t, p.buf[:], []u8{207, 0, 4, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_50_n1125899906842624_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1125899906842624)

    slice_eq(t, p.buf[:], []u8{211, 255, 252, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_50_1125899906842623_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1125899906842623)

    slice_eq(t, p.buf[:], []u8{207, 0, 3, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_50_n1125899906842623_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1125899906842623)

    slice_eq(t, p.buf[:], []u8{211, 255, 252, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_51_2251799813685250_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 2251799813685250)

    slice_eq(t, p.buf[:], []u8{207, 0, 8, 0, 0, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_51_n2251799813685250_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2251799813685250)

    slice_eq(t, p.buf[:], []u8{211, 255, 247, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_51_2251799813685249_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 2251799813685249)

    slice_eq(t, p.buf[:], []u8{207, 0, 8, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_51_n2251799813685249_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2251799813685249)

    slice_eq(t, p.buf[:], []u8{211, 255, 247, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_51_2251799813685248_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 2251799813685248)

    slice_eq(t, p.buf[:], []u8{207, 0, 8, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_51_n2251799813685248_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2251799813685248)

    slice_eq(t, p.buf[:], []u8{211, 255, 248, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_51_2251799813685247_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 2251799813685247)

    slice_eq(t, p.buf[:], []u8{207, 0, 7, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_51_n2251799813685247_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2251799813685247)

    slice_eq(t, p.buf[:], []u8{211, 255, 248, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_52_4503599627370498_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 4503599627370498)

    slice_eq(t, p.buf[:], []u8{207, 0, 16, 0, 0, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_52_n4503599627370498_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -4503599627370498)

    slice_eq(t, p.buf[:], []u8{211, 255, 239, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_52_4503599627370497_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 4503599627370497)

    slice_eq(t, p.buf[:], []u8{207, 0, 16, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_52_n4503599627370497_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -4503599627370497)

    slice_eq(t, p.buf[:], []u8{211, 255, 239, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_52_4503599627370496_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 4503599627370496)

    slice_eq(t, p.buf[:], []u8{207, 0, 16, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_52_n4503599627370496_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -4503599627370496)

    slice_eq(t, p.buf[:], []u8{211, 255, 240, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_52_4503599627370495_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 4503599627370495)

    slice_eq(t, p.buf[:], []u8{207, 0, 15, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_52_n4503599627370495_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -4503599627370495)

    slice_eq(t, p.buf[:], []u8{211, 255, 240, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_53_9007199254740994_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 9007199254740994)

    slice_eq(t, p.buf[:], []u8{207, 0, 32, 0, 0, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_53_n9007199254740994_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -9007199254740994)

    slice_eq(t, p.buf[:], []u8{211, 255, 223, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_53_9007199254740993_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 9007199254740993)

    slice_eq(t, p.buf[:], []u8{207, 0, 32, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_53_n9007199254740993_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -9007199254740993)

    slice_eq(t, p.buf[:], []u8{211, 255, 223, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_53_9007199254740992_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 9007199254740992)

    slice_eq(t, p.buf[:], []u8{207, 0, 32, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_53_n9007199254740992_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -9007199254740992)

    slice_eq(t, p.buf[:], []u8{211, 255, 224, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_53_9007199254740991_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 9007199254740991)

    slice_eq(t, p.buf[:], []u8{207, 0, 31, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_53_n9007199254740991_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -9007199254740991)

    slice_eq(t, p.buf[:], []u8{211, 255, 224, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_54_18014398509481986_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 18014398509481986)

    slice_eq(t, p.buf[:], []u8{207, 0, 64, 0, 0, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_54_n18014398509481986_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -18014398509481986)

    slice_eq(t, p.buf[:], []u8{211, 255, 191, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_54_18014398509481985_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 18014398509481985)

    slice_eq(t, p.buf[:], []u8{207, 0, 64, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_54_n18014398509481985_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -18014398509481985)

    slice_eq(t, p.buf[:], []u8{211, 255, 191, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_54_18014398509481984_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 18014398509481984)

    slice_eq(t, p.buf[:], []u8{207, 0, 64, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_54_n18014398509481984_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -18014398509481984)

    slice_eq(t, p.buf[:], []u8{211, 255, 192, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_54_18014398509481983_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 18014398509481983)

    slice_eq(t, p.buf[:], []u8{207, 0, 63, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_54_n18014398509481983_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -18014398509481983)

    slice_eq(t, p.buf[:], []u8{211, 255, 192, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_55_36028797018963970_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 36028797018963970)

    slice_eq(t, p.buf[:], []u8{207, 0, 128, 0, 0, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_55_n36028797018963970_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -36028797018963970)

    slice_eq(t, p.buf[:], []u8{211, 255, 127, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_55_36028797018963969_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 36028797018963969)

    slice_eq(t, p.buf[:], []u8{207, 0, 128, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_55_n36028797018963969_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -36028797018963969)

    slice_eq(t, p.buf[:], []u8{211, 255, 127, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_55_36028797018963968_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 36028797018963968)

    slice_eq(t, p.buf[:], []u8{207, 0, 128, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_55_n36028797018963968_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -36028797018963968)

    slice_eq(t, p.buf[:], []u8{211, 255, 128, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_55_36028797018963967_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 36028797018963967)

    slice_eq(t, p.buf[:], []u8{207, 0, 127, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_55_n36028797018963967_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -36028797018963967)

    slice_eq(t, p.buf[:], []u8{211, 255, 128, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_56_72057594037927938_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 72057594037927938)

    slice_eq(t, p.buf[:], []u8{207, 1, 0, 0, 0, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_56_n72057594037927938_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -72057594037927938)

    slice_eq(t, p.buf[:], []u8{211, 254, 255, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_56_72057594037927937_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 72057594037927937)

    slice_eq(t, p.buf[:], []u8{207, 1, 0, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_56_n72057594037927937_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -72057594037927937)

    slice_eq(t, p.buf[:], []u8{211, 254, 255, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_56_72057594037927936_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 72057594037927936)

    slice_eq(t, p.buf[:], []u8{207, 1, 0, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_56_n72057594037927936_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -72057594037927936)

    slice_eq(t, p.buf[:], []u8{211, 255, 0, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_56_72057594037927935_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 72057594037927935)

    slice_eq(t, p.buf[:], []u8{207, 0, 255, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_56_n72057594037927935_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -72057594037927935)

    slice_eq(t, p.buf[:], []u8{211, 255, 0, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_57_144115188075855874_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 144115188075855874)

    slice_eq(t, p.buf[:], []u8{207, 2, 0, 0, 0, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_57_n144115188075855874_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -144115188075855874)

    slice_eq(t, p.buf[:], []u8{211, 253, 255, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_57_144115188075855873_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 144115188075855873)

    slice_eq(t, p.buf[:], []u8{207, 2, 0, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_57_n144115188075855873_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -144115188075855873)

    slice_eq(t, p.buf[:], []u8{211, 253, 255, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_57_144115188075855872_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 144115188075855872)

    slice_eq(t, p.buf[:], []u8{207, 2, 0, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_57_n144115188075855872_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -144115188075855872)

    slice_eq(t, p.buf[:], []u8{211, 254, 0, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_57_144115188075855871_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 144115188075855871)

    slice_eq(t, p.buf[:], []u8{207, 1, 255, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_57_n144115188075855871_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -144115188075855871)

    slice_eq(t, p.buf[:], []u8{211, 254, 0, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_58_288230376151711746_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 288230376151711746)

    slice_eq(t, p.buf[:], []u8{207, 4, 0, 0, 0, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_58_n288230376151711746_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -288230376151711746)

    slice_eq(t, p.buf[:], []u8{211, 251, 255, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_58_288230376151711745_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 288230376151711745)

    slice_eq(t, p.buf[:], []u8{207, 4, 0, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_58_n288230376151711745_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -288230376151711745)

    slice_eq(t, p.buf[:], []u8{211, 251, 255, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_58_288230376151711744_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 288230376151711744)

    slice_eq(t, p.buf[:], []u8{207, 4, 0, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_58_n288230376151711744_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -288230376151711744)

    slice_eq(t, p.buf[:], []u8{211, 252, 0, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_58_288230376151711743_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 288230376151711743)

    slice_eq(t, p.buf[:], []u8{207, 3, 255, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_58_n288230376151711743_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -288230376151711743)

    slice_eq(t, p.buf[:], []u8{211, 252, 0, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_59_576460752303423490_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 576460752303423490)

    slice_eq(t, p.buf[:], []u8{207, 8, 0, 0, 0, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_59_n576460752303423490_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -576460752303423490)

    slice_eq(t, p.buf[:], []u8{211, 247, 255, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_59_576460752303423489_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 576460752303423489)

    slice_eq(t, p.buf[:], []u8{207, 8, 0, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_59_n576460752303423489_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -576460752303423489)

    slice_eq(t, p.buf[:], []u8{211, 247, 255, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_59_576460752303423488_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 576460752303423488)

    slice_eq(t, p.buf[:], []u8{207, 8, 0, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_59_n576460752303423488_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -576460752303423488)

    slice_eq(t, p.buf[:], []u8{211, 248, 0, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_59_576460752303423487_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 576460752303423487)

    slice_eq(t, p.buf[:], []u8{207, 7, 255, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_59_n576460752303423487_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -576460752303423487)

    slice_eq(t, p.buf[:], []u8{211, 248, 0, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_60_1152921504606846978_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1152921504606846978)

    slice_eq(t, p.buf[:], []u8{207, 16, 0, 0, 0, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_60_n1152921504606846978_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1152921504606846978)

    slice_eq(t, p.buf[:], []u8{211, 239, 255, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_60_1152921504606846977_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1152921504606846977)

    slice_eq(t, p.buf[:], []u8{207, 16, 0, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_60_n1152921504606846977_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1152921504606846977)

    slice_eq(t, p.buf[:], []u8{211, 239, 255, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_60_1152921504606846976_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1152921504606846976)

    slice_eq(t, p.buf[:], []u8{207, 16, 0, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_60_n1152921504606846976_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1152921504606846976)

    slice_eq(t, p.buf[:], []u8{211, 240, 0, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_60_1152921504606846975_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1152921504606846975)

    slice_eq(t, p.buf[:], []u8{207, 15, 255, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_60_n1152921504606846975_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1152921504606846975)

    slice_eq(t, p.buf[:], []u8{211, 240, 0, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_61_2305843009213693954_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 2305843009213693954)

    slice_eq(t, p.buf[:], []u8{207, 32, 0, 0, 0, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_61_n2305843009213693954_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2305843009213693954)

    slice_eq(t, p.buf[:], []u8{211, 223, 255, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_61_2305843009213693953_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 2305843009213693953)

    slice_eq(t, p.buf[:], []u8{207, 32, 0, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_61_n2305843009213693953_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2305843009213693953)

    slice_eq(t, p.buf[:], []u8{211, 223, 255, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_61_2305843009213693952_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 2305843009213693952)

    slice_eq(t, p.buf[:], []u8{207, 32, 0, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_61_n2305843009213693952_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2305843009213693952)

    slice_eq(t, p.buf[:], []u8{211, 224, 0, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_61_2305843009213693951_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 2305843009213693951)

    slice_eq(t, p.buf[:], []u8{207, 31, 255, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_61_n2305843009213693951_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2305843009213693951)

    slice_eq(t, p.buf[:], []u8{211, 224, 0, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_62_4611686018427387906_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 4611686018427387906)

    slice_eq(t, p.buf[:], []u8{207, 64, 0, 0, 0, 0, 0, 0, 2})
    delete(p.buf)
}

@(test)
test_int_62_n4611686018427387906_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -4611686018427387906)

    slice_eq(t, p.buf[:], []u8{211, 191, 255, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}

@(test)
test_int_62_4611686018427387905_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 4611686018427387905)

    slice_eq(t, p.buf[:], []u8{207, 64, 0, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_int_62_n4611686018427387905_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -4611686018427387905)

    slice_eq(t, p.buf[:], []u8{211, 191, 255, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_62_4611686018427387904_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 4611686018427387904)

    slice_eq(t, p.buf[:], []u8{207, 64, 0, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_62_n4611686018427387904_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -4611686018427387904)

    slice_eq(t, p.buf[:], []u8{211, 192, 0, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}

@(test)
test_int_62_4611686018427387903_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 4611686018427387903)

    slice_eq(t, p.buf[:], []u8{207, 63, 255, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}

@(test)
test_int_62_n4611686018427387903_offset_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -4611686018427387903)

    slice_eq(t, p.buf[:], []u8{211, 192, 0, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}

@(test)
test_float_exp0_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1.0)

    slice_eq(t, p.buf[:], []u8{202, 63, 128, 0, 0})
    delete(p.buf)
}

@(test)
test_float_nexp0_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1.0)

    slice_eq(t, p.buf[:], []u8{202, 191, 128, 0, 0})
    delete(p.buf)
}

@(test)
test_float_exp10_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 22026.465794806703)

    slice_eq(t, p.buf[:], []u8{202, 70, 172, 20, 238})
    delete(p.buf)
}

@(test)
test_float_nexp10_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -22026.465794806703)

    slice_eq(t, p.buf[:], []u8{202, 198, 172, 20, 238})
    delete(p.buf)
}

@(test)
test_float_exp20_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 485165195.40978974)

    slice_eq(t, p.buf[:], []u8{202, 77, 231, 88, 68})
    delete(p.buf)
}

@(test)
test_float_nexp20_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -485165195.40978974)

    slice_eq(t, p.buf[:], []u8{202, 205, 231, 88, 68})
    delete(p.buf)
}

@(test)
test_float_exp30_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 10686474581524.445)

    slice_eq(t, p.buf[:], []u8{202, 85, 27, 130, 56})
    delete(p.buf)
}

@(test)
test_float_nexp30_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -10686474581524.445)

    slice_eq(t, p.buf[:], []u8{202, 213, 27, 130, 56})
    delete(p.buf)
}

@(test)
test_float_exp40_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 2.353852668370195e+17)

    slice_eq(t, p.buf[:], []u8{202, 92, 81, 16, 106})
    delete(p.buf)
}

@(test)
test_float_nexp40_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2.353852668370195e+17)

    slice_eq(t, p.buf[:], []u8{202, 220, 81, 16, 106})
    delete(p.buf)
}

@(test)
test_float_exp50_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 5.184705528587058e+21)

    slice_eq(t, p.buf[:], []u8{202, 99, 140, 136, 31})
    delete(p.buf)
}

@(test)
test_float_nexp50_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -5.184705528587058e+21)

    slice_eq(t, p.buf[:], []u8{202, 227, 140, 136, 31})
    delete(p.buf)
}

@(test)
test_float_exp60_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1.1420073898156806e+26)

    slice_eq(t, p.buf[:], []u8{202, 106, 188, 237, 229})
    delete(p.buf)
}

@(test)
test_float_nexp60_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1.1420073898156806e+26)

    slice_eq(t, p.buf[:], []u8{202, 234, 188, 237, 229})
    delete(p.buf)
}

@(test)
test_float_exp70_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 2.5154386709191576e+30)

    slice_eq(t, p.buf[:], []u8{202, 113, 253, 254, 145})
    delete(p.buf)
}

@(test)
test_float_nexp70_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2.5154386709191576e+30)

    slice_eq(t, p.buf[:], []u8{202, 241, 253, 254, 145})
    delete(p.buf)
}

@(test)
test_float_exp80_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 5.540622384393487e+34)

    slice_eq(t, p.buf[:], []u8{202, 121, 42, 187, 206})
    delete(p.buf)
}

@(test)
test_float_nexp80_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -5.540622384393487e+34)

    slice_eq(t, p.buf[:], []u8{202, 249, 42, 187, 206})
    delete(p.buf)
}

@(test)
test_float_exp90_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1.220403294317835e+39)

    slice_eq(t, p.buf[:], []u8{203, 72, 12, 177, 8, 255, 190, 193, 61})
    delete(p.buf)
}

@(test)
test_float_nexp90_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1.220403294317835e+39)

    slice_eq(t, p.buf[:], []u8{203, 200, 12, 177, 8, 255, 190, 193, 61})
    delete(p.buf)
}

@(test)
test_float_exp100_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 2.6881171418161212e+43)

    slice_eq(t, p.buf[:], []u8{203, 72, 243, 73, 74, 155, 23, 27, 216})
    delete(p.buf)
}

@(test)
test_float_nexp100_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2.6881171418161212e+43)

    slice_eq(t, p.buf[:], []u8{203, 200, 243, 73, 74, 155, 23, 27, 216})
    delete(p.buf)
}

@(test)
test_float_exp110_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 5.920972027664636e+47)

    slice_eq(t, p.buf[:], []u8{203, 73, 217, 237, 163, 163, 30, 88, 84})
    delete(p.buf)
}

@(test)
test_float_nexp110_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -5.920972027664636e+47)

    slice_eq(t, p.buf[:], []u8{203, 201, 217, 237, 163, 163, 30, 88, 84})
    delete(p.buf)
}

@(test)
test_float_exp120_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1.304180878393624e+52)

    slice_eq(t, p.buf[:], []u8{203, 74, 193, 109, 200, 169, 239, 102, 236})
    delete(p.buf)
}

@(test)
test_float_nexp120_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1.304180878393624e+52)

    slice_eq(t, p.buf[:], []u8{203, 202, 193, 109, 200, 169, 239, 102, 236})
    delete(p.buf)
}

@(test)
test_float_exp130_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 2.872649550817812e+56)

    slice_eq(t, p.buf[:], []u8{203, 75, 167, 110, 95, 68, 206, 156, 1})
    delete(p.buf)
}

@(test)
test_float_nexp130_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -2.872649550817812e+56)

    slice_eq(t, p.buf[:], []u8{203, 203, 167, 110, 95, 68, 206, 156, 1})
    delete(p.buf)
}

@(test)
test_float_exp140_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 6.327431707155538e+60)

    slice_eq(t, p.buf[:], []u8{203, 76, 143, 128, 36, 235, 99, 58, 219})
    delete(p.buf)
}

@(test)
test_float_nexp140_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -6.327431707155538e+60)

    slice_eq(t, p.buf[:], []u8{203, 204, 143, 128, 36, 235, 99, 58, 219})
    delete(p.buf)
}

@(test)
test_float_exp150_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1.3937095806663685e+65)

    slice_eq(t, p.buf[:], []u8{203, 77, 117, 44, 172, 41, 130, 37, 99})
    delete(p.buf)
}

@(test)
test_float_nexp150_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1.3937095806663685e+65)

    slice_eq(t, p.buf[:], []u8{203, 205, 117, 44, 172, 41, 130, 37, 99})
    delete(p.buf)
}

@(test)
test_float_exp160_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 3.0698496406442164e+69)

    slice_eq(t, p.buf[:], []u8{203, 78, 92, 119, 125, 198, 92, 148, 68})
    delete(p.buf)
}

@(test)
test_float_nexp160_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -3.0698496406442164e+69)

    slice_eq(t, p.buf[:], []u8{203, 206, 92, 119, 125, 198, 92, 148, 68})
    delete(p.buf)
}

@(test)
test_float_exp170_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 6.761793810484949e+73)

    slice_eq(t, p.buf[:], []u8{203, 79, 67, 34, 156, 92, 13, 53, 95})
    delete(p.buf)
}

@(test)
test_float_nexp170_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -6.761793810484949e+73)

    slice_eq(t, p.buf[:], []u8{203, 207, 67, 34, 156, 92, 13, 53, 95})
    delete(p.buf)
}

@(test)
test_float_exp180_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 1.4893842007818241e+78)

    slice_eq(t, p.buf[:], []u8{203, 80, 41, 185, 163, 43, 29, 136, 64})
    delete(p.buf)
}

@(test)
test_float_nexp180_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -1.4893842007818241e+78)

    slice_eq(t, p.buf[:], []u8{203, 208, 41, 185, 163, 43, 29, 136, 64})
    delete(p.buf)
}

@(test)
test_float_exp190_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, 3.280587015384637e+82)

    slice_eq(t, p.buf[:], []u8{203, 81, 17, 74, 212, 24, 211, 185, 26})
    delete(p.buf)
}

@(test)
test_float_nexp190_output :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }
    m.write(&p, -3.280587015384637e+82)

    slice_eq(t, p.buf[:], []u8{203, 209, 17, 74, 212, 24, 211, 185, 26})
    delete(p.buf)
}

