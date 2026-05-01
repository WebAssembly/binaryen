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
	// TODO: static methods are deprecated; convert to instance and log warnings
	static getIndex() {}
	static setIndex() {}


	constructor(expr: ExpressionRef) {
		super(ExpressionId.LocalGet, expr);
	}
}



export function localGet(this: Module, index: number, type: Type): ExpressionRef {
	return BinaryenObj["_BinaryenLocalGet"](this.ptr, index, type);
}
