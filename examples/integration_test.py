import argparse
import os
import socket
import subprocess
import sys
import time


def choose_port():
    with socket.socket() as probe:
        probe.bind(("127.0.0.1", 0))
        return probe.getsockname()[1]


def sandbox_path(path):
    if os.path.isabs(path):
        return path
    sandbox_root = os.environ.get("IMP_SANDBOX_ROOT")
    if sandbox_root:
        return os.path.join(sandbox_root, path)
    return path


def stop_server(server):
    if server.poll() is None:
        server.terminate()
    try:
        return server.communicate(timeout=3)
    except subprocess.TimeoutExpired:
        server.kill()
        return server.communicate()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--client", required=True)
    parser.add_argument("--server", required=True)
    args = parser.parse_args()

    port = choose_port()
    server = subprocess.Popen(
        [sys.executable, sandbox_path(args.server), "--port", str(port)],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        bufsize=1,
    )

    failure = None
    try:
        deadline = time.monotonic() + 10
        while time.monotonic() < deadline:
            if server.poll() is not None:
                raise AssertionError("server exited before becoming ready")
            try:
                with socket.create_connection(("127.0.0.1", port), timeout=0.2):
                    break
            except OSError:
                time.sleep(0.05)
        else:
            raise AssertionError("server did not become ready before timeout")

        client = subprocess.run(
            [sandbox_path(args.client), str(port)],
            capture_output=True,
            text=True,
            timeout=10,
            check=False,
        )
        if client.returncode != 0:
            raise AssertionError(
                f"client failed with {client.returncode}\n"
                f"stdout: {client.stdout}\nstderr: {client.stderr}"
            )
        if "completed Hello round trip" not in client.stdout:
            raise AssertionError(f"Hello round trip missing from output: {client.stdout}")
        if "completed Goodbye round trip" not in client.stdout:
            raise AssertionError(f"Goodbye round trip missing from output: {client.stdout}")
    except Exception as error:
        failure = error
    finally:
        server_stdout, server_stderr = stop_server(server)

    if failure is not None:
        raise AssertionError(
            f"{failure}\nserver stdout: {server_stdout}\nserver stderr: {server_stderr}"
        ) from failure


if __name__ == "__main__":
    main()
