import {
	ExpressionId,
	type ExpressionRef,
} from "../../constants.ts";
import {
	Expression,
} from "./Expression.ts";



export class Try extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.Try, expr);
	}
}
