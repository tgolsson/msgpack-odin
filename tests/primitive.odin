package tests
import "core:testing"
import "core:fmt"
import m "../"

slice_eq :: proc(t: ^testing.T, a: []$T, b: []T) {
    testing.expectf(t, len(a) == len(b), "mismatch: %v != %v", a, b)
    for i in 0..<len(a) {
        testing.expectf(t, a[i] == b[i], "%v == %v fails at index %v (%v %v)", a, b, i, a[i], b[i])
        if a[i] != b[i] do return
    }
}

map_eq :: proc(t: ^testing.T, a: map[$K]$T, b: map[K]T) {
    testing.expectf(t, len(a) == len(b), "mismatch: %v != %v", a, b)
    for k, v in a {
        testing.expectf(t, v == b[k], "%v == %v fails with key %v (%v %v)", a, b[k], k, k, b[k])
        if v != b[k] do return
    }
}
map_slice_eq :: proc(t: ^testing.T, a: map[$K][]$T, b: map[K][]T) {
    testing.expectf(t, len(a) == len(b), "mismatch: %v != %v", a, b)
    for k, v in a {
        slice_eq(t, v, b[k])
    }
}
@(test)
test_nil_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := rawptr(nil)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{192})
    delete(p.buf)
}


@(test)
test_nil_de :: proc(t: ^testing.T) {
    bytes := [?]u8{192}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected := m.Nil{}
    testing.expect_value(t, res.(m.Nil), expected)

}


@(test)
test_nil_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{192}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: rawptr
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (rawptr)(rawptr(nil)))
}

@(test)
test_true_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := true
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{195})
    delete(p.buf)
}


@(test)
test_true_de :: proc(t: ^testing.T) {
    bytes := [?]u8{195}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected := true
    testing.expect_value(t, res.(bool), expected)

}


@(test)
test_true_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{195}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: bool
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (bool)(true))
}

@(test)
test_false_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := false
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{194})
    delete(p.buf)
}


@(test)
test_false_de :: proc(t: ^testing.T) {
    bytes := [?]u8{194}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected := false
    testing.expect_value(t, res.(bool), expected)

}


@(test)
test_false_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{194}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: bool
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (bool)(false))
}

@(test)
test_fixint_126_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 126
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{126})
    delete(p.buf)
}


@(test)
test_fixint_126_de :: proc(t: ^testing.T) {
    bytes := [?]u8{126}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 126
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_fixint_126_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{126}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(126))
}

@(test)
test_fixint_127_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 127
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{127})
    delete(p.buf)
}


@(test)
test_fixint_127_de :: proc(t: ^testing.T) {
    bytes := [?]u8{127}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 127
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_fixint_127_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{127}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(127))
}

@(test)
test_fixint_128_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 128
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{204, 128})
    delete(p.buf)
}


@(test)
test_fixint_128_de :: proc(t: ^testing.T) {
    bytes := [?]u8{204, 128}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 128
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_fixint_128_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{204, 128}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(128))
}

@(test)
test_nfixint_30_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -30
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{226})
    delete(p.buf)
}


@(test)
test_nfixint_30_de :: proc(t: ^testing.T) {
    bytes := [?]u8{226}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -30
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_nfixint_30_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{226}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-30))
}

@(test)
test_nfixint_31_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -31
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{225})
    delete(p.buf)
}


@(test)
test_nfixint_31_de :: proc(t: ^testing.T) {
    bytes := [?]u8{225}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -31
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_nfixint_31_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{225}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-31))
}

@(test)
test_nfixint_32_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -32
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{224})
    delete(p.buf)
}


@(test)
test_nfixint_32_de :: proc(t: ^testing.T) {
    bytes := [?]u8{224}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -32
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_nfixint_32_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{224}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-32))
}

@(test)
test_nfixint_33_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -33
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{208, 223})
    delete(p.buf)
}


@(test)
test_nfixint_33_de :: proc(t: ^testing.T) {
    bytes := [?]u8{208, 223}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -33
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_nfixint_33_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{208, 223}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-33))
}

@(test)
test_int_254_8_2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := u64(254)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{204, 254})
    delete(p.buf)
}


@(test)
test_int_254_8_2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{204, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 254
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_254_8_2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{204, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(u64(254)))
}

@(test)
test_int_255_8_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := u64(255)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{204, 255})
    delete(p.buf)
}


@(test)
test_int_255_8_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{204, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 255
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_255_8_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{204, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(u64(255)))
}

@(test)
test_int_256_8_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := u64(256)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 1, 0})
    delete(p.buf)
}


@(test)
test_int_256_8_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 1, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 256
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_256_8_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 1, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(u64(256)))
}

@(test)
test_int_257_8_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := u64(257)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 1, 1})
    delete(p.buf)
}


@(test)
test_int_257_8_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 1, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 257
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_257_8_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 1, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(u64(257)))
}

@(test)
test_int_258_8_2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := u64(258)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 1, 2})
    delete(p.buf)
}


@(test)
test_int_258_8_2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 1, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 258
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_258_8_2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 1, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(u64(258)))
}

@(test)
test_int_65534_16_2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := u64(65534)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 255, 254})
    delete(p.buf)
}


@(test)
test_int_65534_16_2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 65534
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_65534_16_2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(u64(65534)))
}

@(test)
test_int_65535_16_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := u64(65535)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 255, 255})
    delete(p.buf)
}


@(test)
test_int_65535_16_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 65535
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_65535_16_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(u64(65535)))
}

@(test)
test_int_65536_16_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := u64(65536)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 1, 0, 0})
    delete(p.buf)
}


@(test)
test_int_65536_16_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 1, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 65536
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_65536_16_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 1, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(u64(65536)))
}

@(test)
test_int_65537_16_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := u64(65537)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 1, 0, 1})
    delete(p.buf)
}


@(test)
test_int_65537_16_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 1, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 65537
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_65537_16_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 1, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(u64(65537)))
}

@(test)
test_int_65538_16_2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := u64(65538)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 1, 0, 2})
    delete(p.buf)
}


@(test)
test_int_65538_16_2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 1, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 65538
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_65538_16_2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 1, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(u64(65538)))
}

@(test)
test_int_4294967294_32_2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := u64(4294967294)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_4294967294_32_2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 4294967294
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_4294967294_32_2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(u64(4294967294)))
}

@(test)
test_int_4294967295_32_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := u64(4294967295)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_4294967295_32_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 4294967295
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_4294967295_32_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(u64(4294967295)))
}

@(test)
test_int_4294967296_32_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := u64(4294967296)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 1, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_4294967296_32_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 1, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 4294967296
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_4294967296_32_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 1, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(u64(4294967296)))
}

@(test)
test_int_4294967297_32_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := u64(4294967297)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 1, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_4294967297_32_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 1, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 4294967297
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_4294967297_32_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 1, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(u64(4294967297)))
}

@(test)
test_int_4294967298_32_2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := u64(4294967298)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 1, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_int_4294967298_32_2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 1, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 4294967298
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_4294967298_32_2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 1, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(u64(4294967298)))
}

@(test)
test_int_18446744073709551614_64_2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := u64(18446744073709551614)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 255, 255, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_18446744073709551614_64_2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 255, 255, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 18446744073709551614
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_18446744073709551614_64_2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 255, 255, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(u64(18446744073709551614)))
}

@(test)
test_int_18446744073709551615_64_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := u64(18446744073709551615)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 255, 255, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_18446744073709551615_64_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 255, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 18446744073709551615
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_18446744073709551615_64_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 255, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(u64(18446744073709551615)))
}

@(test)
test_sint_62_7_2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := i64(-62)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{208, 194})
    delete(p.buf)
}


@(test)
test_sint_62_7_2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{208, 194}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -62
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_62_7_2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{208, 194}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(i64(-62)))
}

@(test)
test_sint_63_7_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := i64(-63)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{208, 193})
    delete(p.buf)
}


@(test)
test_sint_63_7_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{208, 193}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -63
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_63_7_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{208, 193}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(i64(-63)))
}

@(test)
test_sint_64_7_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := i64(-64)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{208, 192})
    delete(p.buf)
}


@(test)
test_sint_64_7_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{208, 192}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -64
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_64_7_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{208, 192}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(i64(-64)))
}

@(test)
test_sint_65_7_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := i64(-65)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{208, 191})
    delete(p.buf)
}


@(test)
test_sint_65_7_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{208, 191}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -65
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_65_7_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{208, 191}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(i64(-65)))
}

@(test)
test_sint_66_7_2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := i64(-66)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{208, 190})
    delete(p.buf)
}


@(test)
test_sint_66_7_2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{208, 190}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -66
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_66_7_2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{208, 190}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(i64(-66)))
}

@(test)
test_sint_16382_15_2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := i64(-16382)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 192, 2})
    delete(p.buf)
}


@(test)
test_sint_16382_15_2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 192, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -16382
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_16382_15_2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 192, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(i64(-16382)))
}

@(test)
test_sint_16383_15_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := i64(-16383)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 192, 1})
    delete(p.buf)
}


@(test)
test_sint_16383_15_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 192, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -16383
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_16383_15_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 192, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(i64(-16383)))
}

@(test)
test_sint_16384_15_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := i64(-16384)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 192, 0})
    delete(p.buf)
}


@(test)
test_sint_16384_15_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 192, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -16384
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_16384_15_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 192, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(i64(-16384)))
}

@(test)
test_sint_16385_15_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := i64(-16385)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 191, 255})
    delete(p.buf)
}


@(test)
test_sint_16385_15_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 191, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -16385
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_16385_15_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 191, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(i64(-16385)))
}

@(test)
test_sint_16386_15_2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := i64(-16386)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 191, 254})
    delete(p.buf)
}


@(test)
test_sint_16386_15_2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 191, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -16386
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_16386_15_2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 191, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(i64(-16386)))
}

@(test)
test_sint_1073741822_31_2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := i64(-1073741822)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 192, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_1073741822_31_2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 192, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -1073741822
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_1073741822_31_2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 192, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(i64(-1073741822)))
}

@(test)
test_sint_1073741823_31_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := i64(-1073741823)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 192, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_1073741823_31_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 192, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -1073741823
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_1073741823_31_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 192, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(i64(-1073741823)))
}

@(test)
test_sint_1073741824_31_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := i64(-1073741824)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 192, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_1073741824_31_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 192, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -1073741824
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_1073741824_31_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 192, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(i64(-1073741824)))
}

@(test)
test_sint_1073741825_31_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := i64(-1073741825)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 191, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_1073741825_31_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 191, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -1073741825
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_1073741825_31_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 191, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(i64(-1073741825)))
}

@(test)
test_sint_1073741826_31_2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := i64(-1073741826)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 191, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_sint_1073741826_31_2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 191, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -1073741826
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_1073741826_31_2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 191, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(i64(-1073741826)))
}

@(test)
test_sint_4611686018427387902_63_2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := i64(-4611686018427387902)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 192, 0, 0, 0, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_4611686018427387902_63_2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 192, 0, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -4611686018427387902
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_4611686018427387902_63_2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 192, 0, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(i64(-4611686018427387902)))
}

@(test)
test_sint_4611686018427387903_63_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := i64(-4611686018427387903)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 192, 0, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_4611686018427387903_63_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 192, 0, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -4611686018427387903
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_4611686018427387903_63_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 192, 0, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(i64(-4611686018427387903)))
}

@(test)
test_sint_4611686018427387904_63_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := i64(-4611686018427387904)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 192, 0, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_4611686018427387904_63_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 192, 0, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -4611686018427387904
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_4611686018427387904_63_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 192, 0, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(i64(-4611686018427387904)))
}

@(test)
test_sint_4611686018427387905_63_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := i64(-4611686018427387905)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 191, 255, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_4611686018427387905_63_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 191, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -4611686018427387905
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_4611686018427387905_63_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 191, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(i64(-4611686018427387905)))
}

@(test)
test_sint_4611686018427387906_63_2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := i64(-4611686018427387906)
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 191, 255, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_sint_4611686018427387906_63_2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 191, 255, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -4611686018427387906
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_4611686018427387906_63_2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 191, 255, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(i64(-4611686018427387906)))
}

@(test)
test_int_pow2_1_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 0
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{0})
    delete(p.buf)
}


@(test)
test_int_pow2_1_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 0
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_1_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(0))
}

@(test)
test_int_pow2_1_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{1})
    delete(p.buf)
}


@(test)
test_int_pow2_1_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 1
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_1_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(1))
}

@(test)
test_sint_pow2_1_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{255})
    delete(p.buf)
}


@(test)
test_sint_pow2_1_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -1
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_1_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-1))
}

@(test)
test_int_pow2_1_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 2
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{2})
    delete(p.buf)
}


@(test)
test_int_pow2_1_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 2
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_1_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(2))
}

@(test)
test_sint_pow2_1_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -2
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{254})
    delete(p.buf)
}


@(test)
test_sint_pow2_1_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -2
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_1_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-2))
}

@(test)
test_int_pow2_2_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 0
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{0})
    delete(p.buf)
}


@(test)
test_int_pow2_2_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 0
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_2_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(0))
}

@(test)
test_int_pow2_2_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{1})
    delete(p.buf)
}


@(test)
test_int_pow2_2_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 1
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_2_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(1))
}

@(test)
test_sint_pow2_2_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{255})
    delete(p.buf)
}


@(test)
test_sint_pow2_2_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -1
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_2_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-1))
}

@(test)
test_int_pow2_2_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 2
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{2})
    delete(p.buf)
}


@(test)
test_int_pow2_2_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 2
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_2_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(2))
}

@(test)
test_sint_pow2_2_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -2
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{254})
    delete(p.buf)
}


@(test)
test_sint_pow2_2_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -2
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_2_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-2))
}

@(test)
test_int_pow2_2_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 3
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{3})
    delete(p.buf)
}


@(test)
test_int_pow2_2_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{3}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 3
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_2_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{3}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(3))
}

@(test)
test_sint_pow2_2_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -3
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{253})
    delete(p.buf)
}


@(test)
test_sint_pow2_2_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{253}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -3
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_2_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{253}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-3))
}

@(test)
test_int_pow2_4_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 2
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{2})
    delete(p.buf)
}


@(test)
test_int_pow2_4_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 2
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_4_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(2))
}

@(test)
test_sint_pow2_4_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -2
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{254})
    delete(p.buf)
}


@(test)
test_sint_pow2_4_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -2
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_4_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-2))
}

@(test)
test_int_pow2_4_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 3
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{3})
    delete(p.buf)
}


@(test)
test_int_pow2_4_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{3}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 3
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_4_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{3}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(3))
}

@(test)
test_sint_pow2_4_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -3
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{253})
    delete(p.buf)
}


@(test)
test_sint_pow2_4_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{253}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -3
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_4_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{253}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-3))
}

