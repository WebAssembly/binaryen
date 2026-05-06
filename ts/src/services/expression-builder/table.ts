import {
	BinaryenObj,
} from "../../-pre.ts";
import type {
	Module,
} from "../../classes/module/Module.ts";
import type {
	ExpressionRef,
	Type,
} from "../../constants.ts";
import {
	preserveStack,
	strToStack,
} from "../../utils.ts";



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#table-instructions */
export function table(mod: Module) {
	return {
		/** Load an element in a table. */
		get: (name: string, index: number, typ: Type): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenTableGet"](mod.ptr, strToStack(name), index, typ))
		),

		/** Store an element in a table. */
		set: (name: string, index: number, value: ExpressionRef): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenTableSet"](mod.ptr, strToStack(name), index, value))
		),

		/** Returns the current size of a table. */
		size: (name: string): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenTableSize"](mod.ptr, strToStack(name)))
		),

		/** Grows table by a given delta and returns the previous size, or -1 if not enough space can be allocated. */
		grow: (name: string, value: ExpressionRef, delta: ExpressionRef): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenTableGrow"](mod.ptr, strToStack(name), value, delta))
		),

		// TODO: fill
		// TODO: copy
		// TODO: init
	} as const;
}
