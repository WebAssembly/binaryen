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
	i32,
	i64,
	f32,
	f64,
	v128,
} from "../../constants.ts";
import {
	Expression,
} from "./Expression.ts";



export class Const extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.Const, expr);
	}

	get value(): number | number[] {
		const this_type = this.type;
		switch (this_type) {
			case i32: { return this.valueI32; }
			case i64: { return this.valueI64; }
			case f32: { return this.valueF32; }
			case f64: { return this.valueF64; }
			case v128: { return this.valueV128; }
		}
		throw new Error(`Unexpected type: ${ this_type }.`);
	}

	get valueI32(): number { return BinaryenObj["_BinaryenConstGetValueI32"](this._ptr); }
	set valueI32(value: number) { BinaryenObj["_BinaryenConstSetValueI32"](this._ptr, value); }

	get valueI64(): number { return BinaryenObj["_BinaryenConstGetValueI64"](this._ptr); }
	set valueI64(value: number) { BinaryenObj["_BinaryenConstSetValueI64"](this._ptr, BigInt(value)); }

	get valueF32(): number { return BinaryenObj["_BinaryenConstGetValueF32"](this._ptr); }
	set valueF32(value: number) { BinaryenObj["_BinaryenConstSetValueF32"](this._ptr, value); }

	get valueF64(): number { return BinaryenObj["_BinaryenConstGetValueF64"](this._ptr); }
	set valueF64(value: number) { BinaryenObj["_BinaryenConstSetValueF64"](this._ptr, value); }

	get valueV128(): number[] {
		const value: number[] = [];
		preserveStack(() => {
			const tempBuffer = stackAlloc(16);
			BinaryenObj["_BinaryenConstGetValueV128"](this._ptr, tempBuffer);
			for (let i = 0; i < 16; ++i) {
				value[i] = HEAPU8[tempBuffer + i];
			}
		});
		return value;
	}

	set valueV128(value: readonly number[]) {
		preserveStack(() => {
			const tempBuffer = stackAlloc(16);
			for (let i = 0; i < 16; ++i) {
				HEAPU8[tempBuffer + i] = value[i];
			}
			BinaryenObj["_BinaryenConstSetValueV128"](this._ptr, tempBuffer);
		});
	}
}



export class Unary extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.Unary, expr);
	}

	get op(): Operation { return BinaryenObj["_BinaryenUnaryGetOp"](this._ptr); }
	set op(op: Operation) { BinaryenObj["_BinaryenUnarySetOp"](this._ptr, op); }

	get value(): ExpressionRef { return BinaryenObj["_BinaryenUnaryGetValue"](this._ptr); }
	set value(valueExpr: ExpressionRef) { BinaryenObj["_BinaryenUnarySetValue"](this._ptr, valueExpr); }
}



export class Binary extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.Binary, expr);
	}

	get op(): Operation { return BinaryenObj["_BinaryenBinaryGetOp"](this._ptr); }
	set op(op: Operation) { BinaryenObj["_BinaryenBinarySetOp"](this._ptr, op); }

	get left(): ExpressionRef { return BinaryenObj["_BinaryenBinaryGetLeft"](this._ptr); }
	set left(leftExpr: ExpressionRef) { BinaryenObj["_BinaryenBinarySetLeft"](this._ptr, leftExpr); }

	get right(): ExpressionRef { return BinaryenObj["_BinaryenBinaryGetRight"](this._ptr); }
	set right(rightExpr: ExpressionRef) { BinaryenObj["_BinaryenBinarySetRight"](this._ptr, rightExpr); }
}



export class WideIntAddSub extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.WideIntAddSub, expr);
	}

	get op(): Operation { return BinaryenObj["_BinaryenWideIntAddSubGetOp"](this._ptr); }
	set op(op: Operation) { BinaryenObj["_BinaryenWideIntAddSubSetOp"](this._ptr, op); }

	get leftLow(): ExpressionRef { return BinaryenObj["_BinaryenWideIntAddSubGetLeftLow"](this._ptr); }
	set leftLow(leftExpr: ExpressionRef) { BinaryenObj["_BinaryenWideIntAddSubSetLeftLow"](this._ptr, leftExpr); }

	get leftHigh(): ExpressionRef { return BinaryenObj["_BinaryenWideIntAddSubGetLeftHigh"](this._ptr); }
	set leftHigh(leftExpr: ExpressionRef) { BinaryenObj["_BinaryenWideIntAddSubSetLeftHigh"](this._ptr, leftExpr); }

	get rightLow(): ExpressionRef { return BinaryenObj["_BinaryenWideIntAddSubGetRightLow"](this._ptr); }
	set rightLow(rightExpr: ExpressionRef) { BinaryenObj["_BinaryenWideIntAddSubSetRightLow"](this._ptr, rightExpr); }

	get rightHigh(): ExpressionRef { return BinaryenObj["_BinaryenWideIntAddSubGetRightHigh"](this._ptr); }
	set rightHigh(rightExpr: ExpressionRef) { BinaryenObj["_BinaryenWideIntAddSubSetRightHigh"](this._ptr, rightExpr); }
}



export class WideIntMul extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.WideIntMul, expr);
	}

	get op(): Operation { return BinaryenObj["_BinaryenWideIntMulGetOp"](this._ptr); }
	set op(op: Operation) { BinaryenObj["_BinaryenWideIntMulSetOp"](this._ptr, op); }

	get left(): ExpressionRef { return BinaryenObj["_BinaryenWideIntMulGetLeft"](this._ptr); }
	set left(leftExpr: ExpressionRef) { BinaryenObj["_BinaryenWideIntMulSetLeft"](this._ptr, leftExpr); }

	get right(): ExpressionRef { return BinaryenObj["_BinaryenWideIntMulGetRight"](this._ptr); }
	set right(rightExpr: ExpressionRef) { BinaryenObj["_BinaryenWideIntMulSetRight"](this._ptr, rightExpr); }
}
