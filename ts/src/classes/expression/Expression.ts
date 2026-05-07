import {
	BinaryenObj,
} from "../../-pre.ts";
import {
	THIS_PTR,
} from "../../-utils.ts";
import type {
	ExpressionId,
	ExpressionRef,
	Type,
} from "../../constants.ts";
import {
	emitText,
	getExpressionType,
} from "../../globals.ts";



export class Expression {
	protected readonly [THIS_PTR]: ExpressionRef;

	/** Not really an “ID”, just the “kind” of expression. */
	readonly #id: ExpressionId;

	/**
	 * Construct a new Expression object given an ID and reference.
	 *
	 * Without an ID, you can still call {@link getExpressionInfo | `getExpressionInfo(expr)`},
	 * which will compute the ID and construct an Expression object from there.
	 * @param exprId the expression “kind” id
	 * @param expr the expression reference
	 */
	constructor(exprId: ExpressionId, expr: ExpressionRef) {
		this[THIS_PTR] = expr;
		this.#id = exprId;
	}

	get id(): ExpressionId {
		return this.#id;
	}

	get type(): Type {
		return getExpressionType(this[THIS_PTR]);
	}

	set type(typ: Type) {
		BinaryenObj["_BinaryenExpressionSetType"](this[THIS_PTR], typ);
	}

	valueOf(): ExpressionRef {
		return this[THIS_PTR];
	}

	finalize(): void {
		BinaryenObj["_BinaryenExpressionFinalize"](this[THIS_PTR]);
	}

	toText(): string {
		return emitText(this[THIS_PTR]);
	}
}
