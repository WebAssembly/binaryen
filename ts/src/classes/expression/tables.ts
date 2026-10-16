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



export class TableGet extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.TableGet, expr);
	}

	get table(): string { return UTF8ToString(BinaryenObj["_BinaryenTableGetGetTable"](this._ptr)); }
	set table(name: string) { preserveStack(() => BinaryenObj["_BinaryenTableGetSetTable"](this._ptr, strToStack(name))); }

	get index(): number { return BinaryenObj["_BinaryenTableGetGetIndex"](this._ptr); }
	set index(index: number) { BinaryenObj["_BinaryenTableGetSetIndex"](this._ptr, index); }
}



export class TableSet extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.TableSet, expr);
	}

	get table(): string { return UTF8ToString(BinaryenObj["_BinaryenTableGetGetTable"](this._ptr)); }
	set table(name: string) { preserveStack(() => BinaryenObj["_BinaryenTableGetSetTable"](this._ptr, strToStack(name))); }

	get index(): number { return BinaryenObj["_BinaryenTableSetGetIndex"](this._ptr); }
	set index(index: number) { BinaryenObj["_BinaryenTableSetSetIndex"](this._ptr, index); }

	get value(): ExpressionRef { return BinaryenObj["_BinaryenTableSetGetValue"](this._ptr); }
	set value(valueExpr: ExpressionRef) { BinaryenObj["_BinaryenTableSetSetValue"](this._ptr, valueExpr); }
}



export class TableSize extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.TableSize, expr);
	}

	get table(): string { return UTF8ToString(BinaryenObj["_BinaryenTableSizeGetTable"](this._ptr)); }
	set table(name: string) { preserveStack(() => BinaryenObj["_BinaryenTableSizeSetTable"](this._ptr, strToStack(name))); }
}



export class TableGrow extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.TableSize, expr);
	}

	get table(): string { return UTF8ToString(BinaryenObj["_BinaryenTableGrowGetTable"](this._ptr)); }
	set table(name: string) { preserveStack(() => BinaryenObj["_BinaryenTableGrowSetTable"](this._ptr, strToStack(name))); }

	get value(): ExpressionRef { return BinaryenObj["_BinaryenTableGrowGetValue"](this._ptr); }
	set value(valueExpr: ExpressionRef) { BinaryenObj["_BinaryenTableGrowSetValue"](this._ptr, valueExpr); }

	get delta(): ExpressionRef { return BinaryenObj["_BinaryenTableGrowGetDelta"](this._ptr); }
	set delta(deltaExpr: ExpressionRef) { BinaryenObj["_BinaryenTableGrowSetDelta"](this._ptr, deltaExpr); }
}
