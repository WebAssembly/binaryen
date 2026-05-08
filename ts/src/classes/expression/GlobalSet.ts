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



export class GlobalSet extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.GlobalSet, expr);
	}


	get name(): string { return UTF8ToString(BinaryenObj["_BinaryenGlobalSetGetName"](this[THIS_PTR])); }
	set name(name: string) { preserveStack(() => BinaryenObj["_BinaryenGlobalSetSetName"](this[THIS_PTR], strToStack(name))); }

	get value(): ExpressionRef { return BinaryenObj["_BinaryenGlobalSetGetValue"](this[THIS_PTR]); }
	set value(valueExpr: ExpressionRef) { BinaryenObj["_BinaryenGlobalSetSetValue"](this[THIS_PTR], valueExpr); }
}
