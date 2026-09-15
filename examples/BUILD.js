import { odinPackage } from "//rules/odin";
import { msgpack } from "//";

export const rpc = odinPackage({
	path: ".",
	deps: [msgpack],
});
