local odinPackage = require("@imp/rules/odin").odin_package

local rpc = odinPackage({ path = "." })

return { rpc = rpc }
