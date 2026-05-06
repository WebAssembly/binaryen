import {
	BinaryenObj,
} from "../../-pre.ts";
import type {
	Module,
} from "../../classes/module/Module.ts";
import type {
	ExpressionRef,
} from "../../constants.ts";



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#parametric-instructions */
export function parametric(mod: Module) {
	return {
		/** Creates a no-operation `(nop)` instruction. */
		nop: (): ExpressionRef => (
			BinaryenObj["_BinaryenNop"](mod.ptr)
		),

		/** Creates an unreachable instruction that will always trap. */
		unreachable: (): ExpressionRef => (
			BinaryenObj["_BinaryenUnreachable"](mod.ptr)
		),

		/** Creates a `(drop)` of a value. */
		drop: (value: ExpressionRef): ExpressionRef => (
			BinaryenObj["_BinaryenDrop"](mod.ptr, value)
		),

		/** Creates a `(select)` of one of two values. */
		select: (ifTrue: ExpressionRef, ifFalse: ExpressionRef): ExpressionRef => (
			BinaryenObj["_BinaryenSelect"](mod.ptr, ifTrue, ifFalse)
		),
	} as const;
}
