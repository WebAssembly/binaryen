/* eslint-disable @stylistic/object-curly-newline */
import {
	BinaryenObj,
} from "../../-pre.ts";
import {
	PTR,
} from "../../-utils.ts";
import type {
	Module,
} from "../../classes/module/Module.ts";
import {
	array,
	struct,
	tuple,
} from "./aggregate.ts";
import {f32} from "./f32.ts";
import {f32x4} from "./f32x4.ts";
import {f64} from "./f64.ts";
import {f64x2} from "./f64x2.ts";
import {
	blocks,
	breaks,
	calls,
	parametrics,
	throws,
} from "./generic.ts";
import {i8x16} from "./i8x16.ts";
import {i16x8} from "./i16x8.ts";
import {i32} from "./i32.ts";
import {i32x4} from "./i32x4.ts";
import {i64} from "./i64.ts";
import {i64x2} from "./i64x2.ts";
import {
	data,
	memory,
} from "./memory.ts";
import {
	i31,
	ref,
} from "./reference.ts";
import {
	table,
} from "./table.ts";
import {v128} from "./v128.ts";
import {
	global,
	local,
} from "./variable.ts";
/* eslint-enable @stylistic/object-curly-newline */



/** Methods for building expressions in a WASM module. */
export function expressionBuilder(mod: Module) {
	/*
	 * Each property of this returned object should be either:
	 *
	 * - a spread function call (`...parametric(mod)`), which “splats” its properties into the top level, or
	 * - a property with a function call value (`local: local(mod)`), which sets the object to a property for nesting, or
	 * - a property set to a singleton object (`elem: {drop: () => {...}}`).
	 *
	 * To keep things clean and concise, stick with the above convention.
	 * If any object literal has more than one property, move it out into a separate function.
	 */
	return {
		...parametrics(mod),
		...blocks(mod),
		...breaks(mod),
		...calls(mod),
		...throws(mod),
		local: local(mod),
		global: global(mod),
		table: table(mod),
		// TODO: elem.drop
		memory: memory(mod),
		data: data(mod),
		ref: ref(mod),
		i31: i31(mod),
		// TODO: extern.convert_any
		// TODO: any.convert_extern
		tuple: tuple(mod),
		struct: struct(mod),
		array: array(mod),
		i32: i32(mod),
		i64: i64(mod),
		f32: f32(mod),
		f64: f64(mod),
		v128: v128(mod),
		i8x16: i8x16(mod),
		i16x8: i16x8(mod),
		i32x4: i32x4(mod),
		i64x2: i64x2(mod),
		f32x4: f32x4(mod),
		f64x2: f64x2(mod),
		atomic: {fence: () => BinaryenObj["_BinaryenAtomicFence"](mod[PTR])},
	} as const;
}



/**
 * An namespace of functions for building WASM expressions.
 * @see https://webassembly.github.io/spec/core/syntax/instructions.html
 * @useDeclaredType
 */
export type ExpressionBuilder = ReturnType<typeof expressionBuilder>;
