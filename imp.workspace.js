import { odinToolchain } from "//rules/odin";
import { odinfmtToolchain } from "//rules/odin/odinfmt";

import "//rules/python";

import "//rules/workflows/fmt";
import "//rules/workflows/lint";
import "//rules/workflows/package";
import "//rules/workflows/run";
import "//rules/workflows/test";

// dev-2026-08 postdates imp's latest release (v0.3.0): its bundled
// odin.lock/odinfmt.lock only go up to dev-2026-03, so `unverified: true` is
// needed until imp cuts a release whose lockfiles know this version.
export const odinToolchainDefault = odinToolchain("dev-2026-08", { default: true, unverified: true });
export const odinfmt = odinfmtToolchain("dev-2026-08", { default: true, unverified: true });
