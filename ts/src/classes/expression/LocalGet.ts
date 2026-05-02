import {
	BinaryenObj,
} from "../../-pre.ts";
import {
	ExpressionId,
	type ExpressionRef,
	type Type,
} from "../../constants.ts";
import {
	THIS_PTR,
} from "../../utils.ts";
import type {
	Module,
} from "../module/Module.ts";
import {
	Expression,
} from "./Expression.ts";



export class LocalGet extends Expression {
	static localGet(mod: Module, index: number, typ: Type): ExpressionRef {
		return BinaryenObj["_BinaryenLocalGet"](mod.ptr, index, typ);
	}


	constructor(expr: ExpressionRef) {
		super(ExpressionId.LocalGet, expr);
	}


	get index(): number {
		return BinaryenObj["_BinaryenLocalGetGetIndex"](this[THIS_PTR]);
	}

	set index(index: number) {
		BinaryenObj["_BinaryenLocalGetSetIndex"](this[THIS_PTR], index);
	}
}
