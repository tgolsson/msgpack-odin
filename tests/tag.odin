package tests

import "core:bytes"
import "core:fmt"
import "core:io"
import "core:strings"
import "core:testing"

import m "../"

make_packer :: proc(flags: m.PackerFlags_Set = {}) -> (p: m.Packer, b: ^strings.Builder) {
	p, _ =m .packer_for_bytes(flags)
	return p, p.string_builder
}

make_unpacker_from_bytes :: proc(b: []u8) -> (m.Unpacker, ^bytes.Reader) {
	unpacker := m.unpacker_from_bytes(b)
	return unpacker, unpacker.bytes_reader
}

@(test)
test_array_tag :: proc(t: ^testing.T) {
	for length in 0 ..< 20 {
		packer, _ := m.packer_for_bytes({})
		defer m.destroy_packer(&packer)
		defer delete(packer.string_builder.buf)

		expected_length: int
		if length < (1 << 4) {
			expected_length = 1
		} else if length < (1 << 16) {
			expected_length = 3
		} else {
			expected_length = 5
		}

		m.encode_tag(&packer, m.Array{length})
		m.flush_packer(&packer)
		testing.expect_value(t, len(packer.string_builder.buf), expected_length)

		u, r := make_unpacker_from_bytes(packer.string_builder.buf[:])
		defer free(r)
		decoded, err := m.decode_tag(&u)
		testing.expect_value(t, err, nil)
		testing.expect_value(t, decoded, m.Array{length})
	}
}

@(test)
test_map_tag :: proc(t: ^testing.T) {
	for length in 0 ..< 20 {

		packer, buf := make_packer()
		defer m.destroy_packer(&packer)
		defer delete(packer.string_builder.buf)

		expected_length: int
		if length < (1 << 4) {
			expected_length = 1
		} else if length < (1 << 16) {
			expected_length = 3
		} else {
			expected_length = 5
		}

		m.encode_tag(&packer, m.Map{length})
		m.flush_packer(&packer)
		testing.expect_value(t, len(buf.buf), expected_length)
		u, r := make_unpacker_from_bytes(buf.buf[:])
		defer free(r)
		decoded, err := m.decode_tag(&u)
		testing.expect_value(t, err, nil)
		testing.expect_value(t, decoded, m.Map{length})
	}
}
