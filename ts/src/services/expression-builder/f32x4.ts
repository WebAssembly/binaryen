import type {
	Module,
} from "../../classes/module/Module.ts";



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#vector-instructions */
export function f32x4(_mod: Module) {
	return {
		abs: null,
		neg: null,
		sqrt: null,
		ceil: null,
		floor: null,
		trunc: null,
		nearest: null,

		add: null,
		sub: null,
		mul: null,
		div: null,
		min: null,
		max: null,
		pmin: null,
		pmax: null,
		relaxed_min: null,
		relaxed_max: null,

		relaxed_madd: null,
		relaxed_nmadd: null,

		eq: null,
		ne: null,
		lt: null,
		gt: null,
		le: null,
		ge: null,

		convert_i32x4_s: null,
		convert_i32x4_u: null,

		demote_f64x2_zero: null,

		splat: null,
		extract_lane: null,
		replace_lane: null,
	} as const;
}
