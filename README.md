# msgpack-odin

This contains a pure Odin implementation of the msgpack spec, including timestamps. There is
currently no support for any extensions. If this is a need you have, I'd suggest using a binary
field and packing your data there. Having ext types makes the unpacker/packer more complex, for no
good reason.

A few notes on compatibility:

* Integers are packed into the smallest possible variant
* ~Floats are packed as is and deserialized as is~ TODO: Unit tests assume efficient packing so right now, anything < F32_MAX is packed as f32. This is temporary.
* `[]u8` and friends are packed as Array[Number]. This is also true for `[]byte`, which is a soft alias for the former. For true binary data, use `[]m.bin` or `m.binary`.
* Packing internally uses a `bufio.Writer`. `pack_into_from_` will flush this, but manual packing requires flushing this explicitly. See `packer_flush`.
* Unions are packed as `{variant_name_or_index: variant_value}`
* `.StableMaps` do not apply to structs, only actual maps.

# Missing functionality

- There's no support for enums (yet)
- No support for `using` in structs

# Performance

I haven't measured against every encoding shipped by default with Odin, only CBOR. The reason for
this is that CBOR is pretty much msgpack, so that's our baseline to beat. As can be seen in the
baseline below, we're slightly faster on unpack, but almost four times as fast when packing. A major
difference here could be using bufio.Writer, as the serialization stack is fairly similar otherwise.

### Unpack

| Size      | Proto   | Rounds | (K) Items | Time (ms) | Rounds/s  | Million Items/s | Relative |
|-----------|---------|--------|-----------|-----------|-----------|-----------------|----------|
| `small`   | `cbor`  | 100    | 22        | 10        | 9439.310  | 1.980           | -        |
| `small`   | `mpack` | 100    | 22        | 4         | 22471.107 | 4.715           | 0.42     |
| `medium`  | `cbor`  | 100    | 220       | 59        | 1669.285  | 3.502           | -        |
| `medium`  | `mpack` | 100    | 220       | 45        | 2211.091  | 4.639           | 0.76    |
| `large`   | `cbor`  | 100    | 2200      | 644       | 155.169   | 3.256           | -        |
| `large`   | `mpack` | 100    | 2200      | 525       | 190.218   | 3.991           | 0.82    |
| `massive` | `cbor`  | 100    | 11000     | 3360      | 29.758    | 3.122           | -        |
| `massive` | `mpack` | 100    | 11000     | 2320      | 43.086    | 4.520           | 0.69     |

---

### Pack

| Size      | Proto   | Rounds | KB Processed | Time (ms) | Rounds/s  | MiB/s   | Relative |
|-----------|---------|--------|--------------|-----------|-----------|---------|----------|
| `small`   | `cbor`  | 100    | 923          | 5         | 18360.728 | 161.619 | -        |
| `small`   | `mpack` | 100    | 914          | 1         | 66822.586 | 582.720 | 0.28     |
| `medium`  | `cbor`  | 100    | 9328         | 51        | 1945.698  | 173.089 | -        |
| `medium`  | `mpack` | 100    | 9316         | 14        | 6776.602  | 602.121 | 0.29     |
| `large`   | `cbor`  | 100    | 93535        | 506       | 197.396   | 176.082 | -        |
| `large`   | `mpack` | 100    | 93555        | 132       | 752.674   | 671.546 | 0.26     |
| `massive` | `cbor`  | 100    | 467802       | 2576      | 38.818    | 173.181 | -        |
| `massive` | `mpack` | 100    | 467935       | 679       | 147.208   | 656.926 | 0.26     |
