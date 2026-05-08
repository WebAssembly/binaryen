import {
	BinaryenObj,
	UTF8ToString,
} from "../../-pre.ts";
import {
	PTR,
	getAllNested,
	i32sToStack,
	preserveStack,
	strToStack,
} from "../../-utils.ts";
import type {
	ExpressionRef,
	FunctionRef,
	Type,
} from "../../constants.ts";
import type {
	Module,
} from "./Module.ts";



/**
 * Information about a function in a WASM module.
 */
class BinaryenFunction {
	/** The underlying C-API pointer of the wrapped function. */
	readonly #ptr: FunctionRef;

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
		this.#ptr = func;
		this.module = UTF8ToString(BinaryenObj["_BinaryenFunctionImportGetModule"](this.#ptr));
		this.base = UTF8ToString(BinaryenObj["_BinaryenFunctionImportGetBase"](this.#ptr));
		this.name = UTF8ToString(BinaryenObj["_BinaryenFunctionGetName"](this.#ptr));
		this.type = BinaryenObj["_BinaryenFunctionGetType"](this.#ptr);
		this.params = BinaryenObj["_BinaryenFunctionGetParams"](this.#ptr);
		this.results = BinaryenObj["_BinaryenFunctionGetResults"](this.#ptr);
		this.numVars = BinaryenObj["_BinaryenFunctionGetNumVars"](this.#ptr);
		this.numLocals = BinaryenObj["_BinaryenFunctionGetNumLocals"](this.#ptr);
		this.vars = getAllNested(func, BinaryenObj["_BinaryenFunctionGetNumVars"], BinaryenObj["_BinaryenFunctionGetVar"]);
	}


	get body(): ExpressionRef {
		return BinaryenObj["_BinaryenFunctionGetBody"](this.#ptr);
	}

	set body(bodyExpr: ExpressionRef) {
		BinaryenObj["_BinaryenFunctionSetBody"](this.#ptr, bodyExpr);
	}


	valueOf(): FunctionRef {
		return this.#ptr;
	}

	getVar(index: number): Type {
		return BinaryenObj["_BinaryenFunctionGetVar"](this.#ptr, index);
	}

	hasLocalName(index: number): boolean {
		return Boolean(BinaryenObj["_BinaryenFunctionHasLocalName"](this.#ptr, index));
	}

	getLocalName(index: number): string {
		return UTF8ToString(BinaryenObj["_BinaryenFunctionGetLocalName"](this.#ptr, index));
	}

	setLocalName(index: number, name: string): void {
		preserveStack(() => {
			BinaryenObj["_BinaryenFunctionSetLocalName"](this.#ptr, index, strToStack(name));
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
			this.mod[PTR],
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
		return preserveStack(() => BinaryenObj["_BinaryenGetFunction"](this.mod[PTR], strToStack(name)));
	}

	/** Gets a function by index. */
	getByIndex(index: number): FunctionRef {
		return BinaryenObj["_BinaryenGetFunctionByIndex"](this.mod[PTR], index);
	}

	/** Gets the number of functions within the module. */
	count(): number {
		return BinaryenObj["_BinaryenGetNumFunctions"](this.mod[PTR]);
	}

	/** Removes a function by name. */
	remove(name: string): void {
		preserveStack(() => BinaryenObj["_BinaryenRemoveFunction"](this.mod[PTR], strToStack(name)));
	}
}
