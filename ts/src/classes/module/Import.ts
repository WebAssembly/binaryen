import {
	BinaryenObj,
} from "../../-pre.ts";
import type {
	Type,
} from "../../constants.ts";
import {
	preserveStack,
	strToStack,
} from "../../utils.ts";
import type {
	Module,
} from "./Module.ts";



/** Information about an import in a WASM module. */
export class Import {
	constructor() {}
}



/** Methods for manipulating imports in a WASM module. */
export class ModuleImports {
	constructor(private readonly mod: Module) {}

	addTag(internalName: string, externalModuleName: string, externalBaseName: string, params: Type, results: Type): void {
		return this.#addComponent("_BinaryenAddTagImport", internalName, externalModuleName, externalBaseName, params, results);
	}

	addGlobal(internalName: string, externalModuleName: string, externalBaseName: string, globalType: Type, mutable: boolean): void {
		return this.#addComponent("_BinaryenAddGlobalImport", internalName, externalModuleName, externalBaseName, globalType, mutable);
	}

	addMemory(internalName: string, externalModuleName: string, externalBaseName: string, shared: boolean): void {
		return this.#addComponent("_BinaryenAddMemoryImport", internalName, externalModuleName, externalBaseName, shared);
	}

	addTable(internalName: string, externalModuleName: string, externalBaseName: string): void {
		return this.#addComponent("_BinaryenAddTableImport", internalName, externalModuleName, externalBaseName);
	}

	addFunction(internalName: string, externalModuleName: string, externalBaseName: string, params: Type, results: Type): void {
		return this.#addComponent("_BinaryenAddFunctionImport", internalName, externalModuleName, externalBaseName, params, results);
	}

	#addComponent(binaryenFuncName: string, internalName: string, externalModuleName: string, externalBaseName: string, ...rest: any[]): void {
		return preserveStack(() => {
			BinaryenObj[binaryenFuncName](
				this.mod.ptr,
				strToStack(internalName),
				strToStack(externalModuleName),
				strToStack(externalBaseName),
				...rest,
			);
		});
	}
}
