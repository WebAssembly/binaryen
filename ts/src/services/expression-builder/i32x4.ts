import type {
	Module,
} from "../../classes/module/Module.ts";



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#vector-instructions */
export function i32x4(_mod: Module) {
	return {
		abs: null,
		neg: null,

		add: null,
		sub: null,
		mul: null,
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

		extadd_pairwise_i16x8_s: null,
		extadd_pairwise_i16x8_u: null,

		extmul_low_i16x8_s: null,
		extmul_low_i16x8_u: null,
		extmul_high_i16x8_s: null,
		extmul_high_i16x8_u: null,

		dot_i16x8_s: null,
		relaxed_dot_i8x16_i7x16_add_s: null,

		extend_low_i16x8_s: null,
		extend_low_i16x8_u: null,
		extend_high_i16x8_s: null,
		extend_high_i16x8_u: null,

		trunc_sat_f32x4_s: null,
		trunc_sat_f32x4_u: null,
		trunc_sat_f64x2_s_zero: null,
		trunc_sat_f64x2_u_zero: null,
		relaxed_trunc_f32x4_s: null,
		relaxed_trunc_f32x4_u: null,
		relaxed_trunc_f64x2_s_zero: null,
		relaxed_trunc_f64x2_u_zero: null,

		splat: null,
		extract_lane: null,
		replace_lane: null,
	} as const;
}
