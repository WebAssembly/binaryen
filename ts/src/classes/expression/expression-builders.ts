import {
	BinaryenObj,
} from "../../-pre";
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
		/** @inheritDoc X.Drop.drop */
		drop: Drop.drop.bind(null, mod),
		/** @inheritDoc X.Select.select */
		select: Select.select.bind(null, mod),
	} as const;
}
/** @useDeclaredType */
export type ExpressionBuilderParametric = ReturnType<typeof parametric>;



function control(mod: Module) {
	return {
		/** @inheritdoc X.Block.block */
		block: Block.block.bind(null, mod),
		/** @inheritdoc X.Loop.loop */
		loop: Loop.loop.bind(null, mod),
		/** @inheritdoc X.Break.br */
		br: Break.br.bind(null, mod),
		/** @inheritdoc X.Break.br_if */
		br_if: Break.br_if.bind(null, mod),
	} as const;
}
/** @useDeclaredType */
export type ExpressionBuilderControl = ReturnType<typeof control>;



function variable(mod: Module) {
	return {
		local: {
			/** @inheritDoc X.LocalGet.localGet */
			get: LocalGet.localGet.bind(null, mod),
			/** @inheritDoc X.LocalSet.localSet */
			set: LocalSet.localSet.bind(null, mod),
			/** @inheritDoc X.LocalSet.localTee */
			tee: LocalSet.localTee.bind(null, mod),
		},
	} as const;
}
/** @useDeclaredType */
export type ExpressionBuilderVariable = ReturnType<typeof variable>;



/**
 * @expandType ExpressionBuilderParametric
 * @expandType ExpressionBuilderControl
 * @expandType ExpressionBuilderVariable
 */
export type ExpressionBuilder = (
	& ExpressionBuilderParametric
	& ExpressionBuilderControl
	& ExpressionBuilderVariable
);
/** Methods for creating expressions in a WASM module. */
export function expressionBuilder(mod: Module): ExpressionBuilder {
	return {
		...parametric(mod),
		...control(mod),
		...variable(mod),
	} as const;
}
