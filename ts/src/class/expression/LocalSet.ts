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
} from "../Module.ts";
import {
	Expression,
} from "./Expression.ts";



export class LocalSet extends Expression {
	// TODO: static methods are deprecated; convert to instance and log warnings
	static getIndex() {}
	static setIndex() {}
	static isTee() {}
	static getValue() {}
	static setValue() {}


	constructor(expr: ExpressionRef) {
		super(ExpressionId.LocalSet, expr);
	}
}



export function localSet(this: Module, index: number, value: ExpressionRef): ExpressionRef {
	return BinaryenObj["_BinaryenLocalSet"](this.ptr, index, value);
}

export function localTee(this: Module, index: number, value: ExpressionRef, type: Type): ExpressionRef {
	return BinaryenObj["_BinaryenLocalTee"](this.ptr, index, value, type);
}
