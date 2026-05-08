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



export class TableGet extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.TableGet, expr);
	}

	get table(): string { return UTF8ToString(BinaryenObj["_BinaryenTableGetGetTable"](this[THIS_PTR])); }
	set table(name: string) { preserveStack(() => BinaryenObj["_BinaryenTableGetSetTable"](this[THIS_PTR], strToStack(name))); }

	get index(): number { return BinaryenObj["_BinaryenTableGetGetIndex"](this[THIS_PTR]); }
	set index(index: number) { BinaryenObj["_BinaryenTableGetSetIndex"](this[THIS_PTR], index); }
}



export class TableSet extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.TableSet, expr);
	}

	get table(): string { return UTF8ToString(BinaryenObj["_BinaryenTableGetGetTable"](this[THIS_PTR])); }
	set table(name: string) { preserveStack(() => BinaryenObj["_BinaryenTableGetSetTable"](this[THIS_PTR], strToStack(name))); }

	get index(): number { return BinaryenObj["_BinaryenTableSetGetIndex"](this[THIS_PTR]); }
	set index(index: number) { BinaryenObj["_BinaryenTableSetSetIndex"](this[THIS_PTR], index); }

	get value(): ExpressionRef { return BinaryenObj["_BinaryenTableSetGetValue"](this[THIS_PTR]); }
	set value(valueExpr: ExpressionRef) { BinaryenObj["_BinaryenTableSetSetValue"](this[THIS_PTR], valueExpr); }
}



export class TableSize extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.TableSize, expr);
	}

	get table(): string { return UTF8ToString(BinaryenObj["_BinaryenTableSizeGetTable"](this[THIS_PTR])); }
	set table(name: string) { preserveStack(() => BinaryenObj["_BinaryenTableSizeSetTable"](this[THIS_PTR], strToStack(name))); }
}



export class TableGrow extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.TableSize, expr);
	}

	get table(): string { return UTF8ToString(BinaryenObj["_BinaryenTableGrowGetTable"](this[THIS_PTR])); }
	set table(name: string) { preserveStack(() => BinaryenObj["_BinaryenTableGrowSetTable"](this[THIS_PTR], strToStack(name))); }

	get value(): ExpressionRef { return BinaryenObj["_BinaryenTableGrowGetValue"](this[THIS_PTR]); }
	set value(valueExpr: ExpressionRef) { BinaryenObj["_BinaryenTableGrowSetValue"](this[THIS_PTR], valueExpr); }

	get delta(): ExpressionRef { return BinaryenObj["_BinaryenTableGrowGetDelta"](this[THIS_PTR]); }
	set delta(deltaExpr: ExpressionRef) { BinaryenObj["_BinaryenTableGrowSetDelta"](this[THIS_PTR], deltaExpr); }
}
