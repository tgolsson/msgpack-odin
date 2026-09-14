package benchmark

import m "../"
import "core:encoding/cbor"
import "core:encoding/json"
import "core:fmt"
import "core:math/rand"
import "core:mem"
import "core:strings"
import "core:time"
import "core:bytes"
import "core:io"

ROUNDS :: 10000
Vec2 :: [2]f32
Vec3 :: [3]f32
Vec4 :: [4]f32

Vertex :: struct {
	position: Vec3,
	normal:   Vec3,
	uv:       Vec2,
	color:    Vec4,
}


Mesh :: struct {
	vertices: [dynamic]Vertex,
	indices:  [dynamic]u16,
}

generate_mesh :: proc(n_verts, n_tris: u16) -> Mesh {
	vertices := make([dynamic]Vertex, n_verts)
	indices := make([dynamic]u16, n_tris * 3)

	for idx in 0 ..< n_verts {
		vertices[idx] = Vertex {
			position = Vec3 {
				rand.float32_range(-10.0, 10.0),
				rand.float32_range(-10.0, 10.0),
				rand.float32_range(-10.0, 10.0),
			},
			normal   = Vec3 {
				rand.float32_range(-10.0, 10.0),
				rand.float32_range(-10.0, 10.0),
				rand.float32_range(-10.0, 10.0),
			},
			uv       = Vec2{rand.float32_range(0.0, 1.0), rand.float32_range(0.0, 1.0)},
			color    = Vec4 {
				rand.float32_range(0.0, 1.0),
				rand.float32_range(0.0, 1.0),
				rand.float32_range(0.0, 1.0),
				rand.float32_range(0.0, 1.0),
			},
		}
	}

	for idx in 0 ..< n_tris {
		for vert in 0 ..< u16(3) {
			indices[idx * 3 + vert] = u16(rand.uint32()) % n_verts
		}
	}

	return Mesh{vertices, indices}
}

make_mesh :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> (
	err: time.Benchmark_Error,
) {
	vertices := u16((options.bytes >> 16) & 0xFFFF)
	tris := u16(options.bytes & 0xFFFF)
	mesh := generate_mesh(vertices, tris)

	mesh_bytes := make([]u8, size_of(Mesh))
	mem.copy_non_overlapping(raw_data(mesh_bytes), rawptr(&mesh), size_of(Mesh))
	options.input = mesh_bytes[:]

	return nil
}

make_bytes_cbor :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> (
	err: time.Benchmark_Error,
) {
	vertices := u16((options.bytes >> 16) & 0xFFFF)
	tris := u16(options.bytes & 0xFFFF)
	mesh := generate_mesh(vertices, tris)

	mesh_bytes, _ := cbor.marshal_into_bytes(mesh)
	options.input = mesh_bytes[:]

	delete(mesh.vertices)
	delete(mesh.indices)

	return nil
}

make_bytes_mpack :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> (
	err: time.Benchmark_Error,
) {
	vertices := u16((options.bytes >> 16) & 0xFFFF)
	tris := u16(options.bytes & 0xFFFF)
	mesh := generate_mesh(vertices, tris)

	mesh_bytes, perr := m.pack_into_bytes(&mesh, {.FieldNames})
	if perr != nil {
		panic(fmt.aprintfln("err: %v", perr))
	}
	options.input = mesh_bytes[:]

	delete(mesh.vertices)
	delete(mesh.indices)

	return nil
}

make_bytes_json :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> (
	err: time.Benchmark_Error,
) {
	vertices := u16((options.bytes >> 16) & 0xFFFF)
	tris := u16(options.bytes & 0xFFFF)
	mesh := generate_mesh(vertices, tris)

	builder: strings.Builder
	strings.builder_init(&builder)
	merr := json.marshal_to_builder(&builder, mesh, &{})
	if merr != nil {
		panic(fmt.aprintfln("err: %v", merr))
	}
	options.input = builder.buf[:]

	delete(mesh.vertices)
	delete(mesh.indices)

	return nil
}

