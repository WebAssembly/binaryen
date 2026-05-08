import {
	BinaryenObj,
	HEAPU8,
	stackAlloc,
} from "../../-pre.ts";
import {
	preserveStack,
} from "../../-utils.ts";
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
	Expression,
} from "./Expression.ts";



export class Const extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.Const, expr);
	}

	get value(): number | number[] {
		const this_type = this.type;
		switch (this_type) {
			case i32: { return this.valueI32; }
			case i64: { return this.valueI64; }
			case f32: { return this.valueF32; }
			case f64: { return this.valueF64; }
			case v128: { return this.valueV128; }
		}
		throw new Error(`Unexpected type: ${ this_type }.`);
	}

	get valueI32(): number { return BinaryenObj["_BinaryenConstGetValueI32"](this._ptr); }
	set valueI32(value: number) { BinaryenObj["_BinaryenConstSetValueI32"](this._ptr, value); }

	get valueI64(): number { return BinaryenObj["_BinaryenConstGetValueI64"](this._ptr); }
	set valueI64(value: number) { BinaryenObj["_BinaryenConstSetValueI64"](this._ptr, BigInt(value)); }

	get valueF32(): number { return BinaryenObj["_BinaryenConstGetValueF32"](this._ptr); }
	set valueF32(value: number) { BinaryenObj["_BinaryenConstSetValueF32"](this._ptr, value); }

	get valueF64(): number { return BinaryenObj["_BinaryenConstGetValueF64"](this._ptr); }
	set valueF64(value: number) { BinaryenObj["_BinaryenConstSetValueF64"](this._ptr, value); }

	get valueV128(): number[] {
		const value: number[] = [];
		preserveStack(() => {
			const tempBuffer = stackAlloc(16);
			BinaryenObj["_BinaryenConstGetValueV128"](this._ptr, tempBuffer);
			for (let i = 0; i < 16; ++i) {
				value[i] = HEAPU8[tempBuffer + i];
			}
		});
		return value;
	}

	set valueV128(value: readonly number[]) {
		preserveStack(() => {
			const tempBuffer = stackAlloc(16);
			for (let i = 0; i < 16; ++i) {
				HEAPU8[tempBuffer + i] = value[i];
			}
			BinaryenObj["_BinaryenConstSetValueV128"](this._ptr, tempBuffer);
		});
	}
}
