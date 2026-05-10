import {
	BinaryenObj,
	HEAPU8,
	stackAlloc,
} from "../../-pre.ts";
import {
	preserveStack,
} from "../../-utils.ts";
import {
	ExpressionId,
	type ExpressionRef,
	type Operation,
} from "../../constants.ts";
import {
	Expression,
} from "./Expression.ts";



export class SIMDTernary extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.SIMDTernary, expr);
	}

	get op(): Operation { return BinaryenObj["_BinaryenSIMDTernaryGetOp"](this._ptr); }
	set op(op: Operation) { BinaryenObj["_BinaryenSIMDTernarySetOp"](this._ptr, op); }

	get a(): ExpressionRef { return BinaryenObj["_BinaryenSIMDTernaryGetA"](this._ptr); }
	set a(aExpr: ExpressionRef) { BinaryenObj["_BinaryenSIMDTernarySetA"](this._ptr, aExpr); }

	get b(): ExpressionRef { return BinaryenObj["_BinaryenSIMDTernaryGetB"](this._ptr); }
	set b(bExpr: ExpressionRef) { BinaryenObj["_BinaryenSIMDTernarySetB"](this._ptr, bExpr); }

	get c(): ExpressionRef { return BinaryenObj["_BinaryenSIMDTernaryGetC"](this._ptr); }
	set c(cExpr: ExpressionRef) { BinaryenObj["_BinaryenSIMDTernarySetC"](this._ptr, cExpr); }
}



export class SIMDShift extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.SIMDShift, expr);
	}

	get op(): Operation { return BinaryenObj["_BinaryenSIMDShiftGetOp"](this._ptr); }
	set op(op: Operation) { BinaryenObj["_BinaryenSIMDShiftSetOp"](this._ptr, op); }

	get vec(): ExpressionRef { return BinaryenObj["_BinaryenSIMDShiftGetVec"](this._ptr); }
	set vec(vecExpr: ExpressionRef) { BinaryenObj["_BinaryenSIMDShiftSetVec"](this._ptr, vecExpr); }

	get shift(): ExpressionRef { return BinaryenObj["_BinaryenSIMDShiftGetShift"](this._ptr); }
	set shift(shiftExpr: ExpressionRef) { BinaryenObj["_BinaryenSIMDShiftSetShift"](this._ptr, shiftExpr); }
}



export class SIMDShuffle extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.SIMDShuffle, expr);
	}

	get left(): ExpressionRef { return BinaryenObj["_BinaryenSIMDShuffleGetLeft"](this._ptr); }
	set left(leftExpr: ExpressionRef) { BinaryenObj["_BinaryenSIMDShuffleSetLeft"](this._ptr, leftExpr); }

	get right(): ExpressionRef { return BinaryenObj["_BinaryenSIMDShuffleGetRight"](this._ptr); }
	set right(rightExpr: ExpressionRef) { BinaryenObj["_BinaryenSIMDShuffleSetRight"](this._ptr, rightExpr); }

	get mask(): number[] {
		const mask: number[] = [];
		preserveStack(() => {
			const tempBuffer = stackAlloc(16);
			BinaryenObj["_BinaryenSIMDShuffleGetMask"](this._ptr, tempBuffer);
			for (let i = 0; i < 16; ++i) {
				mask[i] = HEAPU8[tempBuffer + i];
			}
		});
		return mask;
	}

	set mask(mask: readonly number[]) {
		preserveStack(() => {
			const tempBuffer = stackAlloc(16);
			for (let i = 0; i < 16; ++i) {
				HEAPU8[tempBuffer + i] = mask[i];
			}
			BinaryenObj["_BinaryenSIMDShuffleSetMask"](this._ptr, tempBuffer);
		});
	}
}



export class SIMDExtract extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.SIMDExtract, expr);
	}

	get op(): Operation { return BinaryenObj["_BinaryenSIMDExtractGetOp"](this._ptr); }
	set op(op: Operation) { BinaryenObj["_BinaryenSIMDExtractSetOp"](this._ptr, op); }

	get vec(): ExpressionRef { return BinaryenObj["_BinaryenSIMDExtractGetVec"](this._ptr); }
	set vec(vecExpr: ExpressionRef) { BinaryenObj["_BinaryenSIMDExtractSetVec"](this._ptr, vecExpr); }

	get index(): number { return BinaryenObj["_BinaryenSIMDExtractGetIndex"](this._ptr); }
	set index(index: number) { BinaryenObj["_BinaryenSIMDExtractSetIndex"](this._ptr, index); }
}



export class SIMDReplace extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.SIMDReplace, expr);
	}

	get op(): Operation { return BinaryenObj["_BinaryenSIMDReplaceGetOp"](this._ptr); }
	set op(op: Operation) { BinaryenObj["_BinaryenSIMDReplaceSetOp"](this._ptr, op); }

	get vec(): ExpressionRef { return BinaryenObj["_BinaryenSIMDReplaceGetVec"](this._ptr); }
	set vec(vecExpr: ExpressionRef) { BinaryenObj["_BinaryenSIMDReplaceSetVec"](this._ptr, vecExpr); }

	get index(): number { return BinaryenObj["_BinaryenSIMDReplaceGetIndex"](this._ptr); }
	set index(index: number) { BinaryenObj["_BinaryenSIMDReplaceSetIndex"](this._ptr, index); }

	get value(): ExpressionRef { return BinaryenObj["_BinaryenSIMDReplaceGetValue"](this._ptr); }
	set value(value: ExpressionRef) { BinaryenObj["_BinaryenSIMDReplaceSetValue"](this._ptr, value); }
}
