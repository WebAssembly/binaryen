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



export class Rethrow extends Expression {
	/** Reraise an exception. */
	static throwRef(mod: Module, target: string): ExpressionRef {
		return preserveStack(() => BinaryenObj["_BinaryenRethrow"](mod.ptr, strToStack(target)));
	}


	constructor(expr: ExpressionRef) {
		super(ExpressionId.Rethrow, expr);
	}


	get target(): string | null {
		const target = BinaryenObj["_BinaryenRethrowGetTarget"](this[THIS_PTR]);
		return target ? UTF8ToString(target) : null;
	}

	set target(target: string) {
		preserveStack(() => BinaryenObj["_BinaryenRethrowSetTarget"](this[THIS_PTR], strToStack(target)));
	}
}
