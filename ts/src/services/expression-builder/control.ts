import {
	consoleWarn,
} from "../../lib.ts";
import {
	Block,
	Break,
	Loop,
} from "../../classes/expression/index.ts";
import type {
	Module,
} from "../../classes/module/Module.ts";



/** Placeholder. */
const STUB = (..._args: readonly number[]): number => 0;



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#control-instructions */
export function control(mod: Module) {
	return {
		/** @inheritdoc EXPR.Block.block */
		block: Block.block.bind(null, mod),
		/** @inheritdoc EXPR.Loop.loop */
		loop: Loop.loop.bind(null, mod),
		if: STUB,
		/** @inheritdoc EXPR.Break.br */
		br: Break.br.bind(null, mod),
		/** @inheritdoc EXPR.Break.br_if */
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

		// @ts-expect-error
		/** @deprecated Use {@link ExpressionBuilder#br} instead. */ break(...args) { consoleWarn("`.break()` is deprecated; use `.br()` instead."); return this.br(...args); },
		// @ts-expect-error
		/** @deprecated Use {@link ExpressionBuilder#br_table} instead. */ switch(...args) { consoleWarn("`.switch()` is deprecated; use `.br_table()` instead."); return this.br_table(...args); },
		// @ts-expect-error
		/** @deprecated Use {@link ExpressionBuilder#call_indirect} instead. */ callIndirect(...args) { consoleWarn("`.callIndirect()` is deprecated; use `.call_indirect()` instead."); return this.call_indirect(...args); },
		// @ts-expect-error
		/** @deprecated Use {@link ExpressionBuilder#return_call} instead. */ returnCall(...args) { consoleWarn("`.returnCall()` is deprecated; use `.return_call()` instead."); return this.return_call(...args); },
		// @ts-expect-error
		/** @deprecated Use {@link ExpressionBuilder#return_call_indirect} instead. */ returnCallIndirect(...args) { consoleWarn("`.returnCallIndirect()` is deprecated; use `.return_call_indirect()` instead."); return this.return_call_indirect(...args); },
		// @ts-expect-error
		/** @deprecated Use {@link ExpressionBuilder#throw_ref} instead. */ rethrow(...args) { consoleWarn("`.rethrow()` is deprecated; use `.throw_ref()` instead."); return this.throw_ref(...args); },
		// @ts-expect-error
		/** @deprecated Use {@link ExpressionBuilder#try_table} instead. */ try(...args) { consoleWarn("`.try()` is deprecated; use `.try_table()` instead."); return this.try_table(...args); },
	} as const;
}
