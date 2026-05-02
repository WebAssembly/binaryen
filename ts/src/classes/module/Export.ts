import {
	BinaryenObj,
	UTF8ToString,
} from "../../-pre.ts";
import type {
	ExportRef,
	ExternalKind,
} from "../../constants.ts";
import {
	preserveStack,
	strToStack,
} from "../../utils.ts";
import type {
	Module,
} from "./Module.ts";



/** Information about an export in a WASM module. */
export class Export {
	readonly kind: ExternalKind;
	readonly name: string;
	readonly value: string;


	constructor(xport: ExportRef) {
		this.kind = BinaryenObj["_BinaryenExportGetKind"](xport);
		this.name = UTF8ToString(BinaryenObj["_BinaryenExportGetName"](xport));
		this.value = UTF8ToString(BinaryenObj["_BinaryenExportGetValue"](xport));
	}
}



/** Methods for manipulating exports in a WASM module. */
export class ModuleExports {
	constructor(private readonly mod: Module) {}

	get(externalName: string): ExportRef {
		return preserveStack(() => BinaryenObj["_BinaryenGetExport"](this.mod.ptr, strToStack(externalName)));
	}

	getByIndex(index: number): ExportRef {
		return BinaryenObj["_BinaryenGetExportByIndex"](this.mod.ptr, index);
	}

	count(): number {
		return BinaryenObj["_BinaryenGetNumExports"](this.mod.ptr);
	}

	remove(externalName: string): void {
		return preserveStack(() => {
			BinaryenObj["_BinaryenRemoveExport"](this.mod.ptr, strToStack(externalName));
		});
	}

	addTag(internalName: string, externalName: string): ExportRef {
		return this.#addComponent("_BinaryenAddTagExport", internalName, externalName);
	}

	addGlobal(internalName: string, externalName: string): ExportRef {
		return this.#addComponent("_BinaryenAddGlobalExport", internalName, externalName);
	}

	addMemory(internalName: string, externalName: string): ExportRef {
		return this.#addComponent("_BinaryenAddMemoryExport", internalName, externalName);
	}

	addTable(internalName: string, externalName: string): ExportRef {
		return this.#addComponent("_BinaryenAddTableExport", internalName, externalName);
	}

	addFunction(internalName: string, externalName: string): ExportRef {
		return this.#addComponent("_BinaryenAddFunctionExport", internalName, externalName);
	}

	#addComponent(binaryenFuncName: string, internalName: string, externalName: string): ExportRef {
		return preserveStack(() => BinaryenObj[binaryenFuncName](this.mod.ptr, strToStack(internalName), strToStack(externalName)));
	}
}
