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



function extractParam<First, Rest extends unknown[], Return>(a: First, fn: (a: First, ...rest: Rest) => Return): (...rest: Rest) => Return {
	return (...args) => fn(a, ...args);
}



function parametric(mod: Module) {
	return {
		/** Creates a no-operation `(nop)` instruction. */
		nop: (): ExpressionRef => BinaryenObj["_BinaryenNop"](mod.ptr),
		/** Creates an unreachable instruction that will always trap. */
		unreachable: (): ExpressionRef => BinaryenObj["_BinaryenUnreachable"](mod.ptr),
		/** Creates a `(drop)` of a value. */
		drop: extractParam(mod, Drop.drop),
		/** Creates a `(select)` of one of two values. */
		select: extractParam(mod, Select.select),
	} as const;
}



function control(mod: Module) {
	return {
		/** Creates a `(block)`. */
		block: extractParam(mod, Block.block),
		/** Creates a loop. */
		loop: extractParam(mod, Loop.loop),
		/** Creates an unconditional branch `(br)` to a label. */
		br: extractParam(mod, Break.br),
		/** Creates a conditional branch `(br_if)` to a label. */
		br_if: extractParam(mod, Break.br_if),
	} as const;
}



function variables(mod: Module) {
	return {
		local: {
			/**
			 * Creates a `(local.get)` for the local at the specified index.
			 * Note that we must specify the type here as we may not have created the local being accessed yet.
			 */
			get: extractParam(mod, LocalGet.localGet),
			/** Creates a `(local.set)` for the local at the specified index. */
			set: extractParam(mod, LocalSet.localSet),
			/**
			 * Creates a `(local.tee)` for the local at the specified index.
			 * Note that we must specify the type here as we may not have created the local being accessed yet.
			 */
			tee: extractParam(mod, LocalSet.localTee),
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
