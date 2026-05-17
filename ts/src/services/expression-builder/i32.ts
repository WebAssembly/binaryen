import {
	BinaryenObj,
} from "../../-pre.ts";
import type {
	Module,
} from "../../classes/module/Module.ts";
import {
	type ExpressionRef,
	Operation,
	i32 as i32_t,
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
		load: atomicLoadFn(mod, i32_t, 4),
		load8_u: atomicLoadFn(mod, i32_t, 1),
		load16_u: atomicLoadFn(mod, i32_t, 2),

		store: atomicStoreFn(mod, i32_t, 4),
		store8: atomicStoreFn(mod, i32_t, 1),
		store16: atomicStoreFn(mod, i32_t, 2),

		rmw: atomicRmwOps(mod, i32_t, 4),
		rmw8_u: atomicRmwOps(mod, i32_t, 1),
		rmw16_u: atomicRmwOps(mod, i32_t, 2),
	} as const;
}



/**
 * @see https://webassembly.github.io/spec/core/syntax/instructions.html#memory-instructions
 * @see https://webassembly.github.io/spec/core/syntax/instructions.html#numeric-instructions
 */
export function i32(mod: Module) {
	return {
		load: loadFn(mod, i32_t, 4, true),
		load8_s: loadFn(mod, i32_t, 1, true),
		load8_u: loadFn(mod, i32_t, 1, false),
		load16_s: loadFn(mod, i32_t, 2, true),
		load16_u: loadFn(mod, i32_t, 2, false),

		store: storeFn(mod, i32_t, 4),
		store8: storeFn(mod, i32_t, 1),
		store16: storeFn(mod, i32_t, 2),

		/** Return a static constant i32. */
		const: (value: number): ExpressionRef => (
			constant(mod, "_BinaryenLiteralInt32", value)
		),

		clz: unaryFn(mod, Operation.ClzInt32),
		ctz: unaryFn(mod, Operation.CtzInt32),
		popcnt: unaryFn(mod, Operation.PopcntInt32),
		extend8_s: unaryFn(mod, Operation.ExtendS8Int32),
		extend16_s: unaryFn(mod, Operation.ExtendS16Int32),

		add: binaryFn(mod, Operation.AddInt32),
		sub: binaryFn(mod, Operation.SubInt32),
		mul: binaryFn(mod, Operation.MulInt32),
		div_s: binaryFn(mod, Operation.DivSInt32),
		div_u: binaryFn(mod, Operation.DivUInt32),
		rem_s: binaryFn(mod, Operation.RemSInt32),
		rem_u: binaryFn(mod, Operation.RemUInt32),

		and: binaryFn(mod, Operation.AndInt32),
		or: binaryFn(mod, Operation.OrInt32),
		xor: binaryFn(mod, Operation.XorInt32),
		shl: binaryFn(mod, Operation.ShlInt32),
		shr_s: binaryFn(mod, Operation.ShrSInt32),
		shr_u: binaryFn(mod, Operation.ShrUInt32),
		rotl: binaryFn(mod, Operation.RotLInt32),
		rotr: binaryFn(mod, Operation.RotRInt32),

		eqz: unaryFn(mod, Operation.EqZInt32),

		eq: binaryFn(mod, Operation.EqInt32),
		ne: binaryFn(mod, Operation.NeInt32),
		lt_s: binaryFn(mod, Operation.LtSInt32),
		lt_u: binaryFn(mod, Operation.LtUInt32),
		gt_s: binaryFn(mod, Operation.GtSInt32),
		gt_u: binaryFn(mod, Operation.GtUInt32),
		le_s: binaryFn(mod, Operation.LeSInt32),
		le_u: binaryFn(mod, Operation.LeUInt32),
		ge_s: binaryFn(mod, Operation.GeSInt32),
		ge_u: binaryFn(mod, Operation.GeUInt32),

		wrap_i64: unaryFn(mod, Operation.WrapInt64),

		trunc_f32_s: unaryFn(mod, Operation.TruncSFloat32ToInt32),
		trunc_f32_u: unaryFn(mod, Operation.TruncUFloat32ToInt32),
		trunc_f64_s: unaryFn(mod, Operation.TruncSFloat64ToInt32),
		trunc_f64_u: unaryFn(mod, Operation.TruncUFloat64ToInt32),
		trunc_sat_f32_s: unaryFn(mod, Operation.TruncSatSFloat32ToInt32),
		trunc_sat_f32_u: unaryFn(mod, Operation.TruncSatUFloat32ToInt32),
		trunc_sat_f64_s: unaryFn(mod, Operation.TruncSatSFloat64ToInt32),
		trunc_sat_f64_u: unaryFn(mod, Operation.TruncSatUFloat64ToInt32),
		reinterpret_f32: unaryFn(mod, Operation.ReinterpretFloat32),

		/** @experimental */
		atomic: atomic(mod),

		// @ts-expect-error
		/** @deprecated Use `.wrap_i64()` instead. */ wrap(...args) { BinaryenObj.printWarn("`.wrap()` is deprecated; use `.wrap_i64()` instead."); return this.wrap_i64(...args); },
		/** @deprecated */
		trunc_s: {
			// @ts-expect-error
			/** @deprecated Use `.trunc_f32_s()` instead. */ f32: (...args) => { BinaryenObj.printWarn("`.trunc_s.f32()` is deprecated; use `.trunc_f32_s()` instead."); return i32(mod).trunc_f32_s(...args); },
			// @ts-expect-error
			/** @deprecated Use `.trunc_f64_s()` instead. */ f64: (...args) => { BinaryenObj.printWarn("`.trunc_s.f64()` is deprecated; use `.trunc_f64_s()` instead."); return i32(mod).trunc_f64_s(...args); },
		},
		/** @deprecated */
		trunc_u: {
			// @ts-expect-error
			/** @deprecated Use `.trunc_f32_u()` instead. */ f32: (...args) => { BinaryenObj.printWarn("`.trunc_u.f32()` is deprecated; use `.trunc_f32_u()` instead."); return i32(mod).trunc_f32_u(...args); },
			// @ts-expect-error
			/** @deprecated Use `.trunc_f64_u()` instead. */ f64: (...args) => { BinaryenObj.printWarn("`.trunc_u.f64()` is deprecated; use `.trunc_f64_u()` instead."); return i32(mod).trunc_f64_u(...args); },
		},
		/** @deprecated */
		trunc_s_sat: {
			// @ts-expect-error
			/** @deprecated Use `.trunc_sat_f32_s()` instead. */ f32: (...args) => { BinaryenObj.printWarn("`.trunc_s_sat.f32()` is deprecated; use `.trunc_sat_f32_s()` instead."); return i32(mod).trunc_sat_f32_s(...args); },
			// @ts-expect-error
			/** @deprecated Use `.trunc_sat_f64_s()` instead. */ f64: (...args) => { BinaryenObj.printWarn("`.trunc_s_sat.f64()` is deprecated; use `.trunc_sat_f64_s()` instead."); return i32(mod).trunc_sat_f64_s(...args); },
		},
		/** @deprecated */
		trunc_u_sat: {
			// @ts-expect-error
			/** @deprecated Use `.trunc_sat_f32_u()` instead. */ f32: (...args) => { BinaryenObj.printWarn("`.trunc_u_sat.f32()` is deprecated; use `.trunc_sat_f32_u()` instead."); return i32(mod).trunc_sat_f32_u(...args); },
			// @ts-expect-error
			/** @deprecated Use `.trunc_sat_f64_u()` instead. */ f64: (...args) => { BinaryenObj.printWarn("`.trunc_u_sat.f64()` is deprecated; use `.trunc_sat_f64_u()` instead."); return i32(mod).trunc_sat_f64_u(...args); },
		},
		// @ts-expect-error
		/** @deprecated Use `.reinterpret_f32()` instead. */ reinterpret(...args) { BinaryenObj.printWarn("`.reinterpret()` is deprecated; use `.reinterpret_f32()` instead."); return this.reinterpret_f32(...args); },
	} as const;
}
