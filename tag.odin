package msgpack

import "core:bufio"
import "core:fmt"
import "core:io"

POSITIVE_FIXINT_MASK :: 0x80
NEGATIVE_FIXINT_MASK :: 0xE0

FIXMAP_MASK :: 0xF0
FIXMAP_VALUE :: 0x80
FIXARRAY_MASK :: 0xF0
FIXARRAY_VALUE :: 0x90
FIXSTR_MASK :: 0xE0
FIXSTR_VALUE :: 0xA0

NIL :: 0xC0
UNUSED :: 0xC1
FALSE :: 0xC2
TRUE :: 0xC3
BIN_8 :: 0xC4
BIN_16 :: 0xC5
BIN_32 :: 0xC6
EXT_8 :: 0xC7
EXT_16 :: 0xC8
EXT_32 :: 0xC9
FLOAT_32 :: 0xCA
FLOAT_64 :: 0xCB
UINT_8 :: 0xCC
UINT_16 :: 0xCD
UINT_32 :: 0xCE
UINT_64 :: 0xCF
INT_8 :: 0xD0
INT_16 :: 0xD1
INT_32 :: 0xD2
INT_64 :: 0xD3
FIXEXT_1 :: 0xD4
FIXEXT_2 :: 0xD5
FIXEXT_4 :: 0xD6
FIXEXT_8 :: 0xD7
FIXEXT_16 :: 0xD8
STR_8 :: 0xD9
STR_16 :: 0xDA
STR_32 :: 0xDB
ARRAY_16 :: 0xDC
ARRAY_32 :: 0xDD
MAP_16 :: 0xDE
MAP_32 :: 0xDF

Ext :: struct {
	length: int,
	type:   i8,
}
Map :: struct {
	length: int,
}
Array :: struct {
	length: int,
}
Str :: struct {
	length: int,
}
Bin :: struct {
	length: int,
}
Nil :: struct {}
Bool :: struct {
	value: bool,
}
Float :: struct {
	is_double: bool,
}
Positive_Fixint :: struct {
	value: u8,
}
Negative_Fixint :: struct {
	value: i8,
}
Int :: struct {
	width: u8,
}
Uint :: struct {
	width: u8,
}

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

tag_name :: proc(t: Tag) -> string {
	switch _ in t {
	case Positive_Fixint:	return "Positive_Fixint"
	case Map:				return "Map"
	case Array:				return "Array"
	case Str:				return "Str"
	case Nil:				return "Nil"
	case Bool:				return "Bool"
	case Bin:				return "Bin"
	case Ext:				return "Ext"
	case Float:				return "Float"
	case Uint:				return "Uint"
	case Int:				return "Int"
	case Negative_Fixint:	return "Negative_Fixint"
	}

	unreachable()
}

write_size :: proc(p: ^Packer, size: $T) {
	bytes := transmute([size_of(T)]u8)size
	write_multibyte(p, bytes)
}

encode_tag :: proc(p: ^Packer, tag: Tag) -> (err: Pack_Error ) {
	switch variant in tag {
	case Positive_Fixint:
		err = bufio.writer_write_byte(&p.bw, ~u8(POSITIVE_FIXINT_MASK) & variant.value)

	case Map:
		length := variant.length
		switch length {
		case 0 ..< (1 << 4):
			bufio.writer_write_byte(&p.bw, FIXMAP_VALUE | u8(length))
		case (1 << 4) ..< (1 << 16):
			bufio.writer_write_byte(&p.bw, MAP_16)
			pack_number(p, u16(length))
		case (1 << 16) ..= ((1 << 32) - 1):
			bufio.writer_write_byte(&p.bw, MAP_32)
			pack_number(p, u32(length))
		}
	case Array:
		length := variant.length
		switch length {
		case 0 ..< (1 << 4):
			bufio.writer_write_byte(&p.bw, FIXARRAY_VALUE | u8(length))
		case (1 << 4) ..< (1 << 16):
			bufio.writer_write_byte(&p.bw, ARRAY_16)
			pack_number(p, u16(length))
		case (1 << 16) ..= ((1 << 32) - 1):
			bufio.writer_write_byte(&p.bw, ARRAY_32)
			pack_number(p, u32(length))
		}
	case Str:
		length := variant.length
		switch length {
		case 0 ..< (1 << 5):
			bufio.writer_write_byte(&p.bw, FIXSTR_VALUE | u8(length))
		case (1 << 5) ..< (1<<8):
			bufio.writer_write_byte(&p.bw, STR_8)
			bufio.writer_write_byte(&p.bw, u8(length))
		case (1 << 8) ..< (1 << 16):
			bufio.writer_write_byte(&p.bw, STR_16)
			pack_number(p, u16(length))
		case (1 << 16) ..= ((1 << 32) - 1):
			bufio.writer_write_byte(&p.bw, STR_32)
			pack_number(p, u32(length))
		}
	case Nil:
		bufio.writer_write_byte(&p.bw, NIL)
	case Bool:
		bufio.writer_write_byte(&p.bw, TRUE if variant.value else FALSE)
	case Bin:
		length := variant.length
		switch length {
		case 0 ..< (1 << 8):
			bufio.writer_write_byte(&p.bw, BIN_8)
			bufio.writer_write_byte(&p.bw, u8(length))
		case (1 << 8) ..< (1 << 16):
			bufio.writer_write_byte(&p.bw, BIN_16)
			pack_number(p, u16(length))
		case (1 << 16) ..= ((1 << 32) - 1):
			bufio.writer_write_byte(&p.bw, BIN_32)
			pack_number(p, u32(length))
		}
	case Ext:
		switch variant.length {
		case 1:
			bufio.writer_write_byte(&p.bw, FIXEXT_1)
		case 2:
			bufio.writer_write_byte(&p.bw, FIXEXT_2)
		case 4:
			bufio.writer_write_byte(&p.bw, FIXEXT_4)
		case 8:
			bufio.writer_write_byte(&p.bw, FIXEXT_8)
		case 16:
			bufio.writer_write_byte(&p.bw, FIXEXT_16)
		case 0 ..< (1 << 8):
			bufio.writer_write_byte(&p.bw, EXT_8)
			pack_number(p, u8(variant.length))
		case (1 << 8) ..< (1 << 16):
			bufio.writer_write_byte(&p.bw, EXT_16)
			pack_number(p, u16(variant.length))
		case (1 << 16) ..= ((1 << 32) - 1):
			bufio.writer_write_byte(&p.bw, EXT_32)
			pack_number(p, u32(variant.length))
		}
		pack_number(p, variant.type)

	case Float:
		bufio.writer_write_byte(&p.bw, FLOAT_64 if variant.is_double else FLOAT_32)
	case Uint:
		switch variant.width {
		case 1:
			bufio.writer_write_byte(&p.bw, UINT_8)
		case 2:
			bufio.writer_write_byte(&p.bw, UINT_16)
		case 4:
			bufio.writer_write_byte(&p.bw, UINT_32)
		case 8:
			bufio.writer_write_byte(&p.bw, UINT_64)
		}
	case Int:
		switch variant.width {
		case 1:
			bufio.writer_write_byte(&p.bw, INT_8)
		case 2:
			bufio.writer_write_byte(&p.bw, INT_16)
		case 4:
			bufio.writer_write_byte(&p.bw, INT_32)
		case 8:
			bufio.writer_write_byte(&p.bw, INT_64)
		}
	case Negative_Fixint:
		bufio.writer_write_byte(&p.bw, NEGATIVE_FIXINT_MASK | transmute(u8)variant.value)
	}

	return err
}

