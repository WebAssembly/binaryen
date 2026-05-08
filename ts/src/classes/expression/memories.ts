import {
	BinaryenObj,
	UTF8ToString,
} from "../../-pre.ts";
import {
	THIS_PTR,
	preserveStack,
	strToStack,
} from "../../-utils.ts";
import {
	ExpressionId,
	type ExpressionRef,
	type MemoryOrder,
	type Type,
} from "../../constants.ts";
import type {
	Operation,
} from "../../services/expression-builder/Operation.ts";
import {
	Expression,
} from "./Expression.ts";



export class Load extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.Load, expr);
	}

	get bytes(): number { return BinaryenObj["_BinaryenLoadGetBytes"](this[THIS_PTR]); }
	set bytes(bytes: number) { BinaryenObj["_BinaryenLoadSetBytes"](this[THIS_PTR], bytes); }

	get signed(): boolean { return Boolean(BinaryenObj["_BinaryenLoadIsSigned"](this[THIS_PTR])); }
	set signed(isSigned: boolean) { BinaryenObj["_BinaryenLoadSetSigned"](this[THIS_PTR], isSigned); }

	get offset(): number { return BinaryenObj["_BinaryenLoadGetOffset"](this[THIS_PTR]); }
	set offset(offset: number) { BinaryenObj["_BinaryenLoadSetOffset"](this[THIS_PTR], offset); }

	get align(): number { return BinaryenObj["_BinaryenLoadGetAlign"](this[THIS_PTR]); }
	set align(align: number) { BinaryenObj["_BinaryenLoadSetAlign"](this[THIS_PTR], align); }

	get ptr(): ExpressionRef { return BinaryenObj["_BinaryenLoadGetPtr"](this[THIS_PTR]); }
	set ptr(ptrExpr: ExpressionRef) { BinaryenObj["_BinaryenLoadSetPtr"](this[THIS_PTR], ptrExpr); }

	get atomic(): boolean { return Boolean(BinaryenObj["_BinaryenLoadIsAtomic"](this[THIS_PTR])); }
	// TODO: set atomic

	get memoryOrder(): MemoryOrder { return BinaryenObj["_BinaryenLoadGetMemoryOrder"](this[THIS_PTR]); }
	set memoryOrder(order: MemoryOrder) { BinaryenObj["_BinaryenLoadSetMemoryOrder"](this[THIS_PTR], order); }
}



export class Store extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.Store, expr);
	}

	get bytes(): number { return BinaryenObj["_BinaryenStoreGetBytes"](this[THIS_PTR]); }
	set bytes(bytes: number) { BinaryenObj["_BinaryenStoreSetBytes"](this[THIS_PTR], bytes); }

	get offset(): number { return BinaryenObj["_BinaryenStoreGetOffset"](this[THIS_PTR]); }
	set offset(offset: number) { BinaryenObj["_BinaryenStoreSetOffset"](this[THIS_PTR], offset); }

	get align(): number { return BinaryenObj["_BinaryenStoreGetAlign"](this[THIS_PTR]); }
	set align(align: number) { BinaryenObj["_BinaryenStoreSetAlign"](this[THIS_PTR], align); }

	get ptr(): ExpressionRef { return BinaryenObj["_BinaryenLoadGetPtr"](this[THIS_PTR]); }
	set ptr(ptrExpr: ExpressionRef) { BinaryenObj["_BinaryenLoadSetPtr"](this[THIS_PTR], ptrExpr); }

	get value(): ExpressionRef { return BinaryenObj["_BinaryenStoreGetValue"](this[THIS_PTR]); }
	set value(valueExpr: ExpressionRef) { BinaryenObj["_BinaryenStoreSetValue"](this[THIS_PTR], valueExpr); }

	get valueType(): Type { return BinaryenObj["_BinaryenStoreGetValueType"](this[THIS_PTR]); }
	set valueType(valueType: Type) { BinaryenObj["_BinaryenStoreSetValueType"](this[THIS_PTR], valueType); }

	get atomic(): boolean {return Boolean(BinaryenObj["_BinaryenStoreIsAtomic"](this[THIS_PTR]));}
	// TODO: set atomic

	get memoryOrder(): MemoryOrder { return BinaryenObj["_BinaryenStoreGetMemoryOrder"](this[THIS_PTR]); }
	set memoryOrder(order: MemoryOrder) { BinaryenObj["_BinaryenStoreSetMemoryOrder"](this[THIS_PTR], order); }
}



