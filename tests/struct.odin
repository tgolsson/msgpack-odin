package tests

import "core:testing"
import m "../"

Foo :: struct {
	foo, bar: i32
}

@(test)
test_write_struct :: proc(t: ^testing.T) {
	store := make([dynamic]u8, 0)
    p: m.Packer = { store, {  } }

	m.write(&p, &Foo { 1, 2 })
	testing.expectf(t, false, "%v", p.buf)
}
