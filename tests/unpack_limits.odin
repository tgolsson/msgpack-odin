package tests

import "core:bytes"
import "core:io"
import "core:testing"

import m "../"

expect_length_limit :: proc(t: ^testing.T, data: []u8) {
	_, err := m.unpack_from_bytes(data)
	limited, ok := err.(m.Length_Limit_Exceeded)
	testing.expect_value(t, ok, true)
	if ok {
		testing.expect_value(t, limited.max_length, u64(m.DEFAULT_UNPACK_MAX_LENGTH))
	}
}

@(test)
test_oversized_headers_are_rejected :: proc(t: ^testing.T) {
	expect_length_limit(t, []u8{0xdf, 0xff, 0xff, 0xff, 0xff})
	expect_length_limit(t, []u8{0xdd, 0xff, 0xff, 0xff, 0xff})
	expect_length_limit(t, []u8{0xdb, 0xff, 0xff, 0xff, 0xff})
	expect_length_limit(t, []u8{0xc6, 0xff, 0xff, 0xff, 0xff})
	expect_length_limit(t, []u8{0xc9, 0xff, 0xff, 0xff, 0xff})
}

@(test)
test_specialized_array_rejects_before_resize :: proc(t: ^testing.T) {
	data := [?]u8{0xdd, 0xff, 0xff, 0xff, 0xff}
	out: []u64
	err := m.unpack_into_from_bytes(data[:], &out)

	_, ok := err.(m.Length_Limit_Exceeded)
	testing.expect_value(t, ok, true)
	testing.expect_value(t, len(out), 0)
	delete(out)
}

@(test)
test_custom_limit_accepts_boundary_for_bytes_constructor :: proc(t: ^testing.T) {
	data := [?]u8{0xd9, 3, 'a', 'b', 'c'}
	u := m.unpacker_from_bytes(data[:], max_length = 3)
	obj, err := m.read(&u)
	defer m.unpacker_destroy(u)

	testing.expect_value(t, err, nil)
	testing.expect_value(t, obj.(string), (string)("abc"))
	m.object_delete(obj)
}

@(test)
test_custom_limit_rejects_above_boundary_for_reader_constructor :: proc(t: ^testing.T) {
	data := [?]u8{0xd9, 3, 'a', 'b', 'c'}
	reader := new(bytes.Reader)
	stream := bytes.reader_init(reader, data[:])
	io_reader := io.to_reader(stream)
	u := m.unpacker_from_reader(io_reader, max_length = 2)
	_, err := m.read(&u)
	defer free(reader)
	defer m.unpacker_destroy(u)

	limited, ok := err.(m.Length_Limit_Exceeded)
	testing.expect_value(t, ok, true)
	if ok {
		testing.expect_value(t, limited.length, u64(3))
		testing.expect_value(t, limited.max_length, u64(2))
	}
}

@(test)
test_custom_limit_rejects_fixed_extension :: proc(t: ^testing.T) {
	data := [?]u8{0xd6, 0, 0, 0, 0, 0}
	u := m.unpacker_from_bytes(data[:], max_length = 2)
	_, err := m.read(&u)
	defer m.unpacker_destroy(u)

	limited, ok := err.(m.Length_Limit_Exceeded)
	testing.expect_value(t, ok, true)
	if ok {
		testing.expect_value(t, limited.length, u64(4))
		testing.expect_value(t, limited.max_length, u64(2))
	}
}
