package tests

import "core:testing"
import "core:fmt"
import m "../"

@(test)
test_array_tag :: proc(t: ^testing.T) {
    for length in 0..<20 {
            
        packer := m.Packer{
            make([dynamic]u8, 0, 10),
            {}
        }
        defer delete(packer.buf)

     
        expected_length: int
        if length < (1 << 4) {
            expected_length = 1
        } else if length < (1 << 16) {
            expected_length = 3
        } else {
            expected_length = 5
        }

        m.encode_tag(&packer, m.Array{length})
        testing.expect_value(t, len(packer.buf), expected_length)
        
        decoded := m.decode_tag(&m.Unpacker{raw_data(packer.buf[:]), {}})
        testing.expect_value(t, decoded, m.Array{length})
    }
}
    
@(test)
test_map_tag :: proc(t: ^testing.T) {
    for length in 0..<20 {
        packer := m.Packer{
            make([dynamic]u8, 0, 10),
            {}
        }
        defer delete(packer.buf)   

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
        testing.expect_value(t, len(packer.buf), expected_length)        
        decoded := m.decode_tag(&m.Unpacker{raw_data(packer.buf[:]), {}})
        testing.expect_value(t, decoded, m.Map{length})
    }
}

