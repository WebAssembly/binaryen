import {BinaryenObj} from "../../-pre.ts";
import {
	type ExpressionRef,
	type Type,
	none,
} from "../../constants.ts";
import {
	i32sToStack,
	preserveStack,
	strToStack,
} from "../../utils.ts";
import type {Module} from "../Module.ts";
import {Expression} from "./Expression.ts";



export class Block extends Expression {
	// TODO: static methods are deprecated; convert to instance and log warnings
	static getName() {}
	static setName() {}
	static getNumChildren() {}
	static getChildren() {}
	static setChildren() {}
	static getChildAt() {}
	static setChildAt() {}
	static appendChild() {}
	static insertChildAt() {}
	static removeChildAt() {}
}



export function block(this: Module, name: string, children: readonly ExpressionRef[], resultType: Type = none) {
	return preserveStack(() => BinaryenObj["_BinaryenBlock"](
		this.ptr,
		strToStack(name),
		i32sToStack(children),
		children.length,
		resultType,
	));
}
