import {
	BinaryenObj,
} from "../../-pre.ts";
import type {
	Module,
} from "../../classes/module/Module.ts";
import type {
	ExpressionRef,
} from "../../constants.ts";
import {
	i32sToStack,
	preserveStack,
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
