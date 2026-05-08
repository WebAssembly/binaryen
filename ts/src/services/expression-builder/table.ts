import {
	BinaryenObj,
} from "../../-pre.ts";
import {
	PTR,
	preserveStack,
	strToStack,
} from "../../-utils.ts";
import type {
	Module,
} from "../../classes/module/Module.ts";
import type {
	ExpressionRef,
	Type,
} from "../../constants.ts";



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#table-instructions */
export function table(mod: Module) {
	return {
		/** Load an element in a table. */
		get: (name: string, index: number, typ: Type): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenTableGet"](mod[PTR], strToStack(name), index, typ))
		),

		/** Store an element in a table. */
		set: (name: string, index: number, value: ExpressionRef): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenTableSet"](mod[PTR], strToStack(name), index, value))
		),

		/** Returns the current size of a table. */
		size: (name: string): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenTableSize"](mod[PTR], strToStack(name)))
		),

		/** Grows table by a given delta and returns the previous size, or -1 if not enough space can be allocated. */
		grow: (name: string, value: ExpressionRef, delta: ExpressionRef): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenTableGrow"](mod[PTR], strToStack(name), value, delta))
		),

		// TODO: fill
		// TODO: copy
		// TODO: init
	} as const;
}
