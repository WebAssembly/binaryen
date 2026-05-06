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



export class CallIndirect extends Expression {
	/** Similar to `call_ref`, but indexes into a table to find the function to call. */
	static callIndirect(mod: Module, table: string, target: ExpressionRef, operands: readonly ExpressionRef[], paramsType: Type, resultsType: Type): ExpressionRef {
		return preserveStack(() => BinaryenObj["_BinaryenCallIndirect"](mod.ptr, strToStack(table), target, i32sToStack(operands), operands.length, paramsType, resultsType));
	}


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
