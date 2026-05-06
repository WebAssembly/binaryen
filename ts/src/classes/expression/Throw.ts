import {
	BinaryenObj,
	UTF8ToString,
} from "../../-pre.ts";
import {
	ExpressionId,
	type ExpressionRef,
} from "../../constants.ts";
import {
	THIS_PTR,
	getAllNested,
	i32sToStack,
	preserveStack,
	setAllNested,
	strToStack,
} from "../../utils.ts";
import type {
	Module,
} from "../module/Module.ts";
import {
	Expression,
} from "./Expression.ts";



export class Throw extends Expression {
	/** Raise an exception. */
	static throw(mod: Module, tag: string, operands: readonly ExpressionRef[]): ExpressionRef {
		return preserveStack(() => BinaryenObj["_BinaryenThrow"](mod.ptr, strToStack(tag), i32sToStack(operands), operands.length));
	}


	constructor(expr: ExpressionRef) {
		super(ExpressionId.Throw, expr);
	}


	getTag(): string { return UTF8ToString(BinaryenObj["_BinaryenThrowGetTag"](this[THIS_PTR])); }
	setTag(tagName: string) { preserveStack(() => BinaryenObj["_BinaryenThrowSetTag"](this[THIS_PTR], strToStack(tagName))); }

	getNumOperands(): number { return BinaryenObj["_BinaryenThrowGetNumOperands"](this[THIS_PTR]); }

	getOperands(): ExpressionRef[] {
		return getAllNested(
			this[THIS_PTR],
			BinaryenObj["_BinaryenThrowGetNumOperands"],
			BinaryenObj["_BinaryenThrowGetOperandAt"],
		);
	}

	setOperands(operands: readonly ExpressionRef[]) {
		setAllNested(
			this[THIS_PTR],
			operands,
			BinaryenObj["_BinaryenThrowGetNumOperands"],
			BinaryenObj["_BinaryenThrowSetOperandAt"],
			BinaryenObj["_BinaryenThrowAppendOperand"],
			BinaryenObj["_BinaryenThrowRemoveOperandAt"],
		);
	}


	getOperandAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenThrowGetOperandAt"](this[THIS_PTR], index);
	}

	setOperandAt(index: number, operandExpr: ExpressionRef): void {
		BinaryenObj["_BinaryenThrowSetOperandAt"](this[THIS_PTR], index, operandExpr);
	}

	appendOperand(operandExpr: ExpressionRef): number {
		return BinaryenObj["_BinaryenThrowAppendOperand"](this[THIS_PTR], operandExpr);
	}

	insertOperandAt(index: number, operandExpr: ExpressionRef): void {
		BinaryenObj["_BinaryenThrowInsertOperandAt"](this[THIS_PTR], index, operandExpr);
	}

	removeOperandAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenThrowRemoveOperandAt"](this[THIS_PTR], index);
	}
}
