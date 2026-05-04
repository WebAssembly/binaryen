import type {
	Module,
} from "../../classes/module/Module.ts";
import {
	control,
} from "./control.ts";
import {
	global,
} from "./global.ts";
import {
	local,
} from "./local.ts";
import {
	parametric,
} from "./parametric.ts";



/** Methods for building expressions in a WASM module. */
export function expressionBuilder(mod: Module) {
	return {
		...parametric(mod),
		...control(mod),
		local: local(mod),
		global: global(mod),
	} as const;
}



/** @useDeclaredType */
export type ExpressionBuilder = ReturnType<typeof expressionBuilder>;
