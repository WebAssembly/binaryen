import {
	replaceWith,
} from "../../-utils.ts";
import type {
	Module,
} from "../../classes/module/Module.ts";
import {
	type ExpressionRef,
	Operation,
	Type,
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
		load: loadFn(mod, Type.f64, 8, true),
		store: storeFn(mod, Type.f64, 8),

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
		reinterpret_i64: unaryFn(mod, Operation.ReinterpretInt64),

		promote_f32: unaryFn(mod, Operation.PromoteFloat32),

		/* eslint-disable prefer-arrow-callback */
		/** @deprecated */
		convert_s: {
			// @ts-expect-error
			/** @deprecated Use {@link ExpressionBuilder#f64 | ExpressionBuilder#f64.convert_i32_s} instead. */ i32: replaceWith("convert_s.i32 -> convert_i32_s", (...args) => f64(mod).convert_i32_s(...args)),
			// @ts-expect-error
			/** @deprecated Use {@link ExpressionBuilder#f64 | ExpressionBuilder#f64.convert_i64_s} instead. */ i64: replaceWith("convert_s.i64 -> convert_i64_s", (...args) => f64(mod).convert_i64_s(...args)),
		},
		/** @deprecated */
		convert_u: {
			// @ts-expect-error
			/** @deprecated Use {@link ExpressionBuilder#f64 | ExpressionBuilder#f64.convert_i32_u} instead. */ i32: replaceWith("convert_u.i32 -> convert_i32_u", (...args) => f64(mod).convert_i32_u(...args)),
			// @ts-expect-error
			/** @deprecated Use {@link ExpressionBuilder#f64 | ExpressionBuilder#f64.convert_i64_u} instead. */ i64: replaceWith("convert_u.i64 -> convert_i64_u", (...args) => f64(mod).convert_i64_u(...args)),
		},
		// @ts-expect-error
		/** @deprecated Use {@link ExpressionBuilder#f64 | ExpressionBuilder#f64.reinterpret_i64} instead. */ reinterpret: replaceWith("reinterpret -> reinterpret_i64", function (...args) { return this.reinterpret_i64(...args); }),
		// @ts-expect-error
		/** @deprecated Use {@link ExpressionBuilder#f64 | ExpressionBuilder#f64.promote_f32} instead. */ promote: replaceWith("promote -> promote_f32", function (...args) { return this.promote_f32(...args); }),

		/** @deprecated Use {@link Module#pop} instead. */
		pop: replaceWith(
			"f64.pop -> pop(Type.f64)",
			() => mod.pop(Type.f64),
		),
		/* eslint-enable prefer-arrow-callback */
	} as const;
}
