import {
	BinaryenObj,
	stackAlloc,
	stackRestore,
	stackSave,
	stringToUTF8OnStack,
} from "./-pre.ts";



// # Utilities # //
// Global functions and constants needed across all `.ts` files. These are not exported publicly.



export const HEAP8: Int8Array = BinaryenObj["HEAP8"] as any;
export const HEAPU8: Uint8Array = BinaryenObj["HEAPU8"] as any;
export const HEAP32: Int32Array = BinaryenObj["HEAP32"] as any;
export const HEAPU32: Uint32Array = BinaryenObj["HEAPU32"] as any;



/** Private symbol used to store the underlying C-API pointer of a wrapped object. */
export const THIS_PTR: unique symbol = Symbol();



/**
 * Exports friendly API methods.
 * @param func [description]
 * @return [description]
 */
export function preserveStack<T>(func: () => T): T {
	try {
		var stack = stackSave();
		return func();
	} finally {
		stackRestore(stack);
	}
}

/**
 * [description]
 * @param str [description]
 * @return [description]
 */
export function strToStack(str?: string): number {
	return str ? stringToUTF8OnStack(str) : 0;
}

/**
 * [description]
 * @param i32s [description]
 * @return [description]
 */
export function i32sToStack(i32s: readonly number[]): number {
	const ret = stackAlloc(i32s.length << 2);
	HEAP32.set(i32s, ret >>> 2);
	return ret;
}

/**
 * [description]
 * @param i8s [description]
 * @return [description]
 */
export function i8sToStack(i8s: readonly number[]): number {
	const ret = stackAlloc(i8s.length);
	HEAP8.set(i8s, ret);
	return ret;
}
