package msgpack


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
	#partial switch variant in tag {
	case Map:
		if variant.length < (1 << 4) {
			write_byte(p, FIXMAP_VALUE | u8(variant.length))
		} else if variant.length <= (1 << 16) {
			write_byte(p, MAP_16)
			write_size(p, u16(variant.length))
		} else {
			write_byte(p, MAP_32)
			write_size(p, u32(variant.length))
		}
	case Array:
		if variant.length < (1 << 4) {
			write_byte(p, FIXARRAY_VALUE | u8(variant.length))
		} else if variant.length <= (1 << 16) {
			write_byte(p, ARRAY_16)
			write_size(p, u16(variant.length))
		} else {
			write_byte(p, ARRAY_32)
			write_size(p, u32(variant.length))
		}
	
	case Nil:
		write_byte(p, NIL)
	case Bool:
		write_byte(p, TRUE if variant.value else FALSE)
	}
}

import "core:fmt"

decode_tag :: proc(u: ^Unpacker) -> Tag {
	raw := read_byte(u)

	switch {
	case is_positive_fixint(raw):
		return Positive_Fixint { raw & ~u8(POSITIVE_FIXINT_MASK) }
	case is_negative_fixint(raw):
		return Negative_Fixint { -32 + i8(raw & ~u8(NEGATIVE_FIXINT_MASK))}
	case is_fixarray(raw):
		return Array { int(raw & ~u8(FIXARRAY_MASK))}
	case is_fixstr(raw):
		return Str { int(raw & ~u8(FIXSTR_MASK))}
	case is_fixmap(raw):
		return Map { int(raw & ~u8(FIXMAP_MASK))}
	}

	switch raw {
	case NIL:				 return Nil {}
	case TRUE, FALSE:		 return Bool { raw == TRUE }
	case BIN_8:				 return Bin { int(read_byte(u)) }
	case BIN_16:			 return Bin { int(read_number(u, u16)) }
	case BIN_32:			 return Bin { int(read_number(u, u32)) }
	case EXT_8:				 return Ext { int(read_byte(u)), read_number(u, i8) }
	case EXT_16:			 return Ext { int(read_number(u, u16)), read_number(u, i8) }
	case EXT_32:			 return Ext { int(read_number(u, u32)), read_number(u, i8) }
	case FLOAT_32, FLOAT_64: return Float { raw == FLOAT_64 }
	case UINT_8:			 return Uint { 1 }
	case UINT_16:			 return Uint { 2 }
	case UINT_32:			 return Uint { 4 }
	case UINT_64:			 return Uint { 8 }
	case INT_8:				 return Int { 1 }
	case INT_16:			 return Int { 2 }
	case INT_32:			 return Int { 4 }
	case INT_64:			 return Int { 8 }
	case FIXEXT_1:			 return Ext { 1, read_number(u, i8) }
	case FIXEXT_2:			 return Ext { 2, read_number(u, i8) }
	case FIXEXT_4:			 return Ext { 4, read_number(u, i8) }
	case FIXEXT_8:			 return Ext { 8, read_number(u, i8) }
	case FIXEXT_16:			 return Ext { 16, read_number(u, i8) }
	case STR_8:				 return Str { int(read_byte(u)) }
	case STR_16:			 return Str { int(read_number(u, u16)) }
	case STR_32:			 return Str { int(read_number(u, u32)) }
	case ARRAY_16:			 return Array { int(read_number(u, u16)) }
	case ARRAY_32:			 return Array { int(read_number(u, u32)) }
	case MAP_16:			 return Map { int(read_number(u, u16)) }
	case MAP_32:			 return Map { int(read_number(u, u32)) }
	}

	unreachable()
}
