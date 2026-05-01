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
import {
	THIS_PTR,
} from "../../utils.ts";



/** Base class of all expression wrappers. */
export class Expression {
	protected readonly [THIS_PTR]: ExpressionRef;

	/** Not really an “ID”, just the “kind” of expression. */
	readonly #id: ExpressionId;

	/**
	 * Construct a new Expression object given an ID and reference.
	 *
	 * Without an ID, you can still call `binaryen.getExpressionInfo(expr)`,
	 * which will compute the ID and construct an Expression object from there.
	 * @param exprId the expression “kind” id
	 * @param expr the expression reference
	 */
	constructor(exprId: ExpressionId, expr: ExpressionRef) {
		this[THIS_PTR] = expr;
		this.#id = exprId;
	}

	valueOf(): ExpressionRef {
		return this[THIS_PTR];
	}

	// FIXME: post.js has converted all methods starting with `get` to getters and `set` to setters
	getId(): ExpressionId {
		return this.#id;
	}

	getType(): Type {
		return getExpressionType(this[THIS_PTR]);
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
