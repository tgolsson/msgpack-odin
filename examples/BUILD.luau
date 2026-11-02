local odinPackage = require("@imp/rules/odin").odin_package
local python = require("@imp/rules/python")
local BUILD = require("@imp/rules/workflows/build").BUILD
local root = require("@workspace/BUILD")

local rpc = odinPackage({ path = ".", deps = { root.msgpack } })

-- pytest runs examples/integration_test.py against the built rpc client.
local rpc_integration = python.python_test({
	sources = { "examples/integration_test.py", "examples/server.py" },
	deps = { rpc[BUILD] },
})

return { rpc = rpc, rpc_integration = rpc_integration }
