import {
	BinaryenObj,
	UTF8ToString,
} from "../../-pre.ts";
import {
	ExpressionId,
	type ExpressionRef,
	type Type,
	unreachable,
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
import {
	Operation,
} from "./Operation.ts";



export class BrOn extends Expression {
	static #brOn(mod: Module, op: Operation, label: string, value: ExpressionRef, castType: Type): ExpressionRef {
		return preserveStack(() => BinaryenObj["_BinaryenBrOn"](mod.ptr, op, strToStack(label), value, castType));
	}

	/** Branches if the reference operand is null. */
	static brOnNull(mod: Module, label: string, value: ExpressionRef): ExpressionRef {
		return this.#brOn(mod, Operation.BrOnNull, label, value, unreachable);
	}

	/** Branches if the reference operand is not null. */
	static brOnNonNull(mod: Module, label: string, value: ExpressionRef): ExpressionRef {
		return this.#brOn(mod, Operation.BrOnNonNull, label, value, unreachable);
	}

	/** Branches if the reference operand is successfully downcast to the given type. */
	static brOnCast(mod: Module, label: string, value: ExpressionRef, castType: Type): ExpressionRef {
		return this.#brOn(mod, Operation.BrOnCast, label, value, castType);
	}

	/** Branches if the reference operand fails to downcast to the given type. */
	static brOnCastFail(mod: Module, label: string, value: ExpressionRef, castType: Type): ExpressionRef {
		return this.#brOn(mod, Operation.BrOnCastFail, label, value, castType);
	}



	constructor(expr: ExpressionRef) {
		super(ExpressionId.BrOn, expr);
	}


	get op(): number { return BinaryenObj["_BinaryenBrOnGetOp"](this[THIS_PTR]); }
	set op(op: number) { BinaryenObj["_BinaryenBrOnSetOp"](this[THIS_PTR], op); }

	get name(): string { return UTF8ToString(BinaryenObj["_BinaryenBrOnGetName"](this[THIS_PTR])); }
	set name(name: string) { preserveStack(() => BinaryenObj["_BinaryenBrOnSetName"](this[THIS_PTR], strToStack(name))); }

	get ref(): ExpressionRef { return BinaryenObj["_BinaryenBrOnGetRef"](this[THIS_PTR]); }
	set ref(ref: ExpressionRef) { BinaryenObj["_BinaryenBrOnSetRef"](this[THIS_PTR], ref); }

	get castType(): Type { return BinaryenObj["_BinaryenBrOnGetCastType"](this[THIS_PTR]); }
	set castType(castType: Type) { BinaryenObj["_BinaryenBrOnSetCastType"](this[THIS_PTR], castType); }
}
