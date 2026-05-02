import {
	_BinaryenSizeofAllocateAndWriteResult,
	_free,
	BinaryenObj,
	UTF8ToString,
	stackAlloc,
} from "../../-pre.ts";
import {
	type DataSegmentRef,
	type ExpressionRef,
	type FunctionRef,
	type HeapType,
	type TableRef,
	type Type,
	funcref,
} from "../../constants.ts";
import {
	copyExpression,
} from "../../globals.ts";
import {
	replacedBy,
} from "../../lib.ts";
import {
	HEAPU8,
	HEAPU32,
	i8sToStack,
	i32sToStack,
	preserveStack,
	strToStack,
} from "../../utils.ts";
import {
	expressionCreator,
} from "../expression/expression-creators.ts";
import * as DATA_SEGMENT from "./DataSegment.ts";
import * as ELEMENT_SEGMENT from "./ElementSegment.ts";
import * as EXPORT from "./Export.ts";
import * as FUNCTION from "./Function.ts";
import * as GLOBAL from "./Global.ts";
import * as IMPORT from "./Import.ts";
import * as MEMORY from "./Memory.ts";
import * as TABLE from "./Table.ts";
import * as TAG from "./Tag.ts";



/** Probably used in `BinaryenObj["_BinaryenModulePrintAsmjs"]`. */
declare let out: any;



/**
 * The size of a single literal in memory as used in Const creation,
 * which is a little different: we don’t want users to need to make
 * their own Literals, as the C API handles them by value, which means
 * we would leak them. Instead, Const creation is fused together with
 * an intermediate stack allocation of this size to pass the value.
 */
// eslint-disable-next-line @typescript-eslint/no-unused-vars
const SIZE_OF_LITERAL = BinaryenObj["_BinaryenSizeofLiteral"]();



export enum Feature {
	MVP = BinaryenObj["_BinaryenFeatureMVP"](),
	Atomics = BinaryenObj["_BinaryenFeatureAtomics"](),
	MutableGlobals = BinaryenObj["_BinaryenFeatureMutableGlobals"](),
	NontrappingFPToInt = BinaryenObj["_BinaryenFeatureNontrappingFPToInt"](),
	SIMD128 = BinaryenObj["_BinaryenFeatureSIMD128"](),
	BulkMemory = BinaryenObj["_BinaryenFeatureBulkMemory"](),
	SignExt = BinaryenObj["_BinaryenFeatureSignExt"](),
	ExceptionHandling = BinaryenObj["_BinaryenFeatureExceptionHandling"](),
	TailCall = BinaryenObj["_BinaryenFeatureTailCall"](),
	ReferenceTypes = BinaryenObj["_BinaryenFeatureReferenceTypes"](),
	Multivalue = BinaryenObj["_BinaryenFeatureMultivalue"](),
	GC = BinaryenObj["_BinaryenFeatureGC"](),
	Memory64 = BinaryenObj["_BinaryenFeatureMemory64"](),
	RelaxedSIMD = BinaryenObj["_BinaryenFeatureRelaxedSIMD"](),
	ExtendedConst = BinaryenObj["_BinaryenFeatureExtendedConst"](),
	Strings = BinaryenObj["_BinaryenFeatureStrings"](),
	MultiMemory = BinaryenObj["_BinaryenFeatureMultiMemory"](),
	StackSwitching = BinaryenObj["_BinaryenFeatureStackSwitching"](),
	SharedEverything = BinaryenObj["_BinaryenFeatureSharedEverything"](),
	FP16 = BinaryenObj["_BinaryenFeatureFP16"](),
	BulkMemoryOpt = BinaryenObj["_BinaryenFeatureBulkMemoryOpt"](),
	CallIndirectOverlong = BinaryenObj["_BinaryenFeatureCallIndirectOverlong"](),
	RelaxedAtomics = BinaryenObj["_BinaryenFeatureRelaxedAtomics"](),
	CustomPageSizes = BinaryenObj["_BinaryenFeatureCustomPageSizes"](),
	WideArithmetic = BinaryenObj["_BinaryenFeatureWideArithmetic"](),
	All = BinaryenObj["_BinaryenFeatureAll"](),
}



