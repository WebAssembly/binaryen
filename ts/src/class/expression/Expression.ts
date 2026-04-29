import {BinaryenObj} from "../../-pre.ts";
import type {ExpressionRef} from "../../constants.ts";
import {THIS_PTR} from "../../utils.ts";



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

	constructor(expr: ExpressionRef) {
		this[THIS_PTR] = expr;
	}

	valueOf() {
		return this[THIS_PTR];
	}
}
