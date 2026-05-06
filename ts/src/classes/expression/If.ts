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
import {
	Expression,
} from "./Expression.ts";



export class If extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.If, expr);
	}


	get condition(): ExpressionRef { return BinaryenObj["_BinaryenIfGetCondition"](this[THIS_PTR]); }
	set condition(condExpr: ExpressionRef) { BinaryenObj["_BinaryenIfSetCondition"](condExpr); }

	get ifTrue(): ExpressionRef { return BinaryenObj["_BinaryenIfGetIfTrue"](this[THIS_PTR]); }
	set ifTrue(ifTrueExpr: ExpressionRef) { BinaryenObj["_BinaryenIfSetIfTrue"](this[THIS_PTR], ifTrueExpr); }

	get ifFalse(): ExpressionRef { return BinaryenObj["_BinaryenIfGetIfFalse"](this[THIS_PTR]); }
	set ifFalse(ifFalseExpr: ExpressionRef) { BinaryenObj["_BinaryenIfSetIfFalse"](this[THIS_PTR], ifFalseExpr); }
}