/**
 * A WASM module.
 *
 * `Module` itself is:
 * - an instantiable class (via `new Module()`)
 * - a namespace containing the following members, which themselves are classes (see related documentation):
 * 	- {@link Tag}
 * 	- {@link Global}
 * 	- {@link Memory}
 * 	- {@link Table}
 * 	- {@link Function}
 * 	- {@link DataSegment}
 * 	- {@link ElementSegment}
 * 	- {@link Import}
 * 	- {@link Export}
 *
 * Each instance of `Module` is:
 * - a WASM module with module manipulation methods (`.emitText()`, `.validate()`, etc.).
 * - an individual namespace containing mixins, each with its own component manipulation methods (`.tags.add()`, `.globals.get()`, etc):
 * 	- {@link TAG.ModuleTags | tags}
 * 	- {@link GLOBAL.ModuleGlobals | globals}
 * 	- {@link MEMORY.ModuleMemories | memories}
 * 	- {@link TABLE.ModuleTables | tables}
 * 	- {@link FUNCTION.ModuleFunctions | functions}
 * 	- {@link DATA_SEGMENT.ModuleDataSegments | dataSegments}
 * 	- {@link ELEMENT_SEGMENT.ModuleElementSegments | elementSegments}
 * 	- {@link IMPORT.ModuleImports | imports}
 * 	- {@link EXPORT.ModuleExports | exports}
 */
export class Module {
	readonly ptr: number = BinaryenObj["_BinaryenModuleCreate"]();

	/** This module’s expression creator. */
	readonly x = expressionCreator(this); // “x” for “expression”

	// ## Module Component Operations ## //
	// see https://webassembly.github.io/spec/core/syntax/modules.html
	readonly tags = new TAG.ModuleTags(this);
	readonly globals = new GLOBAL.ModuleGlobals(this);
	readonly memories = new MEMORY.ModuleMemories(this);
	readonly tables = new TABLE.ModuleTables(this);
	readonly functions = new FUNCTION.ModuleFunctions(this);
	readonly dataSegments = new DATA_SEGMENT.ModuleDataSegments(this);
	readonly elementSegments = new ELEMENT_SEGMENT.ModuleElementSegments(this);
	readonly imports = new IMPORT.ModuleImports(this);
	readonly exports = new EXPORT.ModuleExports(this);

	/** @deprecated Use `this.start` instead. */ @replacedBy("`this.start`") getStart() { return this.start; }
	/** @deprecated Use `this.start` instead. */ @replacedBy("`this.start`") setStart(start: FunctionRef) { this.start = start; }
	/** @deprecated Use `this.features` instead. */ @replacedBy("`this.features`") getFeatures() { return this.features; }
	/** @deprecated Use `this.features` instead. */ @replacedBy("`this.features`") setFeatures(features: Feature) { return this.features = features; }

	/** The start function. */
	get start(): FunctionRef {
		return BinaryenObj["_BinaryenGetStart"](this.ptr);
	}

	set start(start: FunctionRef) {
		BinaryenObj["_BinaryenSetStart"](this.ptr, start);
	}

	/**
	 * The WebAssembly features enabled for this module.
	 * Features are a bitmask of `Feature` enum members.
	 */
	get features(): Feature {
		return BinaryenObj["_BinaryenModuleGetFeatures"](this.ptr);
	}

	set features(features: Feature) {
		BinaryenObj["_BinaryenModuleSetFeatures"](this.ptr, features);
	}

	/** @deprecated Use `this.tags.add` instead. */ @replacedBy("`this.tags.add`") addTag(name: string, params: Type, results: Type) { return this.tags.add(name, params, results); }
	/** @deprecated Use `this.tags.get` instead. */ @replacedBy("`this.tags.get`") getTag(name: string) { return this.tags.get(name); }
	/** @deprecated Use `this.tags.remove` instead. */ @replacedBy("`this.tags.remove`") removeTag(name: string) { return this.tags.remove(name); }

