import {
	BinaryenObj,
} from "../../-pre.ts";
import {
	consoleWarn,
} from "../../lib.ts";
import type {
	Module,
} from "../../classes/module/Module.ts";
import {
	type ExpressionRef,
	i64 as i64_t,
} from "../../constants.ts";
import {
	binaryFn,
	constant,
	loadFn,
	storeFn,
	unaryFn,
} from "./-utils.ts";
import {
	Operation,
} from "./Operation.ts";



/**
 * @see https://webassembly.github.io/spec/core/syntax/instructions.html#memory-instructions
 * @see https://webassembly.github.io/spec/core/syntax/instructions.html#numeric-instructions
 */
export function i64(mod: Module) {
	return {
		load: loadFn(mod, i64_t, 8, true),
		load8_s: loadFn(mod, i64_t, 1, true),
		load8_u: loadFn(mod, i64_t, 1, false),
		load16_s: loadFn(mod, i64_t, 2, true),
		load16_u: loadFn(mod, i64_t, 2, false),
		load32_s: loadFn(mod, i64_t, 4, true),
		load32_u: loadFn(mod, i64_t, 4, false),

		store: storeFn(mod, i64_t, 8),
		store8: storeFn(mod, i64_t, 1),
		store16: storeFn(mod, i64_t, 2),
		store32: storeFn(mod, i64_t, 4),

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
			BinaryenObj["_BinaryenWideIntAddSub"](mod.ptr, Operation.AddInt128, leftLow, leftHigh, rightLow, rightHigh)
		),

		sub128: (leftLow: ExpressionRef, leftHigh: ExpressionRef, rightLow: ExpressionRef, rightHigh: ExpressionRef): ExpressionRef => (
			BinaryenObj["_BinaryenWideIntAddSub"](mod.ptr, Operation.SubInt128, leftLow, leftHigh, rightLow, rightHigh)
		),

		mul_wide_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => (
			BinaryenObj["_BinaryenWideIntMul"](mod.ptr, Operation.MulWideSInt64, left, right)
		),

		mul_wide_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => (
			BinaryenObj["_BinaryenWideIntMul"](mod.ptr, Operation.MulWideUInt64, left, right)
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

		// @ts-expect-error
		/** @deprecated Use `.extend_i32_s()` instead. */ extend_s(...args) { consoleWarn("`.extend_s()` is deprecated; use `.extend_i32_s()` instead."); return this.extend_i32_s(...args); },
		// @ts-expect-error
		/** @deprecated Use `.extend_i32_u()` instead. */ extend_u(...args) { consoleWarn("`.extend_u()` is deprecated; use `.extend_i32_u()` instead."); return this.extend_i32_u(...args); },
		/** @deprecated */
		trunc_s: {
			// @ts-expect-error
			/** @deprecated Use `.trunc_f32_s()` instead. */ f32: (...args) => { consoleWarn("`.trunc_s.f32()` is deprecated; use `.trunc_f32_s()` instead."); return i64(mod).trunc_f32_s(...args); },
			// @ts-expect-error
			/** @deprecated Use `.trunc_f64_s()` instead. */ f64: (...args) => { consoleWarn("`.trunc_s.f64()` is deprecated; use `.trunc_f64_s()` instead."); return i64(mod).trunc_f64_s(...args); },
		},
		/** @deprecated */
		trunc_u: {
			// @ts-expect-error
			/** @deprecated Use `.trunc_f32_u()` instead. */ f32: (...args) => { consoleWarn("`.trunc_u.f32()` is deprecated; use `.trunc_f32_u()` instead."); return i64(mod).trunc_f32_u(...args); },
			// @ts-expect-error
			/** @deprecated Use `.trunc_f64_u()` instead. */ f64: (...args) => { consoleWarn("`.trunc_u.f64()` is deprecated; use `.trunc_f64_u()` instead."); return i64(mod).trunc_f64_u(...args); },
		},
		/** @deprecated */
		trunc_s_sat: {
			// @ts-expect-error
			/** @deprecated Use `.trunc_sat_f32_s()` instead. */ f32: (...args) => { consoleWarn("`.trunc_s_sat.f32()` is deprecated; use `.trunc_sat_f32_s()` instead."); return i64(mod).trunc_sat_f32_s(...args); },
			// @ts-expect-error
			/** @deprecated Use `.trunc_sat_f64_s()` instead. */ f64: (...args) => { consoleWarn("`.trunc_s_sat.f64()` is deprecated; use `.trunc_sat_f64_s()` instead."); return i64(mod).trunc_sat_f64_s(...args); },
		},
		/** @deprecated */
		trunc_u_sat: {
			// @ts-expect-error
			/** @deprecated Use `.trunc_sat_f32_u()` instead. */ f32: (...args) => { consoleWarn("`.trunc_u_sat.f32()` is deprecated; use `.trunc_sat_f32_u()` instead."); return i64(mod).trunc_sat_f32_u(...args); },
			// @ts-expect-error
			/** @deprecated Use `.trunc_sat_f64_u()` instead. */ f64: (...args) => { consoleWarn("`.trunc_u_sat.f64()` is deprecated; use `.trunc_sat_f64_u()` instead."); return i64(mod).trunc_sat_f64_u(...args); },
		},
		// @ts-expect-error
		/** @deprecated Use `.reinterpret_f64()` instead. */ reinterpret(...args) { consoleWarn("`.reinterpret()` is deprecated; use `.reinterpret_f64()` instead."); return this.reinterpret_f64(...args); },
	} as const;
}
