import {
	BinaryenObj,
} from "../../-pre.ts";
import type {
	Module,
} from "../../classes/module/Module.ts";
import type {
	ExpressionRef,
	HeapType,
	Type,
} from "../../constants.ts";
import {
	i32sToStack,
	preserveStack,
} from "../../utils.ts";



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