@(test)
test_int_pow2_4_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 4
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{4})
    delete(p.buf)
}


@(test)
test_int_pow2_4_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{4}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 4
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_4_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{4}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(4))
}

@(test)
test_sint_pow2_4_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -4
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{252})
    delete(p.buf)
}


@(test)
test_sint_pow2_4_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{252}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -4
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_4_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{252}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-4))
}

@(test)
test_int_pow2_4_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 5
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{5})
    delete(p.buf)
}


@(test)
test_int_pow2_4_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{5}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 5
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_4_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{5}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(5))
}

@(test)
test_sint_pow2_4_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -5
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{251})
    delete(p.buf)
}


@(test)
test_sint_pow2_4_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{251}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -5
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_4_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{251}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-5))
}

@(test)
test_int_pow2_8_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 6
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{6})
    delete(p.buf)
}


@(test)
test_int_pow2_8_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{6}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 6
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_8_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{6}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(6))
}

@(test)
test_sint_pow2_8_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -6
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{250})
    delete(p.buf)
}


@(test)
test_sint_pow2_8_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{250}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -6
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_8_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{250}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-6))
}

@(test)
test_int_pow2_8_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 7
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{7})
    delete(p.buf)
}


@(test)
test_int_pow2_8_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{7}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 7
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_8_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{7}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(7))
}

@(test)
test_sint_pow2_8_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -7
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{249})
    delete(p.buf)
}


@(test)
test_sint_pow2_8_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{249}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -7
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_8_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{249}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-7))
}

@(test)
test_int_pow2_8_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 8
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{8})
    delete(p.buf)
}


@(test)
test_int_pow2_8_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{8}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 8
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_8_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{8}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(8))
}

@(test)
test_sint_pow2_8_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -8
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{248})
    delete(p.buf)
}


@(test)
test_sint_pow2_8_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{248}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -8
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_8_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{248}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-8))
}

@(test)
test_int_pow2_8_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 9
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{9})
    delete(p.buf)
}


@(test)
test_int_pow2_8_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{9}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 9
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_8_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{9}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(9))
}

@(test)
test_sint_pow2_8_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -9
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{247})
    delete(p.buf)
}


@(test)
test_sint_pow2_8_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{247}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -9
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_8_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{247}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-9))
}

@(test)
test_int_pow2_16_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 14
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{14})
    delete(p.buf)
}


@(test)
test_int_pow2_16_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{14}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 14
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_16_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{14}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(14))
}

@(test)
test_sint_pow2_16_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -14
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{242})
    delete(p.buf)
}


@(test)
test_sint_pow2_16_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{242}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -14
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_16_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{242}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-14))
}

@(test)
test_int_pow2_16_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 15
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{15})
    delete(p.buf)
}


@(test)
test_int_pow2_16_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{15}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 15
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_16_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{15}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(15))
}

@(test)
test_sint_pow2_16_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -15
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{241})
    delete(p.buf)
}


@(test)
test_sint_pow2_16_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{241}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -15
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_16_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{241}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-15))
}

@(test)
test_int_pow2_16_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 16
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{16})
    delete(p.buf)
}


@(test)
test_int_pow2_16_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{16}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 16
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_16_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{16}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(16))
}

@(test)
test_sint_pow2_16_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -16
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{240})
    delete(p.buf)
}


@(test)
test_sint_pow2_16_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{240}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -16
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_16_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{240}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-16))
}

@(test)
test_int_pow2_16_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 17
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{17})
    delete(p.buf)
}


@(test)
test_int_pow2_16_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{17}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 17
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_16_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{17}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(17))
}

@(test)
test_sint_pow2_16_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -17
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{239})
    delete(p.buf)
}


@(test)
test_sint_pow2_16_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{239}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -17
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_16_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{239}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-17))
}

@(test)
test_int_pow2_32_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 30
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{30})
    delete(p.buf)
}


@(test)
test_int_pow2_32_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{30}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 30
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_32_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{30}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(30))
}

@(test)
test_sint_pow2_32_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -30
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{226})
    delete(p.buf)
}


@(test)
test_sint_pow2_32_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{226}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -30
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_32_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{226}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-30))
}

@(test)
test_int_pow2_32_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 31
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{31})
    delete(p.buf)
}


@(test)
test_int_pow2_32_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{31}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 31
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_32_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{31}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(31))
}

@(test)
test_sint_pow2_32_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -31
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{225})
    delete(p.buf)
}


@(test)
test_sint_pow2_32_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{225}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -31
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_32_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{225}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-31))
}

@(test)
test_int_pow2_32_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 32
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{32})
    delete(p.buf)
}


@(test)
test_int_pow2_32_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{32}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 32
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_32_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{32}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(32))
}

@(test)
test_sint_pow2_32_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -32
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{224})
    delete(p.buf)
}


@(test)
test_sint_pow2_32_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{224}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -32
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_32_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{224}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-32))
}

@(test)
test_int_pow2_32_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 33
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{33})
    delete(p.buf)
}


@(test)
test_int_pow2_32_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{33}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 33
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_32_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{33}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(33))
}

@(test)
test_sint_pow2_32_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -33
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{208, 223})
    delete(p.buf)
}


@(test)
test_sint_pow2_32_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{208, 223}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -33
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_32_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{208, 223}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-33))
}

@(test)
test_int_pow2_64_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 62
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{62})
    delete(p.buf)
}


@(test)
test_int_pow2_64_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{62}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 62
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_64_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{62}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(62))
}

@(test)
test_sint_pow2_64_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -62
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{208, 194})
    delete(p.buf)
}


@(test)
test_sint_pow2_64_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{208, 194}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -62
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_64_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{208, 194}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-62))
}

@(test)
test_int_pow2_64_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 63
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{63})
    delete(p.buf)
}


@(test)
test_int_pow2_64_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{63}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 63
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_64_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{63}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(63))
}

@(test)
test_sint_pow2_64_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -63
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{208, 193})
    delete(p.buf)
}


@(test)
test_sint_pow2_64_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{208, 193}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -63
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_64_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{208, 193}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-63))
}

@(test)
test_int_pow2_64_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 64
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{64})
    delete(p.buf)
}


@(test)
test_int_pow2_64_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{64}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 64
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_64_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{64}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(64))
}

@(test)
test_sint_pow2_64_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -64
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{208, 192})
    delete(p.buf)
}


@(test)
test_sint_pow2_64_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{208, 192}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -64
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_64_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{208, 192}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-64))
}

@(test)
test_int_pow2_64_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 65
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{65})
    delete(p.buf)
}


@(test)
test_int_pow2_64_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{65}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 65
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_64_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{65}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(65))
}

@(test)
test_sint_pow2_64_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -65
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{208, 191})
    delete(p.buf)
}


@(test)
test_sint_pow2_64_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{208, 191}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -65
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_64_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{208, 191}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-65))
}

@(test)
test_int_pow2_128_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 126
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{126})
    delete(p.buf)
}


@(test)
test_int_pow2_128_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{126}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 126
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_128_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{126}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(126))
}

@(test)
test_sint_pow2_128_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -126
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{208, 130})
    delete(p.buf)
}


@(test)
test_sint_pow2_128_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{208, 130}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -126
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_128_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{208, 130}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-126))
}

@(test)
test_int_pow2_128_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 127
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{127})
    delete(p.buf)
}


@(test)
test_int_pow2_128_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{127}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 127
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_128_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{127}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(127))
}

@(test)
test_sint_pow2_128_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -127
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{208, 129})
    delete(p.buf)
}


@(test)
test_sint_pow2_128_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{208, 129}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -127
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_128_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{208, 129}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-127))
}

@(test)
test_int_pow2_128_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 128
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{204, 128})
    delete(p.buf)
}


@(test)
test_int_pow2_128_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{204, 128}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 128
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_128_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{204, 128}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(128))
}

@(test)
test_sint_pow2_128_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -128
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{208, 128})
    delete(p.buf)
}


@(test)
test_sint_pow2_128_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{208, 128}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -128
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_128_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{208, 128}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-128))
}

@(test)
test_int_pow2_128_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 129
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{204, 129})
    delete(p.buf)
}


@(test)
test_int_pow2_128_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{204, 129}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 129
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_128_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{204, 129}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(129))
}

@(test)
test_sint_pow2_128_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -129
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 255, 127})
    delete(p.buf)
}


@(test)
test_sint_pow2_128_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 255, 127}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -129
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_128_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 255, 127}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-129))
}

@(test)
test_int_pow2_256_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 254
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{204, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_256_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{204, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 254
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_256_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{204, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(254))
}

@(test)
test_sint_pow2_256_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -254
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 255, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_256_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 255, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -254
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_256_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 255, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-254))
}

@(test)
test_int_pow2_256_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 255
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{204, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_256_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{204, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 255
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_256_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{204, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(255))
}

@(test)
test_sint_pow2_256_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -255
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 255, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_256_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 255, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -255
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_256_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 255, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-255))
}

@(test)
test_int_pow2_256_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 256
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 1, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_256_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 1, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 256
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_256_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 1, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(256))
}

@(test)
test_sint_pow2_256_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -256
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 255, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_256_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 255, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -256
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_256_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 255, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-256))
}

@(test)
test_int_pow2_256_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 257
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 1, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_256_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 1, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 257
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_256_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 1, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(257))
}

@(test)
test_sint_pow2_256_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -257
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 254, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_256_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 254, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -257
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_256_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 254, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-257))
}

@(test)
test_int_pow2_512_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 510
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 1, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_512_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 1, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 510
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_512_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 1, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(510))
}

@(test)
test_sint_pow2_512_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -510
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 254, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_512_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 254, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -510
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_512_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 254, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-510))
}

@(test)
test_int_pow2_512_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 511
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 1, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_512_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 1, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 511
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_512_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 1, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(511))
}

@(test)
test_sint_pow2_512_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -511
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 254, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_512_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 254, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -511
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_512_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 254, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-511))
}

@(test)
test_int_pow2_512_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 512
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 2, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_512_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 2, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 512
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_512_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 2, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(512))
}

@(test)
test_sint_pow2_512_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -512
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 254, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_512_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 254, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -512
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_512_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 254, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-512))
}

@(test)
test_int_pow2_512_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 513
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 2, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_512_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 2, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 513
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_512_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 2, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(513))
}

@(test)
test_sint_pow2_512_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -513
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 253, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_512_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 253, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -513
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_512_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 253, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-513))
}

@(test)
test_int_pow2_1024_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1022
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 3, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_1024_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 3, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 1022
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_1024_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 3, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(1022))
}

@(test)
test_sint_pow2_1024_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1022
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 252, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_1024_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 252, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -1022
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_1024_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 252, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-1022))
}

@(test)
test_int_pow2_1024_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1023
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 3, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_1024_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 3, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 1023
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_1024_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 3, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(1023))
}

@(test)
test_sint_pow2_1024_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1023
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 252, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_1024_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 252, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -1023
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_1024_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 252, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-1023))
}

@(test)
test_int_pow2_1024_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1024
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 4, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_1024_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 4, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 1024
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_1024_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 4, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(1024))
}

@(test)
test_sint_pow2_1024_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1024
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 252, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_1024_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 252, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -1024
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_1024_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 252, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-1024))
}

@(test)
test_int_pow2_1024_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1025
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 4, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_1024_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 4, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 1025
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_1024_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 4, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(1025))
}

@(test)
test_sint_pow2_1024_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1025
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 251, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_1024_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 251, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -1025
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_1024_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 251, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-1025))
}

@(test)
test_int_pow2_2048_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 2046
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 7, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_2048_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 7, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 2046
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_2048_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 7, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(2046))
}

@(test)
test_sint_pow2_2048_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -2046
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 248, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_2048_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 248, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -2046
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_2048_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 248, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-2046))
}

@(test)
test_int_pow2_2048_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 2047
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 7, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_2048_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 7, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 2047
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_2048_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 7, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(2047))
}

@(test)
test_sint_pow2_2048_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -2047
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 248, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_2048_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 248, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -2047
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_2048_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 248, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-2047))
}

@(test)
test_int_pow2_2048_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 2048
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 8, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_2048_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 8, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 2048
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_2048_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 8, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(2048))
}

@(test)
test_sint_pow2_2048_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -2048
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 248, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_2048_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 248, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -2048
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_2048_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 248, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-2048))
}

@(test)
test_int_pow2_2048_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 2049
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 8, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_2048_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 8, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 2049
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_2048_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 8, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(2049))
}

@(test)
test_sint_pow2_2048_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -2049
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 247, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_2048_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 247, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -2049
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_2048_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 247, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-2049))
}

@(test)
test_int_pow2_4096_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 4094
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 15, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_4096_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 15, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 4094
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_4096_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 15, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(4094))
}

@(test)
test_sint_pow2_4096_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -4094
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 240, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_4096_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 240, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -4094
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_4096_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 240, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-4094))
}

@(test)
test_int_pow2_4096_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 4095
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 15, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_4096_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 15, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 4095
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_4096_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 15, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(4095))
}

@(test)
test_sint_pow2_4096_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -4095
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 240, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_4096_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 240, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -4095
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_4096_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 240, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-4095))
}

@(test)
test_int_pow2_4096_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 4096
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 16, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_4096_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 16, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 4096
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_4096_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 16, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(4096))
}

@(test)
test_sint_pow2_4096_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -4096
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 240, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_4096_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 240, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -4096
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_4096_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 240, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-4096))
}

@(test)
test_int_pow2_4096_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 4097
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 16, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_4096_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 16, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 4097
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_4096_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 16, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(4097))
}

@(test)
test_sint_pow2_4096_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -4097
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 239, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_4096_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 239, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -4097
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_4096_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 239, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-4097))
}

@(test)
test_int_pow2_8192_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 8190
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 31, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_8192_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 31, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 8190
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_8192_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 31, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(8190))
}

@(test)
test_sint_pow2_8192_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -8190
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 224, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_8192_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 224, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -8190
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_8192_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 224, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-8190))
}

@(test)
test_int_pow2_8192_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 8191
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 31, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_8192_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 31, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 8191
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_8192_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 31, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(8191))
}

@(test)
test_sint_pow2_8192_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -8191
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 224, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_8192_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 224, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -8191
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_8192_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 224, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-8191))
}

@(test)
test_int_pow2_8192_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 8192
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 32, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_8192_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 32, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 8192
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_8192_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 32, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(8192))
}

@(test)
test_sint_pow2_8192_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -8192
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 224, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_8192_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 224, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -8192
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_8192_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 224, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-8192))
}

@(test)
test_int_pow2_8192_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 8193
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 32, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_8192_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 32, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 8193
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_8192_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 32, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(8193))
}

@(test)
test_sint_pow2_8192_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -8193
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 223, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_8192_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 223, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -8193
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_8192_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 223, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-8193))
}

