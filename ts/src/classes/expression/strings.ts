import {
	ExpressionId,
	type ExpressionRef,
} from "../../constants.ts";
import {
	Expression,
} from "./Expression.ts";



export class StringNew extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.StringNew, expr);
	}
}



export class StringConst extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.StringConst, expr);
	}
}



export class StringMeasure extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.StringMeasure, expr);
	}
}



export class StringEncode extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.StringEncode, expr);
	}
}



export class StringConcat extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.StringConcat, expr);
	}
}



export class StringEq extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.StringEq, expr);
	}
}



export class StringWTF16Get extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.StringWTF16Get, expr);
	}
}



export class StringSliceWTF extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.StringSliceWTF, expr);
	}
}
