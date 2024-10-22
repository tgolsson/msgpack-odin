package tests
import m "../"
import "core:strings"
import "core:testing"

@(test)
test_write_union :: proc(t: ^testing.T) {
	Hello :: struct {}
	Goodbye :: struct {}

	Example :: union {
		Hello,
		Goodbye,
	}

	p, buf := make_packer({.UnionNames})
	defer m.destroy_packer(&p)
	defer delete(p.string_builder.buf)

	m.write(&p, Example(Hello{}))
	m.flush_packer(&p)

	example: Example
	err := m.unpack_into_from_bytes(buf.buf[:], &example)

	testing.expect_value(t, err, nil)
	testing.expect_value(t, example.(Hello), Hello{})
}


@(test)
test_write_union_variant :: proc(t: ^testing.T) {
	Hello :: struct {}
	Goodbye :: struct {
		data: i32,
	}

	Example :: union {
		Hello,
		Goodbye,
	}

	p, buf := make_packer({.UnionNames})
	defer m.destroy_packer(&p)
	defer delete(p.string_builder.buf)

	m.write(&p, Example(Goodbye{120}))
	m.flush_packer(&p)

	example: Example
	err := m.unpack_into_from_bytes(buf.buf[:], &example)

	testing.expect_value(t, err, nil)
	testing.expect_value(t, example.(Goodbye), Goodbye{120})
}


@(test)
test_write_union_variant_numeric :: proc(t: ^testing.T) {
	defer free_all(context.temp_allocator)
	Hello :: struct {}
	Goodbye :: struct {
		data: i32,
	}

	Example :: union {
		Hello,
		Goodbye,
	}

	p, buf := make_packer()
	defer m.destroy_packer(&p)
	defer delete(p.string_builder.buf)

	m.write(&p, Example(Goodbye{120}))
	m.flush_packer(&p)

	example: Example
	err := m.unpack_into_from_bytes(buf.buf[:], &example)

	// testing.expect_value(t, err, nil)
	// testing.expect_value(t, example.(Goodbye), Goodbye{120})
}


@(test)
test_write_union_one_variant_numeric :: proc(t: ^testing.T) {
	defer free_all(context.temp_allocator)
	Hello :: struct {}

	Example :: union {
		Hello,
	}

	p, buf := make_packer()
	defer m.destroy_packer(&p)
	defer delete(p.string_builder.buf)

	m.write(&p, Example(Hello{}))
	m.flush_packer(&p)

	example: Example
	err := m.unpack_into_from_bytes(buf.buf[:], &example)

	testing.expect_value(t, err, nil)
	testing.expect_value(t, example.(Hello), Hello{})
}


@(test)
test_write_union_one_variant_s :: proc(t: ^testing.T) {
	defer free_all(context.temp_allocator)
	Hello :: struct {}

	Example :: union {
		Hello,
	}

	p, buf := make_packer({.UnionNames})
	defer m.destroy_packer(&p)
	defer delete(p.string_builder.buf)

	m.write(&p, Example(Hello{}))
	m.flush_packer(&p)

	example: Example
	err := m.unpack_into_from_bytes(buf.buf[:], &example)

	testing.expect_value(t, err, nil)
	testing.expect_value(t, example.(Hello), Hello{})
}


@(test)
test_write_union_nil :: proc(t: ^testing.T) {
	defer free_all(context.temp_allocator)
	Hello :: struct {}

	Example :: union {
		Hello,
	}

	p, buf := make_packer({.UnionNames})
	defer m.destroy_packer(&p)
	defer delete(p.string_builder.buf)

	m.write(&p, Example(nil))
	m.write(&p, u8(10))
	m.flush_packer(&p)

	example: Example
	u, r := make_unpacker_from_bytes(buf.buf[:])
	defer free(r)
	err := m.read_into(&u, &example)

	num: u8
	err = m.read_into(&u, &num)

	testing.expect_value(t, err, nil)
	testing.expect_value(t, num, 10)
}
