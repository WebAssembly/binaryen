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
