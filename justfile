gentest:
    ./msgpack.pex gentest.py

test: gentest
    odin test tests

perf:
    odin build benchmark -o:speed -debug
    /usr/lib/linux-tools-5.15.0-79/perf record  --call-graph dwarf  ./benchmark.bin
    hotspot perf.data    
