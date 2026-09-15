package tests
import m "../"
import "core:testing"

@(test)
test_write_enum_ordinal :: proc(t: ^testing.T) {
	Color :: enum {
		Red   = 5,
		Green = 6,
		Blue  = 7,
	}

	p, buf := make_packer()
	defer m.destroy_packer(&p)
	defer free(p.string_builder)
	defer delete(p.string_builder.buf)

	m.write(&p, Color.Green)
	m.flush_packer(&p)

	dest: Color
	err := m.unpack_into_from_bytes(buf.buf[:], &dest)

	testing.expect_value(t, err, nil)
	testing.expect_value(t, dest, Color.Green)
}


@(test)
test_write_enum_name :: proc(t: ^testing.T) {
	Color :: enum {
		Red   = 5,
		Green = 6,
		Blue  = 7,
	}

	p, buf := make_packer({.EnumNames})
	defer m.destroy_packer(&p)
	defer free(p.string_builder)
	defer delete(p.string_builder.buf)

	m.write(&p, Color.Green)
	m.flush_packer(&p)

	dest: Color
	err := m.unpack_into_from_bytes(buf.buf[:], &dest)

	testing.expect_value(t, err, nil)
	testing.expect_value(t, dest, Color.Green)
}


@(test)
test_unpack_enum_unknown_ordinal :: proc(t: ^testing.T) {
	Color :: enum {
		Red   = 5,
		Green = 6,
		Blue  = 7,
	}

	p, buf := make_packer()
	defer m.destroy_packer(&p)
	defer free(p.string_builder)
	defer delete(p.string_builder.buf)

	m.write(&p, 99)
	m.flush_packer(&p)

	dest: Color
	err := m.unpack_into_from_bytes(buf.buf[:], &dest)

	unknown, ok := err.(m.Unknown_Enum_Ordinal)
	testing.expect(t, ok)
	testing.expect_value(t, unknown.ordinal, i64(99))
}


@(test)
test_unpack_enum_unknown_name :: proc(t: ^testing.T) {
	Color :: enum {
		Red   = 5,
		Green = 6,
		Blue  = 7,
	}

	p, buf := make_packer()
	defer m.destroy_packer(&p)
	defer free(p.string_builder)
	defer delete(p.string_builder.buf)

	m.write(&p, "Purple")
	m.flush_packer(&p)

	dest: Color
	err := m.unpack_into_from_bytes(buf.buf[:], &dest)

	unknown, ok := err.(m.Unknown_Enum_Name)
	testing.expect(t, ok)
	testing.expect_value(t, unknown.name, "Purple")
	delete(unknown.name)
}