@(test)
test_int_pow2_16384_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 16382
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 63, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_16384_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 63, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 16382
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_16384_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 63, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(16382))
}

@(test)
test_sint_pow2_16384_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -16382
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 192, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_16384_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 192, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -16382
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_16384_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 192, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-16382))
}

@(test)
test_int_pow2_16384_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 16383
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 63, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_16384_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 63, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 16383
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_16384_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 63, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(16383))
}

@(test)
test_sint_pow2_16384_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -16383
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 192, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_16384_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 192, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -16383
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_16384_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 192, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-16383))
}

@(test)
test_int_pow2_16384_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 16384
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 64, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_16384_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 64, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 16384
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_16384_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 64, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(16384))
}

@(test)
test_sint_pow2_16384_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -16384
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 192, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_16384_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 192, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -16384
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_16384_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 192, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-16384))
}

@(test)
test_int_pow2_16384_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 16385
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 64, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_16384_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 64, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 16385
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_16384_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 64, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(16385))
}

@(test)
test_sint_pow2_16384_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -16385
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 191, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_16384_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 191, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -16385
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_16384_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 191, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-16385))
}

@(test)
test_int_pow2_32768_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 32766
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 127, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_32768_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 127, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 32766
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_32768_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 127, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(32766))
}

@(test)
test_sint_pow2_32768_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -32766
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 128, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_32768_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 128, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -32766
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_32768_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 128, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-32766))
}

@(test)
test_int_pow2_32768_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 32767
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 127, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_32768_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 127, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 32767
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_32768_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 127, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(32767))
}

@(test)
test_sint_pow2_32768_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -32767
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 128, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_32768_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 128, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -32767
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_32768_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 128, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-32767))
}

@(test)
test_int_pow2_32768_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 32768
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 128, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_32768_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 128, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 32768
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_32768_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 128, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(32768))
}

@(test)
test_sint_pow2_32768_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -32768
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{209, 128, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_32768_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 128, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -32768
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_32768_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{209, 128, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-32768))
}

@(test)
test_int_pow2_32768_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 32769
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 128, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_32768_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 128, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 32769
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_32768_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 128, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(32769))
}

@(test)
test_sint_pow2_32768_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -32769
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 255, 127, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_32768_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 255, 127, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -32769
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_32768_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 255, 127, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-32769))
}

@(test)
test_int_pow2_65536_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 65534
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_65536_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 65534
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_65536_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(65534))
}

@(test)
test_sint_pow2_65536_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -65534
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 255, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_65536_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 255, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -65534
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_65536_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 255, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-65534))
}

@(test)
test_int_pow2_65536_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 65535
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{205, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_65536_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 65535
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_65536_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{205, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(65535))
}

@(test)
test_sint_pow2_65536_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -65535
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 255, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_65536_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 255, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -65535
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_65536_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 255, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-65535))
}

@(test)
test_int_pow2_65536_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 65536
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 1, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_65536_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 1, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 65536
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_65536_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 1, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(65536))
}

@(test)
test_sint_pow2_65536_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -65536
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 255, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_65536_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 255, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -65536
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_65536_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 255, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-65536))
}

@(test)
test_int_pow2_65536_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 65537
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 1, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_65536_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 1, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 65537
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_65536_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 1, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(65537))
}

@(test)
test_sint_pow2_65536_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -65537
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 254, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_65536_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 254, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -65537
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_65536_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 254, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-65537))
}

@(test)
test_int_pow2_131072_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 131070
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 1, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_131072_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 1, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 131070
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_131072_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 1, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(131070))
}

@(test)
test_sint_pow2_131072_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -131070
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 254, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_131072_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 254, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -131070
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_131072_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 254, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-131070))
}

@(test)
test_int_pow2_131072_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 131071
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 1, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_131072_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 1, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 131071
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_131072_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 1, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(131071))
}

@(test)
test_sint_pow2_131072_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -131071
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 254, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_131072_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 254, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -131071
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_131072_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 254, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-131071))
}

@(test)
test_int_pow2_131072_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 131072
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 2, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_131072_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 2, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 131072
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_131072_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 2, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(131072))
}

@(test)
test_sint_pow2_131072_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -131072
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 254, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_131072_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 254, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -131072
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_131072_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 254, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-131072))
}

@(test)
test_int_pow2_131072_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 131073
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 2, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_131072_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 2, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 131073
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_131072_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 2, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(131073))
}

@(test)
test_sint_pow2_131072_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -131073
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 253, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_131072_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 253, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -131073
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_131072_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 253, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-131073))
}

@(test)
test_int_pow2_262144_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 262142
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 3, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_262144_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 3, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 262142
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_262144_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 3, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(262142))
}

@(test)
test_sint_pow2_262144_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -262142
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 252, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_262144_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 252, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -262142
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_262144_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 252, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-262142))
}

@(test)
test_int_pow2_262144_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 262143
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 3, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_262144_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 3, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 262143
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_262144_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 3, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(262143))
}

@(test)
test_sint_pow2_262144_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -262143
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 252, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_262144_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 252, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -262143
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_262144_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 252, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-262143))
}

@(test)
test_int_pow2_262144_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 262144
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 4, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_262144_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 4, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 262144
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_262144_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 4, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(262144))
}

@(test)
test_sint_pow2_262144_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -262144
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 252, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_262144_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 252, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -262144
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_262144_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 252, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-262144))
}

@(test)
test_int_pow2_262144_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 262145
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 4, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_262144_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 4, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 262145
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_262144_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 4, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(262145))
}

@(test)
test_sint_pow2_262144_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -262145
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 251, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_262144_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 251, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -262145
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_262144_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 251, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-262145))
}

@(test)
test_int_pow2_524288_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 524286
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 7, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_524288_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 7, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 524286
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_524288_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 7, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(524286))
}

@(test)
test_sint_pow2_524288_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -524286
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 248, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_524288_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 248, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -524286
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_524288_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 248, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-524286))
}

@(test)
test_int_pow2_524288_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 524287
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 7, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_524288_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 7, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 524287
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_524288_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 7, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(524287))
}

@(test)
test_sint_pow2_524288_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -524287
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 248, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_524288_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 248, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -524287
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_524288_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 248, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-524287))
}

@(test)
test_int_pow2_524288_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 524288
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 8, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_524288_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 8, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 524288
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_524288_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 8, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(524288))
}

@(test)
test_sint_pow2_524288_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -524288
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 248, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_524288_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 248, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -524288
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_524288_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 248, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-524288))
}

@(test)
test_int_pow2_524288_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 524289
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 8, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_524288_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 8, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 524289
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_524288_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 8, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(524289))
}

@(test)
test_sint_pow2_524288_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -524289
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 247, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_524288_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 247, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -524289
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_524288_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 247, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-524289))
}

@(test)
test_int_pow2_1048576_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1048574
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 15, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_1048576_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 15, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 1048574
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_1048576_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 15, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(1048574))
}

@(test)
test_sint_pow2_1048576_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1048574
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 240, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_1048576_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 240, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -1048574
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_1048576_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 240, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-1048574))
}

@(test)
test_int_pow2_1048576_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1048575
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 15, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_1048576_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 15, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 1048575
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_1048576_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 15, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(1048575))
}

@(test)
test_sint_pow2_1048576_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1048575
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 240, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_1048576_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 240, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -1048575
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_1048576_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 240, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-1048575))
}

@(test)
test_int_pow2_1048576_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1048576
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 16, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_1048576_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 16, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 1048576
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_1048576_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 16, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(1048576))
}

@(test)
test_sint_pow2_1048576_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1048576
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 240, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_1048576_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 240, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -1048576
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_1048576_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 240, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-1048576))
}

@(test)
test_int_pow2_1048576_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1048577
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 16, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_1048576_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 16, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 1048577
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_1048576_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 16, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(1048577))
}

@(test)
test_sint_pow2_1048576_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1048577
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 239, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_1048576_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 239, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -1048577
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_1048576_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 239, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-1048577))
}

@(test)
test_int_pow2_2097152_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 2097150
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 31, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_2097152_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 31, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 2097150
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_2097152_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 31, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(2097150))
}

@(test)
test_sint_pow2_2097152_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -2097150
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 224, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_2097152_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 224, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -2097150
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_2097152_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 224, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-2097150))
}

@(test)
test_int_pow2_2097152_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 2097151
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 31, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_2097152_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 31, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 2097151
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_2097152_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 31, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(2097151))
}

@(test)
test_sint_pow2_2097152_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -2097151
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 224, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_2097152_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 224, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -2097151
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_2097152_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 224, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-2097151))
}

@(test)
test_int_pow2_2097152_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 2097152
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 32, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_2097152_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 32, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 2097152
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_2097152_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 32, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(2097152))
}

@(test)
test_sint_pow2_2097152_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -2097152
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 224, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_2097152_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 224, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -2097152
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_2097152_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 224, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-2097152))
}

@(test)
test_int_pow2_2097152_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 2097153
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 32, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_2097152_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 32, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 2097153
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_2097152_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 32, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(2097153))
}

@(test)
test_sint_pow2_2097152_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -2097153
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 223, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_2097152_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 223, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -2097153
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_2097152_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 223, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-2097153))
}

@(test)
test_int_pow2_4194304_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 4194302
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 63, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_4194304_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 63, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 4194302
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_4194304_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 63, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(4194302))
}

@(test)
test_sint_pow2_4194304_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -4194302
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 192, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_4194304_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 192, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -4194302
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_4194304_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 192, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-4194302))
}

@(test)
test_int_pow2_4194304_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 4194303
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 63, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_4194304_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 63, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 4194303
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_4194304_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 63, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(4194303))
}

@(test)
test_sint_pow2_4194304_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -4194303
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 192, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_4194304_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 192, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -4194303
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_4194304_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 192, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-4194303))
}

@(test)
test_int_pow2_4194304_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 4194304
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 64, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_4194304_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 64, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 4194304
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_4194304_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 64, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(4194304))
}

@(test)
test_sint_pow2_4194304_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -4194304
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 192, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_4194304_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 192, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -4194304
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_4194304_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 192, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-4194304))
}

@(test)
test_int_pow2_4194304_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 4194305
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 64, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_4194304_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 64, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 4194305
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_4194304_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 64, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(4194305))
}

@(test)
test_sint_pow2_4194304_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -4194305
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 191, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_4194304_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 191, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -4194305
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_4194304_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 191, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-4194305))
}

@(test)
test_int_pow2_8388608_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 8388606
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 127, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_8388608_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 127, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 8388606
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_8388608_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 127, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(8388606))
}

@(test)
test_sint_pow2_8388608_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -8388606
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 128, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_8388608_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 128, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -8388606
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_8388608_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 128, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-8388606))
}

@(test)
test_int_pow2_8388608_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 8388607
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 127, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_8388608_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 127, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 8388607
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_8388608_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 127, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(8388607))
}

@(test)
test_sint_pow2_8388608_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -8388607
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 128, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_8388608_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 128, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -8388607
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_8388608_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 128, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-8388607))
}

@(test)
test_int_pow2_8388608_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 8388608
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 128, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_8388608_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 128, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 8388608
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_8388608_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 128, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(8388608))
}

@(test)
test_sint_pow2_8388608_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -8388608
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 128, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_8388608_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 128, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -8388608
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_8388608_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 128, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-8388608))
}

@(test)
test_int_pow2_8388608_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 8388609
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 128, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_8388608_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 128, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 8388609
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_8388608_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 128, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(8388609))
}

@(test)
test_sint_pow2_8388608_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -8388609
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 127, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_8388608_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 127, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -8388609
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_8388608_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 127, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-8388609))
}

@(test)
test_int_pow2_16777216_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 16777214
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_16777216_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 16777214
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_16777216_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(16777214))
}

@(test)
test_sint_pow2_16777216_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -16777214
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_16777216_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -16777214
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_16777216_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-16777214))
}

@(test)
test_int_pow2_16777216_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 16777215
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 0, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_16777216_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 16777215
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_16777216_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 0, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(16777215))
}

@(test)
test_sint_pow2_16777216_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -16777215
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_16777216_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -16777215
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_16777216_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-16777215))
}

@(test)
test_int_pow2_16777216_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 16777216
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 1, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_16777216_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 1, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 16777216
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_16777216_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 1, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(16777216))
}

@(test)
test_sint_pow2_16777216_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -16777216
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 255, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_16777216_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -16777216
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_16777216_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 255, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-16777216))
}

@(test)
test_int_pow2_16777216_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 16777217
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 1, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_16777216_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 1, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 16777217
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_16777216_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 1, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(16777217))
}

@(test)
test_sint_pow2_16777216_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -16777217
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 254, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_16777216_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 254, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -16777217
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_16777216_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 254, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-16777217))
}

@(test)
test_int_pow2_33554432_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 33554430
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 1, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_33554432_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 1, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 33554430
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_33554432_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 1, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(33554430))
}

@(test)
test_sint_pow2_33554432_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -33554430
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 254, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_33554432_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 254, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -33554430
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_33554432_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 254, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-33554430))
}

@(test)
test_int_pow2_33554432_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 33554431
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 1, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_33554432_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 1, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 33554431
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_33554432_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 1, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(33554431))
}

@(test)
test_sint_pow2_33554432_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -33554431
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 254, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_33554432_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 254, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -33554431
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_33554432_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 254, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-33554431))
}

@(test)
test_int_pow2_33554432_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 33554432
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 2, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_33554432_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 2, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 33554432
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_33554432_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 2, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(33554432))
}

@(test)
test_sint_pow2_33554432_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -33554432
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 254, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_33554432_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 254, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -33554432
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_33554432_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 254, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-33554432))
}

@(test)
test_int_pow2_33554432_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 33554433
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 2, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_33554432_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 2, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 33554433
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_33554432_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 2, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(33554433))
}

@(test)
test_sint_pow2_33554432_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -33554433
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 253, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_33554432_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 253, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -33554433
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_33554432_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 253, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-33554433))
}

@(test)
test_int_pow2_67108864_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 67108862
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 3, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_67108864_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 3, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 67108862
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_67108864_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 3, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(67108862))
}

@(test)
test_sint_pow2_67108864_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -67108862
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 252, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_67108864_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 252, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -67108862
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_67108864_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 252, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-67108862))
}

@(test)
test_int_pow2_67108864_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 67108863
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 3, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_67108864_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 3, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 67108863
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_67108864_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 3, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(67108863))
}

@(test)
test_sint_pow2_67108864_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -67108863
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 252, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_67108864_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 252, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -67108863
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_67108864_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 252, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-67108863))
}

@(test)
test_int_pow2_67108864_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 67108864
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 4, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_67108864_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 4, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 67108864
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_67108864_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 4, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(67108864))
}

@(test)
test_sint_pow2_67108864_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -67108864
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 252, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_67108864_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 252, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -67108864
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_67108864_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 252, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-67108864))
}

