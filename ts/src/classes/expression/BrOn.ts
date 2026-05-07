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
	type Type,
} from "../../constants.ts";
import {
	Expression,
} from "./Expression.ts";



export class BrOn extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.BrOn, expr);
	}


	get op(): number { return BinaryenObj["_BinaryenBrOnGetOp"](this[THIS_PTR]); }
	set op(op: number) { BinaryenObj["_BinaryenBrOnSetOp"](this[THIS_PTR], op); }

	get name(): string { return UTF8ToString(BinaryenObj["_BinaryenBrOnGetName"](this[THIS_PTR])); }
	set name(name: string) { preserveStack(() => BinaryenObj["_BinaryenBrOnSetName"](this[THIS_PTR], strToStack(name))); }

	get ref(): ExpressionRef { return BinaryenObj["_BinaryenBrOnGetRef"](this[THIS_PTR]); }
	set ref(ref: ExpressionRef) { BinaryenObj["_BinaryenBrOnSetRef"](this[THIS_PTR], ref); }

	get castType(): Type { return BinaryenObj["_BinaryenBrOnGetCastType"](this[THIS_PTR]); }
	set castType(castType: Type) { BinaryenObj["_BinaryenBrOnSetCastType"](this[THIS_PTR], castType); }
}
