gentest:
    ./msgpack.pex gentest.py

test: gentest
    odin test tests