	/** @deprecated Use `this.globals.add` instead. */ @replacedBy("`this.globals.add`") addGlobal(name: string, type: Type, mutable: boolean, init: ExpressionRef) { return this.globals.add(name, type, mutable, init); }
	/** @deprecated Use `this.globals.get` instead. */ @replacedBy("`this.globals.get`") getGlobal(name: string) { return this.globals.get(name); }
	/** @deprecated Use `this.globals.getByIndex` instead. */ @replacedBy("`this.globals.getByIndex`") getGlobalByIndex(index: number) { return this.globals.getByIndex(index); }
	/** @deprecated Use `this.globals.count` instead. */ @replacedBy("`this.globals.count`") getNumGlobals() { return this.globals.count(); }
	/** @deprecated Use `this.globals.remove` instead. */ @replacedBy("`this.globals.remove`") removeGlobal(name: string) { return this.globals.remove(name); }

	/** @deprecated Use `this.memories.set` instead. */ @replacedBy("`this.memories.set`") setMemory(initial: number, maximum: number, exportName: string, segments?: readonly any[], shared?: boolean, memory64?: boolean, internalName?: string) { return this.memories.set(initial, maximum, exportName, segments, shared, memory64, internalName); }
	/** @deprecated Use `this.memories.has` instead. */ @replacedBy("`this.memories.has`") hasMemory() { return this.memories.has(); }

	/** @deprecated Use `this.tables.add` instead. */ @replacedBy("`this.tables.add`") addTable(name: string, initial: number, maximum: number, type: Type = funcref, init?: ExpressionRef) { return this.tables.add(name, initial, maximum, type, init); }
	/** @deprecated Use `this.tables.get` instead. */ @replacedBy("`this.tables.get`") getTable(name: string) { return this.tables.get(name); }
	/** @deprecated Use `this.tables.getByIndex` instead. */ @replacedBy("`this.tables.getByIndex`") getTableByIndex(index: number) { return this.tables.getByIndex(index); }
	/** @deprecated Use `this.tables.getSegments` instead. */ @replacedBy("`this.tables.getSegments`") getTableSegments(table: TableRef) { return this.tables.getSegments(table); }
	/** @deprecated Use `this.tables.count` instead. */ @replacedBy("`this.tables.count`") getNumTables() { return this.tables.count(); }
	/** @deprecated Use `this.tables.remove` instead. */ @replacedBy("`this.tables.remove`") removeTable(name: string) { return this.tables.remove(name); }

	/** @deprecated Use `this.functions.add` instead. */ @replacedBy("`this.functions.add`") addFunction(name: string, params: Type, results: Type, varTypes: readonly Type[], body: ExpressionRef) { return this.functions.add(name, params, results, varTypes, body); }
	/** @deprecated Use `this.functions.get` instead. */ @replacedBy("`this.functions.get`") getFunction(name: string) { return this.functions.get(name); }
	/** @deprecated Use `this.functions.getByIndex` instead. */ @replacedBy("`this.functions.getByIndex`") getFunctionByIndex(index: number) { return this.functions.getByIndex(index); }
	/** @deprecated Use `this.functions.count` instead. */ @replacedBy("`this.functions.count`") getNumFunctions() { return this.functions.count(); }
	/** @deprecated Use `this.functions.remove` instead. */ @replacedBy("`this.functions.remove`") removeFunction(name: string) { return this.functions.remove(name); }

	/** @deprecated Use `this.dataSegments.get` instead. */ @replacedBy("`this.dataSegments.get`") getDataSegment(name: string) { return this.dataSegments.get(name); }
	/** @deprecated Use `this.dataSegments.getByIndex` instead. */ @replacedBy("`this.dataSegments.getByIndex`") getDataSegmentByIndex(index: number) { return this.dataSegments.getByIndex(index); }
	/** @deprecated Use `this.dataSegments.count` instead. */ @replacedBy("`this.dataSegments.count`") getNumDataSegments() { return this.dataSegments.count(); }

