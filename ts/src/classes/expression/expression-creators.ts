import {
	BinaryenObj,
} from "../../-pre.ts";
import type {
	ExpressionRef,
} from "../../constants.ts";
import type {
	Module,
} from "../module/Module.ts";
import {
	Block,
	Break,
	Drop,
	LocalGet,
	LocalSet,
	Loop,
	Select,
} from "./index.ts";



function parametric(mod: Module) {
	return {
		/** Creates a no-operation `(nop)` instruction. */
		nop: (): ExpressionRef => BinaryenObj["_BinaryenNop"](mod.ptr),
		/** Creates an unreachable instruction that will always trap. */
		unreachable: (): ExpressionRef => BinaryenObj["_BinaryenUnreachable"](mod.ptr),
		/** Creates a `(drop)` of a value. */
		drop: Drop.drop.bind(null, mod),
		/** Creates a `(select)` of one of two values. */
		select: Select.select.bind(null, mod),
	} as const;
}



function control(mod: Module) {
	return {
		/** Creates a `(block)`. */
		block: Block.block.bind(null, mod),
		/** Creates a loop. */
		loop: Loop.loop.bind(null, mod),
		/** Creates an unconditional branch `(br)` to a label. */
		br: Break.br.bind(null, mod),
		/** Creates a conditional branch `(br_if)` to a label. */
		br_if: Break.br_if.bind(null, mod),
	} as const;
}



function variable(mod: Module) {
	return {
		local: {
			/**
			 * Creates a `(local.get)` for the local at the specified index.
			 * Note that we must specify the type here as we may not have created the local being accessed yet.
			 */
			get: LocalGet.localGet.bind(null, mod),
			/** Creates a `(local.set)` for the local at the specified index. */
			set: LocalSet.localSet.bind(null, mod),
			/**
			 * Creates a `(local.tee)` for the local at the specified index.
			 * Note that we must specify the type here as we may not have created the local being accessed yet.
			 */
			tee: LocalSet.localTee.bind(null, mod),
		},
	} as const;
}



/** Methods for creating expressions in a WASM module. */
export function expressionCreator(mod: Module) {
	return {
		...parametric(mod),
		...control(mod),
		...variable(mod),
	} as const;
}
