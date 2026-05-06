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



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#variable-instructions */
export function local(mod: Module) {
	return {
		/**
		 * Creates a `(local.get)` for the local at the specified index.
		 * Note that we must specify the type here as we may not have created the local being accessed yet.
		 */
		get: (index: number, typ: Type): ExpressionRef => (
			BinaryenObj["_BinaryenLocalGet"](mod.ptr, index, typ)
		),

		/** Creates a `(local.set)` for the local at the specified index. */
		set: (index: number, value: ExpressionRef): ExpressionRef => (
			BinaryenObj["_BinaryenLocalSet"](mod.ptr, index, value)
		),

		/**
		 * Creates a `(local.tee)` for the local at the specified index.
		 * Note that we must specify the type here as we may not have created the local being accessed yet.
		 */
		tee: (index: number, value: ExpressionRef, typ: Type): ExpressionRef => (
			BinaryenObj["_BinaryenLocalTee"](mod.ptr, index, value, typ)
		),
	} as const;
}
