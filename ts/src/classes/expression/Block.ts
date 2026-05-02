import {
	BinaryenObj,
} from "../../-pre.ts";
import {
	ExpressionId,
	type ExpressionRef,
	type Type,
	none,
} from "../../constants.ts";
import {
	i32sToStack,
	preserveStack,
	strToStack,
} from "../../utils.ts";
import type {
	Module,
} from "../module/Module.ts";
import {
	Expression,
} from "./Expression.ts";



export class Block extends Expression {
	static block = function (this: Module, name: string | null | undefined, children: readonly ExpressionRef[], resultType: Type = none): ExpressionRef {
		return preserveStack(() => BinaryenObj["_BinaryenBlock"](
			this.ptr,
			name ? strToStack(name) : 0,
			i32sToStack(children),
			children.length,
			resultType,
		));
	};


	constructor(expr: ExpressionRef) {
		super(ExpressionId.Block, expr);
	}


	// FIXME: post.js has converted all methods starting with `get` to getters and `set` to setters
	getName() {}
	setName() {}
	getNumChildren() {}
	getChildren() {}
	setChildren() {}
	getChildAt() {}
	setChildAt() {}
	appendChild() {}
	insertChildAt() {}
	removeChildAt() {}
}
