package tests

import "core:testing"

import m "../"

@(private = "file")
bounded_read :: proc(data: []u8) -> (object: m.Object, wire_bytes: int, err: m.Unpack_Error) {
	u := m.unpacker_from_bytes(data)
	defer m.unpacker_destroy(u)
	u.bounded = true
	u.max_collection = 4
	u.max_string = 8
	u.max_depth = 3
	u.remaining_bytes = 1 << 10
	object, err = m.read(&u)
	return object, u.wire_bytes, err
}

@(private = "file")
expect_bounded_rejects :: proc(t: ^testing.T, data: []u8, loc := #caller_location) {
	object, _, err := bounded_read(data)
	defer m.object_delete(object)
	_, invalid := err.(m.Invalid_Parameter)
	testing.expectf(t, invalid, "expected Invalid_Parameter, got %v", err, loc = loc)
}

@(test)
test_bounded_accepts_values_within_limits :: proc(t: ^testing.T) {
	// {"ab": [1, "xyz"]} followed by one trailing byte.
	data := []u8{0x81, 0xa2, 'a', 'b', 0x92, 0x01, 0xa3, 'x', 'y', 'z', 0xc0}
	object, wire_bytes, err := bounded_read(data)
	defer m.object_delete(object)
	testing.expect_value(t, err, nil)
	testing.expect_value(t, wire_bytes, len(data) - 1)
}

@(test)
test_bounded_rejects_oversized_collections_and_strings :: proc(t: ^testing.T) {
	expect_bounded_rejects(t, []u8{0x95, 1, 2, 3, 4, 5}) // 5-element array
	expect_bounded_rejects(t, []u8{0x85, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5}) // 5-entry map
	expect_bounded_rejects(t, []u8{0xa9, 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'}) // 9-byte string
}

@(test)
test_bounded_rejects_deep_nesting :: proc(t: ^testing.T) {
	expect_bounded_rejects(t, []u8{0x91, 0x91, 0x91, 0x01})
}

@(test)
test_bounded_rejects_allocations_over_budget :: proc(t: ^testing.T) {
	u := m.unpacker_from_bytes([]u8{0xc4, 0x04, 1, 2, 3, 4})
	defer m.unpacker_destroy(u)
	u.bounded = true
	u.max_collection, u.max_string, u.max_depth = 4, 8, 3
	u.remaining_bytes = 3
	object, err := m.read(&u)
	defer m.object_delete(object)
	_, invalid := err.(m.Invalid_Parameter)
	testing.expect(t, invalid)
}

@(test)
test_bounded_rejects_duplicate_keys_and_extensions :: proc(t: ^testing.T) {
	expect_bounded_rejects(t, []u8{0x82, 0xa1, 'k', 0x01, 0xa1, 'k', 0x02})
	expect_bounded_rejects(t, []u8{0xd4, 0x01, 0x00}) // fixext 1
}

@(test)
test_bounded_frees_partial_values_on_error :: proc(t: ^testing.T) {
	// The tracking allocator reports a leak if the earlier elements survive.
	expect_bounded_rejects(t, []u8{0x92, 0xa2, 'o', 'k', 0x91, 0x91, 0x91, 0x01})
	expect_bounded_rejects(t, []u8{0x82, 0xa1, 'a', 0xa2, 'o', 'k', 0xa1, 'b', 0xd4, 0x01, 0x00})
}
