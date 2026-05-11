// # Globals # //
// Top-level functions available in the public API.



import {
	_free,
	_malloc,
	HEAP8,
	HEAPU32,
	BinaryenObj,
	getExceptionMessage,
	stackAlloc,
	stringToAscii,
} from "./-pre.ts";
import {
	PTR,
	i32sToStack,
	preserveStack,
} from "./-utils.ts";
import {
	type Feature,
	Module,
} from "./classes/module/Module.ts";
import * as expressions from "./classes/expression/index.ts";
import {
	ExpressionId,
	type ExpressionRef,
	type HeapType,
	type Type,
} from "./constants.ts";



const EXPRESSION_TYPE_REGISTRY: ReadonlyMap<ExpressionId, new (expr: ExpressionRef) => expressions.Expression> = new Map<ExpressionId, new (expr: ExpressionRef) => expressions.Expression>([
	// Parametric Instructions
	[ExpressionId.Drop, expressions.Drop],
	[ExpressionId.Select, expressions.Select],

	// Control Instructions
	[ExpressionId.Block, expressions.Block],
	[ExpressionId.Loop, expressions.Loop],
	[ExpressionId.If, expressions.If],
	[ExpressionId.Break, expressions.Break],
	[ExpressionId.Switch, expressions.Switch],
	[ExpressionId.BrOn, expressions.BrOn],
	[ExpressionId.Call, expressions.Call],
	[ExpressionId.CallRef, expressions.CallRef],
	[ExpressionId.CallIndirect, expressions.CallIndirect],
	[ExpressionId.Return, expressions.Return],
	[ExpressionId.Throw, expressions.Throw],
	[ExpressionId.Rethrow, expressions.Rethrow],
	[ExpressionId.Try, expressions.Try],

	// Variable Instructions
	[ExpressionId.LocalGet, expressions.LocalGet],
	[ExpressionId.LocalSet, expressions.LocalSet],
	[ExpressionId.GlobalGet, expressions.GlobalGet],
	[ExpressionId.GlobalSet, expressions.GlobalSet],

	// Table Instructions
	[ExpressionId.TableGet, expressions.TableGet],
	[ExpressionId.TableSet, expressions.TableSet],
	[ExpressionId.TableSize, expressions.TableSize],
	[ExpressionId.TableGrow, expressions.TableGrow],

	// Memory Instructions
	[ExpressionId.Load, expressions.Load],
	[ExpressionId.Store, expressions.Store],
	[ExpressionId.SIMDLoad, expressions.SIMDLoad],
	[ExpressionId.SIMDLoadStoreLane, expressions.SIMDLoadStoreLane],
	[ExpressionId.MemorySize, expressions.MemorySize],
	[ExpressionId.MemoryGrow, expressions.MemoryGrow],
	[ExpressionId.MemoryFill, expressions.MemoryFill],
	[ExpressionId.MemoryCopy, expressions.MemoryCopy],
	[ExpressionId.MemoryInit, expressions.MemoryInit],
	[ExpressionId.DataDrop, expressions.DataDrop],

	// Reference Instructions
	[ExpressionId.RefFunc, expressions.RefFunc],
	// TODO: [ExpressionId.RefNull, expressions.RefNull],
	[ExpressionId.RefIsNull, expressions.RefIsNull],
	[ExpressionId.RefAs, expressions.RefAs],
	[ExpressionId.RefEq, expressions.RefEq],
	[ExpressionId.RefTest, expressions.RefTest],
	[ExpressionId.RefCast, expressions.RefCast],
	[ExpressionId.RefI31, expressions.RefI31],
	[ExpressionId.I31Get, expressions.I31Get],

	// Aggregate Instructions
	[ExpressionId.TupleMake, expressions.TupleMake],
	[ExpressionId.TupleExtract, expressions.TupleExtract],
	[ExpressionId.StructNew, expressions.StructNew],
	[ExpressionId.StructGet, expressions.StructGet],
	[ExpressionId.StructSet, expressions.StructSet],
	[ExpressionId.ArrayNew, expressions.ArrayNew],
	[ExpressionId.ArrayNewFixed, expressions.ArrayNewFixed],
	[ExpressionId.ArrayNewData, expressions.ArrayNewData],
	[ExpressionId.ArrayNewElem, expressions.ArrayNewElem],
	[ExpressionId.ArrayGet, expressions.ArrayGet],
	[ExpressionId.ArraySet, expressions.ArraySet],
	[ExpressionId.ArrayLen, expressions.ArrayLen],
	[ExpressionId.ArrayFill, expressions.ArrayFill],
	[ExpressionId.ArrayCopy, expressions.ArrayCopy],
	[ExpressionId.ArrayInitData, expressions.ArrayInitData],
	[ExpressionId.ArrayInitElem, expressions.ArrayInitElem],

	// Numeric & Vector Instructions
	[ExpressionId.Const, expressions.Const],
	[ExpressionId.Unary, expressions.Unary],
	[ExpressionId.Binary, expressions.Binary],
	[ExpressionId.WideIntAddSub, expressions.WideIntAddSub],
	[ExpressionId.WideIntMul, expressions.WideIntMul],
	[ExpressionId.SIMDTernary, expressions.SIMDTernary],
	[ExpressionId.SIMDShift, expressions.SIMDShift],
	[ExpressionId.SIMDShuffle, expressions.SIMDShuffle],
	[ExpressionId.SIMDExtract, expressions.SIMDExtract],
	[ExpressionId.SIMDReplace, expressions.SIMDReplace],

	// Atomic Instructions
	[ExpressionId.AtomicRMW, expressions.AtomicRMW],
	[ExpressionId.AtomicCmpxchg, expressions.AtomicCmpxchg],
	[ExpressionId.AtomicWait, expressions.AtomicWait],
	[ExpressionId.AtomicNotify, expressions.AtomicNotify],
	[ExpressionId.AtomicFence, expressions.AtomicFence],

	// String Instructions
	[ExpressionId.StringNew, expressions.StringNew],
	[ExpressionId.StringConst, expressions.StringConst],
	[ExpressionId.StringMeasure, expressions.StringMeasure],
	[ExpressionId.StringEncode, expressions.StringEncode],
	[ExpressionId.StringConcat, expressions.StringConcat],
	[ExpressionId.StringEq, expressions.StringEq],
	[ExpressionId.StringWTF16Get, expressions.StringWTF16Get],
	[ExpressionId.StringSliceWTF, expressions.StringSliceWTF],
]);



