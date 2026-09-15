import { odinToolchain } from "//rules/odin";
import { defaultOdinfmtToolchain } from "//rules/odin/odinfmt";

import "//rules/python";

import "//rules/workflows/fmt";
import "//rules/workflows/lint";
import "//rules/workflows/package";
import "//rules/workflows/run";
import "//rules/workflows/test";

export const odinToolchainDefault = odinToolchain("dev-2026-08", { default: true });
export const odinfmt = defaultOdinfmtToolchain();