@(test)
test_int_pow2_67108864_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 67108865
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 4, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_67108864_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 4, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 67108865
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_67108864_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 4, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(67108865))
}

@(test)
test_sint_pow2_67108864_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -67108865
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 251, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_67108864_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 251, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -67108865
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_67108864_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 251, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-67108865))
}

@(test)
test_int_pow2_134217728_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 134217726
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 7, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_134217728_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 7, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 134217726
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_134217728_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 7, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(134217726))
}

@(test)
test_sint_pow2_134217728_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -134217726
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 248, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_134217728_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 248, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -134217726
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_134217728_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 248, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-134217726))
}

@(test)
test_int_pow2_134217728_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 134217727
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 7, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_134217728_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 7, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 134217727
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_134217728_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 7, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(134217727))
}

@(test)
test_sint_pow2_134217728_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -134217727
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 248, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_134217728_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 248, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -134217727
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_134217728_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 248, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-134217727))
}

@(test)
test_int_pow2_134217728_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 134217728
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 8, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_134217728_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 8, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 134217728
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_134217728_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 8, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(134217728))
}

@(test)
test_sint_pow2_134217728_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -134217728
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 248, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_134217728_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 248, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -134217728
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_134217728_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 248, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-134217728))
}

@(test)
test_int_pow2_134217728_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 134217729
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 8, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_134217728_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 8, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 134217729
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_134217728_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 8, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(134217729))
}

@(test)
test_sint_pow2_134217728_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -134217729
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 247, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_134217728_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 247, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -134217729
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_134217728_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 247, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-134217729))
}

@(test)
test_int_pow2_268435456_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 268435454
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 15, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_268435456_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 15, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 268435454
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_268435456_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 15, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(268435454))
}

@(test)
test_sint_pow2_268435456_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -268435454
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 240, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_268435456_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 240, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -268435454
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_268435456_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 240, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-268435454))
}

@(test)
test_int_pow2_268435456_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 268435455
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 15, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_268435456_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 15, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 268435455
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_268435456_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 15, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(268435455))
}

@(test)
test_sint_pow2_268435456_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -268435455
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 240, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_268435456_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 240, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -268435455
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_268435456_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 240, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-268435455))
}

@(test)
test_int_pow2_268435456_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 268435456
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 16, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_268435456_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 16, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 268435456
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_268435456_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 16, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(268435456))
}

@(test)
test_sint_pow2_268435456_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -268435456
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 240, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_268435456_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 240, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -268435456
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_268435456_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 240, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-268435456))
}

@(test)
test_int_pow2_268435456_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 268435457
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 16, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_268435456_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 16, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 268435457
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_268435456_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 16, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(268435457))
}

@(test)
test_sint_pow2_268435456_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -268435457
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 239, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_268435456_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 239, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -268435457
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_268435456_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 239, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-268435457))
}

@(test)
test_int_pow2_536870912_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 536870910
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 31, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_536870912_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 31, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 536870910
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_536870912_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 31, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(536870910))
}

@(test)
test_sint_pow2_536870912_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -536870910
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 224, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_536870912_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 224, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -536870910
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_536870912_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 224, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-536870910))
}

@(test)
test_int_pow2_536870912_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 536870911
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 31, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_536870912_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 31, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 536870911
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_536870912_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 31, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(536870911))
}

@(test)
test_sint_pow2_536870912_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -536870911
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 224, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_536870912_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 224, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -536870911
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_536870912_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 224, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-536870911))
}

@(test)
test_int_pow2_536870912_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 536870912
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 32, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_536870912_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 32, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 536870912
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_536870912_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 32, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(536870912))
}

@(test)
test_sint_pow2_536870912_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -536870912
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 224, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_536870912_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 224, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -536870912
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_536870912_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 224, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-536870912))
}

@(test)
test_int_pow2_536870912_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 536870913
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 32, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_536870912_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 32, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 536870913
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_536870912_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 32, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(536870913))
}

@(test)
test_sint_pow2_536870912_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -536870913
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 223, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_536870912_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 223, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -536870913
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_536870912_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 223, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-536870913))
}

@(test)
test_int_pow2_1073741824_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1073741822
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 63, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_1073741824_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 63, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 1073741822
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_1073741824_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 63, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(1073741822))
}

@(test)
test_sint_pow2_1073741824_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1073741822
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 192, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_1073741824_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 192, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -1073741822
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_1073741824_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 192, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-1073741822))
}

@(test)
test_int_pow2_1073741824_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1073741823
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 63, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_1073741824_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 63, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 1073741823
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_1073741824_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 63, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(1073741823))
}

@(test)
test_sint_pow2_1073741824_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1073741823
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 192, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_1073741824_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 192, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -1073741823
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_1073741824_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 192, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-1073741823))
}

@(test)
test_int_pow2_1073741824_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1073741824
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 64, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_1073741824_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 64, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 1073741824
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_1073741824_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 64, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(1073741824))
}

@(test)
test_sint_pow2_1073741824_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1073741824
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 192, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_1073741824_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 192, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -1073741824
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_1073741824_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 192, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-1073741824))
}

@(test)
test_int_pow2_1073741824_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1073741825
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 64, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_1073741824_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 64, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 1073741825
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_1073741824_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 64, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(1073741825))
}

@(test)
test_sint_pow2_1073741824_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1073741825
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 191, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_1073741824_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 191, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -1073741825
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_1073741824_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 191, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-1073741825))
}

@(test)
test_int_pow2_2147483648_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 2147483646
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 127, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_2147483648_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 127, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 2147483646
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_2147483648_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 127, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(2147483646))
}

@(test)
test_sint_pow2_2147483648_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -2147483646
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 128, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_2147483648_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 128, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -2147483646
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_2147483648_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 128, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-2147483646))
}

@(test)
test_int_pow2_2147483648_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 2147483647
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 127, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_2147483648_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 127, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 2147483647
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_2147483648_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 127, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(2147483647))
}

@(test)
test_sint_pow2_2147483648_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -2147483647
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 128, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_2147483648_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 128, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -2147483647
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_2147483648_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 128, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-2147483647))
}

@(test)
test_int_pow2_2147483648_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 2147483648
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 128, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_2147483648_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 128, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 2147483648
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_2147483648_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 128, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(2147483648))
}

@(test)
test_sint_pow2_2147483648_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -2147483648
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{210, 128, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_2147483648_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 128, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -2147483648
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_2147483648_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{210, 128, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-2147483648))
}

@(test)
test_int_pow2_2147483648_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 2147483649
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 128, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_2147483648_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 128, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 2147483649
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_2147483648_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 128, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(2147483649))
}

@(test)
test_sint_pow2_2147483648_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -2147483649
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 255, 127, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_2147483648_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 255, 127, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -2147483649
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_2147483648_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 255, 127, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-2147483649))
}

@(test)
test_int_pow2_4294967296_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 4294967294
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_4294967296_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 4294967294
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_4294967296_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(4294967294))
}

@(test)
test_sint_pow2_4294967296_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -4294967294
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 255, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_4294967296_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 255, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -4294967294
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_4294967296_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 255, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-4294967294))
}

@(test)
test_int_pow2_4294967296_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 4294967295
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{206, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_4294967296_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 4294967295
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_4294967296_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{206, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(4294967295))
}

@(test)
test_sint_pow2_4294967296_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -4294967295
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 255, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_4294967296_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 255, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -4294967295
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_4294967296_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 255, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-4294967295))
}

@(test)
test_int_pow2_4294967296_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 4294967296
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 1, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_4294967296_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 1, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 4294967296
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_4294967296_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 1, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(4294967296))
}

@(test)
test_sint_pow2_4294967296_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -4294967296
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 255, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_4294967296_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 255, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -4294967296
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_4294967296_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 255, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-4294967296))
}

@(test)
test_int_pow2_4294967296_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 4294967297
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 1, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_4294967296_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 1, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 4294967297
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_4294967296_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 1, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(4294967297))
}

@(test)
test_sint_pow2_4294967296_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -4294967297
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 254, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_4294967296_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 254, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -4294967297
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_4294967296_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 254, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-4294967297))
}

@(test)
test_int_pow2_8589934592_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 8589934590
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 1, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_8589934592_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 1, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 8589934590
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_8589934592_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 1, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(8589934590))
}

@(test)
test_sint_pow2_8589934592_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -8589934590
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 254, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_8589934592_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 254, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -8589934590
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_8589934592_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 254, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-8589934590))
}

@(test)
test_int_pow2_8589934592_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 8589934591
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 1, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_8589934592_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 1, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 8589934591
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_8589934592_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 1, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(8589934591))
}

@(test)
test_sint_pow2_8589934592_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -8589934591
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 254, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_8589934592_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 254, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -8589934591
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_8589934592_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 254, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-8589934591))
}

@(test)
test_int_pow2_8589934592_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 8589934592
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 2, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_8589934592_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 2, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 8589934592
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_8589934592_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 2, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(8589934592))
}

@(test)
test_sint_pow2_8589934592_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -8589934592
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 254, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_8589934592_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 254, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -8589934592
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_8589934592_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 254, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-8589934592))
}

@(test)
test_int_pow2_8589934592_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 8589934593
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 2, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_8589934592_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 2, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 8589934593
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_8589934592_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 2, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(8589934593))
}

@(test)
test_sint_pow2_8589934592_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -8589934593
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 253, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_8589934592_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 253, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -8589934593
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_8589934592_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 253, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-8589934593))
}

@(test)
test_int_pow2_17179869184_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 17179869182
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 3, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_17179869184_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 3, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 17179869182
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_17179869184_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 3, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(17179869182))
}

@(test)
test_sint_pow2_17179869184_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -17179869182
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 252, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_17179869184_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 252, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -17179869182
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_17179869184_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 252, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-17179869182))
}

@(test)
test_int_pow2_17179869184_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 17179869183
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 3, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_17179869184_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 3, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 17179869183
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_17179869184_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 3, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(17179869183))
}

@(test)
test_sint_pow2_17179869184_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -17179869183
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 252, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_17179869184_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 252, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -17179869183
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_17179869184_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 252, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-17179869183))
}

@(test)
test_int_pow2_17179869184_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 17179869184
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 4, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_17179869184_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 4, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 17179869184
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_17179869184_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 4, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(17179869184))
}

@(test)
test_sint_pow2_17179869184_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -17179869184
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 252, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_17179869184_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 252, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -17179869184
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_17179869184_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 252, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-17179869184))
}

@(test)
test_int_pow2_17179869184_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 17179869185
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 4, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_17179869184_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 4, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 17179869185
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_17179869184_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 4, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(17179869185))
}

@(test)
test_sint_pow2_17179869184_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -17179869185
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 251, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_17179869184_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 251, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -17179869185
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_17179869184_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 251, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-17179869185))
}

@(test)
test_int_pow2_34359738368_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 34359738366
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 7, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_34359738368_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 7, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 34359738366
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_34359738368_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 7, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(34359738366))
}

@(test)
test_sint_pow2_34359738368_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -34359738366
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 248, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_34359738368_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 248, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -34359738366
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_34359738368_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 248, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-34359738366))
}

@(test)
test_int_pow2_34359738368_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 34359738367
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 7, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_34359738368_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 7, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 34359738367
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_34359738368_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 7, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(34359738367))
}

@(test)
test_sint_pow2_34359738368_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -34359738367
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 248, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_34359738368_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 248, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -34359738367
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_34359738368_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 248, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-34359738367))
}

@(test)
test_int_pow2_34359738368_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 34359738368
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 8, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_34359738368_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 8, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 34359738368
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_34359738368_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 8, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(34359738368))
}

@(test)
test_sint_pow2_34359738368_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -34359738368
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 248, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_34359738368_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 248, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -34359738368
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_34359738368_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 248, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-34359738368))
}

@(test)
test_int_pow2_34359738368_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 34359738369
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 8, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_34359738368_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 8, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 34359738369
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_34359738368_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 8, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(34359738369))
}

@(test)
test_sint_pow2_34359738368_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -34359738369
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 247, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_34359738368_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 247, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -34359738369
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_34359738368_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 247, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-34359738369))
}

@(test)
test_int_pow2_68719476736_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 68719476734
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 15, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_68719476736_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 15, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 68719476734
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_68719476736_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 15, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(68719476734))
}

@(test)
test_sint_pow2_68719476736_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -68719476734
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 240, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_68719476736_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 240, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -68719476734
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_68719476736_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 240, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-68719476734))
}

@(test)
test_int_pow2_68719476736_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 68719476735
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 15, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_68719476736_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 15, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 68719476735
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_68719476736_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 15, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(68719476735))
}

@(test)
test_sint_pow2_68719476736_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -68719476735
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 240, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_68719476736_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 240, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -68719476735
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_68719476736_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 240, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-68719476735))
}

@(test)
test_int_pow2_68719476736_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 68719476736
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 16, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_68719476736_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 16, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 68719476736
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_68719476736_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 16, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(68719476736))
}

@(test)
test_sint_pow2_68719476736_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -68719476736
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 240, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_68719476736_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 240, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -68719476736
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_68719476736_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 240, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-68719476736))
}

@(test)
test_int_pow2_68719476736_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 68719476737
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 16, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_68719476736_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 16, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 68719476737
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_68719476736_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 16, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(68719476737))
}

@(test)
test_sint_pow2_68719476736_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -68719476737
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 239, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_68719476736_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 239, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -68719476737
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_68719476736_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 239, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-68719476737))
}

@(test)
test_int_pow2_137438953472_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 137438953470
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 31, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_137438953472_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 31, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 137438953470
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_137438953472_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 31, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(137438953470))
}

@(test)
test_sint_pow2_137438953472_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -137438953470
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 224, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_137438953472_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 224, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -137438953470
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_137438953472_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 224, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-137438953470))
}

@(test)
test_int_pow2_137438953472_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 137438953471
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 31, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_137438953472_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 31, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 137438953471
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_137438953472_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 31, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(137438953471))
}

@(test)
test_sint_pow2_137438953472_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -137438953471
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 224, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_137438953472_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 224, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -137438953471
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_137438953472_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 224, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-137438953471))
}

@(test)
test_int_pow2_137438953472_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 137438953472
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 32, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_137438953472_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 32, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 137438953472
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_137438953472_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 32, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(137438953472))
}

@(test)
test_sint_pow2_137438953472_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -137438953472
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 224, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_137438953472_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 224, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -137438953472
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_137438953472_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 224, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-137438953472))
}

@(test)
test_int_pow2_137438953472_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 137438953473
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 32, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_137438953472_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 32, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 137438953473
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_137438953472_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 32, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(137438953473))
}

@(test)
test_sint_pow2_137438953472_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -137438953473
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 223, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_137438953472_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 223, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -137438953473
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_137438953472_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 223, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-137438953473))
}

@(test)
test_int_pow2_274877906944_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 274877906942
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 63, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_274877906944_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 63, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 274877906942
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_274877906944_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 63, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(274877906942))
}

