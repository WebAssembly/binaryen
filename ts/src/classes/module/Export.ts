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



/**
 * Information about an export in a WASM module.
 */
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



/**
 * Methods for manipulating exports in a WASM module.
 * @inline
 */
export class ModuleExports {
	constructor(private readonly mod: Module) {}

	/** Gets an export by name. */
	get(externalName: string): ExportRef {
		return preserveStack(() => BinaryenObj["_BinaryenGetExport"](this.mod.ptr, strToStack(externalName)));
	}

	/** Gets an export by index. */
	getByIndex(index: number): ExportRef {
		return BinaryenObj["_BinaryenGetExportByIndex"](this.mod.ptr, index);
	}

	/** Gets the number of exports witin the module. */
	count(): number {
		return BinaryenObj["_BinaryenGetNumExports"](this.mod.ptr);
	}

	/** Removes an export, by external name. */
	remove(externalName: string): void {
		preserveStack(() => BinaryenObj["_BinaryenRemoveExport"](this.mod.ptr, strToStack(externalName)));
	}

	/** Adds a tag export. */
	addTag(internalName: string, externalName: string): ExportRef {
		return this.#addComponent("_BinaryenAddTagExport", internalName, externalName);
	}

	/** Adds a global variable export. Exported globals must be immutable. */
	addGlobal(internalName: string, externalName: string): ExportRef {
		return this.#addComponent("_BinaryenAddGlobalExport", internalName, externalName);
	}

	/** Adds a memory export. There’s just one memory for now, using name "0". */
	addMemory(internalName: string, externalName: string): ExportRef {
		return this.#addComponent("_BinaryenAddMemoryExport", internalName, externalName);
	}

	/** Adds a table export. There’s just one table for now, using name "0". */
	addTable(internalName: string, externalName: string): ExportRef {
		return this.#addComponent("_BinaryenAddTableExport", internalName, externalName);
	}

	/** Adds a function export. */
	addFunction(internalName: string, externalName: string): ExportRef {
		return this.#addComponent("_BinaryenAddFunctionExport", internalName, externalName);
	}

	#addComponent(binaryenFuncName: string, internalName: string, externalName: string): ExportRef {
		return preserveStack(() => BinaryenObj[binaryenFuncName](this.mod.ptr, strToStack(internalName), strToStack(externalName)));
	}
}
