package tests

import "core:testing"
import "core:fmt"
import m "../"
import "core:strings"

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

        decoded := m.decode_tag(&m.Unpacker{raw_data(buf.buf[:]), {}})
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
        decoded := m.decode_tag(&m.Unpacker{raw_data(buf.buf[:]), {}})
        testing.expect_value(t, decoded, m.Map{length})
    }
}