@(test)
test_sint_pow2_274877906944_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -274877906942
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 192, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_274877906944_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 192, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -274877906942
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_274877906944_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 192, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-274877906942))
}

@(test)
test_int_pow2_274877906944_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 274877906943
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 63, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_274877906944_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 63, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 274877906943
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_274877906944_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 63, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(274877906943))
}

@(test)
test_sint_pow2_274877906944_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -274877906943
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 192, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_274877906944_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 192, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -274877906943
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_274877906944_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 192, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-274877906943))
}

@(test)
test_int_pow2_274877906944_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 274877906944
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 64, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_274877906944_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 64, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 274877906944
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_274877906944_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 64, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(274877906944))
}

@(test)
test_sint_pow2_274877906944_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -274877906944
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 192, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_274877906944_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 192, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -274877906944
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_274877906944_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 192, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-274877906944))
}

@(test)
test_int_pow2_274877906944_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 274877906945
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 64, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_274877906944_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 64, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 274877906945
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_274877906944_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 64, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(274877906945))
}

@(test)
test_sint_pow2_274877906944_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -274877906945
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 191, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_274877906944_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 191, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -274877906945
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_274877906944_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 191, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-274877906945))
}

@(test)
test_int_pow2_549755813888_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 549755813886
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 127, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_549755813888_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 127, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 549755813886
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_549755813888_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 127, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(549755813886))
}

@(test)
test_sint_pow2_549755813888_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -549755813886
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 128, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_549755813888_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 128, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -549755813886
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_549755813888_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 128, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-549755813886))
}

@(test)
test_int_pow2_549755813888_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 549755813887
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 127, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_549755813888_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 127, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 549755813887
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_549755813888_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 127, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(549755813887))
}

@(test)
test_sint_pow2_549755813888_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -549755813887
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 128, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_549755813888_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 128, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -549755813887
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_549755813888_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 128, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-549755813887))
}

@(test)
test_int_pow2_549755813888_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 549755813888
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 128, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_549755813888_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 128, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 549755813888
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_549755813888_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 128, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(549755813888))
}

@(test)
test_sint_pow2_549755813888_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -549755813888
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 128, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_549755813888_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 128, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -549755813888
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_549755813888_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 128, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-549755813888))
}

@(test)
test_int_pow2_549755813888_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 549755813889
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 128, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_549755813888_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 128, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 549755813889
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_549755813888_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 128, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(549755813889))
}

@(test)
test_sint_pow2_549755813888_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -549755813889
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 127, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_549755813888_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 127, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -549755813889
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_549755813888_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 127, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-549755813889))
}

@(test)
test_int_pow2_1099511627776_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1099511627774
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 255, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_1099511627776_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 1099511627774
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_1099511627776_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(1099511627774))
}

@(test)
test_sint_pow2_1099511627776_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1099511627774
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 0, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_1099511627776_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -1099511627774
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_1099511627776_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-1099511627774))
}

@(test)
test_int_pow2_1099511627776_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1099511627775
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 0, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_1099511627776_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 1099511627775
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_1099511627776_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 0, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(1099511627775))
}

@(test)
test_sint_pow2_1099511627776_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1099511627775
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_1099511627776_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -1099511627775
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_1099511627776_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-1099511627775))
}

@(test)
test_int_pow2_1099511627776_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1099511627776
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 1, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_1099511627776_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 1, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 1099511627776
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_1099511627776_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 1, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(1099511627776))
}

@(test)
test_sint_pow2_1099511627776_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1099511627776
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 255, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_1099511627776_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -1099511627776
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_1099511627776_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 255, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-1099511627776))
}

@(test)
test_int_pow2_1099511627776_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1099511627777
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 1, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_1099511627776_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 1, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 1099511627777
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_1099511627776_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 1, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(1099511627777))
}

@(test)
test_sint_pow2_1099511627776_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1099511627777
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 254, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_1099511627776_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 254, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -1099511627777
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_1099511627776_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 254, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-1099511627777))
}

@(test)
test_int_pow2_2199023255552_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 2199023255550
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 1, 255, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_2199023255552_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 1, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 2199023255550
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_2199023255552_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 1, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(2199023255550))
}

@(test)
test_sint_pow2_2199023255552_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -2199023255550
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 254, 0, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_2199023255552_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 254, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -2199023255550
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_2199023255552_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 254, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-2199023255550))
}

@(test)
test_int_pow2_2199023255552_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 2199023255551
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 1, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_2199023255552_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 1, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 2199023255551
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_2199023255552_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 1, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(2199023255551))
}

@(test)
test_sint_pow2_2199023255552_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -2199023255551
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 254, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_2199023255552_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 254, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -2199023255551
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_2199023255552_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 254, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-2199023255551))
}

@(test)
test_int_pow2_2199023255552_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 2199023255552
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 2, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_2199023255552_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 2, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 2199023255552
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_2199023255552_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 2, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(2199023255552))
}

@(test)
test_sint_pow2_2199023255552_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -2199023255552
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 254, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_2199023255552_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 254, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -2199023255552
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_2199023255552_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 254, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-2199023255552))
}

@(test)
test_int_pow2_2199023255552_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 2199023255553
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 2, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_2199023255552_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 2, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 2199023255553
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_2199023255552_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 2, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(2199023255553))
}

@(test)
test_sint_pow2_2199023255552_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -2199023255553
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 253, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_2199023255552_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 253, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -2199023255553
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_2199023255552_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 253, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-2199023255553))
}

@(test)
test_int_pow2_4398046511104_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 4398046511102
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 3, 255, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_4398046511104_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 3, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 4398046511102
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_4398046511104_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 3, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(4398046511102))
}

@(test)
test_sint_pow2_4398046511104_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -4398046511102
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 252, 0, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_4398046511104_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 252, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -4398046511102
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_4398046511104_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 252, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-4398046511102))
}

@(test)
test_int_pow2_4398046511104_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 4398046511103
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 3, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_4398046511104_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 3, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 4398046511103
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_4398046511104_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 3, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(4398046511103))
}

@(test)
test_sint_pow2_4398046511104_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -4398046511103
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 252, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_4398046511104_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 252, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -4398046511103
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_4398046511104_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 252, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-4398046511103))
}

@(test)
test_int_pow2_4398046511104_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 4398046511104
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 4, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_4398046511104_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 4, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 4398046511104
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_4398046511104_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 4, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(4398046511104))
}

@(test)
test_sint_pow2_4398046511104_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -4398046511104
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 252, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_4398046511104_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 252, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -4398046511104
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_4398046511104_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 252, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-4398046511104))
}

@(test)
test_int_pow2_4398046511104_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 4398046511105
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 4, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_4398046511104_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 4, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 4398046511105
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_4398046511104_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 4, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(4398046511105))
}

@(test)
test_sint_pow2_4398046511104_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -4398046511105
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 251, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_4398046511104_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 251, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -4398046511105
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_4398046511104_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 251, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-4398046511105))
}

@(test)
test_int_pow2_8796093022208_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 8796093022206
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 7, 255, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_8796093022208_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 7, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 8796093022206
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_8796093022208_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 7, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(8796093022206))
}

@(test)
test_sint_pow2_8796093022208_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -8796093022206
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 248, 0, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_8796093022208_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 248, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -8796093022206
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_8796093022208_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 248, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-8796093022206))
}

@(test)
test_int_pow2_8796093022208_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 8796093022207
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 7, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_8796093022208_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 7, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 8796093022207
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_8796093022208_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 7, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(8796093022207))
}

@(test)
test_sint_pow2_8796093022208_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -8796093022207
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 248, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_8796093022208_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 248, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -8796093022207
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_8796093022208_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 248, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-8796093022207))
}

@(test)
test_int_pow2_8796093022208_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 8796093022208
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 8, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_8796093022208_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 8, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 8796093022208
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_8796093022208_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 8, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(8796093022208))
}

@(test)
test_sint_pow2_8796093022208_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -8796093022208
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 248, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_8796093022208_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 248, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -8796093022208
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_8796093022208_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 248, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-8796093022208))
}

@(test)
test_int_pow2_8796093022208_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 8796093022209
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 8, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_8796093022208_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 8, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 8796093022209
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_8796093022208_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 8, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(8796093022209))
}

@(test)
test_sint_pow2_8796093022208_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -8796093022209
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 247, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_8796093022208_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 247, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -8796093022209
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_8796093022208_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 247, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-8796093022209))
}

@(test)
test_int_pow2_17592186044416_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 17592186044414
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 15, 255, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_17592186044416_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 15, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 17592186044414
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_17592186044416_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 15, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(17592186044414))
}

@(test)
test_sint_pow2_17592186044416_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -17592186044414
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 240, 0, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_17592186044416_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 240, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -17592186044414
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_17592186044416_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 240, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-17592186044414))
}

@(test)
test_int_pow2_17592186044416_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 17592186044415
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 15, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_17592186044416_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 15, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 17592186044415
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_17592186044416_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 15, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(17592186044415))
}

@(test)
test_sint_pow2_17592186044416_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -17592186044415
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 240, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_17592186044416_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 240, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -17592186044415
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_17592186044416_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 240, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-17592186044415))
}

@(test)
test_int_pow2_17592186044416_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 17592186044416
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 16, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_17592186044416_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 16, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 17592186044416
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_17592186044416_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 16, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(17592186044416))
}

@(test)
test_sint_pow2_17592186044416_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -17592186044416
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 240, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_17592186044416_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 240, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -17592186044416
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_17592186044416_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 240, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-17592186044416))
}

@(test)
test_int_pow2_17592186044416_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 17592186044417
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 16, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_17592186044416_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 16, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 17592186044417
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_17592186044416_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 16, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(17592186044417))
}

@(test)
test_sint_pow2_17592186044416_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -17592186044417
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 239, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_17592186044416_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 239, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -17592186044417
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_17592186044416_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 239, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-17592186044417))
}

@(test)
test_int_pow2_35184372088832_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 35184372088830
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 31, 255, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_35184372088832_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 31, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 35184372088830
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_35184372088832_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 31, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(35184372088830))
}

@(test)
test_sint_pow2_35184372088832_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -35184372088830
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 224, 0, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_35184372088832_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 224, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -35184372088830
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_35184372088832_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 224, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-35184372088830))
}

@(test)
test_int_pow2_35184372088832_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 35184372088831
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 31, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_35184372088832_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 31, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 35184372088831
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_35184372088832_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 31, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(35184372088831))
}

@(test)
test_sint_pow2_35184372088832_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -35184372088831
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 224, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_35184372088832_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 224, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -35184372088831
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_35184372088832_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 224, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-35184372088831))
}

@(test)
test_int_pow2_35184372088832_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 35184372088832
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 32, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_35184372088832_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 32, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 35184372088832
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_35184372088832_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 32, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(35184372088832))
}

@(test)
test_sint_pow2_35184372088832_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -35184372088832
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 224, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_35184372088832_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 224, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -35184372088832
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_35184372088832_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 224, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-35184372088832))
}

@(test)
test_int_pow2_35184372088832_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 35184372088833
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 32, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_35184372088832_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 32, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 35184372088833
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_35184372088832_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 32, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(35184372088833))
}

@(test)
test_sint_pow2_35184372088832_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -35184372088833
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 223, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_35184372088832_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 223, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -35184372088833
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_35184372088832_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 223, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-35184372088833))
}

@(test)
test_int_pow2_70368744177664_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 70368744177662
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 63, 255, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_70368744177664_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 63, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 70368744177662
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_70368744177664_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 63, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(70368744177662))
}

@(test)
test_sint_pow2_70368744177664_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -70368744177662
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 192, 0, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_70368744177664_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 192, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -70368744177662
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_70368744177664_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 192, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-70368744177662))
}

@(test)
test_int_pow2_70368744177664_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 70368744177663
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 63, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_70368744177664_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 63, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 70368744177663
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_70368744177664_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 63, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(70368744177663))
}

@(test)
test_sint_pow2_70368744177664_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -70368744177663
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 192, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_70368744177664_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 192, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -70368744177663
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_70368744177664_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 192, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-70368744177663))
}

@(test)
test_int_pow2_70368744177664_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 70368744177664
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 64, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_70368744177664_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 64, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 70368744177664
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_70368744177664_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 64, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(70368744177664))
}

@(test)
test_sint_pow2_70368744177664_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -70368744177664
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 192, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_70368744177664_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 192, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -70368744177664
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_70368744177664_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 192, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-70368744177664))
}

@(test)
test_int_pow2_70368744177664_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 70368744177665
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 64, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_70368744177664_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 64, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 70368744177665
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_70368744177664_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 64, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(70368744177665))
}

@(test)
test_sint_pow2_70368744177664_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -70368744177665
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 191, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_70368744177664_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 191, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -70368744177665
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_70368744177664_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 191, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-70368744177665))
}

@(test)
test_int_pow2_140737488355328_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 140737488355326
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 127, 255, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_140737488355328_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 127, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 140737488355326
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_140737488355328_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 127, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(140737488355326))
}

@(test)
test_sint_pow2_140737488355328_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -140737488355326
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 128, 0, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_140737488355328_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 128, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -140737488355326
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_140737488355328_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 128, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-140737488355326))
}

@(test)
test_int_pow2_140737488355328_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 140737488355327
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 127, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_140737488355328_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 127, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 140737488355327
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_140737488355328_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 127, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(140737488355327))
}

@(test)
test_sint_pow2_140737488355328_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -140737488355327
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 128, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_140737488355328_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 128, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -140737488355327
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_140737488355328_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 128, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-140737488355327))
}

@(test)
test_int_pow2_140737488355328_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 140737488355328
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 128, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_140737488355328_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 128, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 140737488355328
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_140737488355328_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 128, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(140737488355328))
}

@(test)
test_sint_pow2_140737488355328_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -140737488355328
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 128, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_140737488355328_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 128, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -140737488355328
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_140737488355328_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 128, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-140737488355328))
}

@(test)
test_int_pow2_140737488355328_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 140737488355329
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 128, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_140737488355328_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 128, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 140737488355329
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_140737488355328_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 128, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(140737488355329))
}

@(test)
test_sint_pow2_140737488355328_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -140737488355329
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 127, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_140737488355328_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 127, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -140737488355329
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_140737488355328_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 127, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-140737488355329))
}

@(test)
test_int_pow2_281474976710656_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 281474976710654
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_281474976710656_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 281474976710654
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_281474976710656_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(281474976710654))
}

@(test)
test_sint_pow2_281474976710656_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -281474976710654
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 0, 0, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_281474976710656_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -281474976710654
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_281474976710656_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-281474976710654))
}

@(test)
test_int_pow2_281474976710656_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 281474976710655
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 0, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_281474976710656_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 281474976710655
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_281474976710656_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 0, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(281474976710655))
}

