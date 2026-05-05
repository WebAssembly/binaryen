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



/**
 * Information about a function in a WASM module.
 */
class BinaryenFunction {
	private readonly [THIS_PTR]: FunctionRef;

	readonly module: string;
	readonly base: string;
	readonly name: string;
	readonly type: Type;
	readonly params: Type;
	readonly results: Type;
	readonly numVars: number;
	readonly numLocals: number;
	readonly vars: readonly Type[];


	constructor(func: FunctionRef) {
		this[THIS_PTR] = func;
		this.module = UTF8ToString(BinaryenObj["_BinaryenFunctionImportGetModule"](this[THIS_PTR]));
		this.base = UTF8ToString(BinaryenObj["_BinaryenFunctionImportGetBase"](this[THIS_PTR]));
		this.name = UTF8ToString(BinaryenObj["_BinaryenFunctionGetName"](this[THIS_PTR]));
		this.type = BinaryenObj["_BinaryenFunctionGetType"](this[THIS_PTR]);
		this.params = BinaryenObj["_BinaryenFunctionGetParams"](this[THIS_PTR]);
		this.results = BinaryenObj["_BinaryenFunctionGetResults"](this[THIS_PTR]);
		this.numVars = BinaryenObj["_BinaryenFunctionGetNumVars"](this[THIS_PTR]);
		this.numLocals = BinaryenObj["_BinaryenFunctionGetNumLocals"](this[THIS_PTR]);
		this.vars = getAllNested(func, BinaryenObj["_BinaryenFunctionGetNumVars"], BinaryenObj["_BinaryenFunctionGetVar"]);
	}


	get body(): ExpressionRef {
		return BinaryenObj["_BinaryenFunctionGetBody"](this[THIS_PTR]);
	}

	set body(bodyExpr: ExpressionRef) {
		BinaryenObj["_BinaryenFunctionSetBody"](this[THIS_PTR], bodyExpr);
	}


	valueOf(): FunctionRef {
		return this[THIS_PTR];
	}

	getVar(index: number): Type {
		return BinaryenObj["_BinaryenFunctionGetVar"](this[THIS_PTR], index);
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
}
export {BinaryenFunction as Function};



/**
 * Methods for manipulating functions in a WASM module.
 * @inline
 */
export class ModuleFunctions {
	constructor(private readonly mod: Module) {}

	/** Adds a function. `varTypes` indicate additional locals, in the given order. */
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

	/** Gets a function by name. */
	get(name: string): FunctionRef {
		return preserveStack(() => BinaryenObj["_BinaryenGetFunction"](this.mod.ptr, strToStack(name)));
	}

	/** Gets a function by index. */
	getByIndex(index: number): FunctionRef {
		return BinaryenObj["_BinaryenGetFunctionByIndex"](this.mod.ptr, index);
	}

	/** Gets the number of functions within the module. */
	count(): number {
		return BinaryenObj["_BinaryenGetNumFunctions"](this.mod.ptr);
	}

	/** Removes a function by name. */
	remove(name: string): void {
		preserveStack(() => BinaryenObj["_BinaryenRemoveFunction"](this.mod.ptr, strToStack(name)));
	}
}
