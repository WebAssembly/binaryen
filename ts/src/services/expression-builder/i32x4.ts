import type {
	Module,
} from "../../classes/module/Module.ts";
import {
	Operation,
} from "../../constants.ts";
import {
	binaryFn,
	simdExtractFn,
	simdReplaceFn,
	simdShiftFn,
	unaryFn,
} from "./-utils.ts";



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#vector-instructions */
export function i32x4(mod: Module) {
	return {
		abs: unaryFn(mod, Operation.AbsVecI32x4),
		neg: unaryFn(mod, Operation.NegVecI32x4),

		add: binaryFn(mod, Operation.AddVecI32x4),
		sub: binaryFn(mod, Operation.SubVecI32x4),
		mul: binaryFn(mod, Operation.MulVecI32x4),
		min_s: binaryFn(mod, Operation.MinSVecI32x4),
		min_u: binaryFn(mod, Operation.MinUVecI32x4),
		max_s: binaryFn(mod, Operation.MaxSVecI32x4),
		max_u: binaryFn(mod, Operation.MaxUVecI32x4),

		// TODO: relaxed_laneselect

		all_true: unaryFn(mod, Operation.AllTrueVecI32x4),

		eq: binaryFn(mod, Operation.EqVecI32x4),
		ne: binaryFn(mod, Operation.NeVecI32x4),
		lt_s: binaryFn(mod, Operation.LtSVecI32x4),
		lt_u: binaryFn(mod, Operation.LtUVecI32x4),
		gt_s: binaryFn(mod, Operation.GtSVecI32x4),
		gt_u: binaryFn(mod, Operation.GtUVecI32x4),
		le_s: binaryFn(mod, Operation.LeSVecI32x4),
		le_u: binaryFn(mod, Operation.LeUVecI32x4),
		ge_s: binaryFn(mod, Operation.GeSVecI32x4),
		ge_u: binaryFn(mod, Operation.GeUVecI32x4),

		shl: simdShiftFn(mod, Operation.ShlVecI32x4),
		shr_s: simdShiftFn(mod, Operation.ShrSVecI32x4),
		shr_u: simdShiftFn(mod, Operation.ShrUVecI32x4),

		bitmask: unaryFn(mod, Operation.BitmaskVecI32x4),

		extadd_pairwise_i16x8_s: unaryFn(mod, Operation.ExtAddPairwiseSVecI16x8ToI32x4),
		extadd_pairwise_i16x8_u: unaryFn(mod, Operation.ExtAddPairwiseUVecI16x8ToI32x4),

		// NOTE: operation names correspond to “this” object, not instruction names
		extmul_low_i16x8_s: binaryFn(mod, Operation.ExtMulLowSVecI32x4),
		extmul_low_i16x8_u: binaryFn(mod, Operation.ExtMulLowUVecI32x4),
		extmul_high_i16x8_s: binaryFn(mod, Operation.ExtMulHighSVecI32x4),
		extmul_high_i16x8_u: binaryFn(mod, Operation.ExtMulHighUVecI32x4),

		dot_i16x8_s: binaryFn(mod, Operation.DotSVecI16x8ToVecI32x4),
		// TODO: relaxed_dot_i8x16_i7x16_add_s

		extend_low_i16x8_s: unaryFn(mod, Operation.ExtendLowSVecI16x8ToVecI32x4),
		extend_low_i16x8_u: unaryFn(mod, Operation.ExtendLowUVecI16x8ToVecI32x4),
		extend_high_i16x8_s: unaryFn(mod, Operation.ExtendHighSVecI16x8ToVecI32x4),
		extend_high_i16x8_u: unaryFn(mod, Operation.ExtendHighUVecI16x8ToVecI32x4),

		trunc_sat_f32x4_s: unaryFn(mod, Operation.TruncSatSVecF32x4ToVecI32x4),
		trunc_sat_f32x4_u: unaryFn(mod, Operation.TruncSatUVecF32x4ToVecI32x4),
		trunc_sat_f64x2_s_zero: unaryFn(mod, Operation.TruncSatZeroSVecF64x2ToVecI32x4),
		trunc_sat_f64x2_u_zero: unaryFn(mod, Operation.TruncSatZeroUVecF64x2ToVecI32x4),
		// TODO: relaxed_trunc_f32x4_s
		// TODO: relaxed_trunc_f32x4_u
		// TODO: relaxed_trunc_f64x2_s_zero
		// TODO: relaxed_trunc_f64x2_u_zero

		splat: unaryFn(mod, Operation.SplatVecI32x4),
		extract_lane: simdExtractFn(mod, Operation.ExtractLaneVecI32x4),
		replace_lane: simdReplaceFn(mod, Operation.ReplaceLaneVecI32x4),
	} as const;
}
