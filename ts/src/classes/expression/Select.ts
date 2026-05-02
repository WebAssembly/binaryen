import {
	BinaryenObj,
} from "../../-pre.ts";
import {
	ExpressionId,
	type ExpressionRef,
} from "../../constants.ts";
import {
	THIS_PTR,
} from "../../utils.ts";
import type {
	Module,
} from "../module/Module.ts";
import {
	Expression,
} from "./Expression.ts";



export class Select extends Expression {
	static select = function (this: Module, ifTrue: ExpressionRef, ifFalse: ExpressionRef): ExpressionRef {
		return BinaryenObj["_BinaryenSelect"](this.ptr, ifTrue, ifFalse);
	};


	constructor(expr: ExpressionRef) {
		super(ExpressionId.Select, expr);
	}


	/* eslint-disable @stylistic/brace-style */
	get ifTrue(): ExpressionRef { return BinaryenObj["_BinaryenSelectGetIfTrue"](this[THIS_PTR]); }
	set ifTrue(ifTrueExpr: ExpressionRef) { BinaryenObj["_BinaryenSelectSetIfTrue"](this[THIS_PTR], ifTrueExpr); }

	get ifFalse(): ExpressionRef { return BinaryenObj["_BinaryenSelectGetIfFalse"](this[THIS_PTR]); }
	set ifFalse(ifFalseExpr: ExpressionRef) { BinaryenObj["_BinaryenSelectSetIfFalse"](this[THIS_PTR], ifFalseExpr); }

	get condition(): ExpressionRef { return BinaryenObj["_BinaryenSelectGetCondition"](this[THIS_PTR]); }
	set condition(condExpr: ExpressionRef) { BinaryenObj["_BinaryenSelectSetCondition"](this[THIS_PTR], condExpr); }
	/* eslint-enable @stylistic/brace-style */
}
