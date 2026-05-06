import {
	BinaryenObj,
} from "../../-pre.ts";
import type {
	Module,
} from "../../classes/module/Module.ts";
import {
	type ExpressionRef,
	type Type,
	i32,
	i64,
} from "../../constants.ts";
import {
	preserveStack,
	strToStack,
} from "../../utils.ts";



function atomic(mod: Module) {
	function wait(typ: Type, ptr: ExpressionRef, expected: ExpressionRef, timeout: ExpressionRef, name: string): ExpressionRef {
		return preserveStack(() => BinaryenObj["_BinaryenAtomicWait"](mod.ptr, ptr, expected, timeout, typ, strToStack(name)));
	}

	return {
		/** @experimental */
		notify: (ptr: ExpressionRef, notifyCount: ExpressionRef, name: string): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenAtomicNotify"](mod.ptr, ptr, notifyCount, strToStack(name)))
		),

		/** @experimental */
		wait32: (ptr: ExpressionRef, expected: ExpressionRef, timeout: ExpressionRef, name: string): ExpressionRef => (
			wait(i32, ptr, expected, timeout, name)
		),

		/** @experimental */
		wait64: (ptr: ExpressionRef, expected: ExpressionRef, timeout: ExpressionRef, name: string): ExpressionRef => (
			wait(i64, ptr, expected, timeout, name)
		),
	} as const;
}



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#memory-instructions */
export function memory(mod: Module) {
	return {
		/** Returns the current size of a memory. */
		size: (name: string, memory64: boolean = false): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenMemorySize"](mod.ptr, strToStack(name), memory64))
		),

		/** Grows memory by a given delta and returns the previous size, or -1 if not enough space can be allocated. */
		grow: (delta: ExpressionRef, name: string, memory64: boolean = false): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenMemoryGrow"](mod.ptr, delta, strToStack(name), memory64))
		),

		/** Sets all values in a region of memory to a given byte. */
		fill: (dest: ExpressionRef, value: ExpressionRef, size: ExpressionRef, name: string): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenMemoryFill"](mod.ptr, dest, value, size, strToStack(name)))
		),

		/**
		 * Copies data from a source memory region to a possibly overlapping destination region in another or the same memory.
		 * The first index denotes the destination.
		 */
		copy: (dest: ExpressionRef, source: ExpressionRef, size: ExpressionRef, destMemory: string, sourceMemory: string): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenMemoryCopy"](mod.ptr, dest, source, size, strToStack(destMemory), strToStack(sourceMemory)))
		),

		/** Copies data from a passive data segment into a memory. */
		init: (segment: string, dest: ExpressionRef, offset: ExpressionRef, size: ExpressionRef, name: string): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenMemoryInit"](mod.ptr, strToStack(segment), dest, offset, size, strToStack(name)))
		),

		/** @experimental */
		atomic: atomic(mod),
	} as const;
}
