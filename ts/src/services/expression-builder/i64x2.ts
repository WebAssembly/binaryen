import type {
	Module,
} from "../../classes/module/Module.ts";



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#vector-instructions */
export function i64x2(_mod: Module) {
	return {
		abs: null,
		neg: null,

		add: null,
		sub: null,
		mul: null,

		relaxed_laneselect: null,

		all_true: null,

		eq: null,
		ne: null,
		lt_s: null,
		gt_s: null,
		le_s: null,
		ge_s: null,

		shl: null,
		shr_s: null,
		shr_u: null,

		bitmask: null,

		extmul_low_i32x4_s: null,
		extmul_low_i32x4_u: null,
		extmul_high_i32x4_s: null,
		extmul_high_i32x4_u: null,

		extend_low_i32x4_s: null,
		extend_low_i32x4_u: null,
		extend_high_i32x4_s: null,
		extend_high_i32x4_u: null,

		splat: null,
		extract_lane: null,
		replace_lane: null,
	} as const;
}
