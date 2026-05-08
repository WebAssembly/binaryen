import type {
	Module,
} from "../../classes/module/Module.ts";
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
export function i16x8(mod: Module) {
	return {
		abs: unaryFn(mod, Operation.AbsVecI16x8),
		neg: unaryFn(mod, Operation.NegVecI16x8),

		add: binaryFn(mod, Operation.AddVecI16x8),
		sub: binaryFn(mod, Operation.SubVecI16x8),
		add_sat_s: binaryFn(mod, Operation.AddSatSVecI16x8), // TODO: deprecate `add_saturate_s`
		add_sat_u: binaryFn(mod, Operation.AddSatUVecI16x8), // TODO: deprecate `add_saturate_u`
		sub_sat_s: binaryFn(mod, Operation.SubSatSVecI16x8), // TODO: deprecate `sub_saturate_s`
		sub_sat_u: binaryFn(mod, Operation.SubSatUVecI16x8), // TODO: deprecate `sub_saturate_u`
		mul: binaryFn(mod, Operation.MulVecI16x8),
		avgr_u: binaryFn(mod, Operation.AvgrUVecI16x8),
		q15mulr_sat_s: binaryFn(mod, Operation.Q15MulrSatSVecI16x8),
		// TODO: relaxed_q15mulr_s
		min_s: binaryFn(mod, Operation.MinSVecI16x8),
		min_u: binaryFn(mod, Operation.MinUVecI16x8),
		max_s: binaryFn(mod, Operation.MaxSVecI16x8),
		max_u: binaryFn(mod, Operation.MaxUVecI16x8),

		// TODO: relaxed_laneselect

		all_true: unaryFn(mod, Operation.AllTrueVecI16x8),

		eq: binaryFn(mod, Operation.EqVecI16x8),
		ne: binaryFn(mod, Operation.NeVecI16x8),
		lt_s: binaryFn(mod, Operation.LtSVecI16x8),
		lt_u: binaryFn(mod, Operation.LtUVecI16x8),
		gt_s: binaryFn(mod, Operation.GtSVecI16x8),
		gt_u: binaryFn(mod, Operation.GtUVecI16x8),
		le_s: binaryFn(mod, Operation.LeSVecI16x8),
		le_u: binaryFn(mod, Operation.LeUVecI16x8),
		ge_s: binaryFn(mod, Operation.GeSVecI16x8),
		ge_u: binaryFn(mod, Operation.GeUVecI16x8),

		shl: simdShiftFn(mod, Operation.ShlVecI16x8),
		shr_s: simdShiftFn(mod, Operation.ShrSVecI16x8),
		shr_u: simdShiftFn(mod, Operation.ShrUVecI16x8),

		bitmask: unaryFn(mod, Operation.BitmaskVecI16x8),

		extadd_pairwise_i8x16_s: unaryFn(mod, Operation.ExtAddPairwiseSVecI8x16ToI16x8),
		extadd_pairwise_i8x16_u: unaryFn(mod, Operation.ExtAddPairwiseUVecI8x16ToI16x8),

		// NOTE: operation names correspond to “this” object, not instruction names
		extmul_low_i8x16_s: binaryFn(mod, Operation.ExtMulLowSVecI16x8),
		extmul_low_i8x16_u: binaryFn(mod, Operation.ExtMulLowUVecI16x8),
		extmul_high_i8x16_s: binaryFn(mod, Operation.ExtMulHighSVecI16x8),
		extmul_high_i8x16_u: binaryFn(mod, Operation.ExtMulHighUVecI16x8),

		// TODO: relaxed_dot_i8x16_i7x16_s

		narrow_i32x4_s: binaryFn(mod, Operation.NarrowSVecI32x4ToVecI16x8),
		narrow_i32x4_u: binaryFn(mod, Operation.NarrowUVecI32x4ToVecI16x8),

		extend_low_i8x16_s: unaryFn(mod, Operation.ExtendLowSVecI8x16ToVecI16x8),
		extend_low_i8x16_u: unaryFn(mod, Operation.ExtendLowUVecI8x16ToVecI16x8),
		extend_high_i8x16_s: unaryFn(mod, Operation.ExtendHighSVecI8x16ToVecI16x8),
		extend_high_i8x16_u: unaryFn(mod, Operation.ExtendHighUVecI8x16ToVecI16x8),

		splat: unaryFn(mod, Operation.SplatVecI16x8),
		extract_lane_s: simdExtractFn(mod, Operation.ExtractLaneSVecI16x8),
		extract_lane_u: simdExtractFn(mod, Operation.ExtractLaneUVecI16x8),
		replace_lane: simdReplaceFn(mod, Operation.ReplaceLaneVecI16x8),
	} as const;
}
