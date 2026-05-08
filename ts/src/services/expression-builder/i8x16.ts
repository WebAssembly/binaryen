import type {
	Module,
} from "../../classes/module/Module.ts";



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#vector-instructions */
export function i8x16(_mod: Module) {
	return {
		abs: null,
		neg: null,
		popcnt: null,

		add: null,
		sub: null,
		add_sat_s: null,
		add_sat_u: null,
		sub_sat_s: null,
		sub_sat_u: null,
		avgr_u: null,
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

		swizzle: null,
		relaxed_swizzle: null,

		shuffle: null,

		narrow_i16x8_s: null,
		narrow_i16x8_u: null,

		splat: null,
		extract_lane_s: null,
		extract_lane_u: null,
		replace_lane: null,
	} as const;
}
