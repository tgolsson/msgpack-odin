package tests

import "core:testing"
import m "../"
import "core:fmt"
import "core:strings"

Foo :: struct {
	foo, bar: i32
}

@(test)
test_write_struct :: proc(t: ^testing.T) {
    p, buf := make_packer()
	defer strings.builder_destroy(buf)
    defer free(buf)

	m.write(&p, Foo { 1, 2 })

	f: Foo
	err := m.unpack_into_from_bytes(buf.buf[:], &f)

	testing.expect_value(t, err, nil)
	testing.expect_value(t, f.foo, 1)
	testing.expect_value(t, f.bar, 2)
}


@(test)
test_write_false :: proc(t: ^testing.T) {
    p, buf := make_packer()
	defer strings.builder_destroy(buf)
    defer free(buf)

	m.write(&p, false)
	f: bool
	m.unpack_into_from_bytes(buf.buf[:], &f)
	testing.expect_value(t, f, false)
}

@(test)
test_write_true :: proc(t: ^testing.T) {
    p, buf := make_packer()
	defer strings.builder_destroy(buf)
    defer free(buf)

	m.write(&p, true)

	f: bool
	m.unpack_into_from_bytes(buf.buf[:], &f)
	testing.expect_value(t, f, true)
}
