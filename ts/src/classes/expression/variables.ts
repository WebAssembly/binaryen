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
} from "../../constants.ts";
import {
	Expression,
} from "./Expression.ts";



export class LocalGet extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.LocalGet, expr);
	}

	get index(): number { return BinaryenObj["_BinaryenLocalGetGetIndex"](this._ptr); }
	set index(index: number) { BinaryenObj["_BinaryenLocalGetSetIndex"](this._ptr, index); }
}



export class LocalSet extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.LocalSet, expr);
	}

	get index(): number { return BinaryenObj["_BinaryenLocalSetGetIndex"](this._ptr); }
	set index(index: number) { BinaryenObj["_BinaryenLocalSetSetIndex"](this._ptr, index); }

	get value(): ExpressionRef { return BinaryenObj["_BinaryenLocalSetGetValue"](this._ptr); }
	set value(valueExpr: ExpressionRef) { BinaryenObj["_BinaryenLocalSetSetValue"](this._ptr, valueExpr); }

	get isTee(): boolean {
		return Boolean(BinaryenObj["_BinaryenLocalSetIsTee"](this._ptr));
	}
}



export class GlobalGet extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.GlobalGet, expr);
	}

	get name(): string { return UTF8ToString(BinaryenObj["_BinaryenGlobalGetGetName"](this._ptr)); }
	set name(name: string) { preserveStack(() => BinaryenObj["_BinaryenGlobalGetSetName"](this._ptr, strToStack(name))); }
}



export class GlobalSet extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.GlobalSet, expr);
	}

	get name(): string { return UTF8ToString(BinaryenObj["_BinaryenGlobalSetGetName"](this._ptr)); }
	set name(name: string) { preserveStack(() => BinaryenObj["_BinaryenGlobalSetSetName"](this._ptr, strToStack(name))); }

	get value(): ExpressionRef { return BinaryenObj["_BinaryenGlobalSetGetValue"](this._ptr); }
	set value(valueExpr: ExpressionRef) { BinaryenObj["_BinaryenGlobalSetSetValue"](this._ptr, valueExpr); }
}
