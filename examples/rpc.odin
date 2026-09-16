package rpc_example

import m "../"
import rpc_ext "../ext/rpc"
import "core:fmt"
import "core:io"
import "core:net"
import "core:os"
import "core:strconv"

Hello :: struct {
	name: string,
}

Goodbye :: struct {
	total_ticks: i64,
}

Tick :: struct {}

Rpc :: union {
	Hello,
	Goodbye,
	Tick,
}

main :: proc() {
	port := 11223
	if len(os.args) > 1 {
		parsed, ok := strconv.parse_int(os.args[1], 10)
		if !ok || parsed < 1 || parsed > 65535 {
			fmt.eprintfln("invalid port: %v", os.args[1])
			os.exit(1)
		}
		port = parsed
	}

	address := fmt.tprintf("localhost:%d", port)
	socket, err := net.dial_tcp(address)
	if err != nil {
		fmt.eprintfln("failed connection: %w", err)
		os.exit(1)
	}
	defer net.close(socket)

	// configure socket
	err = net.set_blocking(socket, true)
	if err != nil {
		fmt.eprintfln("failed configuring socket: %w", err)
		os.exit(1)
	}

	stream := unbuffered_stream_from_socket(socket)
	writer: io.Writer
	reader, ok := io.to_reader(stream)
	if !ok {
		fmt.eprintfln("failed creating reader: %w", err)
		os.exit(1)
	}

	writer, ok = io.to_writer(stream)
	if !ok {
		fmt.eprintfln("failed creating writer: %w", err)
		os.exit(1)
	}

	unpacker := m.unpacker_from_reader(reader)
	defer m.unpacker_destroy(unpacker)

	dispatcher: rpc_ext.Dispatcher(Rpc, Rpc_State)
	if !rpc_ext.register_handler(&dispatcher, handle_hello) {
		fmt.eprintln("failed registering Hello handler")
		os.exit(1)
	}
	if !rpc_ext.register_handler(&dispatcher, handle_goodbye) {
		fmt.eprintln("failed registering Goodbye handler")
		os.exit(1)
	}

	state := Rpc_State{}

	hello: Rpc = Hello{"world"}
	pack_err := m.pack_into_writer(writer, hello, {.UnionNames, .FieldNames})
	if pack_err != nil {
		fmt.eprintfln("failed packing Hello request: %w", pack_err)
		os.exit(1)
	}

	hello_response: Rpc
	unpack_err := m.read_into(&unpacker, &hello_response)
	if unpack_err != nil {
		fmt.eprintfln("failed unpacking Hello response: %w", unpack_err)
		os.exit(1)
	}

	dispatch_err := rpc_ext.dispatch(&dispatcher, hello_response, &state)
	if dispatch_err != nil {
		fmt.eprintfln("failed dispatching Hello response: %v", dispatch_err)
		os.exit(1)
	}
	fmt.println("completed Hello round trip")

	goodbye: Rpc = Goodbye{29}
	pack_err = m.pack_into_writer(writer, goodbye, {.UnionNames, .FieldNames})
	if pack_err != nil {
		fmt.eprintfln("failed packing Goodbye request: %w", pack_err)
		os.exit(1)
	}

	goodbye_response: Rpc
	unpack_err = m.read_into(&unpacker, &goodbye_response)
	if unpack_err != nil {
		fmt.eprintfln("failed unpacking Goodbye response: %w", unpack_err)
		os.exit(1)
	}

	dispatch_err = rpc_ext.dispatch(&dispatcher, goodbye_response, &state)
	if dispatch_err != nil {
		fmt.eprintfln("failed dispatching Goodbye response: %v", dispatch_err)
		os.exit(1)
	}
	fmt.println("completed Goodbye round trip")
}

Rpc_State :: struct {
	hello_name:    string,
	goodbye_ticks: i64,
}

handle_hello :: proc(state: ^Rpc_State, value: Hello) -> rpc_ext.Dispatch_Error {
	if value.name != "from python" {
		return rpc_ext.Dispatch_Invalid_Parameter{"unexpected Hello response"}
	}
	state.hello_name = value.name
	return nil
}

handle_goodbye :: proc(state: ^Rpc_State, value: Goodbye) -> rpc_ext.Dispatch_Error {
	if value.total_ticks != 29 {
		return rpc_ext.Dispatch_Invalid_Parameter{"unexpected Goodbye response"}
	}
	state.goodbye_ticks = value.total_ticks
	return nil
}

unbuffered_stream_from_socket :: proc(skt: net.TCP_Socket) -> io.Stream {
	s: io.Stream
	s.data = rawptr(uintptr(skt))
	s.procedure = tcp_socket_stream_proc
	return s
}

tcp_socket_stream_proc :: proc(
	stream_data: rawptr,
	mode: io.Stream_Mode,
	p: []byte,
	offset: i64,
	whence: io.Seek_From,
) -> (
	n: i64,
	err: io.Error,
) {
	skt := net.TCP_Socket(uintptr(stream_data))
	switch mode {
	case .Close:
		net.close(skt)
		return 0, nil

	case .Read:
		num_recvd, net_err := net.recv_tcp(skt, p)
		return i64(num_recvd), .Unknown if net_err != nil else .None

	case .Write:
		num_sent, net_err := net.send_tcp(skt, p)
		return i64(num_sent), .Unknown if net_err != nil else .None

	case .Query:
		// query what modes are available
		response: io.Stream_Mode_Set = {.Read, .Write, .Close, .Query}
		return transmute(i64)response, nil

	// unsupported
	case .Read_At:
	case .Flush:
	case .Write_At:
	case .Seek:
	case .Size:
	case .Destroy:
	}

	return 0, nil
}
