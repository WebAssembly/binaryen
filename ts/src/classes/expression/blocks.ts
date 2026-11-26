import {
	BinaryenObj,
	UTF8ToString,
} from "../../-pre.ts";
import {
	getAllNested,
	preserveStack,
	setAllNested,
	strToStack,
} from "../../-utils.ts";
import {
	ExpressionId,
	type ExpressionRef,
} from "../../constants.ts";
import {
	Expression,
} from "./Expression.ts";



export class Block extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.Block, expr);
	}

	get name(): string | null {
		const name = BinaryenObj["_BinaryenBlockGetName"](this._ptr);
		return name ? UTF8ToString(name) : null;
	}

	set name(name: string) {
		preserveStack(() => BinaryenObj["_BinaryenBlockSetName"](this._ptr, strToStack(name)));
	}

	get numChildren(): number {
		return BinaryenObj["_BinaryenBlockGetNumChildren"](this._ptr);
	}

	get children() {
		return getAllNested(this._ptr, BinaryenObj["_BinaryenBlockGetNumChildren"], BinaryenObj["_BinaryenBlockGetChildAt"]);
	}

	set children(children: readonly ExpressionRef[]) {
		setAllNested(
			this._ptr,
			children,
			BinaryenObj["_BinaryenBlockGetNumChildren"],
			BinaryenObj["_BinaryenBlockSetChildAt"],
			BinaryenObj["_BinaryenBlockAppendChild"],
			BinaryenObj["_BinaryenBlockRemoveChildAt"],
		);
	}

	getChildAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenBlockGetChildAt"](this._ptr, index);
	}

	setChildAt(index: number, childExpr: ExpressionRef): void {
		BinaryenObj["_BinaryenBlockSetChildAt"](this._ptr, index, childExpr);
	}

	appendChild(childExpr: ExpressionRef): number {
		return BinaryenObj["_BinaryenBlockAppendChild"](this._ptr, childExpr);
	}

	insertChildAt(index: number, childExpr: ExpressionRef): void {
		BinaryenObj["_BinaryenBlockInsertChildAt"](this._ptr, index, childExpr);
	}

	removeChildAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenBlockRemoveChildAt"](this._ptr, index);
	}
}



export class Loop extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.Loop, expr);
	}

	get name(): string | null {
		const name = BinaryenObj["_BinaryenLoopGetName"](this._ptr);
		return name ? UTF8ToString(name) : null;
	}

	set name(name: string) {
		preserveStack(() => BinaryenObj["_BinaryenLoopSetName"](this._ptr, strToStack(name)));
	}

	get body(): ExpressionRef { return BinaryenObj["_BinaryenLoopGetBody"](this._ptr); }
	set body(bodyExpr: ExpressionRef) { BinaryenObj["_BinaryenLoopSetBody"](this._ptr, bodyExpr); }
}



export class If extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.If, expr);
	}

	get condition(): ExpressionRef { return BinaryenObj["_BinaryenIfGetCondition"](this._ptr); }
	set condition(condExpr: ExpressionRef) { BinaryenObj["_BinaryenIfSetCondition"](condExpr); }

	get ifTrue(): ExpressionRef { return BinaryenObj["_BinaryenIfGetIfTrue"](this._ptr); }
	set ifTrue(ifTrueExpr: ExpressionRef) { BinaryenObj["_BinaryenIfSetIfTrue"](this._ptr, ifTrueExpr); }

	get ifFalse(): ExpressionRef { return BinaryenObj["_BinaryenIfGetIfFalse"](this._ptr); }
	set ifFalse(ifFalseExpr: ExpressionRef) { BinaryenObj["_BinaryenIfSetIfFalse"](this._ptr, ifFalseExpr); }
}
