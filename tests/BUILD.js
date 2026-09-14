import { odinTestPackage } from "//rules/odin";
import { msgpack } from "//";

export const msgpack_tests = odinTestPackage({
	srcs: ["*.odin"],
	deps: [msgpack],
});
