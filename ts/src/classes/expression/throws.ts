import {
	BinaryenObj,
	UTF8ToString,
} from "../../-pre.ts";
import {
	THIS_PTR,
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

	get tag(): string { return UTF8ToString(BinaryenObj["_BinaryenThrowGetTag"](this[THIS_PTR])); }
	set tag(tagName: string) { preserveStack(() => BinaryenObj["_BinaryenThrowSetTag"](this[THIS_PTR], strToStack(tagName))); }

	getNumOperands(): number { return BinaryenObj["_BinaryenThrowGetNumOperands"](this[THIS_PTR]); }

	get operands(): ExpressionRef[] {
		return getAllNested(
			this[THIS_PTR],
			BinaryenObj["_BinaryenThrowGetNumOperands"],
			BinaryenObj["_BinaryenThrowGetOperandAt"],
		);
	}

	set operands(operands: readonly ExpressionRef[]) {
		setAllNested(
			this[THIS_PTR],
			operands,
			BinaryenObj["_BinaryenThrowGetNumOperands"],
			BinaryenObj["_BinaryenThrowSetOperandAt"],
			BinaryenObj["_BinaryenThrowAppendOperand"],
			BinaryenObj["_BinaryenThrowRemoveOperandAt"],
		);
	}


	getOperandAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenThrowGetOperandAt"](this[THIS_PTR], index);
	}

	setOperandAt(index: number, operandExpr: ExpressionRef): void {
		BinaryenObj["_BinaryenThrowSetOperandAt"](this[THIS_PTR], index, operandExpr);
	}

	appendOperand(operandExpr: ExpressionRef): number {
		return BinaryenObj["_BinaryenThrowAppendOperand"](this[THIS_PTR], operandExpr);
	}

	insertOperandAt(index: number, operandExpr: ExpressionRef): void {
		BinaryenObj["_BinaryenThrowInsertOperandAt"](this[THIS_PTR], index, operandExpr);
	}

	removeOperandAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenThrowRemoveOperandAt"](this[THIS_PTR], index);
	}
}



export class Rethrow extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.Rethrow, expr);
	}

	get target(): string | null {
		const target = BinaryenObj["_BinaryenRethrowGetTarget"](this[THIS_PTR]);
		return target ? UTF8ToString(target) : null;
	}

	set target(target: string) {
		preserveStack(() => BinaryenObj["_BinaryenRethrowSetTarget"](this[THIS_PTR], strToStack(target)));
	}
}



export class Try extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.Try, expr);
	}

	get body(): ExpressionRef { return BinaryenObj["_BinaryenTryGetBody"](this[THIS_PTR]); }
	set body(bodyExpr: ExpressionRef) { BinaryenObj["_BinaryenTrySetBody"](this[THIS_PTR], bodyExpr); }

	get numCatchTags(): number { return BinaryenObj["_BinaryenTryGetNumCatchTags"](this[THIS_PTR]); }

	get numCatchBodies(): number { return BinaryenObj["_BinaryenTryGetNumCatchBodies"](this[THIS_PTR]); }

	get delegate(): boolean { return Boolean(BinaryenObj["_BinaryenTryIsDelegate"](this[THIS_PTR])); }

	get name(): string | null {
		const name = BinaryenObj["_BinaryenTryGetName"](this[THIS_PTR]);
		return name ? UTF8ToString(name) : null;
	}

	set name(name: string) {
		preserveStack(() => BinaryenObj["_BinaryenTrySetName"](this[THIS_PTR], strToStack(name)));
	}

	get catchTags(): string[] {
		return getAllNested(
			this[THIS_PTR],
			BinaryenObj["_BinaryenTryGetNumCatchTags"],
			BinaryenObj["_BinaryenTryGetCatchTagAt"],
		).map((p) => UTF8ToString(p));
	}

	set catchTags(catchTags: readonly string[]) {
		preserveStack(() => setAllNested(
			this[THIS_PTR],
			catchTags.map(strToStack),
			BinaryenObj["_BinaryenTryGetNumCatchTags"],
			BinaryenObj["_BinaryenTrySetCatchTagAt"],
			BinaryenObj["_BinaryenTryAppendCatchTag"],
			BinaryenObj["_BinaryenTryRemoveCatchTagAt"],
		));
	}

	get catchBodies(): ExpressionRef[] {
		return getAllNested(
			this[THIS_PTR],
			BinaryenObj["_BinaryenTryGetNumCatchBodies"],
			BinaryenObj["_BinaryenTryGetCatchBodyAt"],
		);
	}

	set catchBodies(catchBodies: readonly ExpressionRef[]) {
		setAllNested(
			this[THIS_PTR],
			catchBodies,
			BinaryenObj["_BinaryenTryGetNumCatchBodies"],
			BinaryenObj["_BinaryenTrySetCatchBodyAt"],
			BinaryenObj["_BinaryenTryAppendCatchBody"],
			BinaryenObj["_BinaryenTryRemoveCatchBodyAt"],
		);
	}

	get delegateTarget(): string | null {
		const name = BinaryenObj["_BinaryenTryGetDelegateTarget"](this[THIS_PTR]);
		return name ? UTF8ToString(name) : null;
	}

	set delegateTarget(name: string) {
		preserveStack(() => BinaryenObj["_BinaryenTrySetDelegateTarget"](this[THIS_PTR], strToStack(name)));
	}

	getCatchTagAt(index: number): string {
		return UTF8ToString(BinaryenObj["_BinaryenTryGetCatchTagAt"](this[THIS_PTR], index));
	}

	setCatchTagAt(index: number, catchTag: string): void {
		preserveStack(() => BinaryenObj["_BinaryenTrySetCatchTagAt"](this[THIS_PTR], index, strToStack(catchTag)));
	}

	appendCatchTag(catchTag: string): void {
		preserveStack(() => BinaryenObj["_BinaryenTryAppendCatchTag"](this[THIS_PTR], strToStack(catchTag)));
	}

	insertCatchTagAt(index: number, catchTag: string): void {
		preserveStack(() => BinaryenObj["_BinaryenTryInsertCatchTagAt"](this[THIS_PTR], index, strToStack(catchTag)));
	}

	removeCatchTagAt(index: number): string {
		return UTF8ToString(BinaryenObj["_BinaryenTryRemoveCatchTagAt"](this[THIS_PTR], index));
	}

	getCatchBodyAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenTryGetCatchBodyAt"](this[THIS_PTR], index);
	}

	setCatchBodyAt(index: number, catchExpr: ExpressionRef): void {
		BinaryenObj["_BinaryenTrySetCatchBodyAt"](this[THIS_PTR], index, catchExpr);
	}

	appendCatchBody(catchExpr: ExpressionRef): number {
		return BinaryenObj["_BinaryenTryAppendCatchBody"](this[THIS_PTR], catchExpr);
	}

	insertCatchBodyAt(index: number, catchExpr: ExpressionRef): void {
		BinaryenObj["_BinaryenTryInsertCatchBodyAt"](this[THIS_PTR], index, catchExpr);
	}

	removeCatchBodyAt(index: number): ExpressionRef {
		return BinaryenObj["_BinaryenTryRemoveCatchBodyAt"](this[THIS_PTR], index);
	}

	hasCatchAll(): boolean {
		return Boolean(BinaryenObj["_BinaryenTryHasCatchAll"](this[THIS_PTR]));
	}
}
