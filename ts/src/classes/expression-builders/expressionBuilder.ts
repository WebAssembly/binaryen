import type {
	Module,
} from "../../classes/module/Module.ts";
import {
	type ExpressionBuilderControl,
	control,
} from "./control.ts";
import {
	type ExpressionBuilderGlobal,
	global,
} from "./global.ts";
import {
	type ExpressionBuilderLocal,
	local,
} from "./local.ts";
import {
	type ExpressionBuilderParametric,
	parametric,
} from "./parametric.ts";



/**
 * @expandType ExpressionBuilderParametric
 * @expandType ExpressionBuilderControl
 * @expandType ExpressionBuilderLocal
 * @expandType ExpressionBuilderGlobal
 */
export type ExpressionBuilder = (
	& ExpressionBuilderParametric
	& ExpressionBuilderControl
	& {
		local: ExpressionBuilderLocal,
		global: ExpressionBuilderGlobal,
	}
);



/** Methods for building expressions in a WASM module. */
export function expressionBuilder(mod: Module) {
	return {
		...parametric(mod),
		...control(mod),
		local: local(mod),
		global: global(mod),
	} as const;
}
