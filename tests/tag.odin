package tests

import "core:bytes"
import "core:fmt"
import "core:io"
import "core:strings"
import "core:testing"

import m "../"

make_packer :: proc(flags: m.PackerFlags_Set = {}) -> (p: m.Packer, b: ^strings.Builder) {
	b = new(strings.Builder)
	strings.builder_init(b)
	w := strings.to_writer(b)
	p = m.Packer {
		w,
		flags,
		context.temp_allocator,
	}

	return
}

make_unpacker_from_bytes :: proc(b: []u8) -> (m.Unpacker, ^bytes.Reader) {
	reader := new(bytes.Reader)
	stream := bytes.reader_init(reader, b)
	io_reader := io.to_reader(stream)

	unpacker := m.Unpacker{io_reader, context.temp_allocator}
	return unpacker, reader
}

@(test)
test_array_tag :: proc(t: ^testing.T) {
    for length in 0..<20 {

        packer, buf := make_packer()
		defer strings.builder_destroy(buf)
        defer free(buf)

        expected_length: int
        if length < (1 << 4) {
            expected_length = 1
        } else if length < (1 << 16) {
            expected_length = 3
        } else {
            expected_length = 5
        }

        m.encode_tag(&packer, m.Array{length})
        testing.expect_value(t, len(buf.buf), expected_length)

		u, r := make_unpacker_from_bytes(buf.buf[:])
		defer free(r)
        decoded, err := m.decode_tag(&u)
		testing.expect_value(t, err, nil)
        testing.expect_value(t, decoded, m.Array{length})
    }
}

@(test)
test_map_tag :: proc(t: ^testing.T) {
    for length in 0..<20 {

        packer, buf := make_packer()
		defer strings.builder_destroy(buf)
        defer free(buf)

        expected_length: int
        if length < (1 << 4) {
            expected_length = 1
        }
        else if length < (1 << 16) {
            expected_length = 3
        } else {
            expected_length = 5
        }

        m.encode_tag(&packer, m.Map{length})
        testing.expect_value(t, len(buf.buf), expected_length)
		u, r := make_unpacker_from_bytes(buf.buf[:])
		defer free(r)
        decoded, err := m.decode_tag(&u)
		testing.expect_value(t, err, nil)
        testing.expect_value(t, decoded, m.Map{length})
    }
}
