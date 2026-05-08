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
	type Operation,
	type Type,
} from "../../constants.ts";
import {
	Expression,
} from "./Expression.ts";



export class RefFunc extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.RefFunc, expr);
	}

	get func(): string { return UTF8ToString(BinaryenObj["_BinaryenRefFuncGetFunc"](this._ptr)); }
	set func(funcName: string) { preserveStack(() => BinaryenObj["_BinaryenRefFuncSetFunc"](this._ptr, strToStack(funcName))); }
}



// TODO: class RefNull



export class RefIsNull extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.RefIsNull, expr);
	}

	get value(): ExpressionRef { return BinaryenObj["_BinaryenRefIsNullGetValue"](this._ptr); }
	set value(valueExpr: ExpressionRef) { BinaryenObj["_BinaryenRefIsNullSetValue"](this._ptr, valueExpr); }
}



export class RefAs extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.RefAs, expr);
	}

	get op(): Operation { return BinaryenObj["_BinaryenRefAsGetOp"](this._ptr); }
	set op(op: Operation) { BinaryenObj["_BinaryenRefAsSetOp"](this._ptr, op); }

	get value(): ExpressionRef {return BinaryenObj["_BinaryenRefAsGetValue"](this._ptr);}
	set value(valueExpr: ExpressionRef) { BinaryenObj["_BinaryenRefAsSetValue"](this._ptr, valueExpr); }
}



export class RefEq extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.RefEq, expr);
	}

	get left(): ExpressionRef { return BinaryenObj["_BinaryenRefEqGetLeft"](this._ptr); }
	set left(leftExpr: ExpressionRef) { BinaryenObj["_BinaryenRefEqSetLeft"](this._ptr, leftExpr); }

	get right(): ExpressionRef { return BinaryenObj["_BinaryenRefEqGetRight"](this._ptr); }
	set right(rightExpr: ExpressionRef) { BinaryenObj["_BinaryenRefEqSetRight"](this._ptr, rightExpr); }
}



export class RefTest extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.RefTest, expr);
	}

	get ref(): ExpressionRef { return BinaryenObj["_BinaryenRefTestGetRef"](this._ptr); }
	set ref(ref: ExpressionRef) { BinaryenObj["_BinaryenRefTestSetRef"](this._ptr, ref); }

	get castType(): Type { return BinaryenObj["_BinaryenRefTestGetCastType"](this._ptr); }
	set castType(castType: Type) { BinaryenObj["_BinaryenRefTestSetCastType"](this._ptr, castType); }
}



export class RefCast extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.RefCast, expr);
	}

	get ref(): ExpressionRef { return BinaryenObj["_BinaryenRefCastGetRef"](this._ptr); }
	set ref(ref: ExpressionRef) { BinaryenObj["_BinaryenRefCastSetRef"](this._ptr, ref); }
}



export class RefI31 extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.RefI31, expr);
	}

	get value(): ExpressionRef { return BinaryenObj["_BinaryenRefI31GetValue"](this._ptr); }
	set value(valueExpr: ExpressionRef) { BinaryenObj["_BinaryenRefI31SetValue"](this._ptr, valueExpr); }
}



export class I31Get extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.I31Get, expr);
	}

	get i31(): ExpressionRef { return BinaryenObj["_BinaryenI31GetGetI31"](this._ptr); }
	set i31(i31Expr: ExpressionRef) { BinaryenObj["_BinaryenI31GetSetI31"](this._ptr, i31Expr); }

	get signed(): boolean { return Boolean(BinaryenObj["_BinaryenI31GetIsSigned"](this._ptr)); }
	set signed(isSigned: boolean) { BinaryenObj["_BinaryenI31GetSetSigned"](this._ptr, isSigned); }
}
