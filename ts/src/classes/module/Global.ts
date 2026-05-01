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



export class ModuleGlobals {
	constructor(private readonly mod: Module) {}

	add(name: string, type: Type, mutable: boolean, init: ExpressionRef): GlobalRef {
		return preserveStack(() => BinaryenObj["_BinaryenAddGlobal"](this.mod.ptr, strToStack(name), type, mutable, init));
	}

	get(name: string): GlobalRef {
		return preserveStack(() => BinaryenObj["_BinaryenGetGlobal"](this.mod.ptr, strToStack(name)));
	}

	getByIndex(index: number): GlobalRef {
		return BinaryenObj["_BinaryenGetGlobalByIndex"](this.mod.ptr, index);
	}

	count(): number {
		return BinaryenObj["_BinaryenGetNumGlobals"](this.mod.ptr);
	}

	remove(name: string): void {
		return preserveStack(() => {
			BinaryenObj["_BinaryenRemoveGlobal"](this.mod.ptr, strToStack(name));
		});
	}
}