	/** @deprecated Use `this.elementSegments.addActive` instead. */ @replacedBy("`this.elementSegments.addActive`") addActiveElementSegment(table: string, name: string, funcNames: readonly string[], offset: ExpressionRef) { return this.elementSegments.addActive(table, name, funcNames, offset); }
	/** @deprecated Use `this.elementSegments.addPassive` instead. */ @replacedBy("`this.elementSegments.addPassive`") addPassiveElementSegment(name: string, funcNames: readonly string[]) { return this.elementSegments.addPassive(name, funcNames); }
	/** @deprecated Use `this.elementSegments.get` instead. */ @replacedBy("`this.elementSegments.get`") getElementSegment(name: string) { return this.elementSegments.get(name); }
	/** @deprecated Use `this.elementSegments.getByIndex` instead. */ @replacedBy("`this.elementSegments.getByIndex`") getElementSegmentByIndex(index: number) { return this.elementSegments.getByIndex(index); }
	/** @deprecated Use `this.elementSegments.count` instead. */ @replacedBy("`this.elementSegments.count`") getNumElementSegments() { return this.elementSegments.count(); }
	/** @deprecated Use `this.elementSegments.remove` instead. */ @replacedBy("`this.elementSegments.remove`") removeElementSegment(name: string) { return this.elementSegments.remove(name); }

	/** @deprecated Use `this.imports.addTag` instead. */ @replacedBy("`this.imports.addTag`") addTagImport(internalName: string, externalModuleName: string, externalBaseName: string, params: Type, results: Type) { return this.imports.addTag(internalName, externalModuleName, externalBaseName, params, results); }
	/** @deprecated Use `this.imports.addGlobal` instead. */ @replacedBy("`this.imports.addGlobal`") addGlobalImport(internalName: string, externalModuleName: string, externalBaseName: string, globalType: Type, mutable: boolean) { return this.imports.addGlobal(internalName, externalModuleName, externalBaseName, globalType, mutable); }
	/** @deprecated Use `this.imports.addMemory` instead. */ @replacedBy("`this.imports.addMemory`") addMemoryImport(internalName: string, externalModuleName: string, externalBaseName: string, shared: boolean) { return this.imports.addMemory(internalName, externalModuleName, externalBaseName, shared); }
	/** @deprecated Use `this.imports.addTable` instead. */ @replacedBy("`this.imports.addTable`") addTableImport(internalName: string, externalModuleName: string, externalBaseName: string) { return this.imports.addTable(internalName, externalModuleName, externalBaseName); }
	/** @deprecated Use `this.imports.addFunction` instead. */ @replacedBy("`this.imports.addFunction`") addFunctionImport(internalName: string, externalModuleName: string, externalBaseName: string, params: Type, results: Type) { return this.imports.addFunction(internalName, externalModuleName, externalBaseName, params, results); }

	/** @deprecated Use `this.exports.addTag` instead. */ @replacedBy("`this.exports.addTag`") addTagExport(internalName: string, externalName: string) { return this.exports.addTag(internalName, externalName); }
	/** @deprecated Use `this.exports.addGlobal` instead. */ @replacedBy("`this.exports.addGlobal`") addGlobalExport(internalName: string, externalName: string) { return this.exports.addGlobal(internalName, externalName); }
	/** @deprecated Use `this.exports.addMemory` instead. */ @replacedBy("`this.exports.addMemory`") addMemoryExport(internalName: string, externalName: string) { return this.exports.addMemory(internalName, externalName); }
	/** @deprecated Use `this.exports.addTable` instead. */ @replacedBy("`this.exports.addTable`") addTableExport(internalName: string, externalName: string) { return this.exports.addTable(internalName, externalName); }
	/** @deprecated Use `this.exports.addFunction` instead. */ @replacedBy("`this.exports.addFunction`") addFunctionExport(internalName: string, externalName: string) { return this.exports.addFunction(internalName, externalName); }
	/** @deprecated Use `this.exports.get` instead. */ @replacedBy("`this.exports.get`") getExport(externalName: string) { return this.exports.get(externalName); }
	/** @deprecated Use `this.exports.getByIndex` instead. */ @replacedBy("`this.exports.getByIndex`") getExportByIndex(index: number) { return this.exports.getByIndex(index); }
	/** @deprecated Use `this.exports.count` instead. */ @replacedBy("`this.exports.count`") getNumExports() { return this.exports.count(); }
	/** @deprecated Use `this.exports.remove` instead. */ @replacedBy("`this.exports.remove`") removeExport(externalName: string) { return this.exports.remove(externalName); }

