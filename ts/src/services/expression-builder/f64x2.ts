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
export function f64x2(mod: Module) {
	return {
		abs: unaryFn(mod, Operation.AbsVecF64x2),
		neg: unaryFn(mod, Operation.NegVecF64x2),
		sqrt: unaryFn(mod, Operation.SqrtVecF64x2),
		ceil: unaryFn(mod, Operation.CeilVecF64x2),
		floor: unaryFn(mod, Operation.FloorVecF64x2),
		trunc: unaryFn(mod, Operation.TruncVecF64x2),
		nearest: unaryFn(mod, Operation.NearestVecF64x2),

		add: binaryFn(mod, Operation.AddVecF64x2),
		sub: binaryFn(mod, Operation.SubVecF64x2),
		mul: binaryFn(mod, Operation.MulVecF64x2),
		div: binaryFn(mod, Operation.DivVecF64x2),
		min: binaryFn(mod, Operation.MinVecF64x2),
		max: binaryFn(mod, Operation.MaxVecF64x2),
		pmin: binaryFn(mod, Operation.PMinVecF64x2),
		pmax: binaryFn(mod, Operation.PMaxVecF64x2),
		// TODO: relaxed_min
		// TODO: relaxed_max

		// TODO: relaxed_madd
		// TODO: relaxed_nmadd

		eq: binaryFn(mod, Operation.EqVecF64x2),
		ne: binaryFn(mod, Operation.NeVecF64x2),
		lt: binaryFn(mod, Operation.LtVecF64x2),
		gt: binaryFn(mod, Operation.GtVecF64x2),
		le: binaryFn(mod, Operation.LeVecF64x2),
		ge: binaryFn(mod, Operation.GeVecF64x2),

		convert_low_i32x4_s: unaryFn(mod, Operation.ConvertLowSVecI32x4ToVecF64x2),
		convert_low_i32x4_u: unaryFn(mod, Operation.ConvertLowUVecI32x4ToVecF64x2),

		promote_low_f32x4: unaryFn(mod, Operation.PromoteLowVecF32x4ToVecF64x2),

		splat: unaryFn(mod, Operation.SplatVecF64x2),
		extract_lane: simdExtractFn(mod, Operation.ExtractLaneVecF64x2),
		replace_lane: simdReplaceFn(mod, Operation.ReplaceLaneVecF64x2),
	} as const;
}
