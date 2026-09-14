import time

import cbor
import msgpack
import orjson

ROUNDS = 100


def repro_json(mesh, size):
    start = time.perf_counter()

    b = 0
    for _ in range(ROUNDS):
        json_data = orjson.dumps(mesh)
        b += len(json_data)

    elapsed_dump = time.perf_counter() - start

    start = time.perf_counter()

    items = 0
    for _ in range(ROUNDS):
        mesh = orjson.loads(json_data)
        items += len(mesh["vertices"]) + len(mesh["indices"])
    elapsed_load = time.perf_counter() - start

    print(
        f"[{size}_json_pack] {ROUNDS} rounds, {int(b // 1000)} K(B/items) processed in {int(elapsed_dump * 1000)} ms\n\t\t{ROUNDS / elapsed_dump:5.3f} rounds/s, {(b / 1e6) / elapsed_dump} MiB/s\n",
    )

    print(
        f"[{size}_json_unpack] {ROUNDS} rounds, {items // 1000} K(B/items) processed in {int(elapsed_load * 1000)} ms\n\t\t{ROUNDS / elapsed_load:5.3f} rounds/s, {(b / 1e6) / elapsed_load} MiB/s\n",
    )


def repro_stdjson(mesh, size):
    import json

    start = time.perf_counter()

    b = 0
    for _ in range(ROUNDS):
        json_data = json.dumps(mesh)
        b += len(json_data)

    elapsed_dump = time.perf_counter() - start

    start = time.perf_counter()

    items = 0
    for _ in range(ROUNDS):
        mesh = json.loads(json_data)
        items += len(mesh["vertices"]) + len(mesh["indices"])
    elapsed_load = time.perf_counter() - start

    print(
        f"[{size}_stdjson_pack] {ROUNDS} rounds, {int(b // 1000)} K(B/items) processed in {int(elapsed_dump * 1000)} ms\n\t\t{ROUNDS / elapsed_dump:5.3f} rounds/s, {(b / 1e6) / elapsed_dump} MiB/s\n",
    )

    print(
        f"[{size}_stdjson_unpack] {ROUNDS} rounds, {items // 1000} K(B/items) processed in {int(elapsed_load * 1000)} ms\n\t\t{ROUNDS / elapsed_load:5.3f} rounds/s, {(b / 1e6) / elapsed_load} MiB/s\n",
    )


def repro_msgpack(mesh, size):
    start = time.perf_counter()

    b = 0
    for _ in range(ROUNDS):
        data = msgpack.packb(mesh)
        b += len(data)
    elapsed_dump = time.perf_counter() - start

    start = time.perf_counter()

    items = 0
    for _ in range(ROUNDS):
        mesh = msgpack.unpackb(data)
        items += len(mesh["vertices"]) + len(mesh["indices"])
    elapsed_load = time.perf_counter() - start

    print(
        f"[{size}_mpack_pack] {ROUNDS} rounds, {int(b // 1000)} K(B/items) processed in {int(elapsed_dump * 1000)} ms\n\t\t{ROUNDS / elapsed_dump:5.3f} rounds/s, {(b / 1e6) / elapsed_dump} MiB/s\n",
    )

    print(
        f"[{size}_mpack_unpack] {ROUNDS} rounds, {items // 1000} K(B/items) processed in {int(elapsed_load * 1000)} ms\n\t\t{ROUNDS / elapsed_load:5.3f} rounds/s, {(b / 1e6) / elapsed_load} MiB/s\n",
    )


def repro_cbor(mesh, size):
    start = time.perf_counter()

    b = 0
    for _ in range(ROUNDS):
        data = cbor.dumps(mesh)
        b += len(data)

    elapsed_dump = time.perf_counter() - start

    start = time.perf_counter()

    items = 0
    for _ in range(ROUNDS):
        mesh = cbor.loads(data)
        items += len(mesh["vertices"]) + len(mesh["indices"])
    elapsed_load = time.perf_counter() - start

    print(
        f"[{size}_cbor_pack] {ROUNDS} rounds, {int(b // 1000)} K(B/items) processed in {int(elapsed_dump * 1000)} ms\n\t\t{ROUNDS / elapsed_dump:5.3f} rounds/s, {(b / 1e6) / elapsed_dump} MiB/s\n",
    )

    print(
        f"[{size}_cbor_unpack] {ROUNDS} rounds, {items // 1000} K(B/items) processed in {int(elapsed_load * 1000)} ms\n\t\t{ROUNDS / elapsed_load:5.3f} rounds/s, {(b / 1e6) / elapsed_load} MiB/s\n",
    )


def repro_testcase(size):
    with open(f"{size}.mp", "rb") as f:
        data = f.read()

    mesh = msgpack.unpackb(data)

    global ROUNDS

    repro_json(mesh, size)
    repro_stdjson(mesh, size)
    repro_cbor(mesh, size)
    repro_msgpack(mesh, size)

    ROUNDS //= 2


for size in ("small", "medium", "large", "massive"):
    repro_testcase(size)
