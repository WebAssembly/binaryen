import {
	BinaryenObj,
	UTF8ToString,
} from "../../-pre.ts";
import {
	getAllNested,
	preserveStack,
	setAllNested,
	strToStack,
} from "../../-utils.ts";
import {
	ExpressionId,
	type ExpressionRef,
} from "../../constants.ts";
import {
	Expression,
} from "./Expression.ts";



export class TupleMake extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.TupleMake, expr);
	}

	get numOperands(): number {
		return BinaryenObj["_BinaryenTupleMakeGetNumOperands"](this._ptr);
	}

	get operands(): ExpressionRef[] {
		return getAllNested(
			this._ptr,
			BinaryenObj["_BinaryenTupleMakeGetNumOperands"],
			BinaryenObj["_BinaryenTupleMakeGetOperandAt"],
		);
	}

	set operands(operands: readonly ExpressionRef[]) {
		setAllNested(
			this._ptr,
			operands,
			BinaryenObj["_BinaryenTupleMakeGetNumOperands"],
			BinaryenObj["_BinaryenTupleMakeSetOperandAt"],
			BinaryenObj["_BinaryenTupleMakeAppendOperand"],
			BinaryenObj["_BinaryenTupleMakeRemoveOperandAt"],
		);
	}

	getOperandAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenTupleMakeGetOperandAt"](this._ptr, index);
	}

	setOperandAt(index: number, operandExpr: ExpressionRef): void {
		BinaryenObj["_BinaryenTupleMakeSetOperandAt"](this._ptr, index, operandExpr);
	}

	appendOperand(operandExpr: ExpressionRef): number {
		return BinaryenObj["_BinaryenTupleMakeAppendOperand"](this._ptr, operandExpr);
	}

	insertOperandAt(index: number, operandExpr: ExpressionRef): void {
		BinaryenObj["_BinaryenTupleMakeInsertOperandAt"](this._ptr, index, operandExpr);
	}

	removeOperandAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenTupleMakeRemoveOperandAt"](this._ptr, index);
	}
}



export class TupleExtract extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.TupleExtract, expr);
	}

	get tuple(): ExpressionRef { return BinaryenObj["_BinaryenTupleExtractGetTuple"](this._ptr); }
	set tuple(tupleExpr: ExpressionRef) { BinaryenObj["_BinaryenTupleExtractSetTuple"](this._ptr, tupleExpr); }

	get index(): number { return BinaryenObj["_BinaryenTupleExtractGetIndex"](this._ptr); }
	set index(index: number) { BinaryenObj["_BinaryenTupleExtractSetIndex"](this._ptr, index); }
}



export class StructNew extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.StructNew, expr);
	}

	get numOperands(): number {
		return BinaryenObj["_BinaryenStructNewGetNumOperands"](this._ptr);
	}

	get operands(): ExpressionRef[] {
		return getAllNested(
			this._ptr,
			BinaryenObj["_BinaryenStructNewGetNumOperands"],
			BinaryenObj["_BinaryenStructNewGetOperandAt"],
		);
	}

	set operands(operands: readonly ExpressionRef[]) {
		setAllNested(
			this._ptr,
			operands,
			BinaryenObj["_BinaryenStructNewGetNumOperands"],
			BinaryenObj["_BinaryenStructNewSetOperandAt"],
			BinaryenObj["_BinaryenStructNewAppendOperand"],
			BinaryenObj["_BinaryenStructNewRemoveOperandAt"],
		);
	}

	getOperandAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenStructNewGetOperandAt"](this._ptr, index);
	}

	setOperandAt(index: number, operandExpr: ExpressionRef): void {
		BinaryenObj["_BinaryenStructNewSetOperandAt"](this._ptr, index, operandExpr);
	}

	appendOperand(operandExpr: ExpressionRef): number {
		return BinaryenObj["_BinaryenStructNewAppendOperand"](this._ptr, operandExpr);
	}

	insertOperandAt(index: number, operandExpr: ExpressionRef): void {
		BinaryenObj["_BinaryenStructNewInsertOperandAt"](this._ptr, index, operandExpr);
	}

	removeOperandAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenStructNewRemoveOperandAt"](this._ptr, index);
	}
}



