import {
	ExpressionId,
	type ExpressionRef,
} from "../../constants.ts";
import {
	Expression,
} from "./Expression.ts";



export class If extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.If, expr);
	}
}
