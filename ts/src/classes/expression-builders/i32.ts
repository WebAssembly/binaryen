import {
	consoleWarn,
} from "../../lib.ts";
import type {
	Module,
} from "../module/Module.ts";



/** Placeholder. */
const STUB = (..._args: readonly number[]): number => 0;



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#numeric-instructions */
export function i32(_mod: Module) {
	return {
		const: STUB,

		clz: STUB,
		ctz: STUB,
		popcnt: STUB,
		extend8_s: STUB,
		extend16_s: STUB,

		add: STUB,
		sub: STUB,
		mul: STUB,
		div_s: STUB,
		div_u: STUB,
		rem_s: STUB,
		rem_u: STUB,

		and: STUB,
		or: STUB,
		xor: STUB,
		shl: STUB,
		shr_s: STUB,
		shr_u: STUB,
		rotl: STUB,
		rotr: STUB,

		eqz: STUB,

		eq: STUB,
		ne: STUB,
		lt_s: STUB,
		lt_u: STUB,
		gt_s: STUB,
		gt_u: STUB,
		le_s: STUB,
		le_u: STUB,
		ge_s: STUB,
		ge_u: STUB,

		wrap_i64: STUB,

		trunc_f32_s: STUB,
		trunc_f32_u: STUB,
		trunc_f64_s: STUB,
		trunc_f64_u: STUB,
		trunc_sat_f32_s: STUB,
		trunc_sat_f32_u: STUB,
		trunc_sat_f64_s: STUB,
		trunc_sat_f64_u: STUB,
		reinterpret_f32: STUB,

		// @ts-expect-error
		/** @deprecated Use `.wrap_i64()` instead. */ wrap(...args) { consoleWarn("`.wrap()` is deprecated; use `.wrap_i64()` instead."); return this.wrap_i64(...args); },
		trunc_s: {
			/** @deprecated Use `.trunc_f32_s()` instead. */ f32: STUB,
			/** @deprecated Use `.trunc_f64_s()` instead. */ f64: STUB,
		},
		trunc_u: {
			/** @deprecated Use `.trunc_f32_u()` instead. */ f32: STUB,
			/** @deprecated Use `.trunc_f64_u()` instead. */ f64: STUB,
		},
		trunc_s_sat: {
			/** @deprecated Use `.trunc_sat_f32_s()` instead. */ f32: STUB,
			/** @deprecated Use `.trunc_sat_f64_s()` instead. */ f64: STUB,
		},
		trunc_u_sat: {
			/** @deprecated Use `.trunc_sat_f32_u()` instead. */ f32: STUB,
			/** @deprecated Use `.trunc_sat_f64_u()` instead. */ f64: STUB,
		},
		// @ts-expect-error
		/** @deprecated Use `.reinterpret_f32()` instead. */ reinterpret(...args) { consoleWarn("`.reinterpret()` is deprecated; use `.reinterpret_f32()` instead."); return this.reinterpret_f32(...args); },
	} as const;
}
