import {
	consoleWarn,
} from "../../lib.ts";
import {
	Operation,
} from "../../classes/expression/Operation.ts";
import type {
	Module,
} from "../../classes/module/Module.ts";
import {
	type ExpressionRef,
	f32 as f32_t,
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
export function f32(mod: Module) {
	return {
		load: loadFn(mod, f32_t, 4, true),
		store: storeFn(mod, f32_t, 4),

		/** Return a static constant f32. */
		const: (value: number): ExpressionRef => (
			constant(mod, "_BinaryenLiteralFloat32", value)
		),

		const_bits: (value: number): ExpressionRef => (
			constant(mod, "_BinaryenLiteralFloat32Bits", value)
		),

		abs: unaryFn(mod, Operation.AbsFloat32),
		neg: unaryFn(mod, Operation.NegFloat32),
		sqrt: unaryFn(mod, Operation.SqrtFloat32),
		ceil: unaryFn(mod, Operation.CeilFloat32),
		floor: unaryFn(mod, Operation.FloorFloat32),
		trunc: unaryFn(mod, Operation.TruncFloat32),
		nearest: unaryFn(mod, Operation.NearestFloat32),

		add: binaryFn(mod, Operation.AddFloat32),
		sub: binaryFn(mod, Operation.SubFloat32),
		mul: binaryFn(mod, Operation.MulFloat32),
		div: binaryFn(mod, Operation.DivFloat32),
		min: binaryFn(mod, Operation.MinFloat32),
		max: binaryFn(mod, Operation.MaxFloat32),
		copysign: binaryFn(mod, Operation.CopySignFloat32),

		eq: binaryFn(mod, Operation.EqFloat32),
		ne: binaryFn(mod, Operation.NeFloat32),
		lt: binaryFn(mod, Operation.LtFloat32),
		gt: binaryFn(mod, Operation.GtFloat32),
		le: binaryFn(mod, Operation.LeFloat32),
		ge: binaryFn(mod, Operation.GeFloat32),

		convert_i32_s: unaryFn(mod, Operation.ConvertSInt32ToFloat32),
		convert_i32_u: unaryFn(mod, Operation.ConvertUInt32ToFloat32),
		convert_i64_s: unaryFn(mod, Operation.ConvertSInt64ToFloat32),
		convert_i64_u: unaryFn(mod, Operation.ConvertUInt64ToFloat32),
		reinterpret_i32: unaryFn(mod, Operation.ReinterpretInt32),

		demote_f64: unaryFn(mod, Operation.DemoteFloat64),

		/** @deprecated */
		convert_s: {
			// @ts-expect-error
			/** @deprecated Use `.convert_i32_s()` instead. */ i32: (...args) => { consoleWarn("`.convert_s.i32()` is deprecated; use `.convert_i32_s()` instead."); return f32(mod).convert_i32_s(...args); },
			// @ts-expect-error
			/** @deprecated Use `.convert_i64_s()` instead. */ i64: (...args) => { consoleWarn("`.convert_s.i64()` is deprecated; use `.convert_i64_s()` instead."); return f32(mod).convert_i64_s(...args); },
		},
		/** @deprecated */
		convert_u: {
			// @ts-expect-error
			/** @deprecated Use `.convert_i32_u()` instead. */ i32: (...args) => { consoleWarn("`.convert_u.i32()` is deprecated; use `.convert_i32_u()` instead."); return f32(mod).convert_i32_u(...args); },
			// @ts-expect-error
			/** @deprecated Use `.convert_i64_u()` instead. */ i64: (...args) => { consoleWarn("`.convert_u.i64()` is deprecated; use `.convert_i64_u()` instead."); return f32(mod).convert_i64_u(...args); },
		},
		// @ts-expect-error
		/** @deprecated Use `.reinterpret_i32()` instead. */ reinterpret(...args) { consoleWarn("`.reinterpret()` is deprecated; use `.reinterpret_i32()` instead."); return this.reinterpret_i32(...args); },
		// @ts-expect-error
		/** @deprecated Use `.demote_f64()` instead. */ demote(...args) { consoleWarn("`.demote()` is deprecated; use `.demote_f64()` instead."); return this.demote_f64(...args); },
	} as const;
}