@(test)
test_sint_pow2_281474976710656_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -281474976710655
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_281474976710656_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -281474976710655
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_281474976710656_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-281474976710655))
}

@(test)
test_int_pow2_281474976710656_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 281474976710656
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 1, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_281474976710656_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 1, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 281474976710656
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_281474976710656_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 1, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(281474976710656))
}

@(test)
test_sint_pow2_281474976710656_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -281474976710656
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 255, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_281474976710656_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -281474976710656
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_281474976710656_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 255, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-281474976710656))
}

@(test)
test_int_pow2_281474976710656_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 281474976710657
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 1, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_281474976710656_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 1, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 281474976710657
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_281474976710656_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 1, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(281474976710657))
}

@(test)
test_sint_pow2_281474976710656_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -281474976710657
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 254, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_281474976710656_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 254, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -281474976710657
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_281474976710656_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 254, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-281474976710657))
}

@(test)
test_int_pow2_562949953421312_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 562949953421310
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 1, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_562949953421312_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 1, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 562949953421310
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_562949953421312_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 1, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(562949953421310))
}

@(test)
test_sint_pow2_562949953421312_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -562949953421310
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 254, 0, 0, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_562949953421312_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 254, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -562949953421310
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_562949953421312_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 254, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-562949953421310))
}

@(test)
test_int_pow2_562949953421312_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 562949953421311
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 1, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_562949953421312_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 1, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 562949953421311
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_562949953421312_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 1, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(562949953421311))
}

@(test)
test_sint_pow2_562949953421312_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -562949953421311
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 254, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_562949953421312_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 254, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -562949953421311
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_562949953421312_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 254, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-562949953421311))
}

@(test)
test_int_pow2_562949953421312_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 562949953421312
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 2, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_562949953421312_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 2, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 562949953421312
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_562949953421312_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 2, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(562949953421312))
}

@(test)
test_sint_pow2_562949953421312_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -562949953421312
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 254, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_562949953421312_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 254, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -562949953421312
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_562949953421312_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 254, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-562949953421312))
}

@(test)
test_int_pow2_562949953421312_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 562949953421313
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 2, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_562949953421312_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 2, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 562949953421313
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_562949953421312_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 2, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(562949953421313))
}

@(test)
test_sint_pow2_562949953421312_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -562949953421313
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 253, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_562949953421312_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 253, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -562949953421313
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_562949953421312_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 253, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-562949953421313))
}

@(test)
test_int_pow2_1125899906842624_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1125899906842622
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 3, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_1125899906842624_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 3, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 1125899906842622
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_1125899906842624_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 3, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(1125899906842622))
}

@(test)
test_sint_pow2_1125899906842624_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1125899906842622
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 252, 0, 0, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_1125899906842624_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 252, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -1125899906842622
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_1125899906842624_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 252, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-1125899906842622))
}

@(test)
test_int_pow2_1125899906842624_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1125899906842623
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 3, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_1125899906842624_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 3, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 1125899906842623
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_1125899906842624_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 3, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(1125899906842623))
}

@(test)
test_sint_pow2_1125899906842624_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1125899906842623
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 252, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_1125899906842624_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 252, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -1125899906842623
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_1125899906842624_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 252, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-1125899906842623))
}

@(test)
test_int_pow2_1125899906842624_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1125899906842624
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 4, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_1125899906842624_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 4, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 1125899906842624
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_1125899906842624_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 4, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(1125899906842624))
}

@(test)
test_sint_pow2_1125899906842624_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1125899906842624
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 252, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_1125899906842624_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 252, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -1125899906842624
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_1125899906842624_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 252, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-1125899906842624))
}

@(test)
test_int_pow2_1125899906842624_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1125899906842625
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 4, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_1125899906842624_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 4, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 1125899906842625
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_1125899906842624_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 4, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(1125899906842625))
}

@(test)
test_sint_pow2_1125899906842624_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1125899906842625
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 251, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_1125899906842624_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 251, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -1125899906842625
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_1125899906842624_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 251, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-1125899906842625))
}

@(test)
test_int_pow2_2251799813685248_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 2251799813685246
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 7, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_2251799813685248_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 7, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 2251799813685246
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_2251799813685248_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 7, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(2251799813685246))
}

@(test)
test_sint_pow2_2251799813685248_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -2251799813685246
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 248, 0, 0, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_2251799813685248_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 248, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -2251799813685246
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_2251799813685248_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 248, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-2251799813685246))
}

@(test)
test_int_pow2_2251799813685248_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 2251799813685247
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 7, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_2251799813685248_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 7, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 2251799813685247
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_2251799813685248_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 7, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(2251799813685247))
}

@(test)
test_sint_pow2_2251799813685248_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -2251799813685247
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 248, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_2251799813685248_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 248, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -2251799813685247
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_2251799813685248_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 248, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-2251799813685247))
}

@(test)
test_int_pow2_2251799813685248_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 2251799813685248
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 8, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_2251799813685248_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 8, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 2251799813685248
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_2251799813685248_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 8, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(2251799813685248))
}

@(test)
test_sint_pow2_2251799813685248_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -2251799813685248
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 248, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_2251799813685248_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 248, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -2251799813685248
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_2251799813685248_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 248, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-2251799813685248))
}

@(test)
test_int_pow2_2251799813685248_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 2251799813685249
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 8, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_2251799813685248_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 8, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 2251799813685249
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_2251799813685248_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 8, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(2251799813685249))
}

@(test)
test_sint_pow2_2251799813685248_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -2251799813685249
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 247, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_2251799813685248_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 247, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -2251799813685249
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_2251799813685248_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 247, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-2251799813685249))
}

@(test)
test_int_pow2_4503599627370496_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 4503599627370494
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 15, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_4503599627370496_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 15, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 4503599627370494
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_4503599627370496_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 15, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(4503599627370494))
}

@(test)
test_sint_pow2_4503599627370496_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -4503599627370494
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 240, 0, 0, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_4503599627370496_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 240, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -4503599627370494
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_4503599627370496_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 240, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-4503599627370494))
}

@(test)
test_int_pow2_4503599627370496_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 4503599627370495
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 15, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_4503599627370496_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 15, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 4503599627370495
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_4503599627370496_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 15, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(4503599627370495))
}

@(test)
test_sint_pow2_4503599627370496_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -4503599627370495
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 240, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_4503599627370496_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 240, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -4503599627370495
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_4503599627370496_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 240, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-4503599627370495))
}

@(test)
test_int_pow2_4503599627370496_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 4503599627370496
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 16, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_4503599627370496_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 16, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 4503599627370496
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_4503599627370496_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 16, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(4503599627370496))
}

@(test)
test_sint_pow2_4503599627370496_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -4503599627370496
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 240, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_4503599627370496_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 240, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -4503599627370496
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_4503599627370496_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 240, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-4503599627370496))
}

@(test)
test_int_pow2_4503599627370496_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 4503599627370497
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 16, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_4503599627370496_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 16, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 4503599627370497
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_4503599627370496_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 16, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(4503599627370497))
}

@(test)
test_sint_pow2_4503599627370496_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -4503599627370497
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 239, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_4503599627370496_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 239, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -4503599627370497
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_4503599627370496_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 239, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-4503599627370497))
}

@(test)
test_int_pow2_9007199254740992_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 9007199254740990
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 31, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_9007199254740992_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 31, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 9007199254740990
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_9007199254740992_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 31, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(9007199254740990))
}

@(test)
test_sint_pow2_9007199254740992_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -9007199254740990
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 224, 0, 0, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_9007199254740992_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 224, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -9007199254740990
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_9007199254740992_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 224, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-9007199254740990))
}

@(test)
test_int_pow2_9007199254740992_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 9007199254740991
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 31, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_9007199254740992_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 31, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 9007199254740991
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_9007199254740992_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 31, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(9007199254740991))
}

@(test)
test_sint_pow2_9007199254740992_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -9007199254740991
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 224, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_9007199254740992_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 224, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -9007199254740991
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_9007199254740992_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 224, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-9007199254740991))
}

@(test)
test_int_pow2_9007199254740992_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 9007199254740992
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 32, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_9007199254740992_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 32, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 9007199254740992
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_9007199254740992_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 32, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(9007199254740992))
}

@(test)
test_sint_pow2_9007199254740992_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -9007199254740992
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 224, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_9007199254740992_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 224, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -9007199254740992
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_9007199254740992_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 224, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-9007199254740992))
}

@(test)
test_int_pow2_9007199254740992_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 9007199254740993
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 32, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_9007199254740992_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 32, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 9007199254740993
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_9007199254740992_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 32, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(9007199254740993))
}

@(test)
test_sint_pow2_9007199254740992_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -9007199254740993
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 223, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_9007199254740992_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 223, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -9007199254740993
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_9007199254740992_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 223, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-9007199254740993))
}

@(test)
test_int_pow2_18014398509481984_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 18014398509481982
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 63, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_18014398509481984_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 63, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 18014398509481982
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_18014398509481984_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 63, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(18014398509481982))
}

@(test)
test_sint_pow2_18014398509481984_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -18014398509481982
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 192, 0, 0, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_18014398509481984_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 192, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -18014398509481982
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_18014398509481984_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 192, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-18014398509481982))
}

@(test)
test_int_pow2_18014398509481984_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 18014398509481983
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 63, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_18014398509481984_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 63, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 18014398509481983
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_18014398509481984_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 63, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(18014398509481983))
}

@(test)
test_sint_pow2_18014398509481984_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -18014398509481983
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 192, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_18014398509481984_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 192, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -18014398509481983
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_18014398509481984_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 192, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-18014398509481983))
}

@(test)
test_int_pow2_18014398509481984_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 18014398509481984
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 64, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_18014398509481984_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 64, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 18014398509481984
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_18014398509481984_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 64, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(18014398509481984))
}

@(test)
test_sint_pow2_18014398509481984_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -18014398509481984
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 192, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_18014398509481984_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 192, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -18014398509481984
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_18014398509481984_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 192, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-18014398509481984))
}

@(test)
test_int_pow2_18014398509481984_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 18014398509481985
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 64, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_18014398509481984_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 64, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 18014398509481985
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_18014398509481984_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 64, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(18014398509481985))
}

@(test)
test_sint_pow2_18014398509481984_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -18014398509481985
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 191, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_18014398509481984_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 191, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -18014398509481985
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_18014398509481984_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 191, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-18014398509481985))
}

@(test)
test_int_pow2_36028797018963968_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 36028797018963966
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 127, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_36028797018963968_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 127, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 36028797018963966
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_36028797018963968_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 127, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(36028797018963966))
}

@(test)
test_sint_pow2_36028797018963968_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -36028797018963966
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 128, 0, 0, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_36028797018963968_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 128, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -36028797018963966
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_36028797018963968_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 128, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-36028797018963966))
}

@(test)
test_int_pow2_36028797018963968_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 36028797018963967
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 127, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_36028797018963968_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 127, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 36028797018963967
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_36028797018963968_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 127, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(36028797018963967))
}

@(test)
test_sint_pow2_36028797018963968_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -36028797018963967
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 128, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_36028797018963968_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 128, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -36028797018963967
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_36028797018963968_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 128, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-36028797018963967))
}

@(test)
test_int_pow2_36028797018963968_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 36028797018963968
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 128, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_36028797018963968_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 128, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 36028797018963968
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_36028797018963968_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 128, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(36028797018963968))
}

@(test)
test_sint_pow2_36028797018963968_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -36028797018963968
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 128, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_36028797018963968_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 128, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -36028797018963968
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_36028797018963968_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 128, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-36028797018963968))
}

@(test)
test_int_pow2_36028797018963968_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 36028797018963969
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 128, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_36028797018963968_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 128, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 36028797018963969
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_36028797018963968_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 128, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(36028797018963969))
}

@(test)
test_sint_pow2_36028797018963968_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -36028797018963969
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 127, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_36028797018963968_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 127, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -36028797018963969
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_36028797018963968_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 127, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-36028797018963969))
}

@(test)
test_int_pow2_72057594037927936_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 72057594037927934
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 255, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_72057594037927936_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 255, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 72057594037927934
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_72057594037927936_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 255, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(72057594037927934))
}

@(test)
test_sint_pow2_72057594037927936_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -72057594037927934
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 0, 0, 0, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_72057594037927936_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 0, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -72057594037927934
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_72057594037927936_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 0, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-72057594037927934))
}

@(test)
test_int_pow2_72057594037927936_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 72057594037927935
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 0, 255, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_72057594037927936_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 72057594037927935
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_72057594037927936_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 0, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(72057594037927935))
}

@(test)
test_sint_pow2_72057594037927936_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -72057594037927935
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 0, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_72057594037927936_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 0, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -72057594037927935
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_72057594037927936_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 0, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-72057594037927935))
}

@(test)
test_int_pow2_72057594037927936_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 72057594037927936
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 1, 0, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_72057594037927936_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 1, 0, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 72057594037927936
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_72057594037927936_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 1, 0, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(72057594037927936))
}

@(test)
test_sint_pow2_72057594037927936_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -72057594037927936
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 255, 0, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_72057594037927936_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 0, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -72057594037927936
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_72057594037927936_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 255, 0, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-72057594037927936))
}

@(test)
test_int_pow2_72057594037927936_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 72057594037927937
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 1, 0, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_72057594037927936_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 1, 0, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 72057594037927937
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_72057594037927936_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 1, 0, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(72057594037927937))
}

@(test)
test_sint_pow2_72057594037927936_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -72057594037927937
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 254, 255, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_72057594037927936_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 254, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -72057594037927937
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_72057594037927936_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 254, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-72057594037927937))
}

@(test)
test_int_pow2_144115188075855872_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 144115188075855870
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 1, 255, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_144115188075855872_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 1, 255, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 144115188075855870
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_144115188075855872_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 1, 255, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(144115188075855870))
}

@(test)
test_sint_pow2_144115188075855872_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -144115188075855870
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 254, 0, 0, 0, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_144115188075855872_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 254, 0, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -144115188075855870
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_144115188075855872_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 254, 0, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-144115188075855870))
}

@(test)
test_int_pow2_144115188075855872_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 144115188075855871
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 1, 255, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_144115188075855872_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 1, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 144115188075855871
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_144115188075855872_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 1, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(144115188075855871))
}

@(test)
test_sint_pow2_144115188075855872_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -144115188075855871
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 254, 0, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_144115188075855872_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 254, 0, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -144115188075855871
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_144115188075855872_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 254, 0, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-144115188075855871))
}

@(test)
test_int_pow2_144115188075855872_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 144115188075855872
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 2, 0, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_144115188075855872_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 2, 0, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 144115188075855872
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_144115188075855872_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 2, 0, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(144115188075855872))
}

@(test)
test_sint_pow2_144115188075855872_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -144115188075855872
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 254, 0, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_144115188075855872_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 254, 0, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -144115188075855872
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_144115188075855872_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 254, 0, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-144115188075855872))
}

