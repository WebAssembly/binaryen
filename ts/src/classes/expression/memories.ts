import {
	BinaryenObj,
	UTF8ToString,
} from "../../-pre.ts";
import {
	preserveStack,
	strToStack,
} from "../../-utils.ts";
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



export class Load extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.Load, expr);
	}

	get bytes(): number { return BinaryenObj["_BinaryenLoadGetBytes"](this._ptr); }
	set bytes(bytes: number) { BinaryenObj["_BinaryenLoadSetBytes"](this._ptr, bytes); }

	get signed(): boolean { return Boolean(BinaryenObj["_BinaryenLoadIsSigned"](this._ptr)); }
	set signed(isSigned: boolean) { BinaryenObj["_BinaryenLoadSetSigned"](this._ptr, isSigned); }

	get offset(): number { return BinaryenObj["_BinaryenLoadGetOffset"](this._ptr); }
	set offset(offset: number) { BinaryenObj["_BinaryenLoadSetOffset"](this._ptr, offset); }

	get align(): number { return BinaryenObj["_BinaryenLoadGetAlign"](this._ptr); }
	set align(align: number) { BinaryenObj["_BinaryenLoadSetAlign"](this._ptr, align); }

	get ptr(): ExpressionRef { return BinaryenObj["_BinaryenLoadGetPtr"](this._ptr); }
	set ptr(ptrExpr: ExpressionRef) { BinaryenObj["_BinaryenLoadSetPtr"](this._ptr, ptrExpr); }

	get atomic(): boolean { return Boolean(BinaryenObj["_BinaryenLoadIsAtomic"](this._ptr)); }
	// TODO: set atomic

	get memoryOrder(): MemoryOrder { return BinaryenObj["_BinaryenLoadGetMemoryOrder"](this._ptr); }
	set memoryOrder(order: MemoryOrder) { BinaryenObj["_BinaryenLoadSetMemoryOrder"](this._ptr, order); }
}



export class Store extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.Store, expr);
	}

	get bytes(): number { return BinaryenObj["_BinaryenStoreGetBytes"](this._ptr); }
	set bytes(bytes: number) { BinaryenObj["_BinaryenStoreSetBytes"](this._ptr, bytes); }

	get offset(): number { return BinaryenObj["_BinaryenStoreGetOffset"](this._ptr); }
	set offset(offset: number) { BinaryenObj["_BinaryenStoreSetOffset"](this._ptr, offset); }

	get align(): number { return BinaryenObj["_BinaryenStoreGetAlign"](this._ptr); }
	set align(align: number) { BinaryenObj["_BinaryenStoreSetAlign"](this._ptr, align); }

	get ptr(): ExpressionRef { return BinaryenObj["_BinaryenLoadGetPtr"](this._ptr); }
	set ptr(ptrExpr: ExpressionRef) { BinaryenObj["_BinaryenLoadSetPtr"](this._ptr, ptrExpr); }

	get value(): ExpressionRef { return BinaryenObj["_BinaryenStoreGetValue"](this._ptr); }
	set value(valueExpr: ExpressionRef) { BinaryenObj["_BinaryenStoreSetValue"](this._ptr, valueExpr); }

	get valueType(): Type { return BinaryenObj["_BinaryenStoreGetValueType"](this._ptr); }
	set valueType(valueType: Type) { BinaryenObj["_BinaryenStoreSetValueType"](this._ptr, valueType); }

	get atomic(): boolean {return Boolean(BinaryenObj["_BinaryenStoreIsAtomic"](this._ptr));}
	// TODO: set atomic

	get memoryOrder(): MemoryOrder { return BinaryenObj["_BinaryenStoreGetMemoryOrder"](this._ptr); }
	set memoryOrder(order: MemoryOrder) { BinaryenObj["_BinaryenStoreSetMemoryOrder"](this._ptr, order); }
}



export class SIMDLoad extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.SIMDLoad, expr);
	}

	get op(): Operation { return BinaryenObj["_BinaryenSIMDLoadGetOp"](this._ptr); }
	set op(op: Operation) { BinaryenObj["_BinaryenSIMDLoadSetOp"](this._ptr, op); }

	get offset(): number { return BinaryenObj["_BinaryenSIMDLoadGetOffset"](this._ptr); }
	set offset(offset: number) { BinaryenObj["_BinaryenSIMDLoadSetOffset"](this._ptr, offset); }

	get align(): number { return BinaryenObj["_BinaryenSIMDLoadGetAlign"](this._ptr); }
	set align(align: number) { BinaryenObj["_BinaryenSIMDLoadSetAlign"](this._ptr, align); }

	get ptr(): ExpressionRef { return BinaryenObj["_BinaryenSIMDLoadGetPtr"](this._ptr); }
	set ptr(ptrExpr: ExpressionRef) { BinaryenObj["_BinaryenSIMDLoadSetPtr"](this._ptr, ptrExpr); }
}



