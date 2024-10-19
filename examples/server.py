import socket
import socketserver

import msgpack


class MyTCPHandler(socketserver.BaseRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.ticks = 0

    def handle(self):
        print("Got message!")

        with self.request.makefile("rb") as f:
            data = msgpack.unpackb(f.read(19))
        print("Received from {}:".format(self.client_address[0]))

        key, data = next(iter(data.items()))
        match key:
            case "Hello":
                print("Hello,", data["name"])

        # just send back the same data, but upper-cased
        self.request.sendall(msgpack.packb({"Hello": {"name": "from python"}}))


socketserver.TCPServer.allow_reuse_address = True
server = socketserver.TCPServer(("", 11223), MyTCPHandler)

with server as s:
    s.serve_forever()
