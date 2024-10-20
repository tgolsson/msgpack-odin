package msgpack

import "core:fmt"

Ext				:: struct { length: int, type: i8 }
Map				:: struct { length: int }
Array			:: struct { length: int }
Str				:: struct { length: int }
Bin				:: struct { length: int }
Nil				:: struct {}
Bool			:: struct { value: bool }
Float			:: struct { is_double: bool }
Positive_Fixint :: struct { value: u8 }
Negative_Fixint :: struct { value: i8 }
Int				:: struct { width: u8 }
Uint			:: struct { width: u8 }

Tag :: union {
	Positive_Fixint,
	Map,
	Array,
	Str,
	Nil,
	Bool,
	Bin,
	Ext,
	Float,
	Uint,
	Int,
	Negative_Fixint,
}

POSITIVE_FIXINT_MASK	:: 0x80
NEGATIVE_FIXINT_MASK	:: 0xE0

FIXMAP_MASK  			:: 0xF0
FIXMAP_VALUE  			:: 0x80
FIXARRAY_MASK			:: 0xF0
FIXARRAY_VALUE 			:: 0x90
FIXSTR_MASK   			:: 0xE0
FIXSTR_VALUE   			:: 0xA0

NIL			:: 0xC0
UNUSED		:: 0xC1
FALSE		:: 0xC2
TRUE		:: 0xC3
BIN_8		:: 0xC4
BIN_16		:: 0xC5
BIN_32		:: 0xC6
EXT_8		:: 0xC7
EXT_16		:: 0xC8
EXT_32		:: 0xC9
FLOAT_32	:: 0xCA
FLOAT_64	:: 0xCB
UINT_8		:: 0xCC
UINT_16		:: 0xCD
UINT_32		:: 0xCE
UINT_64		:: 0xCF
INT_8		:: 0xD0
INT_16		:: 0xD1
INT_32		:: 0xD2
INT_64		:: 0xD3
FIXEXT_1	:: 0xD4
FIXEXT_2	:: 0xD5
FIXEXT_4	:: 0xD6
FIXEXT_8	:: 0xD7
FIXEXT_16	:: 0xD8
STR_8		:: 0xD9
STR_16		:: 0xDA
STR_32		:: 0xDB
ARRAY_16	:: 0xDC
ARRAY_32	:: 0xDD
MAP_16		:: 0xDE
MAP_32		:: 0xDF

is_positive_fixint :: #force_inline proc(raw: u8) -> bool {
	return (raw & POSITIVE_FIXINT_MASK) != 0x80
}

is_negative_fixint :: #force_inline proc(raw: u8) -> bool {
	return (raw & NEGATIVE_FIXINT_MASK) == NEGATIVE_FIXINT_MASK
}

is_fixstr :: #force_inline proc(raw: u8) -> bool {
	return (raw & FIXSTR_MASK) == FIXSTR_VALUE
}

is_fixmap :: #force_inline proc(raw: u8) -> bool {
	return (raw & FIXMAP_MASK) == FIXMAP_VALUE
}

is_fixarray :: #force_inline proc(raw: u8) -> bool {
	return (raw & FIXARRAY_MASK) == FIXARRAY_VALUE
}

write_size :: proc(p: ^Packer, size: $T) {
    bytes := transmute([size_of(T)]u8)size
	write_multibyte(p, bytes)
}

encode_tag :: proc(p: ^Packer, tag: Tag) {
	pack_tag(p, tag)
}

decode_tag :: proc(u: ^Unpacker) -> (t: Tag, err: Unpack_Error) {
	raw := read_byte(u) or_return

	switch {
	case is_positive_fixint(raw):
		t = Positive_Fixint { raw & ~u8(POSITIVE_FIXINT_MASK) }
	case is_negative_fixint(raw):
		t = Negative_Fixint { -32 + i8(raw & ~u8(NEGATIVE_FIXINT_MASK))}
	case is_fixarray(raw):
		t = Array { int(raw & ~u8(FIXARRAY_MASK))}
	case is_fixstr(raw):
		t = Str { int(raw & ~u8(FIXSTR_MASK))}
	case is_fixmap(raw):
		t = Map { int(raw & ~u8(FIXMAP_MASK))}
	}

	switch raw {
	case NIL:				 t = Nil {}
	case TRUE, FALSE:		 t = Bool { raw == TRUE }
	case BIN_8:				 t = Bin { int(read_byte(u) or_return) }
	case BIN_16:			 t = Bin { int(read_number(u, u16) or_return) }
	case BIN_32:			 t = Bin { int(read_number(u, u32) or_return) }
	case EXT_8:				 t = Ext { int(read_byte(u) or_return), read_number(u, i8) or_return }
	case EXT_16:			 t = Ext { int(read_number(u, u16) or_return), read_number(u, i8) or_return }
	case EXT_32:			 t = Ext { int(read_number(u, u32) or_return), read_number(u, i8) or_return }
	case FLOAT_32, FLOAT_64: t = Float { raw == FLOAT_64 }
	case UINT_8:			 t = Uint { 1 }
	case UINT_16:			 t = Uint { 2 }
	case UINT_32:			 t = Uint { 4 }
	case UINT_64:			 t = Uint { 8 }
	case INT_8:				 t = Int { 1 }
	case INT_16:			 t = Int { 2 }
	case INT_32:			 t = Int { 4 }
	case INT_64:			 t = Int { 8 }
	case FIXEXT_1:			 t = Ext { 1, read_number(u, i8) or_return }
	case FIXEXT_2:			 t = Ext { 2, read_number(u, i8) or_return }
	case FIXEXT_4:			 t = Ext { 4, read_number(u, i8) or_return }
	case FIXEXT_8:			 t = Ext { 8, read_number(u, i8) or_return }
	case FIXEXT_16:			 t = Ext { 16, read_number(u, i8) or_return }
	case STR_8:				 t = Str { int(read_byte(u) or_return) }
	case STR_16:			 t = Str { int(read_number(u, u16) or_return) }
	case STR_32:			 t = Str { int(read_number(u, u32) or_return) }
	case ARRAY_16:			 t = Array { int(read_number(u, u16) or_return) }
	case ARRAY_32:			 t = Array { int(read_number(u, u32) or_return) }
	case MAP_16:			 t = Map { int(read_number(u, u16) or_return) }
	case MAP_32:			 t = Map { int(read_number(u, u32) or_return) }
	}

	return
}
