import {
	BinaryenObj,
	UTF8ToString,
} from "../../-pre.ts";
import type {
	ExpressionRef,
	GlobalRef,
	Type,
} from "../../constants.ts";
import {
	preserveStack,
	strToStack,
} from "../../utils.ts";
import type {
	Module,
} from "./Module.ts";



/**
 * Information about a global in a WASM module.
 */
export class Global {
	readonly name: string;
	readonly module: string;
	readonly base: string;
	readonly type: Type;
	readonly mutable: boolean;
	readonly init: ExpressionRef;


	constructor(global: GlobalRef) {
		this.name = UTF8ToString(BinaryenObj["_BinaryenGlobalGetName"](global));
		this.module = UTF8ToString(BinaryenObj["_BinaryenGlobalImportGetModule"](global));
		this.base = UTF8ToString(BinaryenObj["_BinaryenGlobalImportGetBase"](global));
		this.type = BinaryenObj["_BinaryenGlobalGetType"](global);
		this.mutable = Boolean(BinaryenObj["_BinaryenGlobalIsMutable"](global));
		this.init = BinaryenObj["_BinaryenGlobalGetInitExpr"](global);
	}
}



/**
 * Methods for manipulating globals in a WASM module.
 * @inline
 */
export class ModuleGlobals {
	constructor(private readonly mod: Module) {}

	/** Adds a global instance variable. */
	add(name: string, type: Type, mutable: boolean, init: ExpressionRef): GlobalRef {
		return preserveStack(() => BinaryenObj["_BinaryenAddGlobal"](this.mod.ptr, strToStack(name), type, mutable, init));
	}

	/** Gets a global by name. */
	get(name: string): GlobalRef {
		return preserveStack(() => BinaryenObj["_BinaryenGetGlobal"](this.mod.ptr, strToStack(name)));
	}

	/** Gets a global by index. */
	getByIndex(index: number): GlobalRef {
		return BinaryenObj["_BinaryenGetGlobalByIndex"](this.mod.ptr, index);
	}

	/** Gets the number of globals within the module. */
	count(): number {
		return BinaryenObj["_BinaryenGetNumGlobals"](this.mod.ptr);
	}

	/** Removes a global by name. */
	remove(name: string): void {
		return preserveStack(() => {
			BinaryenObj["_BinaryenRemoveGlobal"](this.mod.ptr, strToStack(name));
		});
	}
}
