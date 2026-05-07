import {
	BinaryenObj,
} from "../../-pre.ts";
import {
	i8sToStack,
} from "../../-utils.ts";
import type {
	Module,
} from "../../classes/module/Module.ts";
import {
	type ExpressionRef,
	v128 as v128_t,
} from "../../constants.ts";
import {
	binaryFn,
	constant,
	loadFn,
	simdLoadFn,
	simdLoadStoreLaneFn,
	storeFn,
	unaryFn,
} from "./-utils.ts";
import {
	Operation,
} from "./Operation.ts";



/**
 * @see https://webassembly.github.io/spec/core/syntax/instructions.html#memory-instructions
 * @see https://webassembly.github.io/spec/core/syntax/instructions.html#vector-instructions
 */
export function v128(mod: Module) {
	return {
		load: loadFn(mod, v128_t, 16, false),
		load8x8_s: simdLoadFn(mod, Operation.Load8x8SVec128),
		load8x8_u: simdLoadFn(mod, Operation.Load8x8UVec128),
		load16x4_s: simdLoadFn(mod, Operation.Load16x4SVec128),
		load16x4_u: simdLoadFn(mod, Operation.Load16x4UVec128),
		load32x2_s: simdLoadFn(mod, Operation.Load32x2SVec128),
		load32x2_u: simdLoadFn(mod, Operation.Load32x2UVec128),
		load8_splat: simdLoadFn(mod, Operation.Load8SplatVec128),
		load16_splat: simdLoadFn(mod, Operation.Load16SplatVec128),
		load32_splat: simdLoadFn(mod, Operation.Load32SplatVec128),
		load64_splat: simdLoadFn(mod, Operation.Load64SplatVec128),
		load32_zero: simdLoadFn(mod, Operation.Load32ZeroVec128),
		load64_zero: simdLoadFn(mod, Operation.Load64ZeroVec128),
		load8_lane: simdLoadStoreLaneFn(mod, Operation.Load8LaneVec128),
		load16_lane: simdLoadStoreLaneFn(mod, Operation.Load16LaneVec128),
		load32_lane: simdLoadStoreLaneFn(mod, Operation.Load32LaneVec128),
		load64_lane: simdLoadStoreLaneFn(mod, Operation.Load64LaneVec128),

		store: storeFn(mod, v128_t, 16),
		store8_lane: simdLoadStoreLaneFn(mod, Operation.Store8LaneVec128),
		store16_lane: simdLoadStoreLaneFn(mod, Operation.Store16LaneVec128),
		store32_lane: simdLoadStoreLaneFn(mod, Operation.Store32LaneVec128),
		store64_lane: simdLoadStoreLaneFn(mod, Operation.Store64LaneVec128),

		/** Return a static constant v128. */
		const: (i8s: readonly number[]): ExpressionRef => (
			constant(mod, "_BinaryenLiteralVec128", i8sToStack(i8s))
		),

		not: unaryFn(mod, Operation.NotVec128),

		and: binaryFn(mod, Operation.AndVec128),
		andnot: binaryFn(mod, Operation.AndNotVec128),
		or: binaryFn(mod, Operation.OrVec128),
		xor: binaryFn(mod, Operation.XorVec128),

		bitselect: (left: ExpressionRef, right: ExpressionRef, cond: ExpressionRef): ExpressionRef => (
			BinaryenObj["_BinaryenSIMDTernary"](mod.ptr, Operation.BitselectVec128, left, right, cond)
		),

		anytrue: unaryFn(mod, Operation.AnyTrueVec128),
	} as const;
}
