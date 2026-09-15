import { odinPackage } from "//rules/odin";
import { msgpack } from "//";

export const benchmark = odinPackage({
	path: ".",
	deps: [msgpack],
});