export class SIMDLoad extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.SIMDLoad, expr);
	}

	get op(): Operation { return BinaryenObj["_BinaryenSIMDLoadGetOp"](this[THIS_PTR]); }
	set op(op: Operation) { BinaryenObj["_BinaryenSIMDLoadSetOp"](this[THIS_PTR], op); }

	get offset(): number { return BinaryenObj["_BinaryenSIMDLoadGetOffset"](this[THIS_PTR]); }
	set offset(offset: number) { BinaryenObj["_BinaryenSIMDLoadSetOffset"](this[THIS_PTR], offset); }

	get align(): number { return BinaryenObj["_BinaryenSIMDLoadGetAlign"](this[THIS_PTR]); }
	set align(align: number) { BinaryenObj["_BinaryenSIMDLoadSetAlign"](this[THIS_PTR], align); }

	get ptr(): ExpressionRef { return BinaryenObj["_BinaryenSIMDLoadGetPtr"](this[THIS_PTR]); }
	set ptr(ptrExpr: ExpressionRef) { BinaryenObj["_BinaryenSIMDLoadSetPtr"](this[THIS_PTR], ptrExpr); }
}



export class SIMDLoadStoreLane extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.SIMDLoadStoreLane, expr);
	}

	get op(): Operation { return BinaryenObj["_BinaryenSIMDLoadStoreLaneGetOp"](this[THIS_PTR]); }
	set op(op: Operation) { BinaryenObj["_BinaryenSIMDLoadStoreLaneSetOp"](this[THIS_PTR], op); }

	get offset(): number { return BinaryenObj["_BinaryenSIMDLoadStoreLaneGetOffset"](this[THIS_PTR]); }
	set offset(offset: number) { BinaryenObj["_BinaryenSIMDLoadStoreLaneSetOffset"](this[THIS_PTR], offset); }

	get align(): number { return BinaryenObj["_BinaryenSIMDLoadStoreLaneGetAlign"](this[THIS_PTR]); }
	set align(align: number) { BinaryenObj["_BinaryenSIMDLoadStoreLaneSetAlign"](this[THIS_PTR], align); }

	get index(): ExpressionRef { return BinaryenObj["_BinaryenSIMDLoadStoreLaneGetIndex"](this[THIS_PTR]); }
	set index(index: ExpressionRef) { BinaryenObj["_BinaryenSIMDLoadStoreLaneSetIndex"](this[THIS_PTR], index); }

	get ptr(): ExpressionRef { return BinaryenObj["_BinaryenSIMDLoadStoreLaneGetPtr"](this[THIS_PTR]); }
	set ptr(ptrExpr: ExpressionRef) { BinaryenObj["_BinaryenSIMDLoadStoreLaneSetPtr"](this[THIS_PTR], ptrExpr); }

	get vec(): ExpressionRef { return BinaryenObj["_BinaryenSIMDLoadStoreLaneGetVec"](this[THIS_PTR]); }
	set vec(vecExpr: ExpressionRef) { BinaryenObj["_BinaryenSIMDLoadStoreLaneSetVec"](this[THIS_PTR], vecExpr); }

	get store(): boolean {return Boolean(BinaryenObj["_BinaryenSIMDLoadStoreLaneIsStore"](this[THIS_PTR]));}
}



export class MemorySize extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.MemorySize, expr);
	}
}



