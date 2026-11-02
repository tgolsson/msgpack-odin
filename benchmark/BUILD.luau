local odinPackage = require("@imp/rules/odin").odin_package
local msgpack = require("@workspace/BUILD").msgpack

local benchmark = odinPackage({ path = ".", deps = { msgpack } })

return { benchmark = benchmark }