@(test)
test_int_pow2_144115188075855872_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 144115188075855873
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 2, 0, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_144115188075855872_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 2, 0, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 144115188075855873
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_144115188075855872_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 2, 0, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(144115188075855873))
}

@(test)
test_sint_pow2_144115188075855872_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -144115188075855873
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 253, 255, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_144115188075855872_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 253, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -144115188075855873
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_144115188075855872_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 253, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-144115188075855873))
}

@(test)
test_int_pow2_288230376151711744_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 288230376151711742
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 3, 255, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_288230376151711744_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 3, 255, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 288230376151711742
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_288230376151711744_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 3, 255, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(288230376151711742))
}

@(test)
test_sint_pow2_288230376151711744_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -288230376151711742
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 252, 0, 0, 0, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_288230376151711744_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 252, 0, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -288230376151711742
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_288230376151711744_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 252, 0, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-288230376151711742))
}

@(test)
test_int_pow2_288230376151711744_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 288230376151711743
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 3, 255, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_288230376151711744_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 3, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 288230376151711743
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_288230376151711744_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 3, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(288230376151711743))
}

@(test)
test_sint_pow2_288230376151711744_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -288230376151711743
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 252, 0, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_288230376151711744_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 252, 0, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -288230376151711743
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_288230376151711744_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 252, 0, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-288230376151711743))
}

@(test)
test_int_pow2_288230376151711744_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 288230376151711744
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 4, 0, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_288230376151711744_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 4, 0, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 288230376151711744
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_288230376151711744_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 4, 0, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(288230376151711744))
}

@(test)
test_sint_pow2_288230376151711744_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -288230376151711744
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 252, 0, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_288230376151711744_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 252, 0, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -288230376151711744
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_288230376151711744_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 252, 0, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-288230376151711744))
}

@(test)
test_int_pow2_288230376151711744_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 288230376151711745
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 4, 0, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_288230376151711744_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 4, 0, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 288230376151711745
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_288230376151711744_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 4, 0, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(288230376151711745))
}

@(test)
test_sint_pow2_288230376151711744_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -288230376151711745
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 251, 255, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_288230376151711744_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 251, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -288230376151711745
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_288230376151711744_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 251, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-288230376151711745))
}

@(test)
test_int_pow2_576460752303423488_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 576460752303423486
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 7, 255, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_576460752303423488_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 7, 255, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 576460752303423486
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_576460752303423488_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 7, 255, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(576460752303423486))
}

@(test)
test_sint_pow2_576460752303423488_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -576460752303423486
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 248, 0, 0, 0, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_576460752303423488_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 248, 0, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -576460752303423486
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_576460752303423488_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 248, 0, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-576460752303423486))
}

@(test)
test_int_pow2_576460752303423488_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 576460752303423487
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 7, 255, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_576460752303423488_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 7, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 576460752303423487
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_576460752303423488_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 7, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(576460752303423487))
}

@(test)
test_sint_pow2_576460752303423488_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -576460752303423487
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 248, 0, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_576460752303423488_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 248, 0, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -576460752303423487
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_576460752303423488_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 248, 0, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-576460752303423487))
}

@(test)
test_int_pow2_576460752303423488_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 576460752303423488
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 8, 0, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_576460752303423488_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 8, 0, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 576460752303423488
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_576460752303423488_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 8, 0, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(576460752303423488))
}

@(test)
test_sint_pow2_576460752303423488_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -576460752303423488
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 248, 0, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_576460752303423488_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 248, 0, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -576460752303423488
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_576460752303423488_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 248, 0, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-576460752303423488))
}

@(test)
test_int_pow2_576460752303423488_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 576460752303423489
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 8, 0, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_576460752303423488_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 8, 0, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 576460752303423489
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_576460752303423488_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 8, 0, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(576460752303423489))
}

@(test)
test_sint_pow2_576460752303423488_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -576460752303423489
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 247, 255, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_576460752303423488_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 247, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -576460752303423489
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_576460752303423488_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 247, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-576460752303423489))
}

@(test)
test_int_pow2_1152921504606846976_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1152921504606846974
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 15, 255, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_1152921504606846976_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 15, 255, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 1152921504606846974
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_1152921504606846976_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 15, 255, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(1152921504606846974))
}

@(test)
test_sint_pow2_1152921504606846976_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1152921504606846974
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 240, 0, 0, 0, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_1152921504606846976_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 240, 0, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -1152921504606846974
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_1152921504606846976_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 240, 0, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-1152921504606846974))
}

@(test)
test_int_pow2_1152921504606846976_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1152921504606846975
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 15, 255, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_1152921504606846976_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 15, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 1152921504606846975
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_1152921504606846976_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 15, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(1152921504606846975))
}

@(test)
test_sint_pow2_1152921504606846976_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1152921504606846975
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 240, 0, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_1152921504606846976_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 240, 0, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -1152921504606846975
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_1152921504606846976_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 240, 0, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-1152921504606846975))
}

@(test)
test_int_pow2_1152921504606846976_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1152921504606846976
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 16, 0, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_1152921504606846976_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 16, 0, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 1152921504606846976
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_1152921504606846976_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 16, 0, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(1152921504606846976))
}

@(test)
test_sint_pow2_1152921504606846976_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1152921504606846976
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 240, 0, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_1152921504606846976_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 240, 0, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -1152921504606846976
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_1152921504606846976_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 240, 0, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-1152921504606846976))
}

@(test)
test_int_pow2_1152921504606846976_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1152921504606846977
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 16, 0, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_1152921504606846976_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 16, 0, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 1152921504606846977
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_1152921504606846976_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 16, 0, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(1152921504606846977))
}

@(test)
test_sint_pow2_1152921504606846976_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1152921504606846977
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 239, 255, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_1152921504606846976_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 239, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -1152921504606846977
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_1152921504606846976_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 239, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-1152921504606846977))
}

@(test)
test_int_pow2_2305843009213693952_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 2305843009213693950
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 31, 255, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_2305843009213693952_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 31, 255, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 2305843009213693950
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_2305843009213693952_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 31, 255, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(2305843009213693950))
}

@(test)
test_sint_pow2_2305843009213693952_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -2305843009213693950
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 224, 0, 0, 0, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_2305843009213693952_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 224, 0, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -2305843009213693950
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_2305843009213693952_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 224, 0, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-2305843009213693950))
}

@(test)
test_int_pow2_2305843009213693952_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 2305843009213693951
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 31, 255, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_2305843009213693952_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 31, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 2305843009213693951
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_2305843009213693952_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 31, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(2305843009213693951))
}

@(test)
test_sint_pow2_2305843009213693952_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -2305843009213693951
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 224, 0, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_2305843009213693952_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 224, 0, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -2305843009213693951
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_2305843009213693952_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 224, 0, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-2305843009213693951))
}

@(test)
test_int_pow2_2305843009213693952_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 2305843009213693952
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 32, 0, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_2305843009213693952_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 32, 0, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 2305843009213693952
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_2305843009213693952_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 32, 0, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(2305843009213693952))
}

@(test)
test_sint_pow2_2305843009213693952_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -2305843009213693952
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 224, 0, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_2305843009213693952_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 224, 0, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -2305843009213693952
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_2305843009213693952_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 224, 0, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-2305843009213693952))
}

@(test)
test_int_pow2_2305843009213693952_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 2305843009213693953
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 32, 0, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_2305843009213693952_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 32, 0, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 2305843009213693953
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_2305843009213693952_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 32, 0, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(2305843009213693953))
}

@(test)
test_sint_pow2_2305843009213693952_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -2305843009213693953
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 223, 255, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_2305843009213693952_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 223, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -2305843009213693953
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_2305843009213693952_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 223, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-2305843009213693953))
}

@(test)
test_int_pow2_4611686018427387904_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 4611686018427387902
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 63, 255, 255, 255, 255, 255, 255, 254})
    delete(p.buf)
}


@(test)
test_int_pow2_4611686018427387904_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 63, 255, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 4611686018427387902
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_4611686018427387904_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 63, 255, 255, 255, 255, 255, 255, 254}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(4611686018427387902))
}

@(test)
test_sint_pow2_4611686018427387904_m2_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -4611686018427387902
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 192, 0, 0, 0, 0, 0, 0, 2})
    delete(p.buf)
}


@(test)
test_sint_pow2_4611686018427387904_m2_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 192, 0, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -4611686018427387902
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_4611686018427387904_m2_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 192, 0, 0, 0, 0, 0, 0, 2}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-4611686018427387902))
}

@(test)
test_int_pow2_4611686018427387904_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 4611686018427387903
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 63, 255, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_int_pow2_4611686018427387904_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 63, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 4611686018427387903
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_4611686018427387904_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 63, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(4611686018427387903))
}

@(test)
test_sint_pow2_4611686018427387904_m1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -4611686018427387903
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 192, 0, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_sint_pow2_4611686018427387904_m1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 192, 0, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -4611686018427387903
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_4611686018427387904_m1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 192, 0, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-4611686018427387903))
}

@(test)
test_int_pow2_4611686018427387904_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 4611686018427387904
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 64, 0, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_int_pow2_4611686018427387904_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 64, 0, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 4611686018427387904
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_4611686018427387904_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 64, 0, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(4611686018427387904))
}

@(test)
test_sint_pow2_4611686018427387904_0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -4611686018427387904
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 192, 0, 0, 0, 0, 0, 0, 0})
    delete(p.buf)
}


@(test)
test_sint_pow2_4611686018427387904_0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 192, 0, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -4611686018427387904
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_4611686018427387904_0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 192, 0, 0, 0, 0, 0, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-4611686018427387904))
}

@(test)
test_int_pow2_4611686018427387904_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 4611686018427387905
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{207, 64, 0, 0, 0, 0, 0, 0, 1})
    delete(p.buf)
}


@(test)
test_int_pow2_4611686018427387904_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 64, 0, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: u64 = 4611686018427387905
    testing.expect_value(t, res.(u64), expected)

}


@(test)
test_int_pow2_4611686018427387904_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{207, 64, 0, 0, 0, 0, 0, 0, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: u64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (u64)(4611686018427387905))
}

@(test)
test_sint_pow2_4611686018427387904_1_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -4611686018427387905
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{211, 191, 255, 255, 255, 255, 255, 255, 255})
    delete(p.buf)
}


@(test)
test_sint_pow2_4611686018427387904_1_de :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 191, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: i64 = -4611686018427387905
    testing.expect_value(t, res.(i64), expected)

}


@(test)
test_sint_pow2_4611686018427387904_1_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{211, 191, 255, 255, 255, 255, 255, 255, 255}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: i64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (i64)(-4611686018427387905))
}

@(test)
test_float_exp0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1.0
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{202, 63, 128, 0, 0})
    delete(p.buf)
}


@(test)
test_float_exp0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 63, 128, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f32 = 1.0
    testing.expect_value(t, res.(f32), expected)

}


@(test)
test_float_exp0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 63, 128, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f32
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f32)(1.0))
}

@(test)
test_float_nexp0_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1.0
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{202, 191, 128, 0, 0})
    delete(p.buf)
}


@(test)
test_float_nexp0_de :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 191, 128, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f32 = -1.0
    testing.expect_value(t, res.(f32), expected)

}


@(test)
test_float_nexp0_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 191, 128, 0, 0}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f32
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f32)(-1.0))
}

@(test)
test_float_exp10_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 22026.465794806703
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{202, 70, 172, 20, 238})
    delete(p.buf)
}


@(test)
test_float_exp10_de :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 70, 172, 20, 238}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f32 = 22026.465794806703
    testing.expect_value(t, res.(f32), expected)

}


@(test)
test_float_exp10_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 70, 172, 20, 238}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f32
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f32)(22026.465794806703))
}

@(test)
test_float_nexp10_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -22026.465794806703
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{202, 198, 172, 20, 238})
    delete(p.buf)
}


@(test)
test_float_nexp10_de :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 198, 172, 20, 238}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f32 = -22026.465794806703
    testing.expect_value(t, res.(f32), expected)

}


@(test)
test_float_nexp10_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 198, 172, 20, 238}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f32
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f32)(-22026.465794806703))
}

@(test)
test_float_exp20_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 485165195.40978974
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{202, 77, 231, 88, 68})
    delete(p.buf)
}


@(test)
test_float_exp20_de :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 77, 231, 88, 68}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f32 = 485165195.40978974
    testing.expect_value(t, res.(f32), expected)

}


@(test)
test_float_exp20_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 77, 231, 88, 68}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f32
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f32)(485165195.40978974))
}

@(test)
test_float_nexp20_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -485165195.40978974
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{202, 205, 231, 88, 68})
    delete(p.buf)
}


@(test)
test_float_nexp20_de :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 205, 231, 88, 68}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f32 = -485165195.40978974
    testing.expect_value(t, res.(f32), expected)

}


@(test)
test_float_nexp20_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 205, 231, 88, 68}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f32
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f32)(-485165195.40978974))
}

@(test)
test_float_exp30_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 10686474581524.445
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{202, 85, 27, 130, 56})
    delete(p.buf)
}


@(test)
test_float_exp30_de :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 85, 27, 130, 56}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f32 = 10686474581524.445
    testing.expect_value(t, res.(f32), expected)

}


@(test)
test_float_exp30_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 85, 27, 130, 56}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f32
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f32)(10686474581524.445))
}

@(test)
test_float_nexp30_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -10686474581524.445
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{202, 213, 27, 130, 56})
    delete(p.buf)
}


@(test)
test_float_nexp30_de :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 213, 27, 130, 56}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f32 = -10686474581524.445
    testing.expect_value(t, res.(f32), expected)

}


@(test)
test_float_nexp30_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 213, 27, 130, 56}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f32
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f32)(-10686474581524.445))
}

@(test)
test_float_exp40_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 2.353852668370195e+17
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{202, 92, 81, 16, 106})
    delete(p.buf)
}


@(test)
test_float_exp40_de :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 92, 81, 16, 106}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f32 = 2.353852668370195e+17
    testing.expect_value(t, res.(f32), expected)

}


@(test)
test_float_exp40_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 92, 81, 16, 106}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f32
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f32)(2.353852668370195e+17))
}

@(test)
test_float_nexp40_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -2.353852668370195e+17
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{202, 220, 81, 16, 106})
    delete(p.buf)
}


@(test)
test_float_nexp40_de :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 220, 81, 16, 106}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f32 = -2.353852668370195e+17
    testing.expect_value(t, res.(f32), expected)

}


@(test)
test_float_nexp40_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 220, 81, 16, 106}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f32
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f32)(-2.353852668370195e+17))
}

@(test)
test_float_exp50_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 5.184705528587058e+21
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{202, 99, 140, 136, 31})
    delete(p.buf)
}


@(test)
test_float_exp50_de :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 99, 140, 136, 31}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f32 = 5.184705528587058e+21
    testing.expect_value(t, res.(f32), expected)

}


