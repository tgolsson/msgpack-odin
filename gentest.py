import math
from pathlib import Path
from textwrap import dedent

import msgpack

PRIMITIVE_CASES = {
    "nil": None,
    "true": True,
    "false": False,
}

TESTS_PATH = Path("tests")


def format_bytes(s):
    return "[]m.bin{" + str(list(bytes(s.encode())))[1:-1].format("%x") + "}"


def write_test_generic(
    f,
    name,
    python_value,
    odin_value,
    output_cast,
    output_value,
    odin_type,
    flags="",
    usf=False,
    is_slice_comp=False,
    is_obj_comp=False,
    extras="",
    delete_expected=False,
):
    expectation = str(list(msgpack.packb(python_value, use_single_float=usf)))[1:-1]
    comp = f"testing.expect_value(t, res.({output_cast}), expected)"
    comp2 = f"testing.expect_value(t, out, ({odin_type})({odin_value}))"
    if is_slice_comp:
        comp = f"slice_eq(t, res.({output_cast}), expected)"
        if not "time.Time" in odin_type:
            comp2 = f"v := {odin_value}; slice_eq(t, v[:], out[:])"

    delete = ""
    if is_obj_comp:
        comp = 'testing.expectf(t, m.object_equals(&res, &expected), "mismatch: %v !=  %v", res, expected)'
        delete = "m.object_delete(res)"
        if not "time.Time" in odin_type:
            comp2 = f"v := {odin_value}; slice_eq(t, v[:], out[:])"

    if "map" in odin_type:
        comp2 = f"v := {odin_value}; map_eq(t, out, v)"

    if "][]" in odin_type:
        comp2 = f"v := {odin_value}; map_slice_eq(t, out, v)"

    if delete_expected:
        delete += "; delete(expected.(map[m.ObjectKey]m.Object))"

    f.write(
        dedent(
            f"""\
        @(test)
        test_{name}_ser :: proc(t: ^testing.T) {{
            {extras}
            value := {odin_value}
            data, err := m.pack_into_bytes(value, {{ {flags} }})
            defer delete(data)

            {"delete(value)" if 'map' in str(odin_value) else ""}
            slice_eq(t, data[:], []u8{{{expectation}}})

        }}\n

        @(test)
        test_{name}_de :: proc(t: ^testing.T) {{
            bytes := [?]u8{{{expectation}}}
            res, err := m.unpack_from_bytes(bytes[:])

            testing.expect_value(t, err, nil)
            {output_value}
            {comp}
            {delete}
        }}\n

        @(test)
        test_{name}_de_into :: proc(t: ^testing.T) {{
            bytes := [?]u8{{{expectation}}}
            out: {odin_type}
            err := m.unpack_into_from_bytes(bytes[:], &out)

            {extras}
            testing.expect_value(t, err, nil)
            {comp2}
        }}\n
        """
        )
    )


def header(f):
    f.write("package tests\n")
    f.write('import "core:testing"\n')
    f.write('import "core:fmt"\n')
    f.write('import m "../"\n\n')


with open(TESTS_PATH / "primitive.odin", "w") as f:
    header(f)

    f.write(
        dedent(
            """\
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
    """
        )
    )

    write_test_generic(
        f,
        "true",
        True,
        "true",
        "bool",
        "expected := true",
        "bool",
    )

    write_test_generic(
        f,
        "false",
        False,
        "false",
        "bool",
        "expected := false",
        "bool",
    )

    for i in range(126, 129):
        write_test_generic(
            f,
            f"fixint_{i}",
            i,
            i,
            "u64",
            f"expected: u64 = {i}",
            "u64",
        )

    for i in range(0b00011110, 0b00100010):
        write_test_generic(
            f,
            f"nfixint_{i}",
            -i,
            -i,
            "i64",
            f"expected: i64 = {-i}",
            "i64",
        )

    for bitsize in [8, 16, 32, 64]:
        for offset in [-2, -1, 0, 1, 2]:
            v = (1 << bitsize) + offset
            if v > ((1 << 64) - 1):
                continue
            write_test_generic(
                f,
                f"int_{v}_{bitsize}_{abs(offset)}",
                v,
                f"u64({v})",
                "u64",
                f"expected: u64 = {v}",
                "u64",
            )

    for bitsize in [7, 15, 31, 63]:
        for offset in [-2, -1, 0, 1, 2]:
            v = -((1 << (bitsize - 1)) + offset)
            if abs(v) > ((1 << 63) - 1):
                continue
            write_test_generic(
                f,
                f"sint_{abs(v)}_{bitsize}_{abs(offset)}",
                v,
                f"i64({v})",
                "i64",
                f"expected: i64 = {v}",
                "i64",
            )

    for i in range(63):
        v = 1 << i
        for x in range(-2, 2):
            if (v + x) >= 0:
                write_test_generic(
                    f,
                    f"int_pow2_{abs(v)}_{'m' if x < 0 else ''}{abs(x)}",
                    v + x,
                    str(v + x),
                    "u64",
                    f"expected: u64 = {v + x}",
                    "u64",
                )

            if -(v + x) < 0:
                write_test_generic(
                    f,
                    f"sint_pow2_{abs(v)}_{'m' if x < 0 else ''}{abs(x)}",
                    -(v + x),
                    str(-(v + x)),
                    "i64",
                    f"expected: i64 = {-(v + x)}",
                    "i64",
                )

    for i in range(0, 200, 10):
        v = math.e**i
        t = "f32" if i < 90 else "f64"
        write_test_generic(
            f,
            f"float_exp{i}",
            v,
            v,
            t,
            f"expected: {t} = {v}",
            t,
            usf=i < 90,
        )
        write_test_generic(
            f,
            f"float_nexp{i}",
            -v,
            -v,
            t,
            f"expected: {t} = {-v}",
            t,
            usf=i < 90,
        )

