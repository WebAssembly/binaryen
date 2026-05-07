import type {
	Module,
} from "../../classes/module/Module.ts";
import {
	array,
	struct,
	tuple,
} from "./aggregate.ts";
import {
	blocks,
	breaks,
	calls,
	throws,
} from "./control.ts";
import {
	f32,
} from "./f32.ts";
import {
	f64,
} from "./f64.ts";
import {
	i32,
} from "./i32.ts";
import {
	i64,
} from "./i64.ts";
import {
	data,
	memory,
} from "./memory.ts";
import {
	parametric,
} from "./parametric.ts";
import {
	i31,
	ref,
} from "./reference.ts";
import {
	table,
} from "./table.ts";
import {
	v128,
} from "./v128.ts";
import {
	global,
	local,
} from "./variable.ts";



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
		...parametric(mod),
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
	} as const;
}



/**
 * An namespace of functions for building WASM expressions.
 * @see https://webassembly.github.io/spec/core/syntax/instructions.html
 * @useDeclaredType
 */
export type ExpressionBuilder = ReturnType<typeof expressionBuilder>;