destroy_mesh :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> (
	err: time.Benchmark_Error,
) {
	mesh: Mesh
	mem.copy_non_overlapping(rawptr(&mesh), raw_data(options.input), size_of(Mesh))

	delete(mesh.indices)
	delete(mesh.vertices)
	delete(options.input)

	return nil
}


bench_cbor_marshal :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> (
	err: time.Benchmark_Error,
) {

	mesh: Mesh
	mem.copy_non_overlapping(rawptr(&mesh), raw_data(options.input), size_of(Mesh))

	bytes := 0
	for _ in 0 ..< options.rounds {
		b, err := cbor.marshal_into_bytes(mesh)
		assert(err == nil, fmt.aprintfln("%v", err))
		bytes += len(b)
		delete(b)
	}

	options.processed = bytes
	options.count = options.rounds
	return nil
}

bench_mpack_pack :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> (
	err: time.Benchmark_Error,
) {
	mesh: Mesh
	mem.copy_non_overlapping(rawptr(&mesh), raw_data(options.input), size_of(Mesh))

	bytes := 0
	for _ in 0 ..< options.rounds {
		b, err := m.pack_into_bytes(&mesh, {.FieldNames})
		assert(err == nil)
		bytes += len(b)
		delete(b)
	}

	options.processed = bytes
	options.count = options.rounds
	return nil
}

bench_json_marshal :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> (
	err: time.Benchmark_Error,
) {

	mesh: Mesh
	mem.copy_non_overlapping(rawptr(&mesh), raw_data(options.input), size_of(Mesh))

	bytes := 0
	builder: strings.Builder
	strings.builder_init(&builder)
	for _ in 0 ..< options.rounds {

		err := json.marshal_to_builder(&builder, mesh, &{})
		assert(err == nil, fmt.aprintfln("%v", err))
		bytes += len(builder.buf)
		strings.builder_reset(&builder)
	}

	options.processed = bytes
	options.count = options.rounds
	return nil
}

bench_cbor_unmarshal :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> (
	err: time.Benchmark_Error,
) {

	total_bytes := 0

	for _ in 0 ..< options.rounds {
		m: Mesh
		reader := new(bytes.Reader, allocator)
		stream := bytes.reader_init(reader, options.input)
		io_reader := io.to_reader(stream)

		err := cbor.unmarshal_from_reader(io_reader, &m)
		assert(err == nil)
		total_bytes += len(m.indices) + len(m.vertices)

		free(reader)
		delete(m.indices)
		delete(m.vertices)
	}

	options.processed = total_bytes
	options.count = options.rounds
	return nil
}


bench_json_unmarshal :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> (
	err: time.Benchmark_Error,
) {

	total_bytes := 0

	for _ in 0 ..< options.rounds {
		m: Mesh
		err := json.unmarshal(options.input, &m)
		assert(err == nil)
		total_bytes += len(m.indices) + len(m.vertices)

		delete(m.indices)
		delete(m.vertices)
	}

	options.processed = total_bytes
	options.count = options.rounds
	return nil
}

bench_mpack_unpack :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> (
	err: time.Benchmark_Error,
) {
	bytes := 0
	for _ in 0 ..< options.rounds {
		mesh: Mesh
		err := m.unpack_into_from_bytes(options.input, &mesh)
		assert(err == nil, fmt.aprintfln("%v", err))
		bytes += len(mesh.indices) + len(mesh.vertices)

		delete(mesh.indices)
		delete(mesh.vertices)
	}

	options.processed = bytes
	options.count = options.rounds
	return nil
}

destroy_bytes :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> (
	err: time.Benchmark_Error,
) {
	delete(options.input)
	return nil
}

benchmark_print :: proc(
	str: ^strings.Builder,
	name: string,
	options: ^time.Benchmark_Options,
	loc := #caller_location,
) {
	fmt.sbprintfln(
		str,
		"[%v] %v rounds, %v K(B/items) processed in %v ms\n\t\t%5.3f rounds/s, %5.3f MiB/s\n",
		name,
		options.rounds,
		options.processed / 1e3,
		time.duration_nanoseconds(options.duration) / 1e6,
		options.rounds_per_second,
		options.megabytes_per_second,
	)
}

