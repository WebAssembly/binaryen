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
	getExpressionType,
} from "../../globals.ts";



export class Expression {
	/** The underlying C-API pointer of the wrapped expression. */
	protected readonly _ptr: ExpressionRef;

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
		this._ptr = expr;
		this.#id = exprId;
	}

	get id(): ExpressionId {
		return this.#id;
	}

	get type(): Type {
		return getExpressionType(this._ptr);
	}

	set type(typ: Type) {
		BinaryenObj["_BinaryenExpressionSetType"](this._ptr, typ);
	}

	valueOf(): ExpressionRef {
		return this._ptr;
	}

	finalize(): void {
		BinaryenObj["_BinaryenExpressionFinalize"](this._ptr);
	}

	toText(): string {
		return emitText(this._ptr);
	}
}
