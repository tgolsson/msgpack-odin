package tests

import m "../"
import "core:reflect"
import "core:testing"

// Odin rejects duplicate promoted names at compile time. These fixtures cover
// the valid side of that boundary; packing does not define runtime precedence
// for ambiguous using fields.
Using_Base :: struct {
	base: i32,
	name: string,
}

Using_Nested :: struct {
	using _: Using_Base,
	nested:  bool,
}

Using_Outer :: struct {
	first:       u8,
	using named: Using_Nested,
	last:        i16,
}

flatten_using_fields :: proc(
	type: typeid,
	base_offset: uintptr,
	names: []string,
	offsets: []uintptr,
	count: ^int,
) {
	for field in reflect.struct_fields_zipped(type) {
		field_offset := base_offset + field.offset
		if field.is_using {
			flatten_using_fields(field.type.id, field_offset, names, offsets, count)
			continue
		}

		duplicate := false
		for previous_name in names[:count^] {
			if previous_name == field.name {
				duplicate = true
				break
			}
		}
		if duplicate {
			continue
		}

		names[count^] = field.name
		offsets[count^] = field_offset
		count^ += 1
	}
}

@(test)
test_using_field_reflection_contract :: proc(t: ^testing.T) {
	fields := reflect.struct_fields_zipped(typeid_of(Using_Outer))
	testing.expect_value(t, len(fields), 3)
	testing.expect_value(t, fields[0].name, "first")
	testing.expect_value(t, fields[1].name, "named")
	testing.expect_value(t, fields[1].is_using, true)
	testing.expect_value(t, fields[2].name, "last")

	names: [8]string
	offsets: [8]uintptr
	count := 0
	flatten_using_fields(typeid_of(Using_Outer), 0, names[:], offsets[:], &count)

	expected_names := [?]string{"first", "base", "name", "nested", "last"}
	testing.expect_value(t, count, len(expected_names))
	for expected_name, i in expected_names {
		testing.expect_value(t, names[i], expected_name)
	}

	outer_fields := reflect.struct_fields_zipped(typeid_of(Using_Outer))
	nested_fields := reflect.struct_fields_zipped(typeid_of(Using_Nested))
	base_fields := reflect.struct_fields_zipped(typeid_of(Using_Base))
	testing.expect_value(
		t,
		offsets[1],
		outer_fields[1].offset + nested_fields[0].offset + base_fields[0].offset,
	)
}

@(test)
test_using_field_pack_numeric_keys :: proc(t: ^testing.T) {
	value := Using_Outer{7, Using_Nested{Using_Base{11, "base"}, true}, -3}
	data, err := m.pack_into_bytes(value, {})
	defer delete(data)

	testing.expect_value(t, err, nil)
	slice_eq(
		t,
		data[:],
		[]u8 {
			0x85,
			0x00,
			0x07,
			0x01,
			0x0b,
			0x02,
			0xa4,
			0x62,
			0x61,
			0x73,
			0x65,
			0x03,
			0xc3,
			0x04,
			0xfd,
		},
	)
}

@(test)
test_using_field_pack_named_keys :: proc(t: ^testing.T) {
	value := Using_Outer{7, Using_Nested{Using_Base{11, "base"}, true}, -3}
	data, err := m.pack_into_bytes(value, {.FieldNames})
	defer delete(data)

	testing.expect_value(t, err, nil)
	slice_eq(
		t,
		data[:],
		[]u8 {
			0x85,
			0xa5,
			0x66,
			0x69,
			0x72,
			0x73,
			0x74,
			0x07,
			0xa4,
			0x62,
			0x61,
			0x73,
			0x65,
			0x0b,
			0xa4,
			0x6e,
			0x61,
			0x6d,
			0x65,
			0xa4,
			0x62,
			0x61,
			0x73,
			0x65,
			0xa6,
			0x6e,
			0x65,
			0x73,
			0x74,
			0x65,
			0x64,
			0xc3,
			0xa4,
			0x6c,
			0x61,
			0x73,
			0x74,
			0xfd,
		},
	)
}

@(test)
test_using_field_collision_boundary :: proc(t: ^testing.T) {
	names: [8]string
	offsets: [8]uintptr
	count := 0
	flatten_using_fields(typeid_of(Using_Outer), 0, names[:], offsets[:], &count)

	for name, i in names[:count] {
		for previous_name in names[:i] {
			testing.expect_value(t, previous_name == name, false)
		}
	}
}