with open(TESTS_PATH / "string.odin", "w") as f:
    header(f)

    write_test_generic(
        f,
        "str_less_than_32",
        "hello world",
        '"hello world"',
        "string",
        'expected := "hello world"',
        "string",
    )

    v = "hello world" * 10
    write_test_generic(
        f,
        "str_less_than_256",
        v,
        f'"{v}"',
        "string",
        f'expected := "{v}"',
        "string",
    )

    v = "hello world" * 25
    write_test_generic(
        f,
        "str_above_256",
        v,
        f'"{v}"',
        "string",
        f'expected := "{v}"',
        "string",
    )

with open(TESTS_PATH / "bytes.odin", "w") as f:
    header(f)

    write_test_generic(
        f,
        "bytes_less_than_32",
        bytes(b"hello world"),
        format_bytes("hello world"),
        "[]m.bin",
        f'expected := {format_bytes("hello world")}',
        "[]m.bin",
        is_slice_comp=True,
    )

    b = "hello world" * 10
    write_test_generic(
        f,
        "bytes_less_than_256",
        bytes(b.encode()),
        format_bytes(b),
        "[]m.bin",
        f"expected := {format_bytes(b)}",
        "[]m.bin",
        is_slice_comp=True,
    )

    b = "hello world" * 25
    write_test_generic(
        f,
        "bytes_above_256",
        bytes(b.encode()),
        format_bytes(b),
        "[]m.bin",
        f"expected := {format_bytes(b)}",
        "[]m.bin",
        is_slice_comp=True,
    )

with open(TESTS_PATH / "array.odin", "w") as f:
    header(f)
    for count in (0, 5, 20):
        s = '"x"'

        write_test_generic(
            f,
            f"str_array_{count}",
            ["x"] * count,
            f'[{count}]string{{{", ".join([s] * count)}}}',
            "[]m.Object",
            f'inner := [{count}]m.Object{{{", ".join([s] * count)}}}; expected: m.Object = inner[:]',
            f"[{count}]string",
            is_obj_comp=True,
        )

        write_test_generic(
            f,
            f"u16_array_{count}",
            [1 << 14] * count,
            f'[{count}]u16{{{", ".join("1<<14" for _ in range(count))}}}',
            "[]m.Object",
            f'inner := [{count}]m.Object{{{", ".join("m.Object(u64(1 << 14))" for _ in range( count))}}}; expected: m.Object = inner[:]',
            f"[{count}]u16",
            is_obj_comp=True,
        )

        write_test_generic(
            f,
            f"f32_array_{count}",
            [1.5] * count,
            f'[{count}]f32{{{", ".join("1.5" for _ in range(count))}}}',
            "[]m.Object",
            f'inner := [{count}]m.Object{{{", ".join("m.Object(f32(1.5))" for _ in range( count))}}}; expected: m.Object = inner[:]',
            f"[{count}]f32",
            usf=True,
            is_obj_comp=True,
        )


