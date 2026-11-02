local core = require("@imp/core")
local odinPackage = require("@imp/rules/odin").odin_package
local odinfmt = require("@imp/rules/odin/odinfmt/toolchain")
local python = require("@imp/rules/python")
local uv = require("@imp/rules/python/uv_toolchain")
local generate = require("@imp/rules/imp/generate")
local GENERATE = require("@imp/rules/workflows/generate").GENERATE

local msgpack = odinPackage({ path = "." })

-- The uv workspace at the root (pyproject.toml + uv.lock). Python targets
-- infer the project from the nearest pyproject.toml.
local workspace = python.python_workspace({ path = "." })

local gentest = python.python_sources({ root = ".", sources = { "gentest.py" } })

local GENTEST_OUTPUTS = {
	"tests/primitive.odin",
	"tests/string.odin",
	"tests/bytes.odin",
	"tests/array.odin",
	"tests/map.odin",
	"tests/timestamp.odin",
}

local uvTool = uv.graph_toolchain(uv.default_version())

-- Runs gentest.py through the pinned uv project, then odinfmt over the
-- tests/ directory, in one generator action.
local gentest_check = {
	[GENERATE] = generate.generated_files({
		display = "generate tests/*.odin via gentest.py",
		tools = {
			uv = uvTool.tool,
			uv_cache = uvTool.cache_tool,
			odinfmt = odinfmt.graph_toolchain(nil).tool,
			sh = core.native_tool("sh"),
		},
		inputs = {
			script = core.files({ include = { "gentest.py" } }),
			pyproject = core.files({ include = { "pyproject.toml" } }),
			lock = core.files({ include = { "uv.lock" } }),
		},
		output_paths = GENTEST_OUTPUTS,
		argv = function(exec, resolved)
			local env = uv.cache_env(exec, resolved.uv_cache)
			local argv = {
				"sh",
				"-c",
				'uv=$1; fmt=$2; export UV_CACHE_DIR=$3 UV_PYTHON_INSTALL_DIR=$4; "$uv" run --project . --locked -- python3 gentest.py && "$fmt" -w tests',
				"gentest",
				uv.uv_bin(exec, resolved.uv),
				odinfmt.bin(exec, resolved.odinfmt),
				env.UV_CACHE_DIR,
				env.UV_PYTHON_INSTALL_DIR,
			}
			return argv
		end,
	}),
}

return {
	msgpack = msgpack,
	workspace = workspace,
	gentest = gentest,
	gentest_check = gentest_check,
}
