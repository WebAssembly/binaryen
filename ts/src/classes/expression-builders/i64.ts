import {
	consoleWarn,
} from "../../lib.ts";
import type {
	Module,
} from "../module/Module.ts";



/** Placeholder. */
const STUB = (..._args: readonly number[]): number => 0;



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#numeric-instructions */
export function i64(_mod: Module) {
	return {
		const: STUB,

		clz: STUB,
		ctz: STUB,
		popcnt: STUB,
		extend8_s: STUB,
		extend16_s: STUB,
		extend32_s: STUB,

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

		extend_i32_s: STUB,
		extend_i32_u: STUB,

		trunc_f32_s: STUB,
		trunc_f32_u: STUB,
		trunc_f64_s: STUB,
		trunc_f64_u: STUB,
		trunc_sat_f32_s: STUB,
		trunc_sat_f32_u: STUB,
		trunc_sat_f64_s: STUB,
		trunc_sat_f64_u: STUB,
		reinterpret_f64: STUB,

		// @ts-expect-error
		/** @deprecated Use `.extend_i32_s()` instead. */ extend_s(...args) { consoleWarn("`.extend_s()` is deprecated; use `.extend_i32_s()` instead."); return this.extend_i32_s(...args); },
		// @ts-expect-error
		/** @deprecated Use `.extend_i32_u()` instead. */ extend_u(...args) { consoleWarn("`.extend_u()` is deprecated; use `.extend_i32_u()` instead."); return this.extend_i32_u(...args); },
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
		/** @deprecated Use `.reinterpret_f64()` instead. */ reinterpret(...args) { consoleWarn("`.reinterpret()` is deprecated; use `.reinterpret_f64()` instead."); return this.reinterpret_f64(...args); },
	} as const;
}