with open(TESTS_PATH / "map.odin", "w") as f:
    header(f)

    write_test_generic(
        f,
        "map_empty",
        {},
        "map[u8]u8{}",
        "map[m.ObjectKey]m.Object",
        "expected: m.Object = map[m.ObjectKey]m.Object { }",
        "map[u8]u8",
        is_obj_comp=True,
        delete_expected=True,
    )

    m = {0: 10}
    write_test_generic(
        f,
        "map_int_to_int",
        m,
        "map[u8]u8{0  = 10}",
        "map[m.ObjectKey]m.Object",
        "expected: m.Object = map[m.ObjectKey]m.Object { u64(0) = u64(10) }",
        "map[u8]u8",
        is_obj_comp=True,
        delete_expected=True,
    )

    m = {"foo": "bar"}
    write_test_generic(
        f,
        "map_str_str",
        m,
        'map[string]string{"foo" = "bar"}',
        "map[m.ObjectKey]m.Object",
        'expected: m.Object = map[m.ObjectKey]m.Object { "foo" = "bar" }',
        "map[string]string",
        is_obj_comp=True,
        delete_expected=True,
    )

    m = {"foo": bytes([1, 2, 3])}
    write_test_generic(
        f,
        "map_str_bytes",
        m,
        'map[string][]m.bin{"foo" = bd[:]}',
        "map[m.ObjectKey]m.Object",
        'bd := [?]m.bin{1, 2, 3}; expected: m.Object = map[m.ObjectKey]m.Object { "foo" = bd[:] }',
        "map[string][]m.bin",
        is_obj_comp=True,
        extras="bd := [?]m.bin{1, 2, 3}",
        delete_expected=True,
    )

    m = {"foo": [1, 2, 3]}
    write_test_generic(
        f,
        "map_str_array",
        m,
        'map[string][]u16{"foo" = bd[:]}',
        "map[m.ObjectKey]m.Object",
        'bd := [?]m.Object{u64(1), u64(2), u64(3)}; expected: m.Object = map[m.ObjectKey]m.Object { "foo" = bd[:] }',
        "map[string][]u16",
        is_obj_comp=True,
        extras="bd := [?]u16{1, 2, 3}",
        delete_expected=True,
    )

    def fmt(m):
        out = "map[string]f32{"
        for k, v in reversed(m.items()):
            out += f'"{k}" = {v}, '

        return out + "}"

    def fmt2(m):
        out = "map[m.ObjectKey]m.Object {"
        for k, v in m.items():
            out += f'"{k}" = f32({v}), '

        return out + "}"

    m = {"a": 1.1, "b": 2.2}
    write_test_generic(
        f,
        "map_str_float2",
        m,
        fmt(m),
        "map[m.ObjectKey]m.Object",
        f"expected: m.Object = {fmt2(m)}",
        "map[string]f32",
        is_obj_comp=True,
        flags=".StableMaps",
        usf=True,
        delete_expected=True,
    )

    m = {"a": 1.1, "b": 2.3, "c": 3.4, "d": 4.5, "e": 5.1}
    write_test_generic(
        f,
        "map_str_float5",
        m,
        fmt(m),
        "map[m.ObjectKey]m.Object",
        f"expected: m.Object = {fmt2(m)}",
        "map[string]f32",
        is_obj_comp=True,
        flags=".StableMaps",
        usf=True,
        delete_expected=True,
    )

    m = {"a": 1.1, "b": 2.3, "c": 3.4, "d": 4.5, "e": 5.1, "f": 1.3}
    write_test_generic(
        f,
        "map_str_float6",
        m,
        fmt(m),
        "map[m.ObjectKey]m.Object",
        f"expected: m.Object = {fmt2(m)}",
        "map[string]f32",
        is_obj_comp=True,
        flags=".StableMaps",
        usf=True,
        delete_expected=True,
    )

with open(TESTS_PATH / "timestamp.odin", "w") as f:
    from msgpack.ext import Timestamp

    header(f)
    f.write('import "core:time"\n')

    write_test_generic(
        f,
        "timestamp",
        Timestamp(171798691, 69),
        "time.unix(171798691, 69)",
        "map[m.ObjectKey]m.Object",
        "expected: m.Object = time.unix(171798691, 69)",
        "time.Time",
        is_obj_comp=True,
    )

    write_test_generic(
        f,
        "timestamp_no_ns",
        Timestamp(171798691, 0),
        "time.unix(171798691, 0)",
        "map[m.ObjectKey]m.Object",
        "expected: m.Object = time.unix(171798691, 0)",
        "time.Time",
        is_obj_comp=True,
    )
