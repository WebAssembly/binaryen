import {
	BinaryenObj,
	UTF8ToString,
} from "../../-pre.ts";
import {
	ExpressionId,
	type ExpressionRef,
} from "../../constants.ts";
import {
	THIS_PTR,
	getAllNested,
	preserveStack,
	setAllNested,
	strToStack,
} from "../../utils.ts";
import {
	Expression,
} from "./Expression.ts";



export class Block extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.Block, expr);
	}


	get name(): string | null {
		const name = BinaryenObj["_BinaryenBlockGetName"](this[THIS_PTR]);
		return name ? UTF8ToString(name) : null;
	}

	set name(name: string) {
		preserveStack(() => BinaryenObj["_BinaryenBlockSetName"](this[THIS_PTR], strToStack(name)));
	}

	get numChildren(): number {
		return BinaryenObj["_BinaryenBlockGetNumChildren"](this[THIS_PTR]);
	}

	get children() {
		return getAllNested(this[THIS_PTR], BinaryenObj["_BinaryenBlockGetNumChildren"], BinaryenObj["_BinaryenBlockGetChildAt"]);
	}

	set children(children: readonly ExpressionRef[]) {
		setAllNested(
			this[THIS_PTR],
			children,
			BinaryenObj["_BinaryenBlockGetNumChildren"],
			BinaryenObj["_BinaryenBlockSetChildAt"],
			BinaryenObj["_BinaryenBlockAppendChild"],
			BinaryenObj["_BinaryenBlockRemoveChildAt"],
		);
	}

	getChildAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenBlockGetChildAt"](this[THIS_PTR], index);
	}

	setChildAt(index: number, childExpr: ExpressionRef): void {
		BinaryenObj["_BinaryenBlockSetChildAt"](this[THIS_PTR], index, childExpr);
	}

	appendChild(childExpr: ExpressionRef): number {
		return BinaryenObj["_BinaryenBlockAppendChild"](this[THIS_PTR], childExpr);
	}

	insertChildAt(index: number, childExpr: ExpressionRef): void {
		BinaryenObj["_BinaryenBlockInsertChildAt"](this[THIS_PTR], index, childExpr);
	}

	removeChildAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenBlockRemoveChildAt"](this[THIS_PTR], index);
	}
}
