# msgpack-odin

This contains a pure Odin implementation of the msgpack spec, including timestamps. There is
currently no support for any extensions. If this is a need you have, I'd suggest using a binary
field and packing your data there. Having ext types makes the unpacker/packer more complex, for no
good reason.

A few notes on compatibility:

* Integers are packed into the smallest possible variant
* ~Floats are packed as is and deserialized as is~ TODO: Fix.
* `[]u8` and friends are packed as Array[Number]. This is also true for `[]byte`, which is a soft alias for the former. For true binary data, use `[]m.bin` or `m.binary`.
* Packing internally uses a `bufio.Writer`. `pack_into_from_` will flush this, but manual packing requires flushing this explicitly.

# Performance

I haven't measured against every encoding shipped by default with Odin, only CBOR. The reason for this is that CBOR is pretty much msgpack, so that's our baseline to beat.

### Unpack

| Size      | Proto   | Rounds | (K) Items | Time (ms) | Rounds/s  | Million Items/s | Relative |
|-----------|---------|--------|-----------|-----------|-----------|-----------------|----------|
| `small`   | `cbor`  | 100    | 22        | 6         | 16339.704 | 3.428           | -        |
| `small`   | `mpack` | 100    | 22        | 5         | 19227.855 | 4.034           | 0.85     |
| `medium`  | `cbor`  | 100    | 220       | 62        | 1611.088  | 3.380           | -        |
| `medium`  | `mpack` | 100    | 220       | 52        | 1889.998  | 3.965           | 0.852    |
| `large`   | `cbor`  | 100    | 2200      | 680       | 146.922   | 3.083           | -        |
| `large`   | `mpack` | 100    | 2200      | 545       | 183.359   | 3.847           | 0.801    |
| `massive` | `cbor`  | 100    | 11000     | 3154      | 31.700    | 3.325           | -        |
| `massive` | `mpack` | 100    | 11000     | 2586      | 38.661    | 4.056           | 0.82     |

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
