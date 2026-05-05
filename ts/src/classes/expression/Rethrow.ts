import {
	ExpressionId,
	type ExpressionRef,
} from "../../constants.ts";
import {
	Expression,
} from "./Expression.ts";



export class Rethrow extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.Rethrow, expr);
	}
}
