import {
	LocalGet,
	LocalSet,
} from "../../classes/expression/index.ts";
import type {
	Module,
} from "../../classes/module/Module.ts";



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#variable-instructions */
export function local(mod: Module) {
	return {
		/** @inheritDoc EXPR.LocalGet.localGet */
		get: LocalGet.localGet.bind(null, mod),
		/** @inheritDoc EXPR.LocalSet.localSet */
		set: LocalSet.localSet.bind(null, mod),
		/** @inheritDoc EXPR.LocalSet.localTee */
		tee: LocalSet.localTee.bind(null, mod),
	} as const;
}
