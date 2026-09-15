import { odinPackage } from "//rules/odin";
import { pythonResolve, pythonSources } from "//rules/python";

export const msgpack = odinPackage({ path: "." });

// Pinned environment for gentest.py, which regenerates tests/*.odin from the
// reference Python `msgpack` library. Replaces the ad hoc `just pex` bundle
// for this one purpose; `just pex`/`msgpack.pex` remain for benchmarking.
export const gentestResolve = pythonResolve({ path: "." });
export const gentest = pythonSources({
	root: ".",
	sources: ["gentest.py"],
	resolve: gentestResolve,
});
