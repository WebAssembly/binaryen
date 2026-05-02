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



export class LocalSet extends Expression {
	static localSet = function (this: Module, index: number, value: ExpressionRef): ExpressionRef {
		return BinaryenObj["_BinaryenLocalSet"](this.ptr, index, value);
	};

	static localTee = function (this: Module, index: number, value: ExpressionRef, typ: Type): ExpressionRef {
		return BinaryenObj["_BinaryenLocalTee"](this.ptr, index, value, typ);
	};


	constructor(expr: ExpressionRef) {
		super(ExpressionId.LocalSet, expr);
	}


	// FIXME: post.js has converted all methods starting with `get` to getters and `set` to setters
	getIndex() {}
	setIndex() {}
	isTee() {}
	getValue() {}
	setValue() {}
}
