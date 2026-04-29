import type {
	FunctionRef,
} from "../constants.ts";
import {
	THIS_PTR,
} from "../utils.ts";



class BinaryenFunction {
	// TODO: static methods are deprecated; convert to instance and log warnings
	static getName() {}
	static getType() {}
	static getParams() {}
	static getResults() {}
	static getNumVars() {}
	static getVar() {}
	static getNumLocals() {}
	static hasLocalName() {}
	static getLocalName() {}
	static setLocalName() {}
	static getBody() {}
	static setBody() {}


	private readonly [THIS_PTR]: FunctionRef;

	constructor(func: FunctionRef) {
		this[THIS_PTR] = func;
	}

	valueOf() {
		return this[THIS_PTR];
	}
}
export {BinaryenFunction as Function};
