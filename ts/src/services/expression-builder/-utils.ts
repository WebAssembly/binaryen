import {
	BinaryenObj,
	stackAlloc,
} from "../../-pre.ts";
import {
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
import type {
	Operation,
} from "./Operation.ts";



/**
 * The size of a single literal in memory as used in Const creation,
 * which is a little different: we don’t want users to need to make
 * their own Literals, as the C API handles them by value, which means
 * we would leak them. Instead, Const creation is fused together with
 * an intermediate stack allocation of this size to pass the value.
 */
const SIZE_OF_LITERAL = BinaryenObj["_BinaryenSizeofLiteral"]();



export function constant(
	mod: Module,
	binFuncName: (
		| "_BinaryenLiteralInt32"
		| "_BinaryenLiteralFloat32"
		| "_BinaryenLiteralFloat64"
		| "_BinaryenLiteralVec128"
		| "_BinaryenLiteralFloat32Bits"
	),
	value: number,
): ExpressionRef;
export function constant(
	mod: Module,
	binFuncName: (
		| "_BinaryenLiteralInt64"
		| "_BinaryenLiteralFloat64Bits"
	),
	value: bigint,
): ExpressionRef;
export function constant(mod: Module, binFuncName: string, value: number | bigint): ExpressionRef {
	return preserveStack(() => {
		// Weird C stuff happening here…
		// `tempLiteral` is a pointer whose reference gets mutated by the call to `binFuncName`.
		// Emscripten applies the ‘sret’ convention here, converting `BinaryenObj[binFuncName]`
		// (e.g `BinaryenLiteralInt32`) to a function with 2 params.
		const tempLiteral = stackAlloc(SIZE_OF_LITERAL);
		BinaryenObj[binFuncName](tempLiteral, value);
		return BinaryenObj["_BinaryenConst"](mod.ptr, tempLiteral);
	});
}

export function unaryFn(mod: Module, op: Operation): (value: ExpressionRef) => ExpressionRef {
	return (value) => BinaryenObj["_BinaryenUnary"](mod.ptr, op, value);
}

export function binaryFn(mod: Module, op: Operation): (left: ExpressionRef, right: ExpressionRef) => ExpressionRef {
	return (left, right) => BinaryenObj["_BinaryenBinary"](mod.ptr, op, left, right);
}

export function loadFn(mod: Module, typ: Type, bytes: number, isSigned: boolean): (offset: number, align: number, ptr: ExpressionRef, name: string) => ExpressionRef {
	return (offset, align, ptr, name) => preserveStack(() => BinaryenObj["_BinaryenLoad"](mod.ptr, bytes, isSigned, offset, align, typ, ptr, strToStack(name)));
}

export function storeFn(mod: Module, typ: Type, bytes: number): (offset: number, align: number, ptr: ExpressionRef, value: ExpressionRef, name: string) => ExpressionRef {
	return (offset, align, ptr, value, name) => preserveStack(() => BinaryenObj["_BinaryenStore"](mod.ptr, bytes, offset, align, ptr, value, typ, strToStack(name)));
}

export function simdLoadFn(mod: Module, op: Operation): (offset: number, align: number, ptr: ExpressionRef, name: string) => ExpressionRef {
	return (offset, align, ptr, name) => preserveStack(() => BinaryenObj["_BinaryenSIMDLoad"](mod.ptr, op, offset, align, ptr, strToStack(name)));
}

export function simdLoadStoreLaneFn(mod: Module, op: Operation): (offset: number, align: number, index: number, ptr: ExpressionRef, vec: ExpressionRef, name: string) => ExpressionRef {
	return (offset, align, index, ptr, vec, name) => preserveStack(() => BinaryenObj["_BinaryenSIMDLoadStoreLane"](mod.ptr, op, offset, align, index, ptr, vec, strToStack(name)));
}

export function simdShiftFn(mod: Module, op: Operation): (vec: ExpressionRef, shift: ExpressionRef) => ExpressionRef {
	return (vec, shift) => BinaryenObj["_BinaryenSIMDShift"](mod.ptr, op, vec, shift);
}

export function simdExtractFn(mod: Module, op: Operation): (vec: ExpressionRef, index: number) => ExpressionRef {
	return (vec, index) => BinaryenObj["_BinaryenSIMDExtract"](mod.ptr, op, vec, index);
}

export function simdReplaceFn(mod: Module, op: Operation): (vec: ExpressionRef, index: number, value: ExpressionRef) => ExpressionRef {
	return (vec, index, value) => BinaryenObj["_BinaryenSIMDReplace"](mod.ptr, op, vec, index, value);
}
