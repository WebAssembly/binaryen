import {
	BinaryenObj,
} from "../../-pre.ts";
import {
	THIS_PTR,
} from "../../-utils.ts";
import {
	ExpressionId,
	type ExpressionRef,
} from "../../constants.ts";
import {
	Expression,
} from "./Expression.ts";



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
