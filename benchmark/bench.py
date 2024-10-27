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


#   print(
#       f"""\
# JSON
#   dump: {1.0 / elapsed_dump}/s (total: {elapsed_dump})
#   load: {1.0 / elapsed_load}/s (total: {elapsed_load})
#  """
#   )


def repro_msgpack(mesh):
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


def repro_cbor(mesh):
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
    repro_cbor(mesh)
    repro_msgpack(mesh)

    ROUNDS //= 2


for size in ("small", "medium", "large", "massive"):
    repro_testcase(size)