@(test)
test_float_exp50_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 99, 140, 136, 31}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f32
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f32)(5.184705528587058e+21))
}

@(test)
test_float_nexp50_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -5.184705528587058e+21
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{202, 227, 140, 136, 31})
    delete(p.buf)
}


@(test)
test_float_nexp50_de :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 227, 140, 136, 31}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f32 = -5.184705528587058e+21
    testing.expect_value(t, res.(f32), expected)

}


@(test)
test_float_nexp50_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 227, 140, 136, 31}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f32
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f32)(-5.184705528587058e+21))
}

@(test)
test_float_exp60_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1.1420073898156806e+26
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{202, 106, 188, 237, 229})
    delete(p.buf)
}


@(test)
test_float_exp60_de :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 106, 188, 237, 229}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f32 = 1.1420073898156806e+26
    testing.expect_value(t, res.(f32), expected)

}


@(test)
test_float_exp60_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 106, 188, 237, 229}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f32
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f32)(1.1420073898156806e+26))
}

@(test)
test_float_nexp60_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1.1420073898156806e+26
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{202, 234, 188, 237, 229})
    delete(p.buf)
}


@(test)
test_float_nexp60_de :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 234, 188, 237, 229}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f32 = -1.1420073898156806e+26
    testing.expect_value(t, res.(f32), expected)

}


@(test)
test_float_nexp60_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 234, 188, 237, 229}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f32
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f32)(-1.1420073898156806e+26))
}

@(test)
test_float_exp70_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 2.5154386709191576e+30
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{202, 113, 253, 254, 145})
    delete(p.buf)
}


@(test)
test_float_exp70_de :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 113, 253, 254, 145}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f32 = 2.5154386709191576e+30
    testing.expect_value(t, res.(f32), expected)

}


@(test)
test_float_exp70_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 113, 253, 254, 145}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f32
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f32)(2.5154386709191576e+30))
}

@(test)
test_float_nexp70_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -2.5154386709191576e+30
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{202, 241, 253, 254, 145})
    delete(p.buf)
}


@(test)
test_float_nexp70_de :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 241, 253, 254, 145}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f32 = -2.5154386709191576e+30
    testing.expect_value(t, res.(f32), expected)

}


@(test)
test_float_nexp70_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 241, 253, 254, 145}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f32
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f32)(-2.5154386709191576e+30))
}

@(test)
test_float_exp80_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 5.540622384393487e+34
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{202, 121, 42, 187, 206})
    delete(p.buf)
}


@(test)
test_float_exp80_de :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 121, 42, 187, 206}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f32 = 5.540622384393487e+34
    testing.expect_value(t, res.(f32), expected)

}


@(test)
test_float_exp80_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 121, 42, 187, 206}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f32
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f32)(5.540622384393487e+34))
}

@(test)
test_float_nexp80_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -5.540622384393487e+34
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{202, 249, 42, 187, 206})
    delete(p.buf)
}


@(test)
test_float_nexp80_de :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 249, 42, 187, 206}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f32 = -5.540622384393487e+34
    testing.expect_value(t, res.(f32), expected)

}


@(test)
test_float_nexp80_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{202, 249, 42, 187, 206}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f32
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f32)(-5.540622384393487e+34))
}

@(test)
test_float_exp90_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1.220403294317835e+39
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{203, 72, 12, 177, 8, 255, 190, 193, 61})
    delete(p.buf)
}


@(test)
test_float_exp90_de :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 72, 12, 177, 8, 255, 190, 193, 61}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f64 = 1.220403294317835e+39
    testing.expect_value(t, res.(f64), expected)

}


@(test)
test_float_exp90_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 72, 12, 177, 8, 255, 190, 193, 61}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f64)(1.220403294317835e+39))
}

@(test)
test_float_nexp90_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1.220403294317835e+39
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{203, 200, 12, 177, 8, 255, 190, 193, 61})
    delete(p.buf)
}


@(test)
test_float_nexp90_de :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 200, 12, 177, 8, 255, 190, 193, 61}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f64 = -1.220403294317835e+39
    testing.expect_value(t, res.(f64), expected)

}


@(test)
test_float_nexp90_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 200, 12, 177, 8, 255, 190, 193, 61}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f64)(-1.220403294317835e+39))
}

@(test)
test_float_exp100_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 2.6881171418161212e+43
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{203, 72, 243, 73, 74, 155, 23, 27, 216})
    delete(p.buf)
}


@(test)
test_float_exp100_de :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 72, 243, 73, 74, 155, 23, 27, 216}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f64 = 2.6881171418161212e+43
    testing.expect_value(t, res.(f64), expected)

}


@(test)
test_float_exp100_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 72, 243, 73, 74, 155, 23, 27, 216}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f64)(2.6881171418161212e+43))
}

@(test)
test_float_nexp100_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -2.6881171418161212e+43
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{203, 200, 243, 73, 74, 155, 23, 27, 216})
    delete(p.buf)
}


@(test)
test_float_nexp100_de :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 200, 243, 73, 74, 155, 23, 27, 216}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f64 = -2.6881171418161212e+43
    testing.expect_value(t, res.(f64), expected)

}


@(test)
test_float_nexp100_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 200, 243, 73, 74, 155, 23, 27, 216}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f64)(-2.6881171418161212e+43))
}

@(test)
test_float_exp110_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 5.920972027664636e+47
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{203, 73, 217, 237, 163, 163, 30, 88, 84})
    delete(p.buf)
}


@(test)
test_float_exp110_de :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 73, 217, 237, 163, 163, 30, 88, 84}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f64 = 5.920972027664636e+47
    testing.expect_value(t, res.(f64), expected)

}


@(test)
test_float_exp110_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 73, 217, 237, 163, 163, 30, 88, 84}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f64)(5.920972027664636e+47))
}

@(test)
test_float_nexp110_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -5.920972027664636e+47
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{203, 201, 217, 237, 163, 163, 30, 88, 84})
    delete(p.buf)
}


@(test)
test_float_nexp110_de :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 201, 217, 237, 163, 163, 30, 88, 84}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f64 = -5.920972027664636e+47
    testing.expect_value(t, res.(f64), expected)

}


@(test)
test_float_nexp110_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 201, 217, 237, 163, 163, 30, 88, 84}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f64)(-5.920972027664636e+47))
}

@(test)
test_float_exp120_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1.304180878393624e+52
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{203, 74, 193, 109, 200, 169, 239, 102, 236})
    delete(p.buf)
}


@(test)
test_float_exp120_de :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 74, 193, 109, 200, 169, 239, 102, 236}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f64 = 1.304180878393624e+52
    testing.expect_value(t, res.(f64), expected)

}


@(test)
test_float_exp120_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 74, 193, 109, 200, 169, 239, 102, 236}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f64)(1.304180878393624e+52))
}

@(test)
test_float_nexp120_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1.304180878393624e+52
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{203, 202, 193, 109, 200, 169, 239, 102, 236})
    delete(p.buf)
}


@(test)
test_float_nexp120_de :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 202, 193, 109, 200, 169, 239, 102, 236}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f64 = -1.304180878393624e+52
    testing.expect_value(t, res.(f64), expected)

}


@(test)
test_float_nexp120_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 202, 193, 109, 200, 169, 239, 102, 236}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f64)(-1.304180878393624e+52))
}

@(test)
test_float_exp130_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 2.872649550817812e+56
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{203, 75, 167, 110, 95, 68, 206, 156, 1})
    delete(p.buf)
}


@(test)
test_float_exp130_de :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 75, 167, 110, 95, 68, 206, 156, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f64 = 2.872649550817812e+56
    testing.expect_value(t, res.(f64), expected)

}


@(test)
test_float_exp130_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 75, 167, 110, 95, 68, 206, 156, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f64)(2.872649550817812e+56))
}

@(test)
test_float_nexp130_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -2.872649550817812e+56
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{203, 203, 167, 110, 95, 68, 206, 156, 1})
    delete(p.buf)
}


@(test)
test_float_nexp130_de :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 203, 167, 110, 95, 68, 206, 156, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f64 = -2.872649550817812e+56
    testing.expect_value(t, res.(f64), expected)

}


@(test)
test_float_nexp130_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 203, 167, 110, 95, 68, 206, 156, 1}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f64)(-2.872649550817812e+56))
}

@(test)
test_float_exp140_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 6.327431707155538e+60
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{203, 76, 143, 128, 36, 235, 99, 58, 219})
    delete(p.buf)
}


@(test)
test_float_exp140_de :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 76, 143, 128, 36, 235, 99, 58, 219}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f64 = 6.327431707155538e+60
    testing.expect_value(t, res.(f64), expected)

}


@(test)
test_float_exp140_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 76, 143, 128, 36, 235, 99, 58, 219}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f64)(6.327431707155538e+60))
}

@(test)
test_float_nexp140_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -6.327431707155538e+60
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{203, 204, 143, 128, 36, 235, 99, 58, 219})
    delete(p.buf)
}


@(test)
test_float_nexp140_de :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 204, 143, 128, 36, 235, 99, 58, 219}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f64 = -6.327431707155538e+60
    testing.expect_value(t, res.(f64), expected)

}


@(test)
test_float_nexp140_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 204, 143, 128, 36, 235, 99, 58, 219}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f64)(-6.327431707155538e+60))
}

@(test)
test_float_exp150_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1.3937095806663685e+65
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{203, 77, 117, 44, 172, 41, 130, 37, 99})
    delete(p.buf)
}


@(test)
test_float_exp150_de :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 77, 117, 44, 172, 41, 130, 37, 99}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f64 = 1.3937095806663685e+65
    testing.expect_value(t, res.(f64), expected)

}


@(test)
test_float_exp150_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 77, 117, 44, 172, 41, 130, 37, 99}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f64)(1.3937095806663685e+65))
}

@(test)
test_float_nexp150_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1.3937095806663685e+65
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{203, 205, 117, 44, 172, 41, 130, 37, 99})
    delete(p.buf)
}


@(test)
test_float_nexp150_de :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 205, 117, 44, 172, 41, 130, 37, 99}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f64 = -1.3937095806663685e+65
    testing.expect_value(t, res.(f64), expected)

}


@(test)
test_float_nexp150_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 205, 117, 44, 172, 41, 130, 37, 99}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f64)(-1.3937095806663685e+65))
}

@(test)
test_float_exp160_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 3.0698496406442164e+69
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{203, 78, 92, 119, 125, 198, 92, 148, 68})
    delete(p.buf)
}


@(test)
test_float_exp160_de :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 78, 92, 119, 125, 198, 92, 148, 68}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f64 = 3.0698496406442164e+69
    testing.expect_value(t, res.(f64), expected)

}


@(test)
test_float_exp160_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 78, 92, 119, 125, 198, 92, 148, 68}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f64)(3.0698496406442164e+69))
}

@(test)
test_float_nexp160_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -3.0698496406442164e+69
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{203, 206, 92, 119, 125, 198, 92, 148, 68})
    delete(p.buf)
}


@(test)
test_float_nexp160_de :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 206, 92, 119, 125, 198, 92, 148, 68}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f64 = -3.0698496406442164e+69
    testing.expect_value(t, res.(f64), expected)

}


@(test)
test_float_nexp160_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 206, 92, 119, 125, 198, 92, 148, 68}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f64)(-3.0698496406442164e+69))
}

@(test)
test_float_exp170_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 6.761793810484949e+73
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{203, 79, 67, 34, 156, 92, 13, 53, 95})
    delete(p.buf)
}


@(test)
test_float_exp170_de :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 79, 67, 34, 156, 92, 13, 53, 95}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f64 = 6.761793810484949e+73
    testing.expect_value(t, res.(f64), expected)

}


@(test)
test_float_exp170_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 79, 67, 34, 156, 92, 13, 53, 95}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f64)(6.761793810484949e+73))
}

@(test)
test_float_nexp170_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -6.761793810484949e+73
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{203, 207, 67, 34, 156, 92, 13, 53, 95})
    delete(p.buf)
}


@(test)
test_float_nexp170_de :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 207, 67, 34, 156, 92, 13, 53, 95}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f64 = -6.761793810484949e+73
    testing.expect_value(t, res.(f64), expected)

}


@(test)
test_float_nexp170_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 207, 67, 34, 156, 92, 13, 53, 95}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f64)(-6.761793810484949e+73))
}

@(test)
test_float_exp180_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 1.4893842007818241e+78
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{203, 80, 41, 185, 163, 43, 29, 136, 64})
    delete(p.buf)
}


@(test)
test_float_exp180_de :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 80, 41, 185, 163, 43, 29, 136, 64}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f64 = 1.4893842007818241e+78
    testing.expect_value(t, res.(f64), expected)

}


@(test)
test_float_exp180_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 80, 41, 185, 163, 43, 29, 136, 64}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f64)(1.4893842007818241e+78))
}

@(test)
test_float_nexp180_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -1.4893842007818241e+78
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{203, 208, 41, 185, 163, 43, 29, 136, 64})
    delete(p.buf)
}


@(test)
test_float_nexp180_de :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 208, 41, 185, 163, 43, 29, 136, 64}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f64 = -1.4893842007818241e+78
    testing.expect_value(t, res.(f64), expected)

}


@(test)
test_float_nexp180_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 208, 41, 185, 163, 43, 29, 136, 64}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f64)(-1.4893842007818241e+78))
}

@(test)
test_float_exp190_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := 3.280587015384637e+82
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{203, 81, 17, 74, 212, 24, 211, 185, 26})
    delete(p.buf)
}


@(test)
test_float_exp190_de :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 81, 17, 74, 212, 24, 211, 185, 26}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f64 = 3.280587015384637e+82
    testing.expect_value(t, res.(f64), expected)

}


@(test)
test_float_exp190_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 81, 17, 74, 212, 24, 211, 185, 26}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f64)(3.280587015384637e+82))
}

@(test)
test_float_nexp190_ser :: proc(t: ^testing.T) {
    store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

    value := -3.280587015384637e+82
    m.write(&p, value)

    slice_eq(t, p.buf[:], []u8{203, 209, 17, 74, 212, 24, 211, 185, 26})
    delete(p.buf)
}


@(test)
test_float_nexp190_de :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 209, 17, 74, 212, 24, 211, 185, 26}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    res, err := m.read(&u)

    testing.expect_value(t, err, nil)
    expected: f64 = -3.280587015384637e+82
    testing.expect_value(t, res.(f64), expected)

}


@(test)
test_float_nexp190_de_into :: proc(t: ^testing.T) {
    bytes := [?]u8{203, 209, 17, 74, 212, 24, 211, 185, 26}
    u: m.Unpacker = { raw_data(bytes[:]), 0 }
    out: f64
    err := m.read_into(&u, &out)


    testing.expect_value(t, err, nil)
    testing.expect_value(t, out, (f64)(-3.280587015384637e+82))
}

