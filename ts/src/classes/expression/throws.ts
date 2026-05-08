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



export class Throw extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.Throw, expr);
	}

	get tag(): string { return UTF8ToString(BinaryenObj["_BinaryenThrowGetTag"](this._ptr)); }
	set tag(tagName: string) { preserveStack(() => BinaryenObj["_BinaryenThrowSetTag"](this._ptr, strToStack(tagName))); }

	getNumOperands(): number { return BinaryenObj["_BinaryenThrowGetNumOperands"](this._ptr); }

	get operands(): ExpressionRef[] {
		return getAllNested(
			this._ptr,
			BinaryenObj["_BinaryenThrowGetNumOperands"],
			BinaryenObj["_BinaryenThrowGetOperandAt"],
		);
	}

	set operands(operands: readonly ExpressionRef[]) {
		setAllNested(
			this._ptr,
			operands,
			BinaryenObj["_BinaryenThrowGetNumOperands"],
			BinaryenObj["_BinaryenThrowSetOperandAt"],
			BinaryenObj["_BinaryenThrowAppendOperand"],
			BinaryenObj["_BinaryenThrowRemoveOperandAt"],
		);
	}


	getOperandAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenThrowGetOperandAt"](this._ptr, index);
	}

	setOperandAt(index: number, operandExpr: ExpressionRef): void {
		BinaryenObj["_BinaryenThrowSetOperandAt"](this._ptr, index, operandExpr);
	}

	appendOperand(operandExpr: ExpressionRef): number {
		return BinaryenObj["_BinaryenThrowAppendOperand"](this._ptr, operandExpr);
	}

	insertOperandAt(index: number, operandExpr: ExpressionRef): void {
		BinaryenObj["_BinaryenThrowInsertOperandAt"](this._ptr, index, operandExpr);
	}

	removeOperandAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenThrowRemoveOperandAt"](this._ptr, index);
	}
}



export class Rethrow extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.Rethrow, expr);
	}

	get target(): string | null {
		const target = BinaryenObj["_BinaryenRethrowGetTarget"](this._ptr);
		return target ? UTF8ToString(target) : null;
	}

	set target(target: string) {
		preserveStack(() => BinaryenObj["_BinaryenRethrowSetTarget"](this._ptr, strToStack(target)));
	}
}



export class Try extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.Try, expr);
	}

	get body(): ExpressionRef { return BinaryenObj["_BinaryenTryGetBody"](this._ptr); }
	set body(bodyExpr: ExpressionRef) { BinaryenObj["_BinaryenTrySetBody"](this._ptr, bodyExpr); }

	get numCatchTags(): number { return BinaryenObj["_BinaryenTryGetNumCatchTags"](this._ptr); }

	get numCatchBodies(): number { return BinaryenObj["_BinaryenTryGetNumCatchBodies"](this._ptr); }

	get delegate(): boolean { return Boolean(BinaryenObj["_BinaryenTryIsDelegate"](this._ptr)); }

	get name(): string | null {
		const name = BinaryenObj["_BinaryenTryGetName"](this._ptr);
		return name ? UTF8ToString(name) : null;
	}

	set name(name: string) {
		preserveStack(() => BinaryenObj["_BinaryenTrySetName"](this._ptr, strToStack(name)));
	}

	get catchTags(): string[] {
		return getAllNested(
			this._ptr,
			BinaryenObj["_BinaryenTryGetNumCatchTags"],
			BinaryenObj["_BinaryenTryGetCatchTagAt"],
		).map((p) => UTF8ToString(p));
	}

	set catchTags(catchTags: readonly string[]) {
		preserveStack(() => setAllNested(
			this._ptr,
			catchTags.map(strToStack),
			BinaryenObj["_BinaryenTryGetNumCatchTags"],
			BinaryenObj["_BinaryenTrySetCatchTagAt"],
			BinaryenObj["_BinaryenTryAppendCatchTag"],
			BinaryenObj["_BinaryenTryRemoveCatchTagAt"],
		));
	}

	get catchBodies(): ExpressionRef[] {
		return getAllNested(
			this._ptr,
			BinaryenObj["_BinaryenTryGetNumCatchBodies"],
			BinaryenObj["_BinaryenTryGetCatchBodyAt"],
		);
	}

	set catchBodies(catchBodies: readonly ExpressionRef[]) {
		setAllNested(
			this._ptr,
			catchBodies,
			BinaryenObj["_BinaryenTryGetNumCatchBodies"],
			BinaryenObj["_BinaryenTrySetCatchBodyAt"],
			BinaryenObj["_BinaryenTryAppendCatchBody"],
			BinaryenObj["_BinaryenTryRemoveCatchBodyAt"],
		);
	}

	get delegateTarget(): string | null {
		const name = BinaryenObj["_BinaryenTryGetDelegateTarget"](this._ptr);
		return name ? UTF8ToString(name) : null;
	}

	set delegateTarget(name: string) {
		preserveStack(() => BinaryenObj["_BinaryenTrySetDelegateTarget"](this._ptr, strToStack(name)));
	}

	getCatchTagAt(index: number): string {
		return UTF8ToString(BinaryenObj["_BinaryenTryGetCatchTagAt"](this._ptr, index));
	}

	setCatchTagAt(index: number, catchTag: string): void {
		preserveStack(() => BinaryenObj["_BinaryenTrySetCatchTagAt"](this._ptr, index, strToStack(catchTag)));
	}

	appendCatchTag(catchTag: string): void {
		preserveStack(() => BinaryenObj["_BinaryenTryAppendCatchTag"](this._ptr, strToStack(catchTag)));
	}

	insertCatchTagAt(index: number, catchTag: string): void {
		preserveStack(() => BinaryenObj["_BinaryenTryInsertCatchTagAt"](this._ptr, index, strToStack(catchTag)));
	}

	removeCatchTagAt(index: number): string {
		return UTF8ToString(BinaryenObj["_BinaryenTryRemoveCatchTagAt"](this._ptr, index));
	}

	getCatchBodyAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenTryGetCatchBodyAt"](this._ptr, index);
	}

	setCatchBodyAt(index: number, catchExpr: ExpressionRef): void {
		BinaryenObj["_BinaryenTrySetCatchBodyAt"](this._ptr, index, catchExpr);
	}

	appendCatchBody(catchExpr: ExpressionRef): number {
		return BinaryenObj["_BinaryenTryAppendCatchBody"](this._ptr, catchExpr);
	}

	insertCatchBodyAt(index: number, catchExpr: ExpressionRef): void {
		BinaryenObj["_BinaryenTryInsertCatchBodyAt"](this._ptr, index, catchExpr);
	}

	removeCatchBodyAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenTryRemoveCatchBodyAt"](this._ptr, index);
	}

	hasCatchAll(): boolean {
		return Boolean(BinaryenObj["_BinaryenTryHasCatchAll"](this._ptr));
	}
}
