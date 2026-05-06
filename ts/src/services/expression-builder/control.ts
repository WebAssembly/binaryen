import {
	consoleWarn,
} from "../../lib.ts";
import * as expressions from "../../classes/expression/index.ts";
import type {
	Module,
} from "../../classes/module/Module.ts";



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#control-instructions */
export function control(mod: Module) {
	return {
		/** @inheritDoc expressions.Block.block */
		block: expressions.Block.block.bind(null, mod),
		/** @inheritDoc expressions.Loop.loop */
		loop: expressions.Loop.loop.bind(null, mod),
		/** @inheritDoc expressions.If.if */
		if: expressions.If.if.bind(null, mod),
		/** @inheritDoc expressions.Break.br */
		br: expressions.Break.br.bind(null, mod),
		/** @inheritDoc expressions.Break.br_if */
		br_if: expressions.Break.br_if.bind(null, mod),
		/** @inheritDoc expressions.Switch.brTable */
		br_table: expressions.Switch.brTable.bind(null, mod),
		/** @inheritDoc expressions.BrOn.brOnNull */
		br_on_null: expressions.BrOn.brOnNull.bind(null, mod),
		/** @inheritDoc expressions.BrOn.brOnNonNull */
		br_on_non_null: expressions.BrOn.brOnNonNull.bind(null, mod),
		/** @inheritDoc expressions.BrOn.brOnCast */
		br_on_cast: expressions.BrOn.brOnCast.bind(null, mod),
		/** @inheritDoc expressions.BrOn.brOnCastFail */
		br_on_cast_fail: expressions.BrOn.brOnCastFail.bind(null, mod),
		/** @inheritDoc expressions.Call.call */
		call: expressions.Call.call.bind(null, mod),
		/** @inheritDoc expressions.CallRef.callRef */
		call_ref: expressions.CallRef.callRef.bind(null, mod),
		/** @inheritDoc expressions.CallIndirect.callIndirect */
		call_indirect: expressions.CallIndirect.callIndirect.bind(null, mod),
		/** @inheritDoc expressions.Return.return */
		return: expressions.Return.return.bind(null, mod),
		/** @inheritDoc expressions.Return.returnCall */
		return_call: expressions.Return.returnCall.bind(null, mod),
		/** @inheritDoc expressions.Return.returnCallRef */
		return_call_ref: expressions.Return.returnCallRef.bind(null, mod),
		/** @inheritDoc expressions.Return.returnCallIndirect */
		return_call_indirect: expressions.Return.returnCallIndirect.bind(null, mod),
		/** @inheritDoc expressions.Throw.throw */
		throw: expressions.Throw.throw.bind(null, mod),
		/** @inheritDoc expressions.Rethrow.throwRef */
		throw_ref: expressions.Rethrow.throwRef.bind(null, mod),
		/** @inheritDoc expressions.Try.tryTable */
		try_table: expressions.Try.tryTable.bind(null, mod),
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
