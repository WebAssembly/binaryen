import {
	BinaryenObj,
} from "../../-pre.ts";
import {
	THIS_PTR,
} from "../../-utils.ts";
import {
	ExpressionId,
	type ExpressionRef,
} from "../../constants.ts";
import {
	Expression,
} from "./Expression.ts";



export class LocalSet extends Expression {
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
