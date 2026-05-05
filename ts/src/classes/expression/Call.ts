import {
	ExpressionId,
	type ExpressionRef,
} from "../../constants.ts";
import {
	Expression,
} from "./Expression.ts";



export class Call extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.Call, expr);
	}
}
