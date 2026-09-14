
gentest:
    ./msgpack.pex gentest.py

test: gentest
    odin test tests

perf:
    odin build benchmark -o:speed --debug
    /usr/lib/linux-tools-5.15.0-79/perf record  --call-graph dwarf  ./benchmark.bin

report: perf
    /usr/lib/linux-tools-5.15.0-79/perf report --children -G --no-inline

hotspot: perf
    hotspot perf.data

pex:
   pex msgpack cbor orjson pandas tabulate matplotlib -o msgpack.pex
