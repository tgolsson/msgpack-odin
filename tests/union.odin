package tests
import m "../"
import "core:strings"
import "core:testing"

@(test)
test_write_enum :: proc(t: ^testing.T) {
	Hello :: struct {}
	Goodbye :: struct {}

	Example :: union {
		Hello,
		Goodbye,
	}

	p, buf := make_packer({.UnionNames})
	defer strings.builder_destroy(buf)
	defer free(buf)

	m.write(&p, Example(Hello{}))

	example: Example
	err := m.unpack_into_from_bytes(buf.buf[:], &example)

	testing.expect_value(t, err, nil)
	testing.expect_value(t, example.(Hello), Hello{})
}


@(test)
test_write_enum_variant :: proc(t: ^testing.T) {
	Hello :: struct {}
	Goodbye :: struct {
		data: i32,
	}

	Example :: union {
		Hello,
		Goodbye,
	}

	p, buf := make_packer({.UnionNames})
	defer strings.builder_destroy(buf)
	defer free(buf)

	m.write(&p, Example(Goodbye{120}))

	example: Example
	err := m.unpack_into_from_bytes(buf.buf[:], &example)

	testing.expect_value(t, err, nil)
	testing.expect_value(t, example.(Goodbye), Goodbye{120})
}


@(test)
test_write_enum_variant_numeric :: proc(t: ^testing.T) {
	Hello :: struct {}
	Goodbye :: struct {
		data: i32,
	}

	Example :: union {
		Hello,
		Goodbye,
	}

	p, buf := make_packer()
	defer strings.builder_destroy(buf)
	defer free(buf)

	m.write(&p, Example(Goodbye{120}))

	example: Example
	err := m.unpack_into_from_bytes(buf.buf[:], &example)

	testing.expect_value(t, err, nil)
	testing.expect_value(t, example.(Goodbye), Goodbye{120})
}


@(test)
test_write_enum_one_variant_numeric :: proc(t: ^testing.T) {
	Hello :: struct {}

	Example :: union {
		Hello,
	}

	p, buf := make_packer()
	defer strings.builder_destroy(buf)
	defer free(buf)

	m.write(&p, Example(Hello{}))

	example: Example
	err := m.unpack_into_from_bytes(buf.buf[:], &example)

	testing.expect_value(t, err, nil)
	testing.expect_value(t, example.(Hello), Hello{})
}


@(test)
test_write_enum_one_variant_s :: proc(t: ^testing.T) {
	Hello :: struct {}

	Example :: union {
		Hello,
	}

	p, buf := make_packer({.UnionNames})
	defer strings.builder_destroy(buf)
	defer free(buf)

	m.write(&p, Example(Hello{}))

	example: Example
	err := m.unpack_into_from_bytes(buf.buf[:], &example)

	testing.expect_value(t, err, nil)
	testing.expect_value(t, example.(Hello), Hello{})
}


@(test)
test_write_enum_nil :: proc(t: ^testing.T) {
	Hello :: struct {}

	Example :: union {
		Hello,
	}

	p, buf := make_packer({.UnionNames})
	defer strings.builder_destroy(buf)
	defer free(buf)

	m.write(&p, Example(nil))
	m.write(&p, u8(10))

	example: Example
	u, r := make_unpacker_from_bytes(buf.buf[:])
	defer free(r)
	err := m.read_into(&u, &example)

	num: u8
	err = m.read_into(&u, &num)

	testing.expect_value(t, err, nil)
	testing.expect_value(t, num, 10)
}
