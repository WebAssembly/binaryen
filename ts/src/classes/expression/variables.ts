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
} from "../../constants.ts";
import {
	Expression,
} from "./Expression.ts";



export class LocalGet extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.LocalGet, expr);
	}

	get index(): number { return BinaryenObj["_BinaryenLocalGetGetIndex"](this[THIS_PTR]); }
	set index(index: number) { BinaryenObj["_BinaryenLocalGetSetIndex"](this[THIS_PTR], index); }
}



export class LocalSet extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.LocalSet, expr);
	}

	get index(): number { return BinaryenObj["_BinaryenLocalSetGetIndex"](this[THIS_PTR]); }
	set index(index: number) { BinaryenObj["_BinaryenLocalSetSetIndex"](this[THIS_PTR], index); }

	get value(): ExpressionRef { return BinaryenObj["_BinaryenLocalSetGetValue"](this[THIS_PTR]); }
	set value(valueExpr: ExpressionRef) { BinaryenObj["_BinaryenLocalSetSetValue"](this[THIS_PTR], valueExpr); }

	get isTee(): boolean {
		return Boolean(BinaryenObj["_BinaryenLocalSetIsTee"](this[THIS_PTR]));
	}
}



export class GlobalGet extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.GlobalGet, expr);
	}

	get name(): string { return UTF8ToString(BinaryenObj["_BinaryenGlobalGetGetName"](this[THIS_PTR])); }
	set name(name: string) { preserveStack(() => BinaryenObj["_BinaryenGlobalGetSetName"](this[THIS_PTR], strToStack(name))); }
}



export class GlobalSet extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.GlobalSet, expr);
	}

	get name(): string { return UTF8ToString(BinaryenObj["_BinaryenGlobalSetGetName"](this[THIS_PTR])); }
	set name(name: string) { preserveStack(() => BinaryenObj["_BinaryenGlobalSetSetName"](this[THIS_PTR], strToStack(name))); }

	get value(): ExpressionRef { return BinaryenObj["_BinaryenGlobalSetGetValue"](this[THIS_PTR]); }
	set value(valueExpr: ExpressionRef) { BinaryenObj["_BinaryenGlobalSetSetValue"](this[THIS_PTR], valueExpr); }
}
