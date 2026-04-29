import {
	BinaryenObj,
	UTF8ToString,
} from "../-pre.ts";
import type {
	ExpressionRef,
	FunctionRef,
	Type,
} from "../constants.ts";
import {
	replacedBy,
} from "../lib.ts";
import {
	THIS_PTR,
	preserveStack,
	strToStack,
} from "../utils.ts";



class BinaryenFunction {
	/* eslint-disable @stylistic/brace-style */
	@replacedBy("`instance.getName`") static getName(func: FunctionRef) { return BinaryenFunction.prototype.getName.call({[THIS_PTR]: func}); }
	@replacedBy("`instance.getType`") static getType(func: FunctionRef) { return BinaryenFunction.prototype.getType.call({[THIS_PTR]: func}); }
	@replacedBy("`instance.getParams`") static getParams(func: FunctionRef) { return BinaryenFunction.prototype.getParams.call({[THIS_PTR]: func}); }
	@replacedBy("`instance.getResults`") static getResults(func: FunctionRef) { return BinaryenFunction.prototype.getResults.call({[THIS_PTR]: func}); }
	@replacedBy("`instance.getNumVars`") static getNumVars(func: FunctionRef) { return BinaryenFunction.prototype.getNumVars.call({[THIS_PTR]: func}); }
	@replacedBy("`instance.getVar`") static getVar(func: FunctionRef, index: number) { return BinaryenFunction.prototype.getVar.call({[THIS_PTR]: func}, index); }
	@replacedBy("`instance.getNumLocals`") static getNumLocals(func: FunctionRef) { return BinaryenFunction.prototype.getNumLocals.call({[THIS_PTR]: func}); }
	@replacedBy("`instance.hasLocalName`") static hasLocalName(func: FunctionRef, index: number) { return BinaryenFunction.prototype.hasLocalName.call({[THIS_PTR]: func}, index); }
	@replacedBy("`instance.getLocalName`") static getLocalName(func: FunctionRef, index: number) { return BinaryenFunction.prototype.getLocalName.call({[THIS_PTR]: func}, index); }
	@replacedBy("`instance.setLocalName`") static setLocalName(func: FunctionRef, index: number, name: string) { return BinaryenFunction.prototype.setLocalName.call({[THIS_PTR]: func}, index, name); }
	@replacedBy("`instance.getBody`") static getBody(func: FunctionRef) { return BinaryenFunction.prototype.getBody.call({[THIS_PTR]: func}); }
	@replacedBy("`instance.setBody`") static setBody(func: FunctionRef, bodyExpr: ExpressionRef) { return BinaryenFunction.prototype.setBody.call({[THIS_PTR]: func}, bodyExpr); }
	/* eslint-enable @stylistic/brace-style */


	private readonly [THIS_PTR]: FunctionRef;

	constructor(func: FunctionRef) {
		this[THIS_PTR] = func;
	}

	valueOf() {
		return this[THIS_PTR];
	}

	// TODO: post.js has converted all methods starting with `get` to getters and `set` to setters
	getName(): string {
		return UTF8ToString(BinaryenObj["_BinaryenFunctionGetName"](this[THIS_PTR]));
	}

	getType() {
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
