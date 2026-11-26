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
	unaryFn,
} from "./-utils.ts";



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#vector-instructions */
export function f32x4(mod: Module) {
	return {
		abs: unaryFn(mod, Operation.AbsVecF32x4),
		neg: unaryFn(mod, Operation.NegVecF32x4),
		sqrt: unaryFn(mod, Operation.SqrtVecF32x4),
		ceil: unaryFn(mod, Operation.CeilVecF32x4),
		floor: unaryFn(mod, Operation.FloorVecF32x4),
		trunc: unaryFn(mod, Operation.TruncVecF32x4),
		nearest: unaryFn(mod, Operation.NearestVecF32x4),

		add: binaryFn(mod, Operation.AddVecF32x4),
		sub: binaryFn(mod, Operation.SubVecF32x4),
		mul: binaryFn(mod, Operation.MulVecF32x4),
		div: binaryFn(mod, Operation.DivVecF32x4),
		min: binaryFn(mod, Operation.MinVecF32x4),
		max: binaryFn(mod, Operation.MaxVecF32x4),
		pmin: binaryFn(mod, Operation.PMinVecF32x4),
		pmax: binaryFn(mod, Operation.PMaxVecF32x4),
		// TODO: relaxed_min
		// TODO: relaxed_max

		// TODO: relaxed_madd
		// TODO: relaxed_nmadd

		eq: binaryFn(mod, Operation.EqVecF32x4),
		ne: binaryFn(mod, Operation.NeVecF32x4),
		lt: binaryFn(mod, Operation.LtVecF32x4),
		gt: binaryFn(mod, Operation.GtVecF32x4),
		le: binaryFn(mod, Operation.LeVecF32x4),
		ge: binaryFn(mod, Operation.GeVecF32x4),

		convert_i32x4_s: unaryFn(mod, Operation.ConvertSVecI32x4ToVecF32x4),
		convert_i32x4_u: unaryFn(mod, Operation.ConvertUVecI32x4ToVecF32x4),

		demote_f64x2_zero: unaryFn(mod, Operation.DemoteZeroVecF64x2ToVecF32x4),

		splat: unaryFn(mod, Operation.SplatVecF32x4),
		extract_lane: simdExtractFn(mod, Operation.ExtractLaneVecF32x4),
		replace_lane: simdReplaceFn(mod, Operation.ReplaceLaneVecF32x4),
	} as const;
}
