package rpc

import "base:intrinsics"

Dispatch_Invalid_Parameter :: struct {
	reason: string,
}

Unhandled_Variant :: struct {
	index: int,
}

Dispatch_Error :: union {
	Dispatch_Invalid_Parameter,
	Unhandled_Variant,
}

_Dispatch_Entry :: struct($U, $S: typeid) where intrinsics.type_is_union(U) {
	_handler: rawptr,
	_invoke:  proc(handler: rawptr, user_data: ^S, value: U) -> Dispatch_Error,
}

// Dispatcher stores one typed handler slot for every variant of U.
Dispatcher :: struct($U, $S: typeid) where intrinsics.type_is_union(U) {
	_handlers: [intrinsics.type_union_variant_count(U)]_Dispatch_Entry(U, S),
}

// Registers a handler for one concrete variant of U. V is inferred from the
// handler and must be a member of U. A duplicate or nil handler is rejected.
register_handler :: proc(
	dispatcher: ^Dispatcher($U, $S),
	handler: proc(user_data: ^S, value: $V) -> Dispatch_Error,
) -> bool where intrinsics.type_is_variant_of(U, V) {
	if dispatcher == nil {
		return false
	}

	index := intrinsics.type_variant_index_of(U, V)
	entry := &dispatcher._handlers[index]
	if entry._handler != nil || handler == nil {
		return false
	}

	invoke :: proc(handler_ptr: rawptr, user_data: ^S, value: U) -> Dispatch_Error {
		typed_handler := cast(proc(user_data: ^S, value: V) -> Dispatch_Error)handler_ptr
		value_copy := value
		return typed_handler(user_data, (^V)(rawptr(&value_copy))^)
	}

	entry._handler = rawptr(handler)
	entry._invoke = invoke
	return true
}

// Dispatches the active variant of value through the typed handler table.
// The table is indexed by U's runtime discriminator, while registration
// validates each concrete V at compile time.
dispatch :: proc(
	dispatcher: ^Dispatcher($U, $S),
	value: U,
	user_data: ^S = nil,
) -> Dispatch_Error where intrinsics.type_is_union(U) {
	if dispatcher == nil {
		return Dispatch_Invalid_Parameter{"dispatcher was nil"}
	}

	// Odin stores a single pointer-like union without a discriminator. Keep
	// this path explicit until dispatch can identify its nil/non-nil state
	// without reading beyond the value.
	when intrinsics.type_union_variant_count(U) == 1 {
		return Dispatch_Invalid_Parameter{"single pointer-like unions are unsupported"}
	}

	raw_tag := union_raw_tag(value)
	index := raw_tag - i64(intrinsics.type_union_base_tag_value(U))
	if index < 0 || index >= len(dispatcher._handlers) {
		return Dispatch_Invalid_Parameter{"value had no active union variant"}
	}

	entry := &dispatcher._handlers[index]
	if entry._handler == nil || entry._invoke == nil {
		return Unhandled_Variant{int(index)}
	}

	return entry._invoke(entry._handler, user_data, value)
}

union_raw_tag :: proc(value: $U) -> i64 where intrinsics.type_is_union(U) {
	value_copy := value
	tag_ptr := rawptr(uintptr(&value_copy) + intrinsics.type_union_tag_offset(U))
	Tag :: intrinsics.type_union_tag_type(U)
	tag_any := any{tag_ptr, typeid_of(Tag)}

	switch tag in tag_any {
	case u8:
		return i64(tag)
	case i8:
		return i64(tag)
	case u16:
		return i64(tag)
	case i16:
		return i64(tag)
	case u32:
		return i64(tag)
	case i32:
		return i64(tag)
	case u64:
		return i64(tag)
	case i64:
		return tag
	}

	return -1
}
