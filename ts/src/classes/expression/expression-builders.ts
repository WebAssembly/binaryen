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



/** Placeholder. */
const STUB = (..._args: readonly number[]): number => 0;



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
		if: STUB,
		/** @inheritdoc X.Break.br */
		br: Break.br.bind(null, mod),
		/** @inheritdoc X.Break.br_if */
		br_if: Break.br_if.bind(null, mod),
		br_table: STUB,
		br_on_null: STUB,
		br_on_non_null: STUB,
		br_on_cast: STUB,
		br_on_cast_fail: STUB,
		call: STUB,
		call_ref: STUB,
		call_indirect: STUB,
		return: STUB,
		return_call: STUB,
		return_call_ref: STUB,
		return_call_indirect: STUB,
		throw: STUB,
		throw_ref: STUB,
		try_table: STUB,
		// TODO: catch
		// TODO: catch_ref
		// TODO: catch_all
		// TODO: catch_all_ref

		/** @deprecated Use {@link ExpressionBuilderControl#br} instead. */
		// @ts-expect-error
		break(...args) { return this.br(...args); },
		/** @deprecated Use {@link ExpressionBuilderControl#br_table} instead. */
		// @ts-expect-error
		switch(...args) { return this.br_table(...args); },
		/** @deprecated Use {@link ExpressionBuilderControl#call_indirect} instead. */
		// @ts-expect-error
		callIndirect(...args) { return this.call_indirect(...args); },
		/** @deprecated Use {@link ExpressionBuilderControl#return_call} instead. */
		// @ts-expect-error
		returnCall(...args) { return this.return_call(...args); },
		/** @deprecated Use {@link ExpressionBuilderControl#return_call_indirect} instead. */
		// @ts-expect-error
		returnCallIndirect(...args) { return this.return_call_indirect(...args); },
		/** @deprecated Use {@link ExpressionBuilderControl#throw_ref} instead. */
		// @ts-expect-error
		rethrow(...args) { return this.throw_ref(...args); },
		/** @deprecated Use {@link ExpressionBuilderControl#try_table} instead. */
		// @ts-expect-error
		try(...args) { return this.try_table(...args); },
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
		global: {
			get: STUB,
			set: STUB,
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
