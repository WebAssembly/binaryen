import {
	BinaryenObj,
	UTF8ToString,
} from "../../-pre.ts";
import {
	strToStack,
} from "../../utils.ts";
import type {
	Module,
} from "./Module.ts";



/** Information about a memory in a WASM module. */
export class Memory {
	readonly module: string;
	readonly base: string;
	readonly initial: number;
	readonly shared: boolean;
	readonly is64: boolean;
	readonly max?: number;


	constructor(mod: Module, name: string) {
		this.module = UTF8ToString(BinaryenObj["_BinaryenMemoryImportGetModule"](mod.ptr, strToStack(name)));
		this.base = UTF8ToString(BinaryenObj["_BinaryenMemoryImportGetBase"](mod.ptr, strToStack(name)));
		this.initial = BinaryenObj["_BinaryenMemoryGetInitial"](mod.ptr, strToStack(name));
		this.shared = Boolean(BinaryenObj["_BinaryenMemoryIsShared"](mod.ptr, strToStack(name)));
		this.is64 = Boolean(BinaryenObj["_BinaryenMemoryIs64"](mod.ptr, strToStack(name)));
		if (BinaryenObj["_BinaryenMemoryHasMax"](mod.ptr, strToStack(name))) {
			this.max = BinaryenObj["_BinaryenMemoryGetMax"](mod.ptr, strToStack(name));
		}
	}
}
