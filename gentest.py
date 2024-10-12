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


def write_test(f, name, value, pack_code, usf=None, flags=""):
    if usf is None:
        usf = (
            isinstance(value, float)
            and abs(value) < 3.402823466e38
            or isinstance(value, list)
            and len(value) > 0
            and isinstance(value[0], float)
            and all(abs(v) < 3.402823466e38 for v in value)
        )

    expectation = str(
        list(msgpack.packb(value, use_single_float=usf, strict_types=True))
    )

    f.write(
        dedent(
            f"""\
        @(test)
        test_{name}_output :: proc(t: ^testing.T) {{
            store := make([dynamic]u8, 0, 10)
            p: m.Packer = {{ store, {{ {flags} }} }}
            {pack_code}

            slice_eq(t, p.buf[:], []u8{{{expectation[1:-1]}}})
            delete(p.buf)
        }}\n
        """
        )
    )


def write_unpack_test(f, name, value, result, usf=None, flags="", delete=False):
    if usf is None:
        usf = (
            isinstance(value, float)
            and abs(value) < 3.402823466e38
            or isinstance(value, list)
            and len(value) > 0
            and isinstance(value[0], float)
            and all(abs(v) < 3.402823466e38 for v in value)
        )

    input = str(list(msgpack.packb(value, use_single_float=usf, strict_types=True)))

    delete = "delete(res)" if delete else ""
    f.write(
        dedent(
            f"""\
        @(test)
        test_{name}_output :: proc(t: ^testing.T) {{
            store := [?]u8{{{input[1:-1]}}}
            u: m.Unpacker = {{ raw_data(store[:]), 0 }}
            res := m.read(&u)

            testing.expect_value(t, res.(string), {result})
            {delete}
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
    slice_eq :: proc(t: ^testing.T, a: []u8, b: []u8) {
        testing.expectf(t, len(a) == len(b), "mismatch: %v != %v", a, b)
        for i in 0..<len(a) {
            testing.expectf(t, a[i] == b[i], "%v == %v fails at index %v (%v %v)", a, b, i, a[i], b[i])
        }
    }
    """
        )
    )

    write_test(f, "nil", None, "m.write(&p)")
    write_test(f, "true", True, "m.write(&p, true)")
    write_test(f, "false", False, "m.write(&p, false)")
    for i in range(126, 128):
        write_test(f, f"varint_{i}", i, f"m.write(&p, {i})")

    for bitsize in [8, 16, 32, 64]:
        for offset in [-2, -1, 0, 1, 2]:
            v = (1 << bitsize) + offset
            if v > (1 << 64 - 1):
                continue
            write_test(
                f,
                f"int_{bitsize}_{'M' if offset < 0 else 'P'}{abs(offset)}",
                v,
                f"m.write(&p, {v})",
            )

    for bitsize in [8, 16, 32, 64]:
        for offset in [-2, -1, 0, 1, 2]:
            v = -((1 << (bitsize - 1)) + offset)
            if abs(v) > (1 << 63 - 1):
                continue
            write_test(
                f,
                f"int_{bitsize}_{'M' if v < 0 else 'P'}{abs(v)}",
                v,
                f"m.write(&p, {v})",
            )

    for i in range(63):
        v = 1 << i
        for x in range(-2, 2):
            write_test(
                f,
                f"int_{i}_{v-x}_offset",
                v - x,
                f"m.write(&p, {v-x})",
            )
            write_test(
                f,
                f"int_{i}_n{v-x}_offset",
                -(v - x),
                f"m.write(&p, {-(v - x)})",
            )

    for i in range(0, 200, 10):
        v = math.e**i
        write_test(
            f,
            f"float_exp{i}",
            v,
            f"m.write(&p, {v})",
        )
        write_test(
            f,
            f"float_nexp{i}",
            -v,
            f"m.write(&p, {-v})",
        )

with open(TESTS_PATH / "string.odin", "w") as f:
    header(f)
    write_test(
        f,
        "str_less_than_32",
        "hello world",
        'm.write(&p, "hello world")',
    )
    write_unpack_test(
        f,
        "unpack_str_less_than_32",
        "hello world",
        '"hello world"',
    )

    write_test(
        f,
        "str_less_than_256",
        "hello world" * 10,
        f'm.write(&p, "{"hello world" * 10}")',
    )

    write_test(
        f,
        "str_above_256",
        "hello world" * 25,
        f'm.write(&p, "{"hello world" * 25}")',
    )

