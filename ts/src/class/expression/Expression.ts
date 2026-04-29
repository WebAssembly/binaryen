import {
	BinaryenObj,
} from "../../-pre.ts";
import type {
	ExpressionId,
	ExpressionRef,
} from "../../constants.ts";
import {
	THIS_PTR,
} from "../../utils.ts";



/** Expression ID-to-wrapper map. */
export const EXPR_WRAPPERS = new Map<ExpressionId, Expression>();



/** Base class of all expression wrappers. */
export class Expression {
	// TODO: static methods are deprecated; convert to instance and log warnings
	static getId(expr: number) {
		return BinaryenObj["_BinaryenExpressionGetId"](expr);
	}

	static getType() {}
	static setType() {}
	static finalize() {}
	static toText() {}


	protected readonly [THIS_PTR]: number;

	constructor(exprId: ExpressionId, expr: ExpressionRef) {
		this[THIS_PTR] = expr;
		EXPR_WRAPPERS.set(exprId, this);
	}

	valueOf() {
		return this[THIS_PTR];
	}
}
