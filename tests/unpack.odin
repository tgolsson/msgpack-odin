package tests

import "core:bytes"
import "core:io"
import "core:testing"

import m "../"

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
