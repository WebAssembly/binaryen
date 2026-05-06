import {
	BinaryenObj,
	UTF8ToString,
} from "../../-pre.ts";
import {
	ExpressionId,
	type ExpressionRef,
	type Type,
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



export class Call extends Expression {
	/**
	 * Creates a call to a function.
	 * Note that we must specify the return type here as we may not have created the function being called yet.
	 */
	// NOTE: the `override` keyword is needed here to override JavaScript’s intrinsic `Function#call` method
	static override call(mod: Module, name: string, operands: readonly ExpressionRef[], resultsType: Type): ExpressionRef {
		return preserveStack(() => BinaryenObj["_BinaryenCall"](mod.ptr, strToStack(name), i32sToStack(operands), operands.length, resultsType));
	}


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