	getMemoryInfo(name: string): MEMORY.Memory {
		return new MEMORY.Memory(this, name);
	}

	getDataSegmentInfo(segment: DataSegmentRef): DATA_SEGMENT.DataSegment {
		return new DATA_SEGMENT.DataSegment(this, segment);
	}

	// ## Binaryen Operations ## //
	// ### Emission & Execution ### //
	/** Returns the module in Binaryen’s s-expression text format (not official stack-style text format). */
	emitText(): string {
		const textPtr = BinaryenObj["_BinaryenModuleAllocateAndWriteText"](this.ptr);
		const text = UTF8ToString(textPtr);
		if (textPtr) {
			_free(textPtr);
		}
		return text;
	}

	/** Returns the module in official stack-style text format. */
	emitStackIR(): string {
		const textPtr = BinaryenObj["_BinaryenModuleAllocateAndWriteStackIR"](this.ptr);
		const text = UTF8ToString(textPtr);
		if (textPtr) {
			_free(textPtr);
		}
		return text;
	}

	/** Returns the [asm.js](http://asmjs.org/) representation of the module. */
	emitAsmjs(): string {
		let returned = "";
		const saved = out;
		out = (x: string) => {
			returned += `${ x }\n`;
		};
		BinaryenObj["_BinaryenModulePrintAsmjs"](this.ptr);
		out = saved;
		return returned;
	}

	/** Returns the module in binary format. */
	emitBinary(): Uint8Array;
	/** Returns the module in binary format with a given source map. */
	emitBinary(sourceMapUrl: string): {binary: Uint8Array, sourceMap: string};
	emitBinary(sourceMapUrl?: string): Uint8Array | {binary: Uint8Array, sourceMap: string} {
		return preserveStack(() => {
			const tempBuffer = stackAlloc(_BinaryenSizeofAllocateAndWriteResult());
			BinaryenObj["_BinaryenModuleAllocateAndWrite"](tempBuffer, this.ptr, strToStack(sourceMapUrl));
			const binaryPtr = HEAPU32[tempBuffer >>> 2];
			const binaryBytes = HEAPU32[(tempBuffer >>> 2) + 1];
			const sourceMapPtr = HEAPU32[(tempBuffer >>> 2) + 2];
			try {
				const buffer = new Uint8Array(binaryBytes);
				buffer.set(HEAPU8.subarray(binaryPtr, binaryPtr + binaryBytes));
				return typeof sourceMapUrl === "undefined"
					? buffer
					: {binary: buffer, sourceMap: UTF8ToString(sourceMapPtr)};
			} finally {
				_free(binaryPtr);
				if (sourceMapPtr) {
					_free(sourceMapPtr);
				}
			}
		});
	}

	/** Runs the module in the interpreter, calling the start function. */
	interpret(): void {
		BinaryenObj["_BinaryenModuleInterpret"](this.ptr);
	}

	/** Releases the resources held by the module once it isn't needed anymore. */
	dispose(): void {
		BinaryenObj["_BinaryenModuleDispose"](this.ptr);
	}

	// ### Validation & Optimization ### //
	/** Validates the module. Returns `true` if valid, otherwise prints validation errors and returns `false`. */
	validate(): number {
		return BinaryenObj["_BinaryenModuleValidate"](this.ptr);
	}

	/** Optimizes the module using the default optimization passes. */
	optimize(): void {
		BinaryenObj["_BinaryenModuleOptimize"](this.ptr);
	}

