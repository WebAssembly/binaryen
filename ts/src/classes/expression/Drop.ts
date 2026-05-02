import {
	BinaryenObj,
} from "../../-pre.ts";
import {
	ExpressionId,
	type ExpressionRef,
} from "../../constants.ts";
import type {
	Module,
} from "../module/Module.ts";
import {
	Expression,
} from "./Expression.ts";



export class Drop extends Expression {
	static drop = function (this: Module, value: ExpressionRef): ExpressionRef {
		return BinaryenObj["_BinaryenDrop"](this.ptr, value);
	};


	constructor(expr: ExpressionRef) {
		super(ExpressionId.Drop, expr);
	}


	// FIXME: post.js has converted all methods starting with `get` to getters and `set` to setters
	getValue() {}
	setValue() {}
}
