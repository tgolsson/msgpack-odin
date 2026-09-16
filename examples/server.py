import argparse
import socketserver
import sys

import msgpack


class MyTCPHandler(socketserver.BaseRequestHandler):
    def handle(self):
        unpacker = msgpack.Unpacker(raw=False)
        try:
            while True:
                chunk = self.request.recv(4096)
                if not chunk:
                    break
                unpacker.feed(chunk)
                for message in unpacker:
                    response = response_for(message)
                    payload = msgpack.packb(response, use_bin_type=True)
                    self.request.sendall(payload)
        except Exception as error:  # noqa: BLE001 - surface protocol failures
            print(f"RPC protocol error: {error}", file=sys.stderr, flush=True)


def response_for(message):
    if not isinstance(message, dict) or len(message) != 1:
        raise ValueError("expected a one-variant RPC map")

    key, value = next(iter(message.items()))
    if key == "Hello":
        if not isinstance(value, dict) or not isinstance(value.get("name"), str):
            raise ValueError("invalid Hello payload")
        print(f"Hello, {value['name']}", flush=True)
        return {"Hello": {"name": "from python"}}

    if key == "Goodbye":
        if not isinstance(value, dict) or not isinstance(value.get("total_ticks"), int):
            raise ValueError("invalid Goodbye payload")
        print(f"Goodbye, {value['total_ticks']}", flush=True)
        return {"Goodbye": {"total_ticks": value["total_ticks"]}}

    raise ValueError(f"unsupported RPC variant: {key!r}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--port", type=int, default=11223)
    args = parser.parse_args()

    socketserver.TCPServer.allow_reuse_address = True
    server = socketserver.TCPServer(("127.0.0.1", args.port), MyTCPHandler)
    print(f"RPC server listening on {args.port}", flush=True)
    with server:
        server.serve_forever()


if __name__ == "__main__":
    main()
