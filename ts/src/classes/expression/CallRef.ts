import {
	BinaryenObj,
} from "../../-pre.ts";
import {
	ExpressionId,
	type ExpressionRef,
	type Type,
} from "../../constants.ts";
import {
	THIS_PTR,
	i32sToStack,
	preserveStack,
} from "../../utils.ts";
import type {
	Module,
} from "../module/Module.ts";
import {
	Expression,
} from "./Expression.ts";



export class CallRef extends Expression {
	/** Similar to `call`, but takes a function reference operand instead of a name as the called value. */
	static callRef(mod: Module, target: ExpressionRef, operands: readonly ExpressionRef[], resultsType: Type): ExpressionRef {
		return preserveStack(() => BinaryenObj["_BinaryenCallRef"](mod.ptr, target, i32sToStack(operands), operands.length, resultsType));
	}


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
