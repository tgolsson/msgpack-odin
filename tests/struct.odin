package tests

import "core:testing"
import m "../"
import "core:fmt"

Foo :: struct {
	foo, bar: i32
}

@(test)
test_write_struct :: proc(t: ^testing.T) {
	store := make([dynamic]u8, 0, 20)
    p: m.Packer = { store, {  } }

	m.write(&p, &Foo { 1, 2 })
	f: Foo
	u :=  m.Unpacker { raw_data(store[:]), {} }
	m.read_into(&u, &f)
}


@(test)
test_write_false :: proc(t: ^testing.T) {
	store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

	m.write(&p, false)
	f: bool
	u :=  m.Unpacker { raw_data(p.buf[0:]), {} }
	m.read_into(&u, &f)
	testing.expect_value(t, f, false)
}

@(test)
test_write_true :: proc(t: ^testing.T) {
	store := make([dynamic]u8, 0, 10)
    p: m.Packer = { store, {  } }

	m.write(&p, true)

	f: bool
	u :=  m.Unpacker { raw_data(p.buf[0:]), {} }
	m.read_into(&u, &f)
	testing.expect_value(t, f, true)
}
