package tests

import m "../"
import "core:fmt"
import "core:math/rand"
import "core:mem"
import "core:strings"
import "core:time"
import "core:bytes"
import "core:io"
import "core:testing"

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


make_bytes_mpack :: proc(
	options: ^time.Benchmark_Options,
	allocator := context.allocator,
) -> (
	err: time.Benchmark_Error,
) {
	vertices := u16((options.bytes >> 16) & 0xFFFF)
	tris := u16(options.bytes & 0xFFFF)
	mesh := generate_mesh(vertices, tris)

	mesh_bytes, _ := m.pack_into_bytes(&mesh, {})
	options.input = mesh_bytes[:]
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
		b, _ := m.pack_into_bytes(&mesh, {})
		assert(err == nil)
		bytes += len(b)
		delete(b)
	}

	options.processed = bytes
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
		bytes += len(options.input)

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
		"[%v] %v rounds, %v MB processed in %v ms\n\t\t%5.3f rounds/s, %5.3f MiB/s\n",
		name,
		options.rounds,
		options.processed / 1e6,
		time.duration_nanoseconds(options.duration) / 1e6,
		options.rounds_per_second,
		options.megabytes_per_second,
	)
}

when false {

	@(test)
	bench_pack :: proc(t: ^testing.T) {
		str: strings.Builder
		strings.builder_init(&str, context.allocator)
		defer {
			fmt.println(strings.to_string(str))
			strings.builder_destroy(&str)
		}

		small_mpack := time.Benchmark_Options {
			setup    = make_mesh,
			bench    = bench_mpack_pack,
			teardown = destroy_mesh,
			rounds   = 10,
			bytes    = (100 << 16 | 40),
		}
		err := time.benchmark(&small_mpack)
		benchmark_print(&str, "small_mpack", &small_mpack)

		medium_mpack := time.Benchmark_Options {
			setup    = make_mesh,
			bench    = bench_mpack_pack,
			teardown = destroy_mesh,
			rounds   = 10,
			bytes    = (1000 << 16 | 400),
		}

		err = time.benchmark(&medium_mpack)
		benchmark_print(&str, "medium_mpack", &medium_mpack)

		large_mpack := time.Benchmark_Options {
			setup    = make_mesh,
			bench    = bench_mpack_pack,
			teardown = destroy_mesh,
			rounds   = 10,
			bytes    = (10000 << 16 | 4000),
		}
		err = time.benchmark(&large_mpack)
		benchmark_print(&str, "large_mpack", &large_mpack)


		assert(err == nil)
	}

	@(test)
	bench_unpack :: proc(t: ^testing.T) {
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
			rounds   = 10,
			bytes    = (100 << 16 | 40),
		}
		err := time.benchmark(&small_mpack)
		benchmark_print(&str, "small_mpack", &small_mpack)

		medium_mpack := time.Benchmark_Options {
			setup    = make_bytes_mpack,
			bench    = bench_mpack_unpack,
			teardown = destroy_bytes,
			rounds   = 10,
			bytes    = (1000 << 16 | 400),
		}
		err = time.benchmark(&medium_mpack)
		benchmark_print(&str, "medium_mpack", &medium_mpack)

		large_mpack := time.Benchmark_Options {
			setup    = make_bytes_mpack,
			bench    = bench_mpack_unpack,
			teardown = destroy_bytes,
			rounds   = 10,
			bytes    = (10000 << 16 | 4000),
		}
		err = time.benchmark(&large_mpack)
		benchmark_print(&str, "large_mpack", &large_mpack)


		assert(err == nil)
	}
}
