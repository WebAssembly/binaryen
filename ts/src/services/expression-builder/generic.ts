import {
	BinaryenObj,
} from "../../-pre.ts";
import {
	PTR,
	i32sToStack,
	preserveStack,
	strToStack,
} from "../../-utils.ts";
import type {
	Module,
} from "../../classes/module/Module.ts";
import {
	type ExpressionRef,
	Operation,
	type Type,
	none,
	unreachable,
} from "../../constants.ts";
import {
	expressionBuilder,
} from "./expressionBuilder.ts";



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#parametric-instructions */
export function parametrics(mod: Module) {
	return {
		/** Creates a no-operation `(nop)` instruction. */
		nop: (): ExpressionRef => (
			BinaryenObj["_BinaryenNop"](mod[PTR])
		),

		/** Creates an unreachable instruction that will always trap. */
		unreachable: (): ExpressionRef => (
			BinaryenObj["_BinaryenUnreachable"](mod[PTR])
		),

		/** Creates a `(drop)` of a value. */
		drop: (value: ExpressionRef): ExpressionRef => (
			BinaryenObj["_BinaryenDrop"](mod[PTR], value)
		),

		/** Creates a `(select)` of one of two values. */
		select: (condition: ExpressionRef, ifTrue: ExpressionRef, ifFalse: ExpressionRef): ExpressionRef => (
			BinaryenObj["_BinaryenSelect"](mod[PTR], condition, ifTrue, ifFalse)
		),
	} as const;
}



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#control-instructions */
export function blocks(mod: Module) {
	return {
		/** Creates a `(block)`. */
		block: (name: string | null, children: readonly ExpressionRef[], resultType: Type = none): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenBlock"](
				mod[PTR],
				name ? strToStack(name) : 0,
				i32sToStack(children),
				children.length,
				resultType,
			))
		),

		/** Creates a `(loop)`. */
		loop: (name: string, body: ExpressionRef): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenLoop"](mod[PTR], strToStack(name), body))
		),

		/** Creates an ‘if’ or ‘if/else’ combination. */
		if: (condition: ExpressionRef, ifTrue: ExpressionRef, ifFalse: ExpressionRef = expressionBuilder(mod).nop()): ExpressionRef => (
			BinaryenObj["_BinaryenIf"](mod[PTR], condition, ifTrue, ifFalse)
		),
	} as const;
}



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#control-instructions */
export function breaks(mod: Module) {
	function brOn(op: Operation, label: string, value: ExpressionRef, castType: Type): ExpressionRef {
		return preserveStack(() => BinaryenObj["_BinaryenBrOn"](mod[PTR], op, strToStack(label), value, castType));
	}

	return {
		/** Creates an unconditional branch `(br)` to a label. */
		br: (label: string, condition?: ExpressionRef, value?: ExpressionRef): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenBreak"](mod[PTR], strToStack(label), condition!, value!))
		),

		/** Creates a conditional branch `(br_if)` to a label. */
		br_if: (label: string, condition: ExpressionRef, value?: ExpressionRef): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenBreak"](mod[PTR], strToStack(label), condition, value!))
		),

		/** Creates a switch. */
		br_table: (labels: readonly string[], defaultLabel: string, condition: ExpressionRef, value?: ExpressionRef): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenSwitch"](
				mod[PTR],
				i32sToStack(labels.map(strToStack)),
				labels.length,
				strToStack(defaultLabel),
				condition,
				value!,
			))
		),

		/** Branches if the reference operand is null. */
		br_on_null: (label: string, value: ExpressionRef): ExpressionRef => (
			brOn(Operation.BrOnNull, label, value, unreachable)
		),

		/** Branches if the reference operand is not null. */
		br_on_non_null: (label: string, value: ExpressionRef): ExpressionRef => (
			brOn(Operation.BrOnNonNull, label, value, unreachable)
		),

		/** Branches if the reference operand is successfully downcast to the given type. */
		br_on_cast: (label: string, value: ExpressionRef, castType: Type): ExpressionRef => (
			brOn(Operation.BrOnCast, label, value, castType)
		),

		/** Branches if the reference operand fails to downcast to the given type. */
		br_on_cast_fail: (label: string, value: ExpressionRef, castType: Type): ExpressionRef => (
			brOn(Operation.BrOnCastFail, label, value, castType)
		),

		// @ts-expect-error
		/** @deprecated Use {@link ExpressionBuilder#br} instead. */ break(...args) { BinaryenObj.printWarn("`.break()` is deprecated; use `.br()` instead."); return this.br(...args); },
		// @ts-expect-error
		/** @deprecated Use {@link ExpressionBuilder#br_table} instead. */ switch(...args) { BinaryenObj.printWarn("`.switch()` is deprecated; use `.br_table()` instead."); return this.br_table(...args); },
	} as const;
}



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#control-instructions */
export function calls(mod: Module) {
	return {
		/**
		 * Creates a call to a function.
		 * Note that we must specify the return type here as we may not have created the function being called yet.
		 */
		call: (name: string, operands: readonly ExpressionRef[], resultsType: Type): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenCall"](mod[PTR], strToStack(name), i32sToStack(operands), operands.length, resultsType))
		),

		/** Similar to `call`, but takes a function reference operand instead of a name as the called value. */
		call_ref: (target: ExpressionRef, operands: readonly ExpressionRef[], resultsType: Type): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenCallRef"](mod[PTR], target, i32sToStack(operands), operands.length, resultsType))
		),

		/** Similar to `call_ref`, but indexes into a table to find the function to call. */
		call_indirect: (table: string, target: ExpressionRef, operands: readonly ExpressionRef[], paramsType: Type, resultsType: Type): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenCallIndirect"](mod[PTR], strToStack(table), target, i32sToStack(operands), operands.length, paramsType, resultsType))
		),

		/** Unconditional branch to the body of the current function. */
		return: (value: ExpressionRef): ExpressionRef => (
			BinaryenObj["_BinaryenReturn"](mod[PTR], value)
		),

		/** Tail-call variant of `call`. */
		return_call: (name: string, operands: readonly ExpressionRef[], resultsType: Type): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenReturnCall"](mod[PTR], strToStack(name), i32sToStack(operands), operands.length, resultsType))
		),

		/** Tail-call variant of `call_ref`. */
		return_call_ref: (target: ExpressionRef, operands: readonly ExpressionRef[], resultsType: Type): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenReturnCallRef"](mod[PTR], target, i32sToStack(operands), operands.length, resultsType))
		),

		/** Tail-call variant of `call_indirect`. */
		return_call_indirect: (table: string, target: ExpressionRef, operands: readonly ExpressionRef[], paramsType: Type, resultsType: Type): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenReturnCallIndirect"](mod[PTR], strToStack(table), target, i32sToStack(operands), operands.length, paramsType, resultsType))
		),

		// @ts-expect-error
		/** @deprecated Use {@link ExpressionBuilder#call_indirect} instead. */ callIndirect(...args) { BinaryenObj.printWarn("`.callIndirect()` is deprecated; use `.call_indirect()` instead."); return this.call_indirect(...args); },
		// @ts-expect-error
		/** @deprecated Use {@link ExpressionBuilder#return_call} instead. */ returnCall(...args) { BinaryenObj.printWarn("`.returnCall()` is deprecated; use `.return_call()` instead."); return this.return_call(...args); },
		// @ts-expect-error
		/** @deprecated Use {@link ExpressionBuilder#return_call_indirect} instead. */ returnCallIndirect(...args) { BinaryenObj.printWarn("`.returnCallIndirect()` is deprecated; use `.return_call_indirect()` instead."); return this.return_call_indirect(...args); },
	} as const;
}



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#control-instructions */
export function throws(mod: Module) {
	return {
		/** Raise an exception. */
		throw: (tag: string, operands: readonly ExpressionRef[]): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenThrow"](mod[PTR], strToStack(tag), i32sToStack(operands), operands.length))
		),

		/** Reraise an exception. */
		throw_ref: (target: string): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenRethrow"](mod[PTR], strToStack(target)))
		),

		/** Installs an exception handler that handles exceptions as specified by its catch clauses. */
		try_table: (
			name: string,
			body: ExpressionRef,
			catchTags: readonly string[],
			catchBodies: readonly ExpressionRef[],
			delegateTarget: string,
		): ExpressionRef => preserveStack(() => BinaryenObj["_BinaryenTry"](
			mod[PTR],
			strToStack(name),
			body,
			i32sToStack(catchTags.map(strToStack)),
			catchTags.length,
			i32sToStack(catchBodies),
			catchBodies.length,
			strToStack(delegateTarget),
		)),

		// TODO: catch
		// TODO: catch_ref
		// TODO: catch_all
		// TODO: catch_all_ref

		// @ts-expect-error
		/** @deprecated Use {@link ExpressionBuilder#throw_ref} instead. */ rethrow(...args) { BinaryenObj.printWarn("`.rethrow()` is deprecated; use `.throw_ref()` instead."); return this.throw_ref(...args); },
		// @ts-expect-error
		/** @deprecated Use {@link ExpressionBuilder#try_table} instead. */ try(...args) { BinaryenObj.printWarn("`.try()` is deprecated; use `.try_table()` instead."); return this.try_table(...args); },
	} as const;
}
