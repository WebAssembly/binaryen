import {
	consoleWarn,
} from "../../lib.ts";
import type {
	Module,
} from "../../classes/module/Module.ts";
import {
	type ExpressionRef,
	Operation,
	f64 as f64_t,
} from "../../constants.ts";
import {
	binaryFn,
	constant,
	loadFn,
	storeFn,
	unaryFn,
} from "./-utils.ts";



/**
 * @see https://webassembly.github.io/spec/core/syntax/instructions.html#memory-instructions
 * @see https://webassembly.github.io/spec/core/syntax/instructions.html#numeric-instructions
 */
export function f64(mod: Module) {
	return {
		load: loadFn(mod, f64_t, 8, true),
		store: storeFn(mod, f64_t, 8),

		/** Return a static constant f64. */
		const: (value: number): ExpressionRef => (
			constant(mod, "_BinaryenLiteralFloat64", value)
		),

		const_bits: (value: number | bigint): ExpressionRef => (
			constant(mod, "_BinaryenLiteralFloat64Bits", BigInt(value))
		),

		abs: unaryFn(mod, Operation.AbsFloat64),
		neg: unaryFn(mod, Operation.NegFloat64),
		sqrt: unaryFn(mod, Operation.SqrtFloat64),
		ceil: unaryFn(mod, Operation.CeilFloat64),
		floor: unaryFn(mod, Operation.FloorFloat64),
		trunc: unaryFn(mod, Operation.TruncFloat64),
		nearest: unaryFn(mod, Operation.NearestFloat64),

		add: binaryFn(mod, Operation.AddFloat64),
		sub: binaryFn(mod, Operation.SubFloat64),
		mul: binaryFn(mod, Operation.MulFloat64),
		div: binaryFn(mod, Operation.DivFloat64),
		min: binaryFn(mod, Operation.MinFloat64),
		max: binaryFn(mod, Operation.MaxFloat64),
		copysign: binaryFn(mod, Operation.CopySignFloat64),

		eq: binaryFn(mod, Operation.EqFloat64),
		ne: binaryFn(mod, Operation.NeFloat64),
		lt: binaryFn(mod, Operation.LtFloat64),
		gt: binaryFn(mod, Operation.GtFloat64),
		le: binaryFn(mod, Operation.LeFloat64),
		ge: binaryFn(mod, Operation.GeFloat64),

		convert_i32_s: unaryFn(mod, Operation.ConvertSInt32ToFloat64),
		convert_i32_u: unaryFn(mod, Operation.ConvertUInt32ToFloat64),
		convert_i64_s: unaryFn(mod, Operation.ConvertSInt64ToFloat64),
		convert_i64_u: unaryFn(mod, Operation.ConvertUInt64ToFloat64),
		reinterpret_f64: unaryFn(mod, Operation.ReinterpretInt64),

		promote_f32: unaryFn(mod, Operation.PromoteFloat32),

		/** @deprecated */
		convert_s: {
			// @ts-expect-error
			/** @deprecated Use `.convert_i32_s()` instead. */ i32: (...args) => { consoleWarn("`.convert_s.i32()` is deprecated; use `.convert_i32_s()` instead."); return f64(mod).convert_i32_s(...args); },
			// @ts-expect-error
			/** @deprecated Use `.convert_i64_s()` instead. */ i64: (...args) => { consoleWarn("`.convert_s.i64()` is deprecated; use `.convert_i64_s()` instead."); return f64(mod).convert_i64_s(...args); },
		},
		/** @deprecated */
		convert_u: {
			// @ts-expect-error
			/** @deprecated Use `.convert_i32_u()` instead. */ i32: (...args) => { consoleWarn("`.convert_u.i32()` is deprecated; use `.convert_i32_u()` instead."); return f64(mod).convert_i32_u(...args); },
			// @ts-expect-error
			/** @deprecated Use `.convert_i64_u()` instead. */ i64: (...args) => { consoleWarn("`.convert_u.i64()` is deprecated; use `.convert_i64_u()` instead."); return f64(mod).convert_i64_u(...args); },
		},
		// @ts-expect-error
		/** @deprecated Use `.reinterpret_i64()` instead. */ reinterpret(...args) { consoleWarn("`.reinterpret()` is deprecated; use `.reinterpret_i64()` instead."); return this.reinterpret_i64(...args); },
		// @ts-expect-error
		/** @deprecated Use `.promote_f32()` instead. */ promote(...args) { consoleWarn("`.promote()` is deprecated; use `.promote_f32()` instead."); return this.promote_f32(...args); },
	} as const;
}
