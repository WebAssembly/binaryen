import {
	BinaryenObj,
	stackAlloc,
} from "../../-pre.ts";
import {
	ExpressionId,
	type ExpressionRef,
	i32,
	i64,
	f32,
	f64,
	v128,
} from "../../constants.ts";
import {
	replacedBy,
} from "../../lib.ts";
import {
	HEAPU8,
	THIS_PTR,
	preserveStack,
} from "../../utils.ts";
import {
	Expression,
} from "./Expression.ts";



export class Const extends Expression {
	/* eslint-disable @stylistic/brace-style */
	/** @deprecated */ @replacedBy("`instance.getValueI32`") static getValueI32(expr: ExpressionRef) { return Const.prototype.getValueI32.call({[THIS_PTR]: expr}); }
	/** @deprecated */ @replacedBy("`instance.setValueI32`") static setValueI32(expr: ExpressionRef, value: number) { return Const.prototype.setValueI32.call({[THIS_PTR]: expr}, value); }
	/** @deprecated */ @replacedBy("`instance.getValueI64`") static getValueI64(expr: ExpressionRef) { return Const.prototype.getValueI64.call({[THIS_PTR]: expr}); }
	/** @deprecated */ @replacedBy("`instance.setValueI64`") static setValueI64(expr: ExpressionRef, value: number) { return Const.prototype.setValueI64.call({[THIS_PTR]: expr}, value); }
	/** @deprecated */ @replacedBy("`instance.getValueF32`") static getValueF32(expr: ExpressionRef) { return Const.prototype.getValueF32.call({[THIS_PTR]: expr}); }
	/** @deprecated */ @replacedBy("`instance.setValueF32`") static setValueF32(expr: ExpressionRef, value: number) { return Const.prototype.setValueF32.call({[THIS_PTR]: expr}, value); }
	/** @deprecated */ @replacedBy("`instance.getValueF64`") static getValueF64(expr: ExpressionRef) { return Const.prototype.getValueF64.call({[THIS_PTR]: expr}); }
	/** @deprecated */ @replacedBy("`instance.setValueF64`") static setValueF64(expr: ExpressionRef, value: number) { return Const.prototype.setValueF64.call({[THIS_PTR]: expr}, value); }
	/** @deprecated */ @replacedBy("`instance.getValueV128`") static getValueV128(expr: ExpressionRef) { return Const.prototype.getValueV128.call({[THIS_PTR]: expr}); }
	/** @deprecated */ @replacedBy("`instance.setValueV128`") static setValueV128(expr: ExpressionRef, value: readonly number[]) { return Const.prototype.setValueV128.call({[THIS_PTR]: expr}, value); }
	/* eslint-enable @stylistic/brace-style */


	constructor(expr: ExpressionRef) {
		super(ExpressionId.Const, expr);
	}

	get value(): number | number[] {
		const this_type = this.getType();
		switch (this.getType()) {
			case i32: { return this.getValueI32(); }
			case i64: { return this.getValueI64(); }
			case f32: { return this.getValueF32(); }
			case f64: { return this.getValueF64(); }
			case v128: { return this.getValueV128(); }
		}
		throw new Error(`Unexpected type: ${ this_type }.`);
	}

	getValueI32(): number {
		return BinaryenObj["_BinaryenConstGetValueI32"](this[THIS_PTR]);
	}

	setValueI32(value: number): void {
		BinaryenObj["_BinaryenConstSetValueI32"](this[THIS_PTR], value);
	}

	getValueI64(): number {
		return BinaryenObj["_BinaryenConstGetValueI64"](this[THIS_PTR]);
	}

	setValueI64(value: number): void {
		BinaryenObj["_BinaryenConstSetValueI64"](this[THIS_PTR], BigInt(value));
	}

	getValueF32(): number {
		return BinaryenObj["_BinaryenConstGetValueF32"](this[THIS_PTR]);
	}

	setValueF32(value: number): void {
		BinaryenObj["_BinaryenConstSetValueF32"](this[THIS_PTR], value);
	}

	getValueF64(): number {
		return BinaryenObj["_BinaryenConstGetValueF64"](this[THIS_PTR]);
	}

	setValueF64(value: number): void {
		BinaryenObj["_BinaryenConstSetValueF64"](this[THIS_PTR], value);
	}

	getValueV128(): number[] {
		const value: number[] = [];
		preserveStack(() => {
			const tempBuffer = stackAlloc(16);
			BinaryenObj["_BinaryenConstGetValueV128"](this[THIS_PTR], tempBuffer);
			for (let i = 0; i < 16; ++i) {
				value[i] = HEAPU8[tempBuffer + i];
			}
		});
		return value;
	}

	setValueV128(value: readonly number[]): void {
		preserveStack(() => {
			const tempBuffer = stackAlloc(16);
			for (let i = 0; i < 16; ++i) {
				HEAPU8[tempBuffer + i] = value[i];
			}
			BinaryenObj["_BinaryenConstSetValueV128"](this[THIS_PTR], tempBuffer);
		});
	}
}