@(export)
decode_tag :: #force_no_inline proc(u: ^Unpacker) -> (t: Tag, err: Unpack_Error) {
	raw := read_byte(u) or_return

	switch raw {
	case NIL:		return Nil{}, nil
	case UNUSED:	return nil, Unexpected { "a tag", "0xC1 == UNUSED" }

	case FALSE:		return Bool { false }, nil
	case TRUE:		return Bool { true }, nil

	case BIN_8:		return Bin{int(read_byte(u) or_return)}, nil
	case BIN_16:	return Bin{int(read_number_swapped(u, u16) or_return)}, nil
	case BIN_32:	return Bin{int(read_number_swapped(u, u32) or_return)}, nil

	case EXT_8:		return Ext{int(read_byte(u) or_return), read_number_swapped(u, i8) or_return}, nil
	case EXT_16:	return Ext{int(read_number_swapped(u, u16) or_return), read_number_swapped(u, i8) or_return}, nil
	case EXT_32:	return Ext{int(read_number_swapped(u, u32) or_return), read_number_swapped(u, i8) or_return}, nil

	case FLOAT_32:	return Float{ false }, nil
	case FLOAT_64:	return Float { true }, nil

	case UINT_8:	return Uint{1}, nil
	case UINT_16:	return Uint{2}, nil
	case UINT_32:	return Uint{4}, nil
	case UINT_64:	return Uint{8}, nil

	case INT_8:		return Int{1}, nil
	case INT_16:	return Int{2}, nil
	case INT_32:	return Int{4}, nil
	case INT_64:	return Int{8}, nil

	case FIXEXT_1:	return Ext{1, read_number_swapped(u, i8) or_return}, nil
	case FIXEXT_2:	return Ext{2, read_number_swapped(u, i8) or_return}, nil
	case FIXEXT_4:	return Ext{4, read_number_swapped(u, i8) or_return}, nil
	case FIXEXT_8:	return Ext{8, read_number_swapped(u, i8) or_return}, nil
	case FIXEXT_16: return Ext{16, read_number_swapped(u, i8) or_return}, nil

	case STR_8:		return Str{int(read_byte(u) or_return)}, nil
	case STR_16:	return Str{int(read_number_swapped(u, u16) or_return)}, nil
	case STR_32:	return Str{int(read_number_swapped(u, u32) or_return)}, nil

	case ARRAY_16:	return Array{int(read_number_swapped(u, u16) or_return)}, nil
	case ARRAY_32:	return Array{int(read_number_swapped(u, u32) or_return)}, nil

	case MAP_16:	return Map{int(read_number_swapped(u, u16) or_return)}, nil
	case MAP_32:	return Map{int(read_number_swapped(u, u32) or_return)}, nil

	case 0..<POSITIVE_FIXINT_MASK:
		return Positive_Fixint{raw}, nil

	case POSITIVE_FIXINT_MASK..<FIXARRAY_VALUE:
		return Map{int(raw & ~u8(FIXMAP_MASK))} ,nil

	case FIXARRAY_VALUE..<FIXSTR_VALUE:
		return Array{int(raw & ~u8(FIXARRAY_MASK))}, nil

	case FIXSTR_VALUE..<NIL:
		return Str{int(raw & ~u8(FIXSTR_MASK))}, nil

	case NEGATIVE_FIXINT_MASK..=0xFF:
		return Negative_Fixint{-32 + i8(raw & ~u8(NEGATIVE_FIXINT_MASK))}, nil

	}

	unreachable()
}