export class MemoryGrow extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.MemoryGrow, expr);
	}

	get delta(): ExpressionRef { return BinaryenObj["_BinaryenMemoryGrowGetDelta"](this[THIS_PTR]); }
	set delta(deltaExpr: ExpressionRef) { BinaryenObj["_BinaryenMemoryGrowSetDelta"](this[THIS_PTR], deltaExpr); }
}



export class MemoryFill extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.MemoryFill, expr);
	}

	get dest(): ExpressionRef { return BinaryenObj["_BinaryenMemoryFillGetDest"](this[THIS_PTR]); }
	set dest(destExpr: ExpressionRef) { BinaryenObj["_BinaryenMemoryFillSetDest"](this[THIS_PTR], destExpr); }

	get value(): ExpressionRef { return BinaryenObj["_BinaryenMemoryFillGetValue"](this[THIS_PTR]); }
	set value(valueExpr: ExpressionRef) { BinaryenObj["_BinaryenMemoryFillSetValue"](this[THIS_PTR], valueExpr); }

	get size(): ExpressionRef { return BinaryenObj["_BinaryenMemoryFillGetSize"](this[THIS_PTR]); }
	set size(sizeExpr: ExpressionRef) { BinaryenObj["_BinaryenMemoryFillSetSize"](this[THIS_PTR], sizeExpr); }
}



export class MemoryCopy extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.MemoryCopy, expr);
	}

	get dest(): ExpressionRef { return BinaryenObj["_BinaryenMemoryCopyGetDest"](this[THIS_PTR]); }
	set dest(destExpr: ExpressionRef) { BinaryenObj["_BinaryenMemoryCopySetDest"](this[THIS_PTR], destExpr); }

	get source(): ExpressionRef { return BinaryenObj["_BinaryenMemoryCopyGetSource"](this[THIS_PTR]); }
	set source(sourceExpr: ExpressionRef) { BinaryenObj["_BinaryenMemoryCopySetSource"](this[THIS_PTR], sourceExpr); }

	get size(): ExpressionRef { return BinaryenObj["_BinaryenMemoryCopyGetSize"](this[THIS_PTR]); }
	set size(sizeExpr: ExpressionRef) { BinaryenObj["_BinaryenMemoryCopySetSize"](this[THIS_PTR], sizeExpr); }
}



export class MemoryInit extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.MemoryInit, expr);
	}

	get segment(): string { return UTF8ToString(BinaryenObj["_BinaryenMemoryInitGetSegment"](this[THIS_PTR])); }
	set segment(segment: string) { preserveStack(() => BinaryenObj["_BinaryenMemoryCopySetDest"](this[THIS_PTR], strToStack(segment))); }

	get dest(): ExpressionRef { return BinaryenObj["_BinaryenMemoryInitGetDest"](this[THIS_PTR]); }
	set dest(destExpr: ExpressionRef) { BinaryenObj["_BinaryenMemoryInitSetDest"](this[THIS_PTR], destExpr); }

	get offset(): ExpressionRef { return BinaryenObj["_BinaryenMemoryInitGetOffset"](this[THIS_PTR]); }
	set offset(offsetExpr: ExpressionRef) { BinaryenObj["_BinaryenMemoryInitSetOffset"](this[THIS_PTR], offsetExpr); }

	get size(): ExpressionRef { return BinaryenObj["_BinaryenMemoryInitGetSize"](this[THIS_PTR]); }
	set size(sizeExpr: ExpressionRef) { BinaryenObj["_BinaryenMemoryInitGetSize"](this[THIS_PTR], sizeExpr); }
}



export class DataDrop extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.DataDrop, expr);
	}

	get segment(): string { return UTF8ToString(BinaryenObj["_BinaryenDataDropGetSegment"](this[THIS_PTR])); }
	set segment(segment: string) { preserveStack(() => BinaryenObj["_BinaryenDataDropSetSegment"](this[THIS_PTR], strToStack(segment))); }
}