/**
 * Private utility to create a Module from a given pointer.
 * Users don’t have access to this.
 */
function wrapModule(ptr: number): Module {
	const returned = new Module();
	// @ts-expect-error -- warning: reassigning a readonly field
	returned[PTR] = ptr;
	return returned;
}

/**
 * Calls a function, wrapping it in error handling code so that if it hits a
 * fatal error, we throw a JS exception (which JS can handle) rather than
 * abort the entire process (which would not be a friendly behavior).
 * @param func the function to call
 * @returns the return value of the given function
 */
function handleFatalError<T>(func: () => T): T {
	try {
		return func();
	} catch (e) {
		// Fatal errors begin with a specific prefix. Strip it out, and the newline.
		if (typeof e === "number") {
			// Older version of emscripten can throw C++ exceptions as pointers (numbers) in release builds.
			const [_, message] = getExceptionMessage(e);
			if (message.startsWith("Fatal: ")) {
				// eslint-disable-next-line preserve-caught-error
				throw new Error(message.slice(7).trim());
			}
		} else {
			const err = e as Error;
			// Newer version of emscripten always throw CppException object but don’t
			// always populate the `.message` field.
			// TODO: Set EXCEPTION_STACK_TRACES instead?
			if (!err.message) {
				const [_, message] = getExceptionMessage(err);
				err.message = message;
			}
			err.message = err.message.replace("Fatal:", "");
			err.message = err.message.trim();
		}
		// Rethrow anything else.
		throw e;
	}
}



