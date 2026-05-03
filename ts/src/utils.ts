// # Utilities # //
// Functions and constants used internally. These are not exported publicly.



import {
	BinaryenObj,
	stackAlloc,
	stackRestore,
	stackSave,
	stringToUTF8OnStack,
} from "./-pre.ts";



export const HEAP8: Int8Array = BinaryenObj["HEAP8"] as any;
export const HEAPU8: Uint8Array = BinaryenObj["HEAPU8"] as any;
export const HEAP32: Int32Array = BinaryenObj["HEAP32"] as any;
export const HEAPU32: Uint32Array = BinaryenObj["HEAPU32"] as any;



/** Private symbol used to store the underlying C-API pointer of a wrapped object. */
export const THIS_PTR: unique symbol = Symbol();



/**
 * Exports friendly API methods.
 * @param func [description]
 * @returns [description]
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
 * @returns [description]
 */
export function strToStack(str?: string): number {
	return str ? stringToUTF8OnStack(str) : 0;
}

/**
 * [description]
 * @param i32s [description]
 * @returns [description]
 */
export function i32sToStack(i32s: readonly number[]): number {
	const ret = stackAlloc(i32s.length << 2);
	HEAP32.set(i32s, ret >>> 2);
	return ret;
}

/**
 * [description]
 * @param i8s [description]
 * @returns [description]
 */
export function i8sToStack(i8s: readonly number[]): number {
	const ret = stackAlloc(i8s.length);
	HEAP8.set(i8s, ret);
	return ret;
}



/**
 * [description]
 * @param ref [description]
 * @param numFn [description]
 * @param getFn [description]
 * @returns [description]
 */
export function getAllNested<T, U>(
	ref: T,
	numFn: (ref: T) => number,
	getFn: (ref: T, i: number) => U,
): U[] {
	const num = numFn.call(undefined, ref);
	const ret: U[] = [];
	for (let i = 0; i < num; ++i) {
		ret[i] = getFn.call(undefined, ref, i);
	}
	return ret;
}

/**
 * [description]
 * @param ref [description]
 * @param values [description]
 * @param numFn [description]
 * @param setFn [description]
 * @param appendFn [description]
 * @param removeFn [description]
 */
export function setAllNested<T, U>(
	ref: T,
	values: readonly U[],
	numFn: (ref: T) => number,
	setFn: (ref: T, i: number, val: U) => void,
	appendFn: (ef: T, val: U) => void,
	removeFn: (ef: T, num: number) => void,
): void {
	const num = values.length;
	let prevNum = numFn(ref);
	let index = 0;
	while (index < num) {
		if (index < prevNum) {
			setFn(ref, index, values[index]);
		} else {
			appendFn(ref, values[index]);
		}
		++index;
	}
	while (prevNum > index) {
		removeFn(ref, --prevNum);
	}
}
