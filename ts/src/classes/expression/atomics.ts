import {
	BinaryenObj,
} from "../../-pre.ts";
import {
	ExpressionId,
	type ExpressionRef,
	type MemoryOrder,
	type Operation,
	type Type,
} from "../../constants.ts";
import {
	Expression,
} from "./Expression.ts";



export class AtomicRMW extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.AtomicRMW, expr);
	}

	get op(): Operation { return BinaryenObj["_BinaryenAtomicRMWGetOp"](this._ptr); }
	set op(op: Operation) { BinaryenObj["_BinaryenAtomicRMWSetOp"](this._ptr, op); }

	get memoryOrder(): MemoryOrder { return BinaryenObj["_BinaryenAtomicRMWGetMemoryOrder"](this._ptr); }
	set memoryOrder(order: MemoryOrder) { BinaryenObj["_BinaryenAtomicRMWSetMemoryOrder"](this._ptr, order); }

	get bytes(): number { return BinaryenObj["_BinaryenAtomicRMWGetBytes"](this._ptr); }
	set bytes(bytes: number) { BinaryenObj["_BinaryenAtomicRMWSetBytes"](this._ptr, bytes); }

	get offset(): number { return BinaryenObj["_BinaryenAtomicRMWGetOffset"](this._ptr); }
	set offset(offset: number) { BinaryenObj["_BinaryenAtomicRMWSetOffset"](this._ptr, offset); }

	get ptr(): ExpressionRef { return BinaryenObj["_BinaryenAtomicRMWGetPtr"](this._ptr); }
	set ptr(ptrExpr: ExpressionRef) { BinaryenObj["_BinaryenAtomicRMWSetPtr"](this._ptr, ptrExpr); }

	get value(): ExpressionRef { return BinaryenObj["_BinaryenAtomicRMWGetValue"](this._ptr); }
	set value(valueExpr: ExpressionRef) { BinaryenObj["_BinaryenAtomicRMWSetValue"](this._ptr, valueExpr); }
}



export class AtomicCmpxchg extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.AtomicCmpxchg, expr);
	}

	get memoryOrder(): MemoryOrder { return BinaryenObj["_BinaryenAtomicCmpxchgGetMemoryOrder"](this._ptr); }
	set memoryOrder(order: MemoryOrder) { BinaryenObj["_BinaryenAtomicCmpxchgSetMemoryOrder"](this._ptr, order); }

	get bytes(): number { return BinaryenObj["_BinaryenAtomicCmpxchgGetBytes"](this._ptr); }
	set bytes(bytes: number) { BinaryenObj["_BinaryenAtomicCmpxchgSetBytes"](this._ptr, bytes); }

	get offset(): number { return BinaryenObj["_BinaryenAtomicCmpxchgGetOffset"](this._ptr); }
	set offset(offset: number) { BinaryenObj["_BinaryenAtomicCmpxchgSetOffset"](this._ptr, offset); }

	get ptr(): ExpressionRef { return BinaryenObj["_BinaryenAtomicCmpxchgGetPtr"](this._ptr); }
	set ptr(ptrExpr: ExpressionRef) { BinaryenObj["_BinaryenAtomicCmpxchgSetPtr"](this._ptr, ptrExpr); }

	get expected(): ExpressionRef { return BinaryenObj["_BinaryenAtomicCmpxchgGetExpected"](this._ptr); }
	set expected(expectedExpr: ExpressionRef) { BinaryenObj["_BinaryenAtomicCmpxchgSetExpected"](this._ptr, expectedExpr); }

	get replacement(): ExpressionRef { return BinaryenObj["_BinaryenAtomicCmpxchgGetReplacement"](this._ptr); }
	set replacement(replacementExpr: ExpressionRef) { BinaryenObj["_BinaryenAtomicCmpxchgSetReplacement"](this._ptr, replacementExpr); }
}



export class AtomicWait extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.AtomicWait, expr);
	}

	get ptr(): ExpressionRef { return BinaryenObj["_BinaryenAtomicWaitGetPtr"](this._ptr); }
	set ptr(ptrExpr: ExpressionRef) { BinaryenObj["_BinaryenAtomicWaitSetPtr"](this._ptr, ptrExpr); }

	get expected(): ExpressionRef { return BinaryenObj["_BinaryenAtomicWaitGetExpected"](this._ptr); }
	set expected(expectedExpr: ExpressionRef) { BinaryenObj["_BinaryenAtomicWaitSetExpected"](this._ptr, expectedExpr); }

	get timeout(): ExpressionRef { return BinaryenObj["_BinaryenAtomicWaitGetTimeout"](this._ptr); }
	set timeout(timeoutExpr: ExpressionRef) { BinaryenObj["_BinaryenAtomicWaitSetTimeout"](this._ptr, timeoutExpr); }

	get expectedType(): Type { return BinaryenObj["_BinaryenAtomicWaitGetExpectedType"](this._ptr); }
	set expectedType(expectedType: Type) { BinaryenObj["_BinaryenAtomicWaitSetExpectedType"](this._ptr, expectedType); }
}



export class AtomicNotify extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.AtomicNotify, expr);
	}

	get ptr(): ExpressionRef { return BinaryenObj["_BinaryenAtomicNotifyGetPtr"](this._ptr); }
	set ptr(ptrExpr: ExpressionRef) { BinaryenObj["_BinaryenAtomicNotifySetPtr"](this._ptr, ptrExpr); }

	get notifyCount(): ExpressionRef { return BinaryenObj["_BinaryenAtomicNotifyGetNotifyCount"](this._ptr); }
	set notifyCount(notifyCountExpr: ExpressionRef) { BinaryenObj["_BinaryenAtomicNotifySetNotifyCount"](this._ptr, notifyCountExpr); }
}



export class AtomicFence extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.AtomicFence, expr);
	}

	get order(): number { return BinaryenObj["_BinaryenAtomicFenceGetOrder"](this._ptr); }
	set order(order: number) { BinaryenObj["_BinaryenAtomicFenceSetOrder"](this._ptr, order); }
}