export class StructGet extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.StructGet, expr);
	}

	get index(): number { return BinaryenObj["_BinaryenStructGetGetIndex"](this._ptr); }
	set index(index: number) { BinaryenObj["_BinaryenStructGetSetIndex"](this._ptr, index); }

	get ref(): ExpressionRef { return BinaryenObj["_BinaryenStructGetGetRef"](this._ptr); }
	set ref(ref: ExpressionRef) { BinaryenObj["_BinaryenStructGetSetRef"](this._ptr, ref); }

	get signed(): boolean { return Boolean(BinaryenObj["_BinaryenStructGetIsSigned"](this._ptr)); }
	set signed(signed: boolean) { BinaryenObj["_BinaryenStructGetSetSigned"](this._ptr, signed); }
}



export class StructSet extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.StructSet, expr);
	}

	get index(): number { return BinaryenObj["_BinaryenStructSetGetIndex"](this._ptr); }
	set index(index: number) { BinaryenObj["_BinaryenStructSetSetIndex"](this._ptr, index); }

	get ref(): ExpressionRef { return BinaryenObj["_BinaryenStructSetGetRef"](this._ptr); }
	set ref(ref: ExpressionRef) { BinaryenObj["_BinaryenStructSetSetRef"](this._ptr, ref); }

	get value(): ExpressionRef { return BinaryenObj["_BinaryenStructSetGetValue"](this._ptr); }
	set value(value: ExpressionRef) { BinaryenObj["_BinaryenStructSetSetValue"](this._ptr, value); }
}



export class ArrayNew extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.ArrayNew, expr);
	}

	get init(): ExpressionRef { return BinaryenObj["_BinaryenArrayNewGetInit"](this._ptr); }
	set init(init: ExpressionRef) { BinaryenObj["_BinaryenArrayNewSetInit"](this._ptr, init); }

	get size(): ExpressionRef { return BinaryenObj["_BinaryenArrayNewGetSize"](this._ptr); }
	set size(size: ExpressionRef) { BinaryenObj["_BinaryenArrayNewSetSize"](this._ptr, size); }
}



export class ArrayNewFixed extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.ArrayNewFixed, expr);
	}

	get numValues(): number {
		return BinaryenObj["_BinaryenArrayNewFixedGetNumValues"](this._ptr);
	}

	get values(): ExpressionRef[] {
		return getAllNested(
			this._ptr,
			BinaryenObj["_BinaryenArrayNewFixedGetNumValues"],
			BinaryenObj["_BinaryenArrayNewFixedGetValueAt"],
		);
	}

	set values(operands: readonly ExpressionRef[]) {
		setAllNested(
			this._ptr,
			operands,
			BinaryenObj["_BinaryenArrayNewFixedGetNumValues"],
			BinaryenObj["_BinaryenArrayNewFixedSetValueAt"],
			BinaryenObj["_BinaryenArrayNewFixedAppendValue"],
			BinaryenObj["_BinaryenArrayNewFixedRemoveValueAt"],
		);
	}

	getValueAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenArrayNewFixedGetValueAt"](this._ptr, index);
	}

	setValueAt(index: number, valueExpr: ExpressionRef): void {
		BinaryenObj["_BinaryenArrayNewFixedSetValueAt"](this._ptr, index, valueExpr);
	}

	appendValue(valueExpr: ExpressionRef): number {
		return BinaryenObj["_BinaryenArrayNewFixedAppendValue"](this._ptr, valueExpr);
	}

	insertValueAt(index: number, valueExpr: ExpressionRef): void {
		BinaryenObj["_BinaryenArrayNewFixedInsertValueAt"](this._ptr, index, valueExpr);
	}

	removeValueAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenArrayNewFixedRemoveValueAt"](this._ptr, index);
	}
}



export class ArrayNewData extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.ArrayNewData, expr);
	}

	get segment(): string { return UTF8ToString(BinaryenObj["_BinaryenArrayNewDataGetSegment"](this._ptr)); }
	set segment(segment: string) { preserveStack(() => BinaryenObj["_BinaryenArrayNewDataSetSegment"](this._ptr, strToStack(segment))); }

	get offset(): ExpressionRef { return BinaryenObj["_BinaryenArrayNewDataGetOffset"](this._ptr); }
	set offset(offset: ExpressionRef) { BinaryenObj["_BinaryenArrayNewDataSetOffset"](this._ptr, offset); }

	get size(): ExpressionRef { return BinaryenObj["_BinaryenArrayNewDataGetSize"](this._ptr); }
	set size(size: ExpressionRef) { BinaryenObj["_BinaryenArrayNewDataSetSize"](this._ptr, size); }
}



