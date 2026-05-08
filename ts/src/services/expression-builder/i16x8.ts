import type {
	Module,
} from "../../classes/module/Module.ts";



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#vector-instructions */
export function i16x8(_mod: Module) {
	return {
		abs: null,
		neg: null,

		add: null,
		sub: null,
		add_sat_s: null,
		add_sat_u: null,
		sub_sat_s: null,
		sub_sat_u: null,
		mul: null,
		avgr_u: null,
		q15mulr_sat_s: null,
		relaxed_q15mulr_s: null,
		min_s: null,
		min_u: null,
		max_s: null,
		max_u: null,

		relaxed_laneselect: null,

		all_true: null,

		eq: null,
		ne: null,
		lt_s: null,
		lt_u: null,
		gt_s: null,
		gt_u: null,
		le_s: null,
		le_u: null,
		ge_s: null,
		ge_u: null,

		shl: null,
		shr_s: null,
		shr_u: null,

		bitmask: null,

		extadd_pairwise_i8x16_s: null,
		extadd_pairwise_i8x16_u: null,

		extmul_low_i8x16_s: null,
		extmul_low_i8x16_u: null,
		extmul_high_i8x16_s: null,
		extmul_high_i8x16_u: null,

		relaxed_dot_i8x16_i7x16_s: null,

		narrow_i32x4_s: null,
		narrow_i32x4_u: null,

		extend_low_i8x16_s: null,
		extend_low_i8x16_u: null,
		extend_high_i8x16_s: null,
		extend_high_i8x16_u: null,

		splat: null,
		extract_lane_s: null,
		extract_lane_u: null,
		replace_lane: null,
	} as const;
}
