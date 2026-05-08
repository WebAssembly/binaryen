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



export class GlobalGet extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.GlobalGet, expr);
	}


	get name(): string { return UTF8ToString(BinaryenObj["_BinaryenGlobalGetGetName"](this[THIS_PTR])); }
	set name(name: string) { preserveStack(() => BinaryenObj["_BinaryenGlobalGetSetName"](this[THIS_PTR], strToStack(name))); }
}
