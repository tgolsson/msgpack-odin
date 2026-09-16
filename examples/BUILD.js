import { file, output, task } from "imp:core";
import { odinPackage } from "//rules/odin";
import { RUN } from "//rules/workflows/run";
import { TEST } from "//rules/workflows/test";
import { defaultUvToolchainVersion, uvGraphTool } from "//rules/python";
import { msgpack } from "//";

export const rpc = odinPackage({
	path: ".",
	deps: [msgpack],
});

const rpcIntegration = task({
	display: "rpc Odin/Python integration test",
	inputs: {
		client: rpc[RUN],
		server: file("examples/server.py"),
		test: file("examples/integration_test.py"),
		pyproject: file("pyproject.toml"),
		lock: file("uv.lock"),
		uv: uvGraphTool(defaultUvToolchainVersion()),
	},
	outputs: { units: output.value() },
	async run(exec, inputs) {
		const client = exec.path(inputs.client);
		const server = exec.path(inputs.server);
		const test = exec.path(inputs.test);
		const result = await exec.action({
			argv: [
				exec.tool(inputs.uv, "uv"),
				"run",
				"--project",
				exec.path(inputs.pyproject),
				"--locked",
				"--",
				"python",
				test,
				"--client",
				client,
				"--server",
				server,
			],
			inputs: [inputs.client, inputs.server, inputs.test, inputs.pyproject, inputs.lock],
			tools: [inputs.uv],
			allowFailure: true,
			impure: true,
		});
		const ok = result.exitCode === 0;
		return {
			units: [{
				name: "examples/rpc integration",
				ok,
				...(ok ? {} : { output: [result.stdout, result.stderr].filter(Boolean).join("\n") }),
			}],
		};
	},
});

export const rpc_integration = { [TEST]: rpcIntegration.outputs.units };
