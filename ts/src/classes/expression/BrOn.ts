import {
	ExpressionId,
	type ExpressionRef,
} from "../../constants.ts";
import {
	Expression,
} from "./Expression.ts";



export class BrOn extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.BrOn, expr);
	}
}
