import {
	consoleWarn,
} from "../../lib.ts";
import type {
	Module,
} from "../module/Module.ts";



/** Placeholder. */
const STUB = (..._args: readonly number[]): number => 0;



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#numeric-instructions */
export function f64(_mod: Module) {
	return {
		const: STUB,

		abs: STUB,
		neg: STUB,
		sqrt: STUB,
		ceil: STUB,
		floor: STUB,
		trunc: STUB,
		nearest: STUB,

		add: STUB,
		sub: STUB,
		mul: STUB,
		div: STUB,
		min: STUB,
		max: STUB,
		copysign: STUB,

		eq: STUB,
		ne: STUB,
		lt: STUB,
		gt: STUB,
		le: STUB,
		ge: STUB,

		convert_i32_s: STUB,
		convert_i32_u: STUB,
		convert_i64_s: STUB,
		convert_i64_u: STUB,
		reinterpret_f64: STUB,

		prmote_f32: STUB,

		convert_s: {
			/** @deprecated Use `.convert_i32_s()` instead. */ i32: STUB,
			/** @deprecated Use `.convert_i64_s()` instead. */ i64: STUB,
		},
		convert_u: {
			/** @deprecated Use `.convert_i32_u()` instead. */ i32: STUB,
			/** @deprecated Use `.convert_i64_u()` instead. */ i64: STUB,
		},
		// @ts-expect-error
		/** @deprecated Use `.reinterpret_i64()` instead. */ reinterpret(...args) { consoleWarn("`.reinterpret()` is deprecated; use `.reinterpret_i64()` instead."); return this.reinterpret_i64(...args); },
		// @ts-expect-error
		/** @deprecated Use `.promote_f32()` instead. */ promote(...args) { consoleWarn("`.promote()` is deprecated; use `.promote_f32()` instead."); return this.promote_f32(...args); },
	} as const;
}
