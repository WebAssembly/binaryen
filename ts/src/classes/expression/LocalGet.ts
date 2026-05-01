import {
	BinaryenObj,
} from "../../-pre.ts";
import {
	ExpressionId,
	type ExpressionRef,
	type Type,
} from "../../constants.ts";
import type {
	Module,
} from "../module/Module.ts";
import {
	Expression,
} from "./Expression.ts";



export class LocalGet extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.LocalGet, expr);
	}


	// FIXME: post.js has converted all methods starting with `get` to getters and `set` to setters
	getIndex() {}
	setIndex() {}
}



export function localGet(this: Module, index: number, type: Type): ExpressionRef {
	return BinaryenObj["_BinaryenLocalGet"](this.ptr, index, type);
}
