import * as expressions from "../../classes/expression/index.ts";
import type {
	Module,
} from "../../classes/module/Module.ts";



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#variable-instructions */
export function local(mod: Module) {
	return {
		/** @inheritDoc expressions.LocalGet.localGet */
		get: expressions.LocalGet.localGet.bind(null, mod),
		/** @inheritDoc expressions.LocalSet.localSet */
		set: expressions.LocalSet.localSet.bind(null, mod),
		/** @inheritDoc expressions.LocalSet.localTee */
		tee: expressions.LocalSet.localTee.bind(null, mod),
	} as const;
}
