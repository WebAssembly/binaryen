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



export class LocalGet extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.LocalGet, expr);
	}


	get index(): number {
		return BinaryenObj["_BinaryenLocalGetGetIndex"](this[THIS_PTR]);
	}

	set index(index: number) {
		BinaryenObj["_BinaryenLocalGetSetIndex"](this[THIS_PTR], index);
	}
}
