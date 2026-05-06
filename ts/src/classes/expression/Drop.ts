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



export class Drop extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.Drop, expr);
	}


	get value(): ExpressionRef {
		return BinaryenObj["_BinaryenDropGetValue"](this[THIS_PTR]);
	}

	set value(valueExpr: ExpressionRef) {
		BinaryenObj["_BinaryenDropSetValue"](this[THIS_PTR], valueExpr);
	}
}
