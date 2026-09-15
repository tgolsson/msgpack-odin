import { file, output, platformInfo, task } from "imp:core";
import { odinPackage } from "//rules/odin";
import { odinfmtCommandName, odinfmtGraphTool } from "//rules/odin/odinfmt/toolchain";
import { pythonResolve, pythonSources } from "//rules/python";
import { defaultUvToolchainVersion, uvGraphTool } from "//rules/python/uv_toolchain";
import { GENERATE } from "//rules/workflows/generate";

export const msgpack = odinPackage({ path: "." });

export const gentestResolve = pythonResolve({ path: "." });
export const gentest = pythonSources({
	root: ".",
	sources: ["gentest.py"],
	resolve: gentestResolve,
});

const GENTEST_OUTPUTS = [
	"tests/primitive.odin",
	"tests/string.odin",
	"tests/bytes.odin",
	"tests/array.odin",
	"tests/map.odin",
	"tests/timestamp.odin",
];

export const gentest_check = {
	[GENERATE]: task({
		display: "generate tests/*.odin via gentest.py",
		inputs: {
			script: file("gentest.py"),
			pyproject: file("pyproject.toml"),
			lock: file("uv.lock"),
			uv: uvGraphTool(defaultUvToolchainVersion()),
			odinfmt: odinfmtGraphTool(undefined),
		},
		outputs: { result: output.value() },
		async run(exec, { script, pyproject, lock, uv, odinfmt }) {
			const raw = await exec.action({
				display: "gentest.py",
				argv: [
					exec.tool(uv, "uv"),
					"run",
					"--project",
					".",
					"--locked",
					"--",
					"python3",
					"gentest.py",
				],
				tools: [uv],
				inputs: [script, pyproject, lock],
				outputs: { tests: output.directory("tests") },
			});

			const formatted = await exec.action({
				display: "odinfmt tests/",
				argv: [
					exec.tool(odinfmt, odinfmtCommandName(platformInfo())),
					"-w",
					exec.path(raw.outputs.tests),
				],
				inputs: [raw.outputs.tests],
				outputs: { tests: output.directory("tests") },
			});

			return {
				result: {
					paths: GENTEST_OUTPUTS,
					files: Object.fromEntries(
						GENTEST_OUTPUTS.map((path) => [path, formatted.outputs.tests]),
					),
				},
			};
		},
	}).outputs.result,
};
