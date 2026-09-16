import { odinTestPackage } from "//rules/odin";
import { rpc } from "//ext/rpc";

export const rpc_tests = odinTestPackage({
	srcs: ["*.odin"],
	deps: [rpc],
});