export class SIMDLoadStoreLane extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.SIMDLoadStoreLane, expr);
	}

	get op(): Operation { return BinaryenObj["_BinaryenSIMDLoadStoreLaneGetOp"](this._ptr); }
	set op(op: Operation) { BinaryenObj["_BinaryenSIMDLoadStoreLaneSetOp"](this._ptr, op); }

	get offset(): number { return BinaryenObj["_BinaryenSIMDLoadStoreLaneGetOffset"](this._ptr); }
	set offset(offset: number) { BinaryenObj["_BinaryenSIMDLoadStoreLaneSetOffset"](this._ptr, offset); }

	get align(): number { return BinaryenObj["_BinaryenSIMDLoadStoreLaneGetAlign"](this._ptr); }
	set align(align: number) { BinaryenObj["_BinaryenSIMDLoadStoreLaneSetAlign"](this._ptr, align); }

	get index(): ExpressionRef { return BinaryenObj["_BinaryenSIMDLoadStoreLaneGetIndex"](this._ptr); }
	set index(index: ExpressionRef) { BinaryenObj["_BinaryenSIMDLoadStoreLaneSetIndex"](this._ptr, index); }

	get ptr(): ExpressionRef { return BinaryenObj["_BinaryenSIMDLoadStoreLaneGetPtr"](this._ptr); }
	set ptr(ptrExpr: ExpressionRef) { BinaryenObj["_BinaryenSIMDLoadStoreLaneSetPtr"](this._ptr, ptrExpr); }

	get vec(): ExpressionRef { return BinaryenObj["_BinaryenSIMDLoadStoreLaneGetVec"](this._ptr); }
	set vec(vecExpr: ExpressionRef) { BinaryenObj["_BinaryenSIMDLoadStoreLaneSetVec"](this._ptr, vecExpr); }

	get store(): boolean {return Boolean(BinaryenObj["_BinaryenSIMDLoadStoreLaneIsStore"](this._ptr));}
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

	get delta(): ExpressionRef { return BinaryenObj["_BinaryenMemoryGrowGetDelta"](this._ptr); }
	set delta(deltaExpr: ExpressionRef) { BinaryenObj["_BinaryenMemoryGrowSetDelta"](this._ptr, deltaExpr); }
}



export class MemoryFill extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.MemoryFill, expr);
	}

	get dest(): ExpressionRef { return BinaryenObj["_BinaryenMemoryFillGetDest"](this._ptr); }
	set dest(destExpr: ExpressionRef) { BinaryenObj["_BinaryenMemoryFillSetDest"](this._ptr, destExpr); }

	get value(): ExpressionRef { return BinaryenObj["_BinaryenMemoryFillGetValue"](this._ptr); }
	set value(valueExpr: ExpressionRef) { BinaryenObj["_BinaryenMemoryFillSetValue"](this._ptr, valueExpr); }

	get size(): ExpressionRef { return BinaryenObj["_BinaryenMemoryFillGetSize"](this._ptr); }
	set size(sizeExpr: ExpressionRef) { BinaryenObj["_BinaryenMemoryFillSetSize"](this._ptr, sizeExpr); }
}



export class MemoryCopy extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.MemoryCopy, expr);
	}

	get dest(): ExpressionRef { return BinaryenObj["_BinaryenMemoryCopyGetDest"](this._ptr); }
	set dest(destExpr: ExpressionRef) { BinaryenObj["_BinaryenMemoryCopySetDest"](this._ptr, destExpr); }

	get source(): ExpressionRef { return BinaryenObj["_BinaryenMemoryCopyGetSource"](this._ptr); }
	set source(sourceExpr: ExpressionRef) { BinaryenObj["_BinaryenMemoryCopySetSource"](this._ptr, sourceExpr); }

	get size(): ExpressionRef { return BinaryenObj["_BinaryenMemoryCopyGetSize"](this._ptr); }
	set size(sizeExpr: ExpressionRef) { BinaryenObj["_BinaryenMemoryCopySetSize"](this._ptr, sizeExpr); }
}



export class MemoryInit extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.MemoryInit, expr);
	}

	get segment(): string { return UTF8ToString(BinaryenObj["_BinaryenMemoryInitGetSegment"](this._ptr)); }
	set segment(segment: string) { preserveStack(() => BinaryenObj["_BinaryenMemoryCopySetDest"](this._ptr, strToStack(segment))); }

	get dest(): ExpressionRef { return BinaryenObj["_BinaryenMemoryInitGetDest"](this._ptr); }
	set dest(destExpr: ExpressionRef) { BinaryenObj["_BinaryenMemoryInitSetDest"](this._ptr, destExpr); }

	get offset(): ExpressionRef { return BinaryenObj["_BinaryenMemoryInitGetOffset"](this._ptr); }
	set offset(offsetExpr: ExpressionRef) { BinaryenObj["_BinaryenMemoryInitSetOffset"](this._ptr, offsetExpr); }

	get size(): ExpressionRef { return BinaryenObj["_BinaryenMemoryInitGetSize"](this._ptr); }
	set size(sizeExpr: ExpressionRef) { BinaryenObj["_BinaryenMemoryInitGetSize"](this._ptr, sizeExpr); }
}



export class DataDrop extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.DataDrop, expr);
	}

	get segment(): string { return UTF8ToString(BinaryenObj["_BinaryenDataDropGetSegment"](this._ptr)); }
	set segment(segment: string) { preserveStack(() => BinaryenObj["_BinaryenDataDropSetSegment"](this._ptr, strToStack(segment))); }
}
