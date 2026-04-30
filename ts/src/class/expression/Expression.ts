import {
	BinaryenObj,
} from "../../-pre.ts";
import type {
	ExpressionId,
	ExpressionRef,
	Type,
} from "../../constants.ts";
import {
	emitText,
} from "../../global.ts";
import {
	replacedBy,
} from "../../lib.ts";
import {
	THIS_PTR,
} from "../../utils.ts";



/** Expression ID-to-wrapper map. */
export const EXPR_WRAPPERS = new Map<ExpressionId, Expression>();



/** Base class of all expression wrappers. */
export class Expression {
	/* eslint-disable @stylistic/brace-style */
	@replacedBy("`instance.getId`") static getId(expr: ExpressionRef) { return Expression.prototype.getId.call({[THIS_PTR]: expr}); }
	@replacedBy("`instance.getType`") static getType(expr: ExpressionRef) { return Expression.prototype.getType.call({[THIS_PTR]: expr}); }
	@replacedBy("`instance.setType`") static setType(expr: ExpressionRef, typ: Type) { return Expression.prototype.setType.call({[THIS_PTR]: expr}, typ); }
	@replacedBy("`instance.finalize`") static finalize(expr: ExpressionRef) { return Expression.prototype.finalize.call({[THIS_PTR]: expr}); }
	@replacedBy("`instance.toText`") static toText(expr: ExpressionRef): string { return Expression.prototype.toText.call({[THIS_PTR]: expr}); }
	/* eslint-enable @stylistic/brace-style */


	protected readonly [THIS_PTR]: number;

	constructor(exprId: ExpressionId, expr: ExpressionRef) {
		this[THIS_PTR] = expr;
		EXPR_WRAPPERS.set(exprId, this);
	}

	valueOf() {
		return this[THIS_PTR];
	}

	// TODO: post.js has converted all methods starting with `get` to getters and `set` to setters
	getId(): ExpressionId {
		return BinaryenObj["_BinaryenExpressionGetId"](this[THIS_PTR]);
	}

	getType(): Type {
		return BinaryenObj["_BinaryenExpressionGetType"](this[THIS_PTR]);
	}

	setType(typ: Type): void {
		BinaryenObj["_BinaryenExpressionSetType"](this[THIS_PTR], typ);
	}

	finalize(): void {
		BinaryenObj["_BinaryenExpressionFinalize"](this[THIS_PTR]);
	}

	toText(): string {
		return emitText(this[THIS_PTR]);
	}
}