bench_pack :: proc() {
	str: strings.Builder
	strings.builder_init(&str, context.allocator)
	defer {
		fmt.println(strings.to_string(str))
		strings.builder_destroy(&str)
	}

	small_cbor := time.Benchmark_Options {
		setup    = make_mesh,
		bench    = bench_cbor_marshal,
		teardown = destroy_mesh,
		rounds   = ROUNDS,
		bytes    = (100 << 16 | 40),
	}
	err := time.benchmark(&small_cbor)
	benchmark_print(&str, "small_cbor_pack", &small_cbor)


	medium_cbor := time.Benchmark_Options {
		setup    = make_mesh,
		bench    = bench_cbor_marshal,
		teardown = destroy_mesh,
		rounds   = ROUNDS,
		bytes    = (1000 << 16 | 400),
	}
	err = time.benchmark(&medium_cbor)
	benchmark_print(&str, "medium_cbor_pack", &medium_cbor)

	large_cbor := time.Benchmark_Options {
		setup    = make_mesh,
		bench    = bench_cbor_marshal,
		teardown = destroy_mesh,
		rounds   = ROUNDS,
		bytes    = (10000 << 16 | 4000),
	}
	err = time.benchmark(&large_cbor)
	benchmark_print(&str, "large_cbor_pack", &large_cbor)

	massive_cbor := time.Benchmark_Options {
		setup    = make_mesh,
		bench    = bench_cbor_marshal,
		teardown = destroy_mesh,
		rounds   = ROUNDS,
		bytes    = (50000 << 16 | 20000),
	}
	err = time.benchmark(&massive_cbor)
	benchmark_print(&str, "massive_cbor_pack", &massive_cbor)


	small_json := time.Benchmark_Options {
		setup    = make_mesh,
		bench    = bench_json_marshal,
		teardown = destroy_mesh,
		rounds   = ROUNDS,
		bytes    = (100 << 16 | 40),
	}
	err = time.benchmark(&small_json)
	benchmark_print(&str, "small_json_pack", &small_json)


	medium_json := time.Benchmark_Options {
		setup    = make_mesh,
		bench    = bench_json_marshal,
		teardown = destroy_mesh,
		rounds   = ROUNDS,
		bytes    = (1000 << 16 | 400),
	}
	err = time.benchmark(&medium_json)
	benchmark_print(&str, "medium_json_pack", &medium_json)

	large_json := time.Benchmark_Options {
		setup    = make_mesh,
		bench    = bench_json_marshal,
		teardown = destroy_mesh,
		rounds   = ROUNDS,
		bytes    = (10000 << 16 | 4000),
	}
	err = time.benchmark(&large_json)
	benchmark_print(&str, "large_json_pack", &large_json)

	massive_json := time.Benchmark_Options {
		setup    = make_mesh,
		bench    = bench_json_marshal,
		teardown = destroy_mesh,
		rounds   = ROUNDS,
		bytes    = (50000 << 16 | 20000),
	}
	err = time.benchmark(&massive_json)
	benchmark_print(&str, "massive_json_pack", &massive_json)

	small_mpack := time.Benchmark_Options {
		setup    = make_mesh,
		bench    = bench_mpack_pack,
		teardown = destroy_mesh,
		rounds   = ROUNDS,
		bytes    = (100 << 16 | 40),
	}
	err = time.benchmark(&small_mpack)
	benchmark_print(&str, "small_mpack_pack", &small_mpack)

	medium_mpack := time.Benchmark_Options {
		setup    = make_mesh,
		bench    = bench_mpack_pack,
		teardown = destroy_mesh,
		rounds   = ROUNDS,
		bytes    = (1000 << 16 | 400),
	}

	err = time.benchmark(&medium_mpack)
	benchmark_print(&str, "medium_mpack_pack", &medium_mpack)

	large_mpack := time.Benchmark_Options {
		setup    = make_mesh,
		bench    = bench_mpack_pack,
		teardown = destroy_mesh,
		rounds   = ROUNDS,
		bytes    = (10000 << 16 | 4000),
	}
	err = time.benchmark(&large_mpack)
	benchmark_print(&str, "large_mpack_pack", &large_mpack)

	massive_mpack := time.Benchmark_Options {
		setup    = make_mesh,
		bench    = bench_mpack_pack,
		teardown = destroy_mesh,
		rounds   = ROUNDS,
		bytes    = (50000 << 16 | 20000),
	}

	err = time.benchmark(&massive_mpack)
	benchmark_print(&str, "massive_mpack_pack", &massive_mpack)

	assert(err == nil)
}

