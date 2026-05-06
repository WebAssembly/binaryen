import {
	BinaryenObj,
} from "../../-pre.ts";
import {
	Operation,
} from "../../classes/expression/Operation.ts";
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



export function ref(mod: Module) {
	return {
		/** Produces a reference to a given function. */
		func: (name: string, type: Type) => (
			preserveStack(() => BinaryenObj["_BinaryenRefFunc"](mod.ptr, strToStack(name), type))
		),

		/** Produces a null reference. */
		null: (typ: Type): ExpressionRef => (
			BinaryenObj["_BinaryenRefNull"](mod.ptr, typ)
		),

		/** Checks for null. */
		is_null: (value: ExpressionRef): ExpressionRef => (
			BinaryenObj["_BinaryenRefIsNull"](mod.ptr, value)
		),

		/** Converts a nullible reference to a non-null one, or traps. */
		as_non_null: (value: ExpressionRef): ExpressionRef => (
			BinaryenObj["_BinaryenRefAs"](mod.ptr, Operation.RefAsNonNull, value)
		),

		/** Compares two references. */
		eq: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => (
			BinaryenObj["_BinaryenRefEq"](mod.ptr, left, right)
		),

		/** Tests the dynamic type of a reference, and returns boolean. */
		test: (value: ExpressionRef, castType: Type): ExpressionRef => (
			BinaryenObj["_BinaryenRefTest"](mod.ptr, value, castType)
		),

		/** Tests the dynamic type of a reference, and performs a downcast or traps. */
		cast: (value: ExpressionRef, castType: Type): ExpressionRef => (
			BinaryenObj["_BinaryenRefCast"](mod.ptr, value, castType)
		),

		/** Converts type i32 to an unboxed scalar. */
		i31: (value: ExpressionRef): ExpressionRef => (
			BinaryenObj["_BinaryenRefI31"](mod.ptr, value)
		),
	} as const;
}



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#aggregate-instructions */
export function i31(mod: Module) {
	return {
		/** Converts an unboxed scalar to type i32, signed. */
		get_s: (value: ExpressionRef): ExpressionRef => (
			BinaryenObj["_BinaryenI31Get"](mod.ptr, value, true)
		),

		/** Converts an unboxed scalar to type i32, unsigned. */
		get_u: (value: ExpressionRef): ExpressionRef => (
			BinaryenObj["_BinaryenI31Get"](mod.ptr, value, false)
		),
	} as const;
}
