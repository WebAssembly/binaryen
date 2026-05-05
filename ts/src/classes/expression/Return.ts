import {
	ExpressionId,
	type ExpressionRef,
} from "../../constants.ts";
import {
	Expression,
} from "./Expression.ts";



export class Return extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.Return, expr);
	}
}
