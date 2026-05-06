import {
	BinaryenObj,
} from "../../-pre.ts";
import type {
	Module,
} from "../../classes/module/Module.ts";
import type {
	HeapType,
	ExpressionRef,
	Type,
} from "../../constants.ts";
import {
	i32sToStack,
	preserveStack,
	strToStack,
} from "../../utils.ts";



export function tuple(mod: Module) {
	return {
		/**
		 * A Binaryen-specific operation that combines values into a virtual tuple.
		 * A virtual tuple is simply a set of locals treated together as one unit,
		 * not an actual object stored in the heap.
		 */
		make: (elements: readonly ExpressionRef[]): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenTupleMake"](mod.ptr, i32sToStack(elements), elements.length))
		),

		/** Extracts a value from a Binaryen virtual tuple. */
		extract: (tupl: ExpressionRef, index: number): ExpressionRef => (
			BinaryenObj["_BinaryenTupleExtract"](mod.ptr, tupl, index)
		),
	} as const;
}



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#aggregate-instructions */
export function struct(mod: Module) {
	return {
		/**
		 * Allocates a new struct and initializes it with the given operands.
		 * Passing in an empty array for `operands` returns `(struct.new_default)`.
		 */
		new: (operands: readonly ExpressionRef[], heapType: HeapType): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenStructNew"](mod.ptr, i32sToStack(operands), operands.length, heapType))
		),

		/** Allocate a new struct and initializes it with default values. */
		new_default: (heapType: HeapType): ExpressionRef => (
			BinaryenObj["_BinaryenStructNew"](mod.ptr, 0, 0, heapType)
		),

		/**
		 * Gets a struct entry with an unpacked type at an index.
		 *
		 * **Warning:** `.get()` no longer takes the boolean `isSigned` argument, and assumes an unpacked type.
		 * For packed types, use `.get_s()` for signed and `.get_u()` for unsigned.
		 */
		get: function (index: number, ref: number, type: number, deprecated_isSigned?: boolean) {
			return deprecated_isSigned === undefined
				? BinaryenObj["_BinaryenStructGet"](mod.ptr, index, ref, type)
				: deprecated_isSigned
					? this.get_s(index, ref, type)
					: this.get_u(index, ref, type);
		},

		/** Gets a struct entry with a signed packed type at an index. */
		get_s: (index: number, ref: ExpressionRef, type: Type): ExpressionRef => (
			BinaryenObj["_BinaryenStructGet"](mod.ptr, index, ref, type, true)
		),

		/** Gets a struct entry with an unsigned packed type at an index. */
		get_u: (index: number, ref: ExpressionRef, type: Type): ExpressionRef => (
			BinaryenObj["_BinaryenStructGet"](mod.ptr, index, ref, type, false)
		),

		/** Sets a struct entry at an index. */
		set: (index: number, ref: ExpressionRef, value: ExpressionRef): ExpressionRef => (
			BinaryenObj["_BinaryenStructSet"](mod.ptr, index, ref, value)
		),
	} as const;
}



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#aggregate-instructions */
export function array(mod: Module) {
	return {
		/** Allocates a new array and initializes it with the given operand (repeated). */
		new: (heapType: HeapType, size: ExpressionRef, operand: ExpressionRef): ExpressionRef => (
			BinaryenObj["_BinaryenArrayNew"](mod.ptr, heapType, size, operand)
		),

		/** Allocates a new array and initializes it with a default value (repeated). */
		new_default: (heapType: HeapType, size: ExpressionRef): ExpressionRef => (
			BinaryenObj["_BinaryenArrayNew"](mod.ptr, heapType, size, 0)
		),

		/** Allocates a new array with the given operands and a statically fixed size. */
		new_fixed: (heapType: HeapType, operands: readonly ExpressionRef[]): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenArrayNewFixed"](mod.ptr, heapType, i32sToStack(operands), operands.length))
		),

		/** Allocates a new array and initializes it from a data segment. */
		new_data: (heapType: HeapType, name: string, offset: ExpressionRef, size: ExpressionRef): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenArrayNewData"](mod.ptr, heapType, strToStack(name), offset, size))
		),

		/** Allocates a new array and initializes it from an element segment. */
		new_elem: (heapType: HeapType, name: string, offset: ExpressionRef, size: ExpressionRef): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenArrayNewElem"](mod.ptr, heapType, strToStack(name), offset, size))
		),

		/**
		 * Gets an array entry with an unpacked type at an index.
		 *
		 * **Warning:** `.get()` no longer takes the boolean `isSigned` argument, and assumes an unpacked type.
		 * For packed types, use `.get_s()` for signed and `.get_u()` for unsigned.
		 */
		get: function (ref: number, index: number, type: number, deprecated_isSigned?: boolean) {
			return deprecated_isSigned === undefined
				? BinaryenObj["_BinaryenArrayGet"](mod.ptr, ref, index, type)
				: deprecated_isSigned
					? this.get_s(ref, index, type)
					: this.get_u(ref, index, type);
		},

		/** Gets an array entry with a signed packed type at an index. */
		get_s: (ref: ExpressionRef, index: ExpressionRef, type: Type): ExpressionRef => (
			BinaryenObj["_BinaryenArrayGet"](mod.ptr, ref, index, type, true)
		),

		/** Gets an array entry with an unsigned packed type at an index. */
		get_u: (ref: ExpressionRef, index: ExpressionRef, type: Type): ExpressionRef => (
			BinaryenObj["_BinaryenArrayGet"](mod.ptr, ref, index, type, false)
		),

		/** Sets an array entry at an index. */
		set: (ref: ExpressionRef, index: ExpressionRef, value: ExpressionRef): ExpressionRef => (
			BinaryenObj["_BinaryenArraySet"](mod.ptr, ref, index, value)
		),

		/** Produces the length of an array. */
		len: (ref: ExpressionRef): ExpressionRef => (
			BinaryenObj["_BinaryenArrayLen"](mod.ptr, ref)
		),

		/** Fills a specified slice of an array with the given value. */
		fill: (ref: ExpressionRef, index: ExpressionRef, value: ExpressionRef, size: ExpressionRef): ExpressionRef => (
			BinaryenObj["_BinaryenArrayFill"](mod.ptr, ref, index, value, size)
		),

		/** Copies elements to a specified slice of an array from a given array. */
		copy: (
			destRef: ExpressionRef,
			destIndex: ExpressionRef,
			srcRef: ExpressionRef,
			srcIndex: ExpressionRef,
			length: ExpressionRef,
		): ExpressionRef => (
			BinaryenObj["_BinaryenArrayCopy"](mod.ptr, destRef, destIndex, srcRef, srcIndex, length)
		),

		/** Copies elements to a specified slice of an array from a given data segment. */
		init_data: (
			name: string,
			ref: ExpressionRef,
			index: ExpressionRef,
			offset: ExpressionRef,
			size: ExpressionRef,
		): ExpressionRef => (
			BinaryenObj["_BinaryenArrayInitData"](mod.ptr, strToStack(name), ref, index, offset, size)
		),

		/** Copies elements to a specified slice of an array from a given element segment. */
		init_elem: (
			name: string,
			ref: ExpressionRef,
			index: ExpressionRef,
			offset: ExpressionRef,
			size: ExpressionRef,
		): ExpressionRef => (
			preserveStack(() => BinaryenObj["_BinaryenArrayInitElem"](mod.ptr, strToStack(name), ref, index, offset, size))
		),
	} as const;
}