// ## General Binaryen Functions ## //
/** Probably used in `BinaryenObj["_BinaryenExpressionPrint"]`. */
declare let out: any;
/** Emits the expression in Binaryen’s s-expression text format (not official stack-style text format). */
export function emitText(expr: ExpressionRef): string {
	let returned = "";
	const saved = out;
	out = (x: string) => {
		returned += `${ x }\n`;
	};
	BinaryenObj["_BinaryenExpressionPrint"](expr);
	out = saved;
	return returned;
}

/** Creates a module from binary data. */
export function readBinary(data: Uint8Array): Module {
	const buffer = _malloc(data.length);
	HEAP8.set(data, buffer);
	const ptr = handleFatalError(() => BinaryenObj["_BinaryenModuleRead"](buffer, data.length));
	_free(buffer);
	return wrapModule(ptr);
}

export function readBinaryWithFeatures(data: Uint8Array, features: Feature): Module {
	const buffer = _malloc(data.length);
	HEAP8.set(data, buffer);
	const ptr = handleFatalError(() => BinaryenObj["_BinaryenModuleReadWithFeatures"](buffer, data.length, features));
	_free(buffer);
	return wrapModule(ptr);
}

/** Creates a module from Binaryen’s s-expression text format (not official stack-style text format). */
export function parseText(text: string): Module {
	const buffer = _malloc(text.length + 1);
	stringToAscii(text, buffer);
	const ptr = handleFatalError(() => BinaryenObj["_BinaryenModuleParse"](buffer));
	_free(buffer);
	return wrapModule(ptr);
}

export function exit(status: number): void {
	// Instead of exiting silently on errors, always show an error with a stack trace, for debuggability.
	if (status !== 0) {
		throw new Error(`exiting due to error: ${ status }`);
	}
}



// ## Types and Expressions ## //
/**
 * Creates a multi-value type from an array of types.
 * @param types the array of types
 * @returns a tuple type containing the array’s components
 */
export function createType(types: readonly Type[]): Type {
	return preserveStack(() => BinaryenObj["_BinaryenTypeCreate"](i32sToStack(types), types.length));
}

/**
 * Expands a multi-value type to an array of types.
 * @param typ the tuple type
 * @returns an array containing the tuple’s components
 */
export function expandType(typ: Type): Type[] {
	return preserveStack(() => {
		const numTypes = BinaryenObj["_BinaryenTypeArity"](typ);
		const array = stackAlloc(numTypes << 2);
		BinaryenObj["_BinaryenTypeExpand"](typ, array);
		const types = new Array(numTypes);
		for (let i = 0; i < numTypes; i++) {
			types[i] = HEAPU32[(array >>> 2) + i];
		}
		return types;
	});
}

/**
 * Gets the type from a heap type generated by TypeBuilder.
 * @param heapType the heap type from which to get the type
 * @param nullable whether the return type should be nullable
 * @returns given `ht`: `(ref null? ht)`
 */
export function getTypeFromHeapType(heapType: HeapType, nullable: boolean): Type {
	return BinaryenObj["_BinaryenTypeFromHeapType"](heapType, nullable);
}

/**
 * Gets the heap type of a type.
 * @param typ the type from which to get the heap type
 * @returns given `(ref null? ht)`: `ht`
 */
export function getHeapType(typ: Type): HeapType {
	return BinaryenObj["_BinaryenTypeGetHeapType"](typ);
}

/** A misnomer — returns not a unique “ID”, but the “kind” of the expression. */
export function getExpressionId(expr: ExpressionRef): ExpressionId {
	return BinaryenObj["_BinaryenExpressionGetId"](expr);
}

/** Gets the type of the specified expression. */
export function getExpressionType(expr: ExpressionRef): Type {
	return BinaryenObj["_BinaryenExpressionGetType"](expr);
}

/**
 * Obtains information about an expression.
 * Additional properties depend on the expression’s ID
 * and are usually equivalent to the respective parameters when creating such an expression.
 */
export function getExpressionInfo(expr: ExpressionRef): expressions.Expression {
	const id = getExpressionId(expr);
	const specificExpression = EXPRESSION_TYPE_REGISTRY.get(id);
	return specificExpression ? new specificExpression(expr) : new expressions.Expression(id, expr);
}