bench_unpack :: proc() {
	str: strings.Builder
	strings.builder_init(&str, context.allocator)
	defer {
		fmt.println(strings.to_string(str))
		strings.builder_destroy(&str)
	}

	small_mpack := time.Benchmark_Options {
		setup    = make_bytes_mpack,
		bench    = bench_mpack_unpack,
		teardown = destroy_bytes,
		rounds   = ROUNDS,
		bytes    = (100 << 16 | 40),
	}
	err := time.benchmark(&small_mpack)
	benchmark_print(&str, "small_mpack_unpack", &small_mpack)

	medium_mpack := time.Benchmark_Options {
		setup    = make_bytes_mpack,
		bench    = bench_mpack_unpack,
		teardown = destroy_bytes,
		rounds   = ROUNDS,
		bytes    = (1000 << 16 | 400),
	}
	err = time.benchmark(&medium_mpack)
	benchmark_print(&str, "medium_mpack_unpack", &medium_mpack)

	// large_mpack := time.Benchmark_Options {
	// 	setup    = make_bytes_mpack,
	// 	bench    = bench_mpack_unpack,
	// 	teardown = destroy_bytes,
	// 	rounds   = ROUNDS,
	// 	bytes    = (10000 << 16 | 4000),
	// }
	// err = time.benchmark(&large_mpack)
	// benchmark_print(&str, "large_mpack_unpack", &large_mpack)
	// assert(err == nil)

	// massive_mpack := time.Benchmark_Options {
	// 	setup    = make_bytes_mpack,
	// 	bench    = bench_mpack_unpack,
	// 	teardown = destroy_bytes,
	// 	rounds   = ROUNDS,
	// 	bytes    = (50000 << 16 | 20000),
	// }
	// err = time.benchmark(&massive_mpack)
	// benchmark_print(&str, "massive_mpack_unpack", &massive_mpack)
	// assert(err == nil)

	// small_cbor := time.Benchmark_Options {
	// 	setup    = make_bytes_cbor,
	// 	bench    = bench_cbor_unmarshal,
	// 	teardown = destroy_bytes,
	// 	rounds   = ROUNDS,
	// 	bytes    = (100 << 16 | 40),
	// }
	// err = time.benchmark(&small_cbor)
	// benchmark_print(&str, "small_cbor_unpack", &small_cbor)

	// medium_cbor := time.Benchmark_Options {
	// 	setup    = make_bytes_cbor,
	// 	bench    = bench_cbor_unmarshal,
	// 	teardown = destroy_bytes,
	// 	rounds   = ROUNDS,
	// 	bytes    = (1000 << 16 | 400),
	// }
	// err = time.benchmark(&medium_cbor)
	// benchmark_print(&str, "medium_cbor_unpack", &medium_cbor)


	// large_cbor := time.Benchmark_Options {
	// 	setup    = make_bytes_cbor,
	// 	bench    = bench_cbor_unmarshal,
	// 	teardown = destroy_bytes,
	// 	rounds   = ROUNDS,
	// 	bytes    = (10000 << 16 | 4000),
	// }
	// err = time.benchmark(&large_cbor)
	// benchmark_print(&str, "large_cbor_unpack", &large_cbor)

	// massive_cbor := time.Benchmark_Options {
	// 	setup    = make_bytes_cbor,
	// 	bench    = bench_cbor_unmarshal,
	// 	teardown = destroy_bytes,
	// 	rounds   = ROUNDS,
	// 	bytes    = (50000 << 16 | 20000),
	// }
	// err = time.benchmark(&massive_cbor)
	// benchmark_print(&str, "massive_cbor_unpack", &massive_cbor)


	// small_json := time.Benchmark_Options {
	// 	setup    = make_bytes_json,
	// 	bench    = bench_json_unmarshal,
	// 	teardown = destroy_bytes,
	// 	rounds   = ROUNDS,
	// 	bytes    = (100 << 16 | 40),
	// }
	// err = time.benchmark(&small_json)
	// benchmark_print(&str, "small_json_unpack", &small_json)

	// medium_json := time.Benchmark_Options {
	// 	setup    = make_bytes_json,
	// 	bench    = bench_json_unmarshal,
	// 	teardown = destroy_bytes,
	// 	rounds   = ROUNDS,
	// 	bytes    = (1000 << 16 | 400),
	// }
	// err = time.benchmark(&medium_json)
	// benchmark_print(&str, "medium_json_unpack", &medium_json)


	// large_json := time.Benchmark_Options {
	// 	setup    = make_bytes_json,
	// 	bench    = bench_json_unmarshal,
	// 	teardown = destroy_bytes,
	// 	rounds   = ROUNDS,
	// 	bytes    = (10000 << 16 | 4000),
	// }
	// err = time.benchmark(&large_json)
	// benchmark_print(&str, "large_json_unpack", &large_json)

	// massive_json := time.Benchmark_Options {
	// 	setup    = make_bytes_json,
	// 	bench    = bench_json_unmarshal,
	// 	teardown = destroy_bytes,
	// 	rounds   = ROUNDS,
	// 	bytes    = (50000 << 16 | 20000),
	// }
	// err = time.benchmark(&massive_json)
	// benchmark_print(&str, "massive_json_unpack", &massive_json)

}
import "core:os"
main :: proc() {
	{
		mesh := generate_mesh(100, 40)
		defer delete(mesh.vertices)
		defer delete(mesh.indices)
		file, _ := os.open("small.mp", os.O_CREATE | os.O_WRONLY | os.O_TRUNC, os.Permissions_Default_File)
		defer os.close(file)
		stream := os.to_stream(file)
		m.pack_into_writer(stream, &mesh, {.UnionNames, .FieldNames})
	}
	{
		mesh := generate_mesh(1000, 400)
		defer delete(mesh.vertices)
		defer delete(mesh.indices)
		file, _ := os.open("medium.mp", os.O_CREATE | os.O_WRONLY | os.O_TRUNC, os.Permissions_Default_File)
		defer os.close(file)
		stream := os.to_stream(file)
		m.pack_into_writer(stream, &mesh, {.UnionNames, .FieldNames})
	}
	{
		mesh := generate_mesh(10000, 4000)
		defer delete(mesh.vertices)
		defer delete(mesh.indices)

		file, _ := os.open("large.mp", os.O_CREATE | os.O_WRONLY | os.O_TRUNC, os.Permissions_Default_File)
		defer os.close(file)

		stream := os.to_stream(file)
		m.pack_into_writer(stream, &mesh, {.UnionNames, .FieldNames})
	}
	{
		mesh := generate_mesh(50000, 20000)
		defer delete(mesh.vertices)
		defer delete(mesh.indices)

		file, _ := os.open("massive.mp", os.O_CREATE | os.O_WRONLY | os.O_TRUNC, os.Permissions_Default_File)
		defer os.close(file)

		stream := os.to_stream(file)
		m.pack_into_writer(stream, &mesh, {.UnionNames, .FieldNames})
	}


		bench_unpack()
	// bench_pack()
}
