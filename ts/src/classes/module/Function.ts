import {
	BinaryenObj,
	UTF8ToString,
} from "../../-pre.ts";
import type {
	ExpressionRef,
	FunctionRef,
	Type,
} from "../../constants.ts";
import {
	THIS_PTR,
	getAllNested,
	i32sToStack,
	preserveStack,
	strToStack,
} from "../../utils.ts";
import type {
	Module,
} from "./Module.ts";



class BinaryenFunction {
	private readonly [THIS_PTR]: FunctionRef;

	readonly module: string;
	readonly base: string;
	readonly vars: readonly Type[];


	constructor(func: FunctionRef) {
		this[THIS_PTR] = func;
		this.module = UTF8ToString(BinaryenObj["_BinaryenFunctionImportGetModule"](this[THIS_PTR]));
		this.base = UTF8ToString(BinaryenObj["_BinaryenFunctionImportGetBase"](this[THIS_PTR]));
		this.vars = getAllNested(func, BinaryenObj["_BinaryenFunctionGetNumVars"], BinaryenObj["_BinaryenFunctionGetVar"]);
	}


	valueOf(): FunctionRef {
		return this[THIS_PTR];
	}

	// FIXME: post.js has converted all methods starting with `get` to getters and `set` to setters
	getName(): string {
		return UTF8ToString(BinaryenObj["_BinaryenFunctionGetName"](this[THIS_PTR]));
	}

	getType(): Type {
		return BinaryenObj["_BinaryenFunctionGetType"](this[THIS_PTR]);
	}

	getParams(): Type {
		return BinaryenObj["_BinaryenFunctionGetParams"](this[THIS_PTR]);
	}

	getResults(): Type {
		return BinaryenObj["_BinaryenFunctionGetResults"](this[THIS_PTR]);
	}

	getNumVars(): number {
		return BinaryenObj["_BinaryenFunctionGetNumVars"](this[THIS_PTR]);
	}

	getVar(index: number): Type {
		return BinaryenObj["_BinaryenFunctionGetVar"](this[THIS_PTR], index);
	}

	getNumLocals(): number {
		return BinaryenObj["_BinaryenFunctionGetNumLocals"](this[THIS_PTR]);
	}

	hasLocalName(index: number): boolean {
		return Boolean(BinaryenObj["_BinaryenFunctionHasLocalName"](this[THIS_PTR], index));
	}

	getLocalName(index: number): string {
		return UTF8ToString(BinaryenObj["_BinaryenFunctionGetLocalName"](this[THIS_PTR], index));
	}

	setLocalName(index: number, name: string): void {
		preserveStack(() => {
			BinaryenObj["_BinaryenFunctionSetLocalName"](this[THIS_PTR], index, strToStack(name));
		});
	}

	getBody(): ExpressionRef {
		return BinaryenObj["_BinaryenFunctionGetBody"](this[THIS_PTR]);
	}

	setBody(bodyExpr: ExpressionRef): void {
		BinaryenObj["_BinaryenFunctionSetBody"](this[THIS_PTR], bodyExpr);
	}
}
export {BinaryenFunction as Function};



export class ModuleFunctions {
	constructor(private readonly mod: Module) {}

	add(name: string, params: Type, results: Type, varTypes: readonly Type[], body: ExpressionRef): FunctionRef {
		return preserveStack(() => BinaryenObj["_BinaryenAddFunction"](
			this.mod.ptr,
			strToStack(name),
			params,
			results,
			i32sToStack(varTypes),
			varTypes.length,
			body,
		));
	}

	get(name: string): FunctionRef {
		return preserveStack(() => BinaryenObj["_BinaryenGetFunction"](this.mod.ptr, strToStack(name)));
	}

	getByIndex(index: number): FunctionRef {
		return BinaryenObj["_BinaryenGetFunctionByIndex"](this.mod.ptr, index);
	}

	count(): number {
		return BinaryenObj["_BinaryenGetNumFunctions"](this.mod.ptr);
	}

	remove(name: string): void {
		return preserveStack(() => {
			BinaryenObj["_BinaryenRemoveFunction"](this.mod.ptr, strToStack(name));
		});
	}
}
