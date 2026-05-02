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


	get index(): number { return BinaryenObj["_BinaryenLocalSetGetIndex"](this[THIS_PTR]); }
	set index(index: number) { BinaryenObj["_BinaryenLocalSetSetIndex"](this[THIS_PTR], index); }

	get value(): ExpressionRef { return BinaryenObj["_BinaryenLocalSetGetValue"](this[THIS_PTR]); }
	set value(valueExpr: ExpressionRef) { BinaryenObj["_BinaryenLocalSetSetValue"](this[THIS_PTR], valueExpr); }

	get isTee(): boolean {
		return Boolean(BinaryenObj["_BinaryenLocalSetIsTee"](this[THIS_PTR]));
	}
}
