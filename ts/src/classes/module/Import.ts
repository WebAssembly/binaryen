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



/**
 * Information about an import in a WASM module.
 * @see {@link ModuleImports}
 */
export class Import {
	constructor() {}
}



/**
 * Methods for manipulating {@link Import | imports} in a WASM module.
 */
export class ModuleImports {
	constructor(private readonly mod: Module) {}

	/** Adds a tag import. */
	addTag(internalName: string, externalModuleName: string, externalBaseName: string, params: Type, results: Type): void {
		return this.#addComponent("_BinaryenAddTagImport", internalName, externalModuleName, externalBaseName, params, results);
	}

	/** Adds a global variable import. Imported globals must be immutable. */
	addGlobal(internalName: string, externalModuleName: string, externalBaseName: string, globalType: Type, mutable: boolean): void {
		return this.#addComponent("_BinaryenAddGlobalImport", internalName, externalModuleName, externalBaseName, globalType, mutable);
	}

	/** Adds a memory import. There’s just one memory for now, using name "0". */
	addMemory(internalName: string, externalModuleName: string, externalBaseName: string, shared: boolean): void {
		return this.#addComponent("_BinaryenAddMemoryImport", internalName, externalModuleName, externalBaseName, shared);
	}

	/** Adds a table import. There’s just one table for now, using name "0". */
	addTable(internalName: string, externalModuleName: string, externalBaseName: string): void {
		return this.#addComponent("_BinaryenAddTableImport", internalName, externalModuleName, externalBaseName);
	}

	/** Adds a function import. */
	addFunction(internalName: string, externalModuleName: string, externalBaseName: string, params: Type, results: Type): void {
		return this.#addComponent("_BinaryenAddFunctionImport", internalName, externalModuleName, externalBaseName, params, results);
	}

	#addComponent(binaryenFuncName: string, internalName: string, externalModuleName: string, externalBaseName: string, ...rest: any[]): void {
		preserveStack(() => BinaryenObj[binaryenFuncName](
			this.mod.ptr,
			strToStack(internalName),
			strToStack(externalModuleName),
			strToStack(externalBaseName),
			...rest,
		));
	}
}
