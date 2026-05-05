import {
	ExpressionId,
	type ExpressionRef,
} from "../../constants.ts";
import {
	Expression,
} from "./Expression.ts";



export class Throw extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.Throw, expr);
	}
}
