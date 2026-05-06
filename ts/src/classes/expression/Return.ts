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
	i32sToStack,
	preserveStack,
	strToStack,
} from "../../utils.ts";
import type {
	Module,
} from "../module/Module.ts";
import {
	Expression,
} from "./Expression.ts";



export class Return extends Expression {
	/** Unconditional branch to the body of the current function. */
	static return(mod: Module, value: ExpressionRef): ExpressionRef {
		return BinaryenObj["_BinaryenReturn"](mod.ptr, value);
	}

	/** Tail-call variant of `call`. */
	static returnCall(mod: Module, name: string, operands: readonly ExpressionRef[], resultsType: Type): ExpressionRef {
		return preserveStack(() => BinaryenObj["_BinaryenReturnCall"](mod.ptr, strToStack(name), i32sToStack(operands), operands.length, resultsType));
	}

	/** Tail-call variant of `call_ref`. */
	static returnCallRef(mod: Module, target: ExpressionRef, operands: readonly ExpressionRef[], resultsType: Type): ExpressionRef {
		return preserveStack(() => BinaryenObj["_BinaryenReturnCallRef"](mod.ptr, target, i32sToStack(operands), operands.length, resultsType));
	}

	/** Tail-call variant of `call_indirect`. */
	static returnCallIndirect(mod: Module, table: string, target: ExpressionRef, operands: readonly ExpressionRef[], paramsType: Type, resultsType: Type): ExpressionRef {
		return preserveStack(() => BinaryenObj["_BinaryenReturnCallIndirect"](mod.ptr, strToStack(table), target, i32sToStack(operands), operands.length, paramsType, resultsType));
	}


	constructor(expr: ExpressionRef) {
		super(ExpressionId.Return, expr);
	}


	get value(): ExpressionRef { return BinaryenObj["_BinaryenReturnGetValue"](this[THIS_PTR]); }
	set value(valueExpr: ExpressionRef) { BinaryenObj["_BinaryenReturnSetValue"](this[THIS_PTR], valueExpr); }
}
