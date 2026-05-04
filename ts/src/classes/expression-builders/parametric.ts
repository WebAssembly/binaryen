import {
	BinaryenObj,
} from "../../-pre.ts";
import type {
	Module,
} from "../../classes/module/Module.ts";
import {
	Drop,
	Select,
} from "../../classes/expression/index.ts";
import type {
	ExpressionRef,
} from "../../constants.ts";



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#parametric-instructions */
export function parametric(mod: Module) {
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