export class ArrayNewElem extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.ArrayNewElem, expr);
	}

	get segment(): string { return UTF8ToString(BinaryenObj["_BinaryenArrayNewElemGetSegment"](this._ptr)); }
	set segment(segment: string) { preserveStack(() => BinaryenObj["_BinaryenArrayNewElemSetSegment"](this._ptr, strToStack(segment))); }

	get offset(): ExpressionRef { return BinaryenObj["_BinaryenArrayNewElemGetOffset"](this._ptr); }
	set offset(offset: ExpressionRef) { BinaryenObj["_BinaryenArrayNewElemSetOffset"](this._ptr, offset); }

	get size(): ExpressionRef { return BinaryenObj["_BinaryenArrayNewElemGetSize"](this._ptr); }
	set size(size: ExpressionRef) { BinaryenObj["_BinaryenArrayNewElemSetSize"](this._ptr, size); }
}



export class ArrayGet extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.ArrayGet, expr);
	}

	get ref(): ExpressionRef { return BinaryenObj["_BinaryenArrayGetGetRef"](this._ptr); }
	set ref(ref: ExpressionRef) { BinaryenObj["_BinaryenArrayGetSetRef"](this._ptr, ref); }

	get index(): ExpressionRef { return BinaryenObj["_BinaryenArrayGetGetIndex"](this._ptr); }
	set index(index: ExpressionRef) { BinaryenObj["_BinaryenArrayGetSetIndex"](this._ptr, index); }

	get signed(): boolean { return Boolean(BinaryenObj["_BinaryenArrayGetIsSigned"](this._ptr)); }
	set signed(signed: boolean) { BinaryenObj["_BinaryenArrayGetSetSigned"](this._ptr, signed); }
}



export class ArraySet extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.ArraySet, expr);
	}

	get ref(): ExpressionRef { return BinaryenObj["_BinaryenArraySetGetRef"](this._ptr); }
	set ref(ref: ExpressionRef) { BinaryenObj["_BinaryenArraySetSetRef"](this._ptr, ref); }

	get index(): ExpressionRef { return BinaryenObj["_BinaryenArraySetGetIndex"](this._ptr); }
	set index(index: ExpressionRef) { BinaryenObj["_BinaryenArraySetSetIndex"](this._ptr, index); }

	get value(): ExpressionRef { return BinaryenObj["_BinaryenArraySetGetValue"](this._ptr); }
	set value(value: ExpressionRef) { BinaryenObj["_BinaryenArraySetSetValue"](this._ptr, value); }
}



export class ArrayLen extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.ArrayLen, expr);
	}

	get ref(): ExpressionRef { return BinaryenObj["_BinaryenArrayLenGetRef"](this._ptr); }
	set ref(ref: ExpressionRef) { BinaryenObj["_BinaryenArrayLenSetRef"](this._ptr, ref); }
}



export class ArrayFill extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.ArrayFill, expr);
	}

	get ref(): ExpressionRef { return BinaryenObj["_BinaryenArrayFillGetRef"](this._ptr); }
	set ref(ref: ExpressionRef) { BinaryenObj["_BinaryenArrayFillSetRef"](this._ptr, ref); }

	get index(): ExpressionRef { return BinaryenObj["_BinaryenArrayFillGetIndex"](this._ptr); }
	set index(index: ExpressionRef) { BinaryenObj["_BinaryenArrayFillSetIndex"](this._ptr, index); }

	get value(): ExpressionRef { return BinaryenObj["_BinaryenArrayFillGetValue"](this._ptr); }
	set value(value: ExpressionRef) { BinaryenObj["_BinaryenArrayFillSetValue"](this._ptr, value); }

	get size(): ExpressionRef { return BinaryenObj["_BinaryenArrayFillGetSize"](this._ptr); }
	set size(size: ExpressionRef) { BinaryenObj["_BinaryenArrayFillSetSize"](this._ptr, size); }
}



