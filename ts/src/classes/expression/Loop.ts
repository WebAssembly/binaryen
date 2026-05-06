import {
	BinaryenObj,
	UTF8ToString,
} from "../../-pre.ts";
import {
	ExpressionId,
	type ExpressionRef,
} from "../../constants.ts";
import {
	THIS_PTR,
	preserveStack,
	strToStack,
} from "../../utils.ts";
import {
	Expression,
} from "./Expression.ts";



export class Loop extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.Loop, expr);
	}


	get name(): string | null {
		const name = BinaryenObj["_BinaryenLoopGetName"](this[THIS_PTR]);
		return name ? UTF8ToString(name) : null;
	}

	set name(name: string) {
		preserveStack(() => BinaryenObj["_BinaryenLoopSetName"](this[THIS_PTR], strToStack(name)));
	}

	get body(): ExpressionRef { return BinaryenObj["_BinaryenLoopGetBody"](this[THIS_PTR]); }
	set body(bodyExpr: ExpressionRef) { BinaryenObj["_BinaryenLoopSetBody"](this[THIS_PTR], bodyExpr); }
}
