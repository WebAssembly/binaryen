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



export class ModuleImports {
	constructor(private readonly mod: Module) {}

	addTag(internalName: string, externalModuleName: string, externalBaseName: string, params: Type, results: Type): void {
		return preserveStack(() => {
			BinaryenObj["_BinaryenAddTagImport"](
				this.mod.ptr,
				strToStack(internalName),
				strToStack(externalModuleName),
				strToStack(externalBaseName),
				params,
				results,
			);
		});
	}

	addGlobal(internalName: string, externalModuleName: string, externalBaseName: string, globalType: Type, mutable: boolean): void {
		return preserveStack(() => {
			BinaryenObj["_BinaryenAddGlobalImport"](
				this.mod.ptr,
				strToStack(internalName),
				strToStack(externalModuleName),
				strToStack(externalBaseName),
				globalType,
				mutable,
			);
		});
	}

	addMemory(internalName: string, externalModuleName: string, externalBaseName: string, shared: boolean): void {
		return preserveStack(() => {
			BinaryenObj["_BinaryenAddMemoryImport"](
				this.mod.ptr,
				strToStack(internalName),
				strToStack(externalModuleName),
				strToStack(externalBaseName),
				shared,
			);
		});
	}

	addTable(internalName: string, externalModuleName: string, externalBaseName: string): void {
		return preserveStack(() => {
			BinaryenObj["_BinaryenAddTableImport"](
				this.mod.ptr,
				strToStack(internalName),
				strToStack(externalModuleName),
				strToStack(externalBaseName),
			);
		});
	}

	addFunction(internalName: string, externalModuleName: string, externalBaseName: string, params: Type, results: Type): void {
		return preserveStack(() => {
			BinaryenObj["_BinaryenAddFunctionImport"](
				this.mod.ptr,
				strToStack(internalName),
				strToStack(externalModuleName),
				strToStack(externalBaseName),
				params,
				results,
			);
		});
	}
}
