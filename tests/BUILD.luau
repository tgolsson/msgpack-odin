local odinTestPackage = require("@imp/rules/odin").odin_test_package
local msgpack = require("@workspace/BUILD").msgpack

local msgpack_tests = odinTestPackage({ srcs = { "*.odin" }, deps = { msgpack } })

return { msgpack_tests = msgpack_tests }
