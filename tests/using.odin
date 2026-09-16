package tests

import "core:reflect"
import "core:testing"

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
