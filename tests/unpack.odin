package tests

import "core:bytes"
import "core:io"
import "core:testing"

import m "../"

expect_unexpected_key_error :: proc(t: ^testing.T, data: []u8, found: string) {
	_, err := m.unpack_from_bytes(data)
	unexpected, ok := err.(m.Unexpected)
	testing.expect_value(t, ok, true)
	if ok {
		testing.expect_value(t, unexpected.wanted, "a valid key type")
		testing.expect_value(t, unexpected.found, found)
	}
}

@(test)
test_read_multiple_messages_from_one_unpacker :: proc(t: ^testing.T) {
	packer, _ := m.packer_for_bytes({})
	defer m.destroy_packer(&packer)
	defer free(packer.string_builder)
	defer delete(packer.string_builder.buf)

	m.write(&packer, "first")
	m.write(&packer, "second")
	m.flush_packer(&packer)

	reader := new(bytes.Reader)
	stream := bytes.reader_init(reader, packer.string_builder.buf[:])
	io_reader := io.to_reader(stream)
	u := m.unpacker_from_reader(io_reader)
	defer m.unpacker_destroy(u)
	defer free(reader)

	first, err := m.read(&u)
	testing.expect_value(t, err, nil)
	testing.expect_value(t, first.(string), (string)("first"))
	m.object_delete(first)

	second: m.Object
	second, err = m.read(&u)
	testing.expect_value(t, err, nil)
	testing.expect_value(t, second.(string), (string)("second"))
	m.object_delete(second)
}

@(test)
test_read_into_multiple_messages_from_one_unpacker :: proc(t: ^testing.T) {
	packer, _ := m.packer_for_bytes({})
	defer m.destroy_packer(&packer)
	defer free(packer.string_builder)
	defer delete(packer.string_builder.buf)

	m.write(&packer, i32(17))
	m.write(&packer, i32(29))
	m.flush_packer(&packer)

	reader := new(bytes.Reader)
	stream := bytes.reader_init(reader, packer.string_builder.buf[:])
	io_reader := io.to_reader(stream)
	u := m.unpacker_from_reader(io_reader)
	defer m.unpacker_destroy(u)
	defer free(reader)

	first: i32
	err := m.read_into(&u, &first)
	testing.expect_value(t, err, nil)
	testing.expect_value(t, first, i32(17))

	second: i32
	err = m.read_into(&u, &second)
	testing.expect_value(t, err, nil)
	testing.expect_value(t, second, i32(29))
}

@(test)
test_unsupported_map_key_tags_return_errors :: proc(t: ^testing.T) {
	// Each input is a one-entry map. The key is unsupported, so read_key
	// returns before the value is decoded.
	map_key := [?]u8{129, 128, 0}
	array_key := [?]u8{129, 144, 0}
	nil_key := [?]u8{129, 192, 0}
	bin_key := [?]u8{129, 196, 0, 0}
	ext_key := [?]u8{129, 212, 0, 0, 0}

	expect_unexpected_key_error(t, map_key[:], "Map")
	expect_unexpected_key_error(t, array_key[:], "Array")
	expect_unexpected_key_error(t, nil_key[:], "Nil")
	expect_unexpected_key_error(t, bin_key[:], "Bin")
	expect_unexpected_key_error(t, ext_key[:], "Ext")
}
