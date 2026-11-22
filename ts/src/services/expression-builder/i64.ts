import {
	BinaryenObj,
} from "../../-pre.ts";
import {
	PTR,
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
	atomicLoadFn,
	atomicRmwOps,
	atomicStoreFn,
	binaryFn,
	constant,
	loadFn,
	storeFn,
	unaryFn,
} from "./-utils.ts";



function atomic(mod: Module) {
	return {
		load: atomicLoadFn(mod, Type.i64, 8),
		load8_u: atomicLoadFn(mod, Type.i64, 1),
		load16_u: atomicLoadFn(mod, Type.i64, 2),
		load32_u: atomicLoadFn(mod, Type.i64, 4),

		store: atomicStoreFn(mod, Type.i64, 8),
		store8: atomicStoreFn(mod, Type.i64, 1),
		store16: atomicStoreFn(mod, Type.i64, 2),
		store32: atomicStoreFn(mod, Type.i64, 4),

		rmw: atomicRmwOps(mod, Type.i64, 8),
		rmw8_u: atomicRmwOps(mod, Type.i64, 1),
		rmw16_u: atomicRmwOps(mod, Type.i64, 2),
		rmw32_u: atomicRmwOps(mod, Type.i64, 4),
	} as const;
}



/**
 * @see https://webassembly.github.io/spec/core/syntax/instructions.html#memory-instructions
 * @see https://webassembly.github.io/spec/core/syntax/instructions.html#numeric-instructions
 */
