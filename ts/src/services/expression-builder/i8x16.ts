import {
	BinaryenObj,
} from "../../-pre.ts";
import {
	i8sToStack,
	preserveStack,
} from "../../-utils.ts";
import type {
	Module,
} from "../../classes/module/Module.ts";
import type {
	ExpressionRef,
} from "../../constants.ts";
import {
	consoleWarn,
} from "../../lib.ts";
import {
	binaryFn,
	simdExtractFn,
	simdReplaceFn,
	simdShiftFn,
	unaryFn,
} from "./-utils.ts";
import {
	Operation,
} from "./Operation.ts";



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#vector-instructions */
export function i8x16(mod: Module) {
	return {
		abs: unaryFn(mod, Operation.AbsVecI8x16),
		neg: unaryFn(mod, Operation.NegVecI8x16),
		popcnt: unaryFn(mod, Operation.PopcntVecI8x16),

		add: binaryFn(mod, Operation.AddVecI8x16),
		sub: binaryFn(mod, Operation.SubVecI8x16),
		add_sat_s: binaryFn(mod, Operation.AddSatSVecI8x16),
		add_sat_u: binaryFn(mod, Operation.AddSatUVecI8x16),
		sub_sat_s: binaryFn(mod, Operation.SubSatSVecI8x16),
		sub_sat_u: binaryFn(mod, Operation.SubSatUVecI8x16),
		avgr_u: binaryFn(mod, Operation.AvgrUVecI8x16),
		min_s: binaryFn(mod, Operation.MinSVecI8x16),
		min_u: binaryFn(mod, Operation.MinUVecI8x16),
		max_s: binaryFn(mod, Operation.MaxSVecI8x16),
		max_u: binaryFn(mod, Operation.MaxUVecI8x16),

		// TODO: relaxed_laneselect

		all_true: unaryFn(mod, Operation.AllTrueVecI8x16),

		eq: binaryFn(mod, Operation.EqVecI8x16),
		ne: binaryFn(mod, Operation.NeVecI8x16),
		lt_s: binaryFn(mod, Operation.LtSVecI8x16),
		lt_u: binaryFn(mod, Operation.LtUVecI8x16),
		gt_s: binaryFn(mod, Operation.GtSVecI8x16),
		gt_u: binaryFn(mod, Operation.GtUVecI8x16),
		le_s: binaryFn(mod, Operation.LeSVecI8x16),
		le_u: binaryFn(mod, Operation.LeUVecI8x16),
		ge_s: binaryFn(mod, Operation.GeSVecI8x16),
		ge_u: binaryFn(mod, Operation.GeUVecI8x16),

		shl: simdShiftFn(mod, Operation.ShlVecI8x16),
		shr_s: simdShiftFn(mod, Operation.ShrSVecI8x16),
		shr_u: simdShiftFn(mod, Operation.ShrUVecI8x16),

		bitmask: unaryFn(mod, Operation.BitmaskVecI8x16),

		swizzle: binaryFn(mod, Operation.SwizzleVecI8x16),
		// TODO: relaxed_swizzle

		shuffle: (left: ExpressionRef, right: ExpressionRef, mask: readonly number[]): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenSIMDShuffle"](mod.ptr, left, right, i8sToStack(mask)))
		),

		narrow_i16x8_s: binaryFn(mod, Operation.NarrowSVecI16x8ToVecI8x16),
		narrow_i16x8_u: binaryFn(mod, Operation.NarrowUVecI16x8ToVecI8x16),

		splat: unaryFn(mod, Operation.SplatVecI8x16),
		extract_lane_s: simdExtractFn(mod, Operation.ExtractLaneSVecI8x16),
		extract_lane_u: simdExtractFn(mod, Operation.ExtractLaneUVecI8x16),
		replace_lane: simdReplaceFn(mod, Operation.ReplaceLaneVecI8x16),

		// @ts-expect-error
		/** @deprecated Use {@link ExpressionBuilder#i8x16 | ExpressionBuilder#i8x16.add_sat_s} instead. */ add_saturate_s(...args) { consoleWarn("`.i8x16.add_saturate_s()` is deprecated; use `.i8x16.add_sat_s()` instead."); return this.add_sat_s(...args); },
		// @ts-expect-error
		/** @deprecated Use {@link ExpressionBuilder#i8x16 | ExpressionBuilder#i8x16.add_sat_u} instead. */ add_saturate_u(...args) { consoleWarn("`.i8x16.add_saturate_u()` is deprecated; use `.i8x16.add_sat_u()` instead."); return this.add_sat_u(...args); },
		// @ts-expect-error
		/** @deprecated Use {@link ExpressionBuilder#i8x16 | ExpressionBuilder#i8x16.sub_sat_s} instead. */ sub_saturate_s(...args) { consoleWarn("`.i8x16.sub_saturate_s()` is deprecated; use `.i8x16.sub_sat_s()` instead."); return this.sub_sat_s(...args); },
		// @ts-expect-error
		/** @deprecated Use {@link ExpressionBuilder#i8x16 | ExpressionBuilder#i8x16.sub_sat_u} instead. */ sub_saturate_u(...args) { consoleWarn("`.i8x16.sub_saturate_u()` is deprecated; use `.i8x16.sub_sat_u()` instead."); return this.sub_sat_u(...args); },
	} as const;
}
