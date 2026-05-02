import {
	BinaryenObj,
} from "../../-pre.ts";
import type {
	Module,
} from "../module/Module.ts";
import {
	Block,
	Drop,
	LocalGet,
	LocalSet,
	Select,
} from "./index.ts";



function parametric(mod: Module) {
	return {
		/** Creates a no-operation `(nop)` instruction. */
		nop: () => BinaryenObj["_BinaryenNop"](mod.ptr),
		/** Creates an unreachable instruction that will always trap. */
		unreachable: () => BinaryenObj["_BinaryenUnreachable"](mod.ptr),
		/** Creates a `(drop)` of a value. */
		drop: Drop.drop.bind(mod),
		/** Creates a `(select)` of one of two values. */
		select: Select.select.bind(mod),
	} as const;
}



function control(mod: Module) {
	return {
		/** Creates a `(block)`. */
		block: Block.block.bind(mod),
	} as const;
}



function variables(mod: Module) {
	return {
		local: {
			/**
			 * Creates a `(local.get)` for the local at the specified index.
			 * Note that we must specify the type here as we may not have created the local being accessed yet.
			 */
			get: LocalGet.localGet.bind(mod),
			/** Creates a `(local.set)` for the local at the specified index. */
			set: LocalSet.localSet.bind(mod),
			/**
			 * Creates a `(local.tee)` for the local at the specified index.
			 * Note that we must specify the type here as we may not have created the local being accessed yet.
			 */
			tee: LocalSet.localTee.bind(mod),
		},
	} as const;
}



/** Methods for creating expressions in a WASM module. */
export function expressionCreator(mod: Module) {
	return {
		...parametric(mod),
		...control(mod),
		...variables(mod),
	} as const;
}
