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
	type Type,
} from "../../constants.ts";
import {
	Expression,
} from "./Expression.ts";



export class Call extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.Call, expr);
	}

	get target(): string { return UTF8ToString(BinaryenObj["_BinaryenCallGetTarget"](this._ptr)); }
	set target(targetName: string) { preserveStack(() => BinaryenObj["_BinaryenCallSetTarget"](this._ptr, strToStack(targetName))); }

	get return(): boolean { return Boolean(BinaryenObj["_BinaryenCallIsReturn"](this._ptr)); }
	set return(isReturn: boolean) { BinaryenObj["_BinaryenCallSetReturn"](this._ptr, isReturn); }

	get numOperands(): number { return BinaryenObj["_BinaryenCallGetNumOperands"](this._ptr); }

	get operands(): ExpressionRef[] {
		return getAllNested(
			this._ptr,
			BinaryenObj["_BinaryenCallGetNumOperands"],
			BinaryenObj["_BinaryenCallGetOperandAt"],
		);
	}

	set operands(operands: readonly ExpressionRef[]) {
		setAllNested(
			this._ptr,
			operands,
			BinaryenObj["_BinaryenCallGetNumOperands"],
			BinaryenObj["_BinaryenCallSetOperandAt"],
			BinaryenObj["_BinaryenCallAppendOperand"],
			BinaryenObj["_BinaryenCallRemoveOperandAt"],
		);
	}

	getOperandAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenCallGetOperandAt"](this._ptr, index);
	}

	setOperandAt(index: number, operandExpr: ExpressionRef): void {
		BinaryenObj["_BinaryenCallSetOperandAt"](this._ptr, index, operandExpr);
	}

	appendOperand(operandExpr: ExpressionRef): number {
		return BinaryenObj["_BinaryenCallAppendOperand"](this._ptr, operandExpr);
	}

	insertOperandAt(index: number, operandExpr: ExpressionRef): void {
		BinaryenObj["_BinaryenCallInsertOperandAt"](this._ptr, index, operandExpr);
	}

	removeOperandAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenCallRemoveOperandAt"](this._ptr, index);
	}
}



export class CallRef extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.CallRef, expr);
	}

	get target(): ExpressionRef { return BinaryenObj["_BinaryenCallRefGetTarget"](this._ptr); }
	set target(targetExpr: ExpressionRef) { BinaryenObj["_BinaryenCallRefSetTarget"](this._ptr, targetExpr); }

	get return(): boolean { return Boolean(BinaryenObj["_BinaryenCallRefIsReturn"](this._ptr)); }
	set return(isReturn: boolean) { BinaryenObj["_BinaryenCallRefSetReturn"](this._ptr, isReturn); }

	get numOperands(): number { return BinaryenObj["_BinaryenCallRefGetNumOperands"](this._ptr); }

	getOperandAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenCallRefGetOperandAt"](this._ptr, index);
	}

	setOperandAt(index: number, operandExpr: ExpressionRef): void {
		BinaryenObj["_BinaryenCallRefSetOperandAt"](this._ptr, index, operandExpr);
	}

	appendOperand(operandExpr: ExpressionRef): number {
		return BinaryenObj["_BinaryenCallRefAppendOperand"](this._ptr, operandExpr);
	}

	removeOperandAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenCallRefRemoveOperandAt"](this._ptr, index);
	}
}



export class CallIndirect extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.CallIndirect, expr);
	}

	get target(): ExpressionRef { return BinaryenObj["_BinaryenCallIndirectGetTarget"](this._ptr); }
	set target(targetExpr: ExpressionRef) { BinaryenObj["_BinaryenCallIndirectSetTarget"](this._ptr, targetExpr); }

	get return(): boolean { return Boolean(BinaryenObj["_BinaryenCallIndirectIsReturn"](this._ptr)); }
	set return(isReturn: boolean) { BinaryenObj["_BinaryenCallIndirectSetReturn"](this._ptr, isReturn); }

	get table(): string { return UTF8ToString(BinaryenObj["_BinaryenCallIndirectGetTable"](this._ptr)); }
	set table(table: string) { preserveStack(() => BinaryenObj["_BinaryenCallIndirectSetTable"](this._ptr, strToStack(table))); }

	get params(): Type {return BinaryenObj["_BinaryenCallIndirectGetParams"](this._ptr);}
	set params(params: Type) { BinaryenObj["_BinaryenCallIndirectSetParams"](this._ptr, params); }

	get results(): Type { return BinaryenObj["_BinaryenCallIndirectGetResults"](this._ptr); }
	set results(results: Type) { BinaryenObj["_BinaryenCallIndirectSetResults"](this._ptr, results); }

	get numOperands(): number { return BinaryenObj["_BinaryenCallIndirectGetNumOperands"](this._ptr); }

	get operands(): ExpressionRef[] {
		return getAllNested(
			this._ptr,
			BinaryenObj["_BinaryenCallIndirectGetNumOperands"],
			BinaryenObj["_BinaryenCallIndirectGetOperandAt"],
		);
	}

	set operands(operands: readonly ExpressionRef[]) {
		setAllNested(
			this._ptr,
			operands,
			BinaryenObj["_BinaryenCallIndirectGetNumOperands"],
			BinaryenObj["_BinaryenCallIndirectSetOperandAt"],
			BinaryenObj["_BinaryenCallIndirectAppendOperand"],
			BinaryenObj["_BinaryenCallIndirectRemoveOperandAt"],
		);
	}

	getOperandAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenCallIndirectGetOperandAt"](this._ptr, index);
	}

	setOperandAt(index: number, operandExpr: ExpressionRef): void {
		BinaryenObj["_BinaryenCallIndirectSetOperandAt"](this._ptr, index, operandExpr);
	}

	appendOperand(operandExpr: ExpressionRef): number {
		return BinaryenObj["_BinaryenCallIndirectAppendOperand"](this._ptr, operandExpr);
	}

	insertOperandAt(index: number, operandExpr: ExpressionRef): void {
		BinaryenObj["_BinaryenCallIndirectInsertOperandAt"](this._ptr, index, operandExpr);
	}

	removeOperandAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenCallIndirectRemoveOperandAt"](this._ptr, index);
	}
}



export class Return extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.Return, expr);
	}

	get value(): ExpressionRef { return BinaryenObj["_BinaryenReturnGetValue"](this._ptr); }
	set value(valueExpr: ExpressionRef) { BinaryenObj["_BinaryenReturnSetValue"](this._ptr, valueExpr); }
}
