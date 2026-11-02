local odinTestPackage = require("@imp/rules/odin").odin_test_package
local rpc = require("@workspace/ext/rpc/BUILD").rpc

local rpc_tests = odinTestPackage({ srcs = { "*.odin" }, deps = { rpc } })

return { rpc_tests = rpc_tests }
