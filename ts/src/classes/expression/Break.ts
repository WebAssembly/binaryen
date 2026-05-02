import {
	BinaryenObj,
	UTF8ToString,
} from "../../-pre.ts";
import {
	ExpressionId,
	type ExpressionRef,
} from "../../constants.ts";
import {
	THIS_PTR,
	preserveStack,
	strToStack,
} from "../../utils.ts";
import type {
	Module,
} from "../module/Module.ts";
import {
	Expression,
} from "./Expression.ts";



export class Break extends Expression {
	static br = function (this: Module, label: string, condition?: ExpressionRef, value?: ExpressionRef): ExpressionRef {
		return preserveStack(() => BinaryenObj["_BinaryenBreak"](this.ptr, strToStack(label), condition!, value!));
	};

	static br_if = function (this: Module, label: string, condition: ExpressionRef, value?: ExpressionRef): ExpressionRef {
		return preserveStack(() => BinaryenObj["_BinaryenBreak"](this.ptr, strToStack(label), condition, value!));
	};


	constructor(expr: ExpressionRef) {
		super(ExpressionId.Loop, expr);
	}


	get name(): string | null {
		const name = BinaryenObj["_BinaryenBreakGetName"](this[THIS_PTR]);
		return name ? UTF8ToString(name) : null;
	}

	set name(name: string) {
		preserveStack(() => BinaryenObj["_BinaryenBreakSetName"](this[THIS_PTR], strToStack(name)));
	}

	get condition(): ExpressionRef { return BinaryenObj["_BinaryenBreakGetCondition"](this[THIS_PTR]); }
	set condition(condExpr: ExpressionRef) {BinaryenObj["_BinaryenBreakSetCondition"](this[THIS_PTR], condExpr);}

	get value(): ExpressionRef { return BinaryenObj["_BinaryenBreakGetValue"](this[THIS_PTR]); }
	set value(valueExpr: ExpressionRef) { BinaryenObj["_BinaryenBreakSetValue"](this[THIS_PTR], valueExpr); }
}