export class ArrayCopy extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.ArrayCopy, expr);
	}

	get destRef(): ExpressionRef { return BinaryenObj["_BinaryenArrayCopyGetDestRef"](this._ptr); }
	set destRef(ref: ExpressionRef) { BinaryenObj["_BinaryenArrayCopySetDestRef"](this._ptr, ref); }

	get destIndex(): ExpressionRef { return BinaryenObj["_BinaryenArrayCopyGetDestIndex"](this._ptr); }
	set destIndex(index: ExpressionRef) { BinaryenObj["_BinaryenArrayCopySetDestIndex"](this._ptr, index); }

	get srcRef(): ExpressionRef { return BinaryenObj["_BinaryenArrayCopyGetSrcRef"](this._ptr); }
	set srcRef(ref: ExpressionRef) { BinaryenObj["_BinaryenArrayCopySetSrcRef"](this._ptr, ref); }

	get srcIndex(): ExpressionRef { return BinaryenObj["_BinaryenArrayCopyGetSrcIndex"](this._ptr); }
	set srcIndex(index: ExpressionRef) { BinaryenObj["_BinaryenArrayCopySetSrcIndex"](this._ptr, index); }

	get length(): ExpressionRef { return BinaryenObj["_BinaryenArrayCopyGetLength"](this._ptr); }
	set length(length: ExpressionRef) { BinaryenObj["_BinaryenArrayCopySetLength"](this._ptr, length); }
}



export class ArrayInitData extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.ArrayInitData, expr);
	}

	get segment(): string { return UTF8ToString(BinaryenObj["_BinaryenArrayInitDataGetSegment"](this._ptr)); }
	set segment(segment: string) { preserveStack(() => BinaryenObj["_BinaryenArrayInitDataSetSegment"](this._ptr, strToStack(segment))); }

	get ref(): ExpressionRef { return BinaryenObj["_BinaryenArrayInitDataGetRef"](this._ptr); }
	set ref(ref: ExpressionRef) { BinaryenObj["_BinaryenArrayInitDataSetRef"](this._ptr, ref); }

	get index(): ExpressionRef { return BinaryenObj["_BinaryenArrayInitDataGetIndex"](this._ptr); }
	set index(index: ExpressionRef) { BinaryenObj["_BinaryenArrayInitDataSetIndex"](this._ptr, index); }

	get offset(): ExpressionRef { return BinaryenObj["_BinaryenArrayInitDataGetOffset"](this._ptr); }
	set offset(offset: ExpressionRef) { BinaryenObj["_BinaryenArrayInitDataSetOffset"](this._ptr, offset); }

	get size(): ExpressionRef { return BinaryenObj["_BinaryenArrayInitDataGetSize"](this._ptr); }
	set size(size: ExpressionRef) { BinaryenObj["_BinaryenArrayInitDataSetSize"](this._ptr, size); }
}



export class ArrayInitElem extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.ArrayInitElem, expr);
	}

	get segment(): string { return UTF8ToString(BinaryenObj["_BinaryenArrayInitElemGetSegment"](this._ptr)); }
	set segment(segment: string) { preserveStack(() => BinaryenObj["_BinaryenArrayInitElemSetSegment"](this._ptr, strToStack(segment))); }

	get ref(): ExpressionRef { return BinaryenObj["_BinaryenArrayInitElemGetRef"](this._ptr); }
	set ref(ref: ExpressionRef) { BinaryenObj["_BinaryenArrayInitElemSetRef"](this._ptr, ref); }

	get index(): ExpressionRef { return BinaryenObj["_BinaryenArrayInitElemGetIndex"](this._ptr); }
	set index(index: ExpressionRef) { BinaryenObj["_BinaryenArrayInitElemSetIndex"](this._ptr, index); }

	get offset(): ExpressionRef { return BinaryenObj["_BinaryenArrayInitElemGetOffset"](this._ptr); }
	set offset(offset: ExpressionRef) { BinaryenObj["_BinaryenArrayInitElemSetOffset"](this._ptr, offset); }

	get size(): ExpressionRef { return BinaryenObj["_BinaryenArrayInitElemGetSize"](this._ptr); }
	set size(size: ExpressionRef) { BinaryenObj["_BinaryenArrayInitElemSetSize"](this._ptr, size); }
}