	/** Optimizes a single function using the default optimization passes. */
	optimizeFunction(func: FunctionRef | string): void {
		if (typeof func === "string") {
			func = this.functions.get(func);
		}
		BinaryenObj["_BinaryenFunctionOptimize"](func, this.ptr);
	}

	/** Runs the specified passes on the module. */
	runPasses(passes: readonly string[]): void {
		return preserveStack(() => {
			BinaryenObj["_BinaryenModuleRunPasses"](this.ptr, i32sToStack(passes.map(strToStack)), passes.length);
		});
	}

	/** Runs the specified passes on a single function. */
	runPassesOnFunction(func: string | FunctionRef, passes: readonly string[]): void {
		if (typeof func === "string") {
			func = this.functions.get(func);
		}
		return preserveStack(() => {
			BinaryenObj["_BinaryenFunctionRunPasses"](func, this.ptr, i32sToStack(passes.map(strToStack)), passes.length);
		});
	}

	// ### Debugging ### //
	/** Adds a debug info file name to the module and returns its index. */
	addDebugInfoFileName(filename: string): number {
		return preserveStack(() => BinaryenObj["_BinaryenModuleAddDebugInfoFileName"](this.ptr, strToStack(filename)));
	}

	/** Gets the name of the debug info file at the specified index. */
	getDebugInfoFileName(index: number): string {
		return UTF8ToString(BinaryenObj["_BinaryenModuleGetDebugInfoFileName"](this.ptr, index));
	}

	/** Sets the debug location of the specified `ExpressionRef` within the specified `FunctionRef`. */
	setDebugLocation(func: FunctionRef, expr: ExpressionRef, fileIndex: number, lineNumber: number, columnNumber: number): void {
		BinaryenObj["_BinaryenFunctionSetDebugLocation"](func, expr, fileIndex, lineNumber, columnNumber);
	}

	// ### Other ### //
	/** [description] */
	setTypeName(heapType: HeapType, name: string): void {
		return preserveStack(() => {
			BinaryenObj["_BinaryenModuleSetTypeName"](this.ptr, heapType, strToStack(name));
		});
	}

	/** [description] */
	setFieldName(heapType: HeapType, index: number, name: string): void {
		return preserveStack(() => {
			BinaryenObj["_BinaryenModuleSetFieldName"](this.ptr, heapType, index, strToStack(name));
		});
	}

	/** Adds a custom section to the binary. */
	addCustomSection(name: string, contents: Uint8Array): void {
		return preserveStack(() => {
			BinaryenObj["_BinaryenAddCustomSection"](this.ptr, strToStack(name), i8sToStack([...contents]), contents.length);
		});
	}

	/** [description] */
	updateMaps(): void {
		BinaryenObj["_BinaryenModuleUpdateMaps"](this.ptr);
	}

	/** @deprecated Use global `copyExpression(expr, this)` instead. */
	@replacedBy("global `copyExpression(expr, this)`")
	copyExpression(expr: ExpressionRef) {
		return copyExpression(expr, this);
	}
}



/**
 * A collection of types and classes related to WASM module manipulation.
 *
 * Each class represents a component of a WASM module,
 * and its corresponding type is included for documentation.
 */
// eslint-disable-next-line no-redeclare
export namespace Module {
	export type Tag = TAG.Tag;
	export type Global = GLOBAL.Global;
	export type Memory = MEMORY.Memory;
	export type Table = TABLE.Table;
	export type Function = FUNCTION.Function;
	export type DataSegment = DATA_SEGMENT.DataSegment;
	export type ElementSegment = ELEMENT_SEGMENT.ElementSegment;
	export type Import = IMPORT.Import;
	export type Export = EXPORT.Export;

	export const Tag = TAG.Tag;
	export const Global = GLOBAL.Global;
	export const Memory = MEMORY.Memory;
	export const Table = TABLE.Table;
	export const Function = FUNCTION.Function;
	export const DataSegment = DATA_SEGMENT.DataSegment;
	export const ElementSegment = ELEMENT_SEGMENT.ElementSegment;
	export const Import = IMPORT.Import;
	export const Export = EXPORT.Export;
}
