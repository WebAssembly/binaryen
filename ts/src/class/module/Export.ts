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



export class ModuleExports {
	constructor(private readonly mod: Module) {}

	addTag(internalName: string, externalName: string): ExportRef {
		return preserveStack(() => BinaryenObj["_BinaryenAddTagExport"](this.mod.ptr, strToStack(internalName), strToStack(externalName)));
	}

	addGlobal(internalName: string, externalName: string): ExportRef {
		return preserveStack(() => BinaryenObj["_BinaryenAddGlobalExport"](this.mod.ptr, strToStack(internalName), strToStack(externalName)));
	}

	addMemory(internalName: string, externalName: string): ExportRef {
		return preserveStack(() => BinaryenObj["_BinaryenAddMemoryExport"](this.mod.ptr, strToStack(internalName), strToStack(externalName)));
	}

	addTable(internalName: string, externalName: string): ExportRef {
		return preserveStack(() => BinaryenObj["_BinaryenAddTableExport"](this.mod.ptr, strToStack(internalName), strToStack(externalName)));
	}

	addFunction(internalName: string, externalName: string): ExportRef {
		return preserveStack(() => BinaryenObj["_BinaryenAddFunctionExport"](this.mod.ptr, strToStack(internalName), strToStack(externalName)));
	}

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
}
