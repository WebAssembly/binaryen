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



export class Return extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.Return, expr);
	}


	get value(): ExpressionRef { return BinaryenObj["_BinaryenReturnGetValue"](this[THIS_PTR]); }
	set value(valueExpr: ExpressionRef) { BinaryenObj["_BinaryenReturnSetValue"](this[THIS_PTR], valueExpr); }
}