with open(TESTS_PATH / "bytes.odin", "w") as f:
    header(f)
    write_test(
        f,
        "bytes_less_than_32",
        bytes(b"hello world"),
        f'm.write(&p, {format_bytes("hello world")})',
    )

    write_test(
        f,
        "bytes_less_than_256",
        bytes(b"hello world" * 10),
        f'm.write(&p, {format_bytes("hello world" * 10)})',
    )

    write_test(
        f,
        "bytes_above_256",
        bytes(b"hello world" * 25),
        f'm.write(&p, {format_bytes("hello world" * 25)})',
    )

with open(TESTS_PATH / "array.odin", "w") as f:
    header(f)
    for count in (0, 5, 20):
        s = '"x"'
        write_test(
            f,
            f"str_array_{count}",
            ["x"] * count,
            f'arg := [{count}]string{{{", ".join([s] * count)}}}; m.write(&p, arg[:])',
        )

        write_test(
            f,
            f"u16_array_{count}",
            [1 << 14] * count,
            f"arg := [{count}]u16{{ {', '.join(str(1<<14) for x in range(count))} }}; m.write(&p, arg[:])",
        )

        write_test(
            f,
            f"float_array_{count}",
            [1.5] * count,
            f"arg := [{count}]f32{{ {', '.join(str(1.5) for x in range(count))} }}; m.write(&p, arg[:])",
        )


with open(TESTS_PATH / "map.odin", "w") as f:
    header(f)
    m = {0: 10}

    write_test(
        f,
        "map_int_to_int",
        m,
        "arg := map[u8]u8{0  = 10}; m.write(&p, arg); delete(arg)",
    )

    m = {"foo": "bar"}
    write_test(
        f,
        "map_str_to_str",
        m,
        'arg := map[string]string{"foo" = "bar"}; m.write(&p, arg); delete(arg)',
    )

    m = {"foo": bytes([1, 2, 3])}
    write_test(
        f,
        "map_str_to_bytes",
        m,
        'arg := map[string][3]m.bin{"foo" = [3]m.bin{1,2,3}}; m.write(&p, arg); delete(arg)',
    )

    m = {"foo": [1, 2, 3]}
    write_test(
        f,
        "map_str_to_array",
        m,
        'arg := map[string][3]u16{"foo" = [3]u16{1,2,3}}; m.write(&p, arg); delete(arg)',
    )

    def fmt(m):
        out = "map[string]f32{"
        for k, v in reversed(m.items()):
            out += f'"{k}" = {v}, '

        return out + "}"

    m = {"a": 1.1, "b": 2.2}
    write_test(
        f,
        "map_multiple_to_float2",
        m,
        f"arg := {fmt(m)}; m.write(&p, arg); delete(arg)",
        usf=True,
        flags=".StableMaps",
    )

    m = {"a": 1.1, "b": 2.3, "c": 3.4, "d": 4.5, "e": 5.1}
    write_test(
        f,
        "map_multiple_to_float5",
        m,
        f"arg := {fmt(m)}; m.write(&p, arg); delete(arg)",
        usf=True,
        flags=".StableMaps",
    )
    m = {"a": 1.1, "b": 2.3, "c": 3.4, "d": 4.5, "e": 5.1, "f": 1.3}
    write_test(
        f,
        "map_multiple_to_float6",
        m,
        f"arg := {fmt(m)}; m.write(&p, arg); delete(arg)",
        usf=True,
        flags=".StableMaps",
    )

with open(TESTS_PATH / "timestamp.odin", "w") as f:
    from msgpack.ext import Timestamp

    header(f)
    f.write('import "core:time"\n')
    write_test(
        f,
        "timestamp",
        Timestamp(171798691, 69),
        f"arg := time.Time {{ 1e9 * 171798691 + 69}}; m.write(&p, arg)",
    )
    write_test(
        f,
        "timestamp_no_ns",
        Timestamp(171798691, 0),
        f"arg := time.Time {{ 1e9 * 171798691 + 0}}; m.write(&p, arg)",
    )
