package rpc

import m "../"
import "core:fmt"
import "core:io"
import "core:net"

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
	socket, err := net.dial_tcp("localhost:11223")
	if err != nil {
		fmt.eprintfln("failed connection: %w", err)
		return
	}


	// configure socket
	err = net.set_blocking(socket, true)
	if err != nil {
		panic("cannot block")
	}

	stream := unbuffered_stream_from_socket(socket)
	writer: io.Writer
	reader, ok := io.to_reader(stream)
	if !ok {
		fmt.eprintfln("failed creating reader: %w", err)
		return
	}

	writer, ok = io.to_writer(stream)
	if !ok {
		fmt.eprintfln("failed creating writer: %w", err)
		return
	}

	{

		data: Rpc = Hello{"world"}
		err := m.pack_into_writer(writer, data, {.UnionNames})
		if err != nil {
			fmt.eprintfln("failed sending: %w", err)
			return
		}
	}

	{
		response: Rpc
		m.unpack_into_from_reader(reader, &response)
		fmt.println(response)
	}

	net.close(socket)
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
