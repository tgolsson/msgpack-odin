package rpc

import "core:net"
import m "../"
import "core:fmt"

Hello :: struct {
	name: string,
}

Goodbye :: struct {
	total_ticks: i64
}

Tick :: struct {}

Rpc :: union {
	Hello,
	Goodbye,
	Tick
}

main ::  proc() {
	socket, err := net.dial_tcp("localhost:11223")
	if err != nil {
		fmt.eprintfln("failed connection: %w", err)
		return
	}

	{
		data: Rpc = Hello { "world" }
		bytes, err := m.pack_into_bytes(data, {.UnionNames})
		if err != nil {
			fmt.eprintfln("failed serialization: %w", err)
			return
		}
		defer delete(bytes)

		n, e := net.send(socket, bytes)
		fmt.println("Sent", n, "bytes")
		if e != nil {
			fmt.eprintfln("failed serialization: %w", e)
			return
		}
	}

	{
		out_bytes := [100]u8{}
		n_bytes, _, err := net.recv_any(socket, out_bytes[:])

		if err != nil {
			panic("foo")
		}

		response: Rpc
		u := m.Unpacker { raw_data(out_bytes[:]), 0 }
		m.read_into(&u, &response)

		fmt.println(response)
	}

	net.close(socket)
}
