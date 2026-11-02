local odinToolchain = require("@imp/rules/odin").odin_toolchain
local odinfmtToolchain = require("@imp/rules/odin/odinfmt").odinfmt_toolchain
require("@imp/rules/python")
require("@imp/rules/workflows/fmt")
require("@imp/rules/workflows/lint")
require("@imp/rules/workflows/package")
require("@imp/rules/workflows/run")
require("@imp/rules/workflows/test")

-- dev-2026-08 postdates imp's latest release (v0.3.0): its bundled
-- odin.lock/odinfmt.lock only go up to dev-2026-03, so `unverified: true` is
-- needed until imp cuts a release whose lockfiles know this version.
local odinToolchainDefault = odinToolchain("dev-2026-08", { default = true, unverified = true })
local odinfmt = odinfmtToolchain("dev-2026-08", { default = true, unverified = true })

return { odinToolchainDefault = odinToolchainDefault, odinfmt = odinfmt }
