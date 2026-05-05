import {
	ExpressionId,
	type ExpressionRef,
} from "../../constants.ts";
import {
	Expression,
} from "./Expression.ts";



export class Switch extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.Switch, expr);
	}
}
