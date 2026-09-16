package tests

import r "../"
import "core:testing"

Dispatch_Hello :: struct {
	name: string,
}

Dispatch_Goodbye :: struct {
	total: i64,
}

Dispatch_Union :: union {
	Dispatch_Hello,
	Dispatch_Goodbye,
}

No_Nil_Union :: union #no_nil {
	Dispatch_Hello,
	Dispatch_Goodbye,
}

Shared_Nil_Union :: union #shared_nil {
	^Dispatch_Hello,
	^Dispatch_Goodbye,
}

Tagless_Value :: struct {
	total: i64,
}

Tagless_Union :: union {
	^Tagless_Value,
}

Dispatch_State :: struct {
	hello_seen:    bool,
	goodbye_total: i64,
}

dispatch_hello :: proc(state: ^Dispatch_State, value: Dispatch_Hello) -> r.Dispatch_Error {
	state.hello_seen = value.name == "world"
	return nil
}

dispatch_goodbye :: proc(state: ^Dispatch_State, value: Dispatch_Goodbye) -> r.Dispatch_Error {
	state.goodbye_total = value.total
	return nil
}

dispatch_shared_goodbye :: proc(
	state: ^Dispatch_State,
	value: ^Dispatch_Goodbye,
) -> r.Dispatch_Error {
	state.goodbye_total = value.total
	return nil
}

@(test)
test_generic_union_dispatch :: proc(t: ^testing.T) {
	dispatcher: r.Dispatcher(Dispatch_Union, Dispatch_State)

	testing.expect_value(t, r.register_handler(&dispatcher, dispatch_hello), true)
	testing.expect_value(t, r.register_handler(&dispatcher, dispatch_goodbye), true)

	state := Dispatch_State{}
	err := r.dispatch(&dispatcher, Dispatch_Union(Dispatch_Hello{"world"}), &state)
	testing.expect_value(t, err, nil)
	testing.expect_value(t, state.hello_seen, true)

	err = r.dispatch(&dispatcher, Dispatch_Union(Dispatch_Goodbye{29}), &state)
	testing.expect_value(t, err, nil)
	testing.expect_value(t, state.goodbye_total, i64(29))
}

@(test)
test_generic_union_dispatch_missing_handler :: proc(t: ^testing.T) {
	dispatcher: r.Dispatcher(Dispatch_Union, Dispatch_State)
	testing.expect_value(t, r.register_handler(&dispatcher, dispatch_hello), true)

	state := Dispatch_State{}
	err := r.dispatch(&dispatcher, Dispatch_Union(Dispatch_Goodbye{29}), &state)
	missing, ok := err.(r.Unhandled_Variant)
	testing.expect_value(t, ok, true)
	testing.expect_value(t, missing.index, 1)
	testing.expect_value(t, state.goodbye_total, i64(0))
}

@(test)
test_generic_union_dispatch_rejects_nil_and_duplicate :: proc(t: ^testing.T) {
	dispatcher: r.Dispatcher(Dispatch_Union, Dispatch_State)
	testing.expect_value(t, r.register_handler(&dispatcher, dispatch_hello), true)
	testing.expect_value(t, r.register_handler(&dispatcher, dispatch_hello), false)

	state := Dispatch_State{}
	nil_value: Dispatch_Union = nil
	err := r.dispatch(&dispatcher, nil_value, &state)
	_, ok := err.(r.Dispatch_Invalid_Parameter)
	testing.expect_value(t, ok, true)
}

@(test)
test_generic_union_dispatch_nil_dispatcher :: proc(t: ^testing.T) {
	dispatcher: ^r.Dispatcher(Dispatch_Union, Dispatch_State) = nil
	testing.expect_value(t, r.register_handler(dispatcher, dispatch_hello), false)

	err := r.dispatch(dispatcher, Dispatch_Union(Dispatch_Hello{"world"}))
	invalid, ok := err.(r.Dispatch_Invalid_Parameter)
	testing.expect_value(t, ok, true)
	testing.expect_value(t, invalid.reason, "dispatcher was nil")
}

@(test)
test_generic_union_dispatch_union_kinds :: proc(t: ^testing.T) {
	no_nil_dispatcher: r.Dispatcher(No_Nil_Union, Dispatch_State)
	testing.expect_value(t, r.register_handler(&no_nil_dispatcher, dispatch_hello), true)

	state := Dispatch_State{}
	err := r.dispatch(&no_nil_dispatcher, No_Nil_Union(Dispatch_Hello{"world"}), &state)
	testing.expect_value(t, err, nil)
	testing.expect_value(t, state.hello_seen, true)

	shared_nil_dispatcher: r.Dispatcher(Shared_Nil_Union, Dispatch_State)
	testing.expect_value(
		t,
		r.register_handler(&shared_nil_dispatcher, dispatch_shared_goodbye),
		true,
	)
	goodbye := Dispatch_Goodbye{31}
	err = r.dispatch(&shared_nil_dispatcher, Shared_Nil_Union(&goodbye), &state)
	testing.expect_value(t, err, nil)
	testing.expect_value(t, state.goodbye_total, i64(31))
}

@(test)
test_generic_union_dispatch_rejects_tagless_union :: proc(t: ^testing.T) {
	dispatcher: r.Dispatcher(Tagless_Union, Dispatch_State)
	testing.expect_value(t, r.register_handler(&dispatcher, dispatch_tagless), true)

	value := Tagless_Value{37}
	err := r.dispatch(&dispatcher, Tagless_Union(&value))
	invalid, ok := err.(r.Dispatch_Invalid_Parameter)
	testing.expect_value(t, ok, true)
	testing.expect_value(t, invalid.reason, "single pointer-like unions are unsupported")
}

dispatch_tagless :: proc(state: ^Dispatch_State, value: ^Tagless_Value) -> r.Dispatch_Error {
	return nil
}