export function i64(mod: Module) {
	return {
		load: loadFn(mod, Type.i64, 8, true),
		load8_s: loadFn(mod, Type.i64, 1, true),
		load8_u: loadFn(mod, Type.i64, 1, false),
		load16_s: loadFn(mod, Type.i64, 2, true),
		load16_u: loadFn(mod, Type.i64, 2, false),
		load32_s: loadFn(mod, Type.i64, 4, true),
		load32_u: loadFn(mod, Type.i64, 4, false),

		store: storeFn(mod, Type.i64, 8),
		store8: storeFn(mod, Type.i64, 1),
		store16: storeFn(mod, Type.i64, 2),
		store32: storeFn(mod, Type.i64, 4),

		/** Return a static constant i64. */
		const: (value: number | bigint): ExpressionRef => (
			constant(mod, "_BinaryenLiteralInt64", BigInt(value))
		),

		clz: unaryFn(mod, Operation.ClzInt64),
		ctz: unaryFn(mod, Operation.CtzInt64),
		popcnt: unaryFn(mod, Operation.PopcntInt64),
		extend8_s: unaryFn(mod, Operation.ExtendS8Int64),
		extend16_s: unaryFn(mod, Operation.ExtendS16Int64),
		extend32_s: unaryFn(mod, Operation.ExtendS32Int64),

		add: binaryFn(mod, Operation.AddInt64),
		sub: binaryFn(mod, Operation.SubInt64),
		mul: binaryFn(mod, Operation.MulInt64),
		div_s: binaryFn(mod, Operation.DivSInt64),
		div_u: binaryFn(mod, Operation.DivUInt64),
		rem_s: binaryFn(mod, Operation.RemSInt64),
		rem_u: binaryFn(mod, Operation.RemUInt64),

		add128: (leftLow: ExpressionRef, leftHigh: ExpressionRef, rightLow: ExpressionRef, rightHigh: ExpressionRef): ExpressionRef => (
			BinaryenObj["_BinaryenWideIntAddSub"](mod[PTR], Operation.AddInt128, leftLow, leftHigh, rightLow, rightHigh)
		),

		sub128: (leftLow: ExpressionRef, leftHigh: ExpressionRef, rightLow: ExpressionRef, rightHigh: ExpressionRef): ExpressionRef => (
			BinaryenObj["_BinaryenWideIntAddSub"](mod[PTR], Operation.SubInt128, leftLow, leftHigh, rightLow, rightHigh)
		),

		mul_wide_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => (
			BinaryenObj["_BinaryenWideIntMul"](mod[PTR], Operation.MulWideSInt64, left, right)
		),

		mul_wide_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => (
			BinaryenObj["_BinaryenWideIntMul"](mod[PTR], Operation.MulWideUInt64, left, right)
		),

		and: binaryFn(mod, Operation.AndInt64),
		or: binaryFn(mod, Operation.OrInt64),
		xor: binaryFn(mod, Operation.XorInt64),
		shl: binaryFn(mod, Operation.ShlInt64),
		shr_s: binaryFn(mod, Operation.ShrSInt64),
		shr_u: binaryFn(mod, Operation.ShrUInt64),
		rotl: binaryFn(mod, Operation.RotLInt64),
		rotr: binaryFn(mod, Operation.RotRInt64),

		eqz: unaryFn(mod, Operation.EqZInt64),

		eq: binaryFn(mod, Operation.EqInt64),
		ne: binaryFn(mod, Operation.NeInt64),
		lt_s: binaryFn(mod, Operation.LtSInt64),
		lt_u: binaryFn(mod, Operation.LtUInt64),
		gt_s: binaryFn(mod, Operation.GtSInt64),
		gt_u: binaryFn(mod, Operation.GtUInt64),
		le_s: binaryFn(mod, Operation.LeSInt64),
		le_u: binaryFn(mod, Operation.LeUInt64),
		ge_s: binaryFn(mod, Operation.GeSInt64),
		ge_u: binaryFn(mod, Operation.GeUInt64),

		extend_i32_s: unaryFn(mod, Operation.ExtendSInt32),
		extend_i32_u: unaryFn(mod, Operation.ExtendUInt32),

		trunc_f32_s: unaryFn(mod, Operation.TruncSFloat32ToInt64),
		trunc_f32_u: unaryFn(mod, Operation.TruncUFloat32ToInt64),
		trunc_f64_s: unaryFn(mod, Operation.TruncSFloat64ToInt64),
		trunc_f64_u: unaryFn(mod, Operation.TruncUFloat64ToInt64),
		trunc_sat_f32_s: unaryFn(mod, Operation.TruncSatSFloat32ToInt64),
		trunc_sat_f32_u: unaryFn(mod, Operation.TruncSatUFloat32ToInt64),
		trunc_sat_f64_s: unaryFn(mod, Operation.TruncSatSFloat64ToInt64),
		trunc_sat_f64_u: unaryFn(mod, Operation.TruncSatUFloat64ToInt64),
		reinterpret_f64: unaryFn(mod, Operation.ReinterpretFloat64),

		/** @experimental */
		atomic: atomic(mod),

		/* eslint-disable prefer-arrow-callback */
		// @ts-expect-error
		/** @deprecated Use {@link ExpressionBuilder#i64 | ExpressionBuilder#i64.extend_i32_s} instead. */ extend_s: replaceWith("extend_s -> extend_i32_s", function (...args) { return this.extend_i32_s(...args); }),
		// @ts-expect-error
		/** @deprecated Use {@link ExpressionBuilder#i64 | ExpressionBuilder#i64.extend_i32_u} instead. */ extend_u: replaceWith("extend_u -> extend_i32_u", function (...args) { return this.extend_i32_u(...args); }),
		/** @deprecated */
		trunc_s: {
			// @ts-expect-error
			/** @deprecated Use {@link ExpressionBuilder#i64 | ExpressionBuilder#i64.trunc_f32_s} instead. */ f32: replaceWith("trunc_s.f32 -> trunc_f32_s", (...args) => i64(mod).trunc_f32_s(...args)),
			// @ts-expect-error
			/** @deprecated Use {@link ExpressionBuilder#i64 | ExpressionBuilder#i64.trunc_f64_s} instead. */ f64: replaceWith("trunc_s.f64 -> trunc_f64_s", (...args) => i64(mod).trunc_f64_s(...args)),
		},
		/** @deprecated */
		trunc_u: {
			// @ts-expect-error
			/** @deprecated Use {@link ExpressionBuilder#i64 | ExpressionBuilder#i64.trunc_f32_u} instead. */ f32: replaceWith("trunc_u.f32 -> trunc_f32_u", (...args) => i64(mod).trunc_f32_u(...args)),
			// @ts-expect-error
			/** @deprecated Use {@link ExpressionBuilder#i64 | ExpressionBuilder#i64.trunc_f64_u} instead. */ f64: replaceWith("trunc_u.f64 -> trunc_f64_u", (...args) => i64(mod).trunc_f64_u(...args)),
		},
		/** @deprecated */
		trunc_s_sat: {
			// @ts-expect-error
			/** @deprecated Use {@link ExpressionBuilder#i64 | ExpressionBuilder#i64.trunc_sat_f32_s} instead. */ f32: replaceWith("trunc_s_sat.f32 -> trunc_sat_f32_s", (...args) => i64(mod).trunc_sat_f32_s(...args)),
			// @ts-expect-error
			/** @deprecated Use {@link ExpressionBuilder#i64 | ExpressionBuilder#i64.trunc_sat_f64_s} instead. */ f64: replaceWith("trunc_s_sat.f64 -> trunc_sat_f64_s", (...args) => i64(mod).trunc_sat_f64_s(...args)),
		},
		/** @deprecated */
		trunc_u_sat: {
			// @ts-expect-error
			/** @deprecated Use {@link ExpressionBuilder#i64 | ExpressionBuilder#i64.trunc_sat_f32_u} instead. */ f32: replaceWith("trunc_u_sat.f32 -> trunc_sat_f32_u", (...args) => i64(mod).trunc_sat_f32_u(...args)),
			// @ts-expect-error
			/** @deprecated Use {@link ExpressionBuilder#i64 | ExpressionBuilder#i64.trunc_sat_f64_u} instead. */ f64: replaceWith("trunc_u_sat.f64 -> trunc_sat_f64_u", (...args) => i64(mod).trunc_sat_f64_u(...args)),
		},
		// @ts-expect-error
		/** @deprecated Use {@link ExpressionBuilder#i64 | ExpressionBuilder#i64.reinterpret_f64} instead. */ reinterpret: replaceWith("reinterpret -> reinterpret_f64", function (...args) { return this.reinterpret_f64(...args); }),

		/** @deprecated Use {@link Module#pop} instead. */
		pop: replaceWith(
			"i64.pop -> pop(Type.i64)",
			() => mod.pop(Type.i64),
		),
		/* eslint-enable prefer-arrow-callback */
	} as const;
}
