import {
	BinaryenObj,
	UTF8ToString,
} from "../../-pre.ts";
import {
	THIS_PTR,
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

	get target(): string { return UTF8ToString(BinaryenObj["_BinaryenCallGetTarget"](this[THIS_PTR])); }
	set target(targetName: string) { preserveStack(() => BinaryenObj["_BinaryenCallSetTarget"](this[THIS_PTR], strToStack(targetName))); }

	get return(): boolean { return Boolean(BinaryenObj["_BinaryenCallIsReturn"](this[THIS_PTR])); }
	set return(isReturn: boolean) { BinaryenObj["_BinaryenCallSetReturn"](this[THIS_PTR], isReturn); }

	get numOperands(): number { return BinaryenObj["_BinaryenCallGetNumOperands"](this[THIS_PTR]); }

	get operands(): ExpressionRef[] {
		return getAllNested(
			this[THIS_PTR],
			BinaryenObj["_BinaryenCallGetNumOperands"],
			BinaryenObj["_BinaryenCallGetOperandAt"],
		);
	}

	set operands(operands: readonly ExpressionRef[]) {
		setAllNested(
			this[THIS_PTR],
			operands,
			BinaryenObj["_BinaryenCallGetNumOperands"],
			BinaryenObj["_BinaryenCallSetOperandAt"],
			BinaryenObj["_BinaryenCallAppendOperand"],
			BinaryenObj["_BinaryenCallRemoveOperandAt"],
		);
	}

	getOperandAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenCallGetOperandAt"](this[THIS_PTR], index);
	}

	setOperandAt(index: number, operandExpr: ExpressionRef): void {
		BinaryenObj["_BinaryenCallSetOperandAt"](this[THIS_PTR], index, operandExpr);
	}

	appendOperand(operandExpr: ExpressionRef): number {
		return BinaryenObj["_BinaryenCallAppendOperand"](this[THIS_PTR], operandExpr);
	}

	insertOperandAt(index: number, operandExpr: ExpressionRef): void {
		BinaryenObj["_BinaryenCallInsertOperandAt"](this[THIS_PTR], index, operandExpr);
	}

	removeOperandAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenCallRemoveOperandAt"](this[THIS_PTR], index);
	}
}



export class CallRef extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.CallRef, expr);
	}

	get target(): ExpressionRef { return BinaryenObj["_BinaryenCallRefGetTarget"](this[THIS_PTR]); }
	set target(targetExpr: ExpressionRef) { BinaryenObj["_BinaryenCallRefSetTarget"](this[THIS_PTR], targetExpr); }

	get return(): boolean { return Boolean(BinaryenObj["_BinaryenCallRefIsReturn"](this[THIS_PTR])); }
	set return(isReturn: boolean) { BinaryenObj["_BinaryenCallRefSetReturn"](this[THIS_PTR], isReturn); }

	get numOperands(): number { return BinaryenObj["_BinaryenCallRefGetNumOperands"](this[THIS_PTR]); }

	getOperandAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenCallRefGetOperandAt"](this[THIS_PTR], index);
	}

	setOperandAt(index: number, operandExpr: ExpressionRef): void {
		BinaryenObj["_BinaryenCallRefSetOperandAt"](this[THIS_PTR], index, operandExpr);
	}

	appendOperand(operandExpr: ExpressionRef): number {
		return BinaryenObj["_BinaryenCallRefAppendOperand"](this[THIS_PTR], operandExpr);
	}

	removeOperandAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenCallRefRemoveOperandAt"](this[THIS_PTR], index);
	}
}



export class CallIndirect extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.CallIndirect, expr);
	}

	get target(): ExpressionRef { return BinaryenObj["_BinaryenCallIndirectGetTarget"](this[THIS_PTR]); }
	set target(targetExpr: ExpressionRef) { BinaryenObj["_BinaryenCallIndirectSetTarget"](this[THIS_PTR], targetExpr); }

	get return(): boolean { return Boolean(BinaryenObj["_BinaryenCallIndirectIsReturn"](this[THIS_PTR])); }
	set return(isReturn: boolean) { BinaryenObj["_BinaryenCallIndirectSetReturn"](this[THIS_PTR], isReturn); }

	get table(): string { return UTF8ToString(BinaryenObj["_BinaryenCallIndirectGetTable"](this[THIS_PTR])); }
	set table(table: string) { preserveStack(() => BinaryenObj["_BinaryenCallIndirectSetTable"](this[THIS_PTR], strToStack(table))); }

	get params(): Type {return BinaryenObj["_BinaryenCallIndirectGetParams"](this[THIS_PTR]);}
	set params(params: Type) { BinaryenObj["_BinaryenCallIndirectSetParams"](this[THIS_PTR], params); }

	get results(): Type { return BinaryenObj["_BinaryenCallIndirectGetResults"](this[THIS_PTR]); }
	set results(results: Type) { BinaryenObj["_BinaryenCallIndirectSetResults"](this[THIS_PTR], results); }

	get numOperands(): number { return BinaryenObj["_BinaryenCallIndirectGetNumOperands"](this[THIS_PTR]); }

	get operands(): ExpressionRef[] {
		return getAllNested(
			this[THIS_PTR],
			BinaryenObj["_BinaryenCallIndirectGetNumOperands"],
			BinaryenObj["_BinaryenCallIndirectGetOperandAt"],
		);
	}

	set operands(operands: readonly ExpressionRef[]) {
		setAllNested(
			this[THIS_PTR],
			operands,
			BinaryenObj["_BinaryenCallIndirectGetNumOperands"],
			BinaryenObj["_BinaryenCallIndirectSetOperandAt"],
			BinaryenObj["_BinaryenCallIndirectAppendOperand"],
			BinaryenObj["_BinaryenCallIndirectRemoveOperandAt"],
		);
	}

	getOperandAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenCallIndirectGetOperandAt"](this[THIS_PTR], index);
	}

	setOperandAt(index: number, operandExpr: ExpressionRef): void {
		BinaryenObj["_BinaryenCallIndirectSetOperandAt"](this[THIS_PTR], index, operandExpr);
	}

	appendOperand(operandExpr: ExpressionRef): number {
		return BinaryenObj["_BinaryenCallIndirectAppendOperand"](this[THIS_PTR], operandExpr);
	}

	insertOperandAt(index: number, operandExpr: ExpressionRef): void {
		BinaryenObj["_BinaryenCallIndirectInsertOperandAt"](this[THIS_PTR], index, operandExpr);
	}

	removeOperandAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenCallIndirectRemoveOperandAt"](this[THIS_PTR], index);
	}
}



export class Return extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.Return, expr);
	}

	get value(): ExpressionRef { return BinaryenObj["_BinaryenReturnGetValue"](this[THIS_PTR]); }
	set value(valueExpr: ExpressionRef) { BinaryenObj["_BinaryenReturnSetValue"](this[THIS_PTR], valueExpr); }
}
