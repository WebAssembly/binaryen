import type {
	Module,
} from "../../classes/module/Module.ts";
import {
	LocalGet,
	LocalSet,
} from "../../classes/expression/index.ts";



export function local(mod: Module) {
	return {
		/** @inheritDoc X.LocalGet.localGet */
		get: LocalGet.localGet.bind(null, mod),
		/** @inheritDoc X.LocalSet.localSet */
		set: LocalSet.localSet.bind(null, mod),
		/** @inheritDoc X.LocalSet.localTee */
		tee: LocalSet.localTee.bind(null, mod),
	} as const;
}



/** @useDeclaredType */
export type ExpressionBuilderLocal = ReturnType<typeof local>;
