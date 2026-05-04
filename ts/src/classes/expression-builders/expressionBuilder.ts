import type {
	Module,
} from "../../classes/module/Module.ts";
import {
	array,
} from "./array.ts";
import {
	control,
} from "./control.ts";
import {
	f32,
} from "./f32.ts";
import {
	f64,
} from "./f64.ts";
import {
	global,
} from "./global.ts";
import {
	i31,
} from "./i31.ts";
import {
	i32,
} from "./i32.ts";
import {
	i64,
} from "./i64.ts";
import {
	local,
} from "./local.ts";
import {
	memory,
} from "./memory.ts";
import {
	parametric,
} from "./parametric.ts";
import {
	ref,
} from "./ref.ts";
import {
	struct,
} from "./struct.ts";
import {
	table,
} from "./table.ts";
import {
	tuple,
} from "./tuple.ts";



/** Placeholder. */
const STUB = (..._args: readonly number[]): number => 0;






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
		...control(mod),
		local: local(mod),
		global: global(mod),
		table: table(mod),
		elem: {drop: STUB},
		memory: memory(mod),
		data: {drop: STUB},
		ref: ref(mod),
		struct: struct(mod),
		array: array(mod),
		i31: i31(mod),
		// TODO: extern
		// TODO: any
		i32: i32(mod),
		i64: i64(mod),
		f32: f32(mod),
		f64: f64(mod),
		tuple: tuple(mod),
	} as const;
}



/** @useDeclaredType */
export type ExpressionBuilder = ReturnType<typeof expressionBuilder>;
