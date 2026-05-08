import {
	_free,
	BinaryenObj,
	HEAPU8,
	HEAPU32,
	UTF8ToString,
	stackAlloc,
} from "../../-pre.ts";
import {
	i8sToStack,
	i32sToStack,
	preserveStack,
	strToStack,
} from "../../-utils.ts";
import {
	type DataSegmentRef,
	type ExpressionRef,
	type FunctionRef,
	type HeapType,
	type SideEffect,
	type TableRef,
	type Type,
	i32,
	i64,
	f32,
	f64,
	v128,
	anyref,
	eqref,
	i31ref,
	structref,
	arrayref,
	funcref,
	externref,
	stringref,
} from "../../constants.ts";
import {
	replacedBy,
} from "../../lib.ts";
import {
	type ExpressionBuilder,
	expressionBuilder,
} from "../../services/expression-builder/expressionBuilder.ts";
import {
	DataSegment as DataSegment_,
	ModuleDataSegments,
} from "./DataSegment.ts";
import {
	ElementSegment as ElementSegment_,
	ModuleElementSegments,
} from "./ElementSegment.ts";
import {
	Export as Export_,
	ModuleExports,
} from "./Export.ts";
import {
	Function as Function_,
	ModuleFunctions,
} from "./Function.ts";
import {
	Global as Global_,
	ModuleGlobals,
} from "./Global.ts";
import {
	Import as Import_,
	ModuleImports,
} from "./Import.ts";
import {
	Memory as Memory_,
	ModuleMemories,
} from "./Memory.ts";
import {
	ModuleTables,
	Table as Table_,
} from "./Table.ts";
import {
	ModuleTags,
	Tag as Tag_,
} from "./Tag.ts";



/** Probably used in `BinaryenObj["_BinaryenModulePrintAsmjs"]`. */
declare let out: any;



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
 * 	- {@link Module.Tag}
 * 	- {@link Module.Global}
 * 	- {@link Module.Memory}
 * 	- {@link Module.Table}
 * 	- {@link Module.Function}
 * 	- {@link Module.DataSegment}
 * 	- {@link Module.ElementSegment}
 * 	- {@link Module.Import}
 * 	- {@link Module.Export}
 *
 * Each instance of `Module`:
 * - is a WASM module with module manipulation methods (`.emitText()`, `.validate()`, etc.).
 * - is an individual namespace containing mixins, each with its own component manipulation methods (`.tags.add()`, `.globals.get()`, etc):
 * 	- {@link Module#tags}
 * 	- {@link Module#globals}
 * 	- {@link Module#memories}
 * 	- {@link Module#tables}
 * 	- {@link Module#functions}
 * 	- {@link Module#dataSegments}
 * 	- {@link Module#elementSegments}
 * 	- {@link Module#imports}
 * 	- {@link Module#exports}
 * - has a property `.wasm`, a namespace for creating expressions in the module (`.wasm.nop()`, `.wasm.i32.add()`, etc.)
 */
export class Module {
	/** @class */ static readonly Tag = Tag_;
	/** @class */ static readonly Global = Global_;
	/** @class */ static readonly Memory = Memory_;
	/** @class */ static readonly Table = Table_;
	/** @class */ static readonly Function = Function_;
	/** @class */ static readonly DataSegment = DataSegment_;
	/** @class */ static readonly ElementSegment = ElementSegment_;
	/** @class */ static readonly Import = Import_;
	/** @class */ static readonly Export = Export_;


	/** @internal */
	readonly ptr: number = BinaryenObj["_BinaryenModuleCreate"]();

	// ## Expression Manipulation ## //
	/**
	 * This module’s WASM expression builder.
	 *
	 * See {@link ExpressionBuilder} for its type signature.
	 *
	 * N.B.: For convenience, developers may want to destructure the module to free `wasm`:
	 * ```ts
	 * const mod = new Module();
	 * const {wasm} = mod;
	 * wasm.drop(wasm.i32.add(wasm.i32.const(3), wasm.i32.const(5)));
	 * ```
	 * or to free its properties:
	 * ```ts
	 * const {i32, drop} = mod.wasm;
	 * drop(i32.add(i32.const(3), i32.const(5)));
	 * ```
	 * @category Expression Manipulation
	 */
	readonly wasm: ExpressionBuilder = expressionBuilder(this);

	/**
	 * Pseudo-instruction enabling Binaryen to reason about multiple values on the stack.
	 * @category Expression Manipulation
	 */
	pop(typ: Type): ExpressionRef {
		if ([
			i32,
			i64,
			f32,
			f64,
			v128,
			anyref,
			eqref,
			i31ref,
			structref,
			arrayref,
			funcref,
			externref,
			stringref,
		].includes(typ)) {
			return BinaryenObj["_BinaryenPop"](this.ptr, typ);
		} else {
			throw new Error(`Unexpected type ${ typ }.`);
		}
	}

	/**
	 * Gets the side effects of the specified expression.
	 * @category Expression Manipulation
	 */
	getSideEffects(expr: ExpressionRef): SideEffect {
		return BinaryenObj["_BinaryenExpressionGetSideEffects"](expr, this.ptr);
	}

	/**
	 * Creates a deep copy of an expression.
	 * @category Expression Manipulation
	 */
	copyExpression(expr: ExpressionRef): ExpressionRef {
		return BinaryenObj["_BinaryenExpressionCopy"](expr, this.ptr);
	}

	// ## Module Component Operations ## //
	// see https://webassembly.github.io/spec/core/syntax/modules.html
	/** @category Module Component Operations */ readonly tags = new ModuleTags(this);
	/** @category Module Component Operations */ readonly globals = new ModuleGlobals(this);
	/** @category Module Component Operations */ readonly memories = new ModuleMemories(this);
	/** @category Module Component Operations */ readonly tables = new ModuleTables(this);
	/** @category Module Component Operations */ readonly functions = new ModuleFunctions(this);
	/** @category Module Component Operations */ readonly dataSegments = new ModuleDataSegments(this);
	/** @category Module Component Operations */ readonly elementSegments = new ModuleElementSegments(this);
	/** @category Module Component Operations */ readonly imports = new ModuleImports(this);
	/** @category Module Component Operations */ readonly exports = new ModuleExports(this);

	/** @deprecated Use {@link Module#start | `this.start`} instead. */ @replacedBy("`this.start`") getStart() { return this.start; }
	/** @deprecated Use {@link Module#start | `this.start`} instead. */ @replacedBy("`this.start`") setStart(start: FunctionRef) { this.start = start; }
	/** @deprecated Use {@link Module#features | `this.features`} instead. */ @replacedBy("`this.features`") getFeatures() { return this.features; }
	/** @deprecated Use {@link Module#features | `this.features`} instead. */ @replacedBy("`this.features`") setFeatures(features: Feature) { return this.features = features; }

	/**
	 * The start function.
	 * @category Module Component Operations
	 */
	get start(): FunctionRef {
		return BinaryenObj["_BinaryenGetStart"](this.ptr);
	}

	set start(start: FunctionRef) {
		BinaryenObj["_BinaryenSetStart"](this.ptr, start);
	}

	/**
	 * The WebAssembly features enabled for this module.
	 * Features are a bitmask of `Feature` enum members.
	 * @category Module Component Operations
	 */
	get features(): Feature {
		return BinaryenObj["_BinaryenModuleGetFeatures"](this.ptr);
	}

	set features(features: Feature) {
		BinaryenObj["_BinaryenModuleSetFeatures"](this.ptr, features);
	}

	/** @deprecated Use {@link Module#tags | `this.tags.add`} instead. */ @replacedBy("`this.tags.add`") addTag(name: string, params: Type, results: Type) { return this.tags.add(name, params, results); }
	/** @deprecated Use {@link Module#tags | `this.tags.get`} instead. */ @replacedBy("`this.tags.get`") getTag(name: string) { return this.tags.get(name); }
	/** @deprecated Use {@link Module#tags | `this.tags.remove`} instead. */ @replacedBy("`this.tags.remove`") removeTag(name: string) { return this.tags.remove(name); }

	/** @deprecated Use {@link Module#globals | `this.globals.add`} instead. */ @replacedBy("`this.globals.add`") addGlobal(name: string, type: Type, mutable: boolean, init: ExpressionRef) { return this.globals.add(name, type, mutable, init); }
	/** @deprecated Use {@link Module#globals | `this.globals.get`} instead. */ @replacedBy("`this.globals.get`") getGlobal(name: string) { return this.globals.get(name); }
	/** @deprecated Use {@link Module#globals | `this.globals.getByIndex`} instead. */ @replacedBy("`this.globals.getByIndex`") getGlobalByIndex(index: number) { return this.globals.getByIndex(index); }
	/** @deprecated Use {@link Module#globals | `this.globals.count`} instead. */ @replacedBy("`this.globals.count`") getNumGlobals() { return this.globals.count(); }
	/** @deprecated Use {@link Module#globals | `this.globals.remove`} instead. */ @replacedBy("`this.globals.remove`") removeGlobal(name: string) { return this.globals.remove(name); }

	/** @deprecated Use {@link Module#memories | `this.memories.set`} instead. */ @replacedBy("`this.memories.set`") setMemory(initial: number, maximum: number, exportName: string, segments?: readonly any[], shared?: boolean, memory64?: boolean, internalName?: string) { return this.memories.set(initial, maximum, exportName, segments, shared, memory64, internalName); }
	/** @deprecated Use {@link Module#memories | `this.memories.has`} instead. */ @replacedBy("`this.memories.has`") hasMemory() { return this.memories.has(); }

	/** @deprecated Use {@link Module#tables | `this.tables.add`} instead. */ @replacedBy("`this.tables.add`") addTable(name: string, initial: number, maximum: number, type: Type = funcref, init?: ExpressionRef) { return this.tables.add(name, initial, maximum, type, init); }
	/** @deprecated Use {@link Module#tables | `this.tables.get`} instead. */ @replacedBy("`this.tables.get`") getTable(name: string) { return this.tables.get(name); }
	/** @deprecated Use {@link Module#tables | `this.tables.getByIndex`} instead. */ @replacedBy("`this.tables.getByIndex`") getTableByIndex(index: number) { return this.tables.getByIndex(index); }
	/** @deprecated Use {@link Module#tables | `this.tables.getSegments`} instead. */ @replacedBy("`this.tables.getSegments`") getTableSegments(table: TableRef) { return this.tables.getSegments(table); }
	/** @deprecated Use {@link Module#tables | `this.tables.count`} instead. */ @replacedBy("`this.tables.count`") getNumTables() { return this.tables.count(); }
	/** @deprecated Use {@link Module#tables | `this.tables.remove`} instead. */ @replacedBy("`this.tables.remove`") removeTable(name: string) { return this.tables.remove(name); }

	/** @deprecated Use {@link Module#functions | `this.functions.add`} instead. */ @replacedBy("`this.functions.add`") addFunction(name: string, params: Type, results: Type, varTypes: readonly Type[], body: ExpressionRef) { return this.functions.add(name, params, results, varTypes, body); }
	/** @deprecated Use {@link Module#functions | `this.functions.get`} instead. */ @replacedBy("`this.functions.get`") getFunction(name: string) { return this.functions.get(name); }
	/** @deprecated Use {@link Module#functions | `this.functions.getByIndex`} instead. */ @replacedBy("`this.functions.getByIndex`") getFunctionByIndex(index: number) { return this.functions.getByIndex(index); }
	/** @deprecated Use {@link Module#functions | `this.functions.count`} instead. */ @replacedBy("`this.functions.count`") getNumFunctions() { return this.functions.count(); }
	/** @deprecated Use {@link Module#functions | `this.functions.remove`} instead. */ @replacedBy("`this.functions.remove`") removeFunction(name: string) { return this.functions.remove(name); }

	/** @deprecated Use {@link Module#dataSegments | `this.dataSegments.get`} instead. */ @replacedBy("`this.dataSegments.get`") getDataSegment(name: string) { return this.dataSegments.get(name); }
	/** @deprecated Use {@link Module#dataSegments | `this.dataSegments.getByIndex`} instead. */ @replacedBy("`this.dataSegments.getByIndex`") getDataSegmentByIndex(index: number) { return this.dataSegments.getByIndex(index); }
	/** @deprecated Use {@link Module#dataSegments | `this.dataSegments.count`} instead. */ @replacedBy("`this.dataSegments.count`") getNumDataSegments() { return this.dataSegments.count(); }

	/** @deprecated Use {@link Module#elementSegments | `this.elementSegments.addActive`} instead. */ @replacedBy("`this.elementSegments.addActive`") addActiveElementSegment(table: string, name: string, funcNames: readonly string[], offset: ExpressionRef) { return this.elementSegments.addActive(table, name, funcNames, offset); }
	/** @deprecated Use {@link Module#elementSegments | `this.elementSegments.addPassive`} instead. */ @replacedBy("`this.elementSegments.addPassive`") addPassiveElementSegment(name: string, funcNames: readonly string[]) { return this.elementSegments.addPassive(name, funcNames); }
	/** @deprecated Use {@link Module#elementSegments | `this.elementSegments.get`} instead. */ @replacedBy("`this.elementSegments.get`") getElementSegment(name: string) { return this.elementSegments.get(name); }
	/** @deprecated Use {@link Module#elementSegments | `this.elementSegments.getByIndex`} instead. */ @replacedBy("`this.elementSegments.getByIndex`") getElementSegmentByIndex(index: number) { return this.elementSegments.getByIndex(index); }
	/** @deprecated Use {@link Module#elementSegments | `this.elementSegments.count`} instead. */ @replacedBy("`this.elementSegments.count`") getNumElementSegments() { return this.elementSegments.count(); }
	/** @deprecated Use {@link Module#elementSegments | `this.elementSegments.remove`} instead. */ @replacedBy("`this.elementSegments.remove`") removeElementSegment(name: string) { return this.elementSegments.remove(name); }

	/** @deprecated Use {@link Module#imports | `this.imports.addTag`} instead. */ @replacedBy("`this.imports.addTag`") addTagImport(internalName: string, externalModuleName: string, externalBaseName: string, params: Type, results: Type) { return this.imports.addTag(internalName, externalModuleName, externalBaseName, params, results); }
	/** @deprecated Use {@link Module#imports | `this.imports.addGlobal`} instead. */ @replacedBy("`this.imports.addGlobal`") addGlobalImport(internalName: string, externalModuleName: string, externalBaseName: string, globalType: Type, mutable: boolean) { return this.imports.addGlobal(internalName, externalModuleName, externalBaseName, globalType, mutable); }
	/** @deprecated Use {@link Module#imports | `this.imports.addMemory`} instead. */ @replacedBy("`this.imports.addMemory`") addMemoryImport(internalName: string, externalModuleName: string, externalBaseName: string, shared: boolean) { return this.imports.addMemory(internalName, externalModuleName, externalBaseName, shared); }
	/** @deprecated Use {@link Module#imports | `this.imports.addTable`} instead. */ @replacedBy("`this.imports.addTable`") addTableImport(internalName: string, externalModuleName: string, externalBaseName: string) { return this.imports.addTable(internalName, externalModuleName, externalBaseName); }
	/** @deprecated Use {@link Module#imports | `this.imports.addFunction`} instead. */ @replacedBy("`this.imports.addFunction`") addFunctionImport(internalName: string, externalModuleName: string, externalBaseName: string, params: Type, results: Type) { return this.imports.addFunction(internalName, externalModuleName, externalBaseName, params, results); }

	/** @deprecated Use {@link Module#exports | `this.exports.get`} instead. */ @replacedBy("`this.exports.get`") getExport(externalName: string) { return this.exports.get(externalName); }
	/** @deprecated Use {@link Module#exports | `this.exports.getByIndex`} instead. */ @replacedBy("`this.exports.getByIndex`") getExportByIndex(index: number) { return this.exports.getByIndex(index); }
	/** @deprecated Use {@link Module#exports | `this.exports.count`} instead. */ @replacedBy("`this.exports.count`") getNumExports() { return this.exports.count(); }
	/** @deprecated Use {@link Module#exports | `this.exports.remove`} instead. */ @replacedBy("`this.exports.remove`") removeExport(externalName: string) { return this.exports.remove(externalName); }
	/** @deprecated Use {@link Module#exports | `this.exports.addTag`} instead. */ @replacedBy("`this.exports.addTag`") addTagExport(internalName: string, externalName: string) { return this.exports.addTag(internalName, externalName); }
	/** @deprecated Use {@link Module#exports | `this.exports.addGlobal`} instead. */ @replacedBy("`this.exports.addGlobal`") addGlobalExport(internalName: string, externalName: string) { return this.exports.addGlobal(internalName, externalName); }
	/** @deprecated Use {@link Module#exports | `this.exports.addMemory`} instead. */ @replacedBy("`this.exports.addMemory`") addMemoryExport(internalName: string, externalName: string) { return this.exports.addMemory(internalName, externalName); }
	/** @deprecated Use {@link Module#exports | `this.exports.addTable`} instead. */ @replacedBy("`this.exports.addTable`") addTableExport(internalName: string, externalName: string) { return this.exports.addTable(internalName, externalName); }
	/** @deprecated Use {@link Module#exports | `this.exports.addFunction`} instead. */ @replacedBy("`this.exports.addFunction`") addFunctionExport(internalName: string, externalName: string) { return this.exports.addFunction(internalName, externalName); }

	/** @category Module Component Operations */
	getMemoryInfo(name: string): Memory_ {
		return new Memory_(this, name);
	}

	/** @category Module Component Operations */
	getDataSegmentInfo(segment: DataSegmentRef): DataSegment_ {
		return new DataSegment_(this, segment);
	}

	// ## Binaryen Operations ## //
	// ### Emission & Execution ### //
	/**
	 * Returns the module in Binaryen’s s-expression text format (not official stack-style text format).
	 * @category Emission & Execution
	 */
	emitText(): string {
		const textPtr = BinaryenObj["_BinaryenModuleAllocateAndWriteText"](this.ptr);
		const text = UTF8ToString(textPtr);
		if (textPtr) {
			_free(textPtr);
		}
		return text;
	}

	/**
	 * Returns the module in official stack-style text format.
	 * @category Emission & Execution
	 */
	emitStackIR(): string {
		const textPtr = BinaryenObj["_BinaryenModuleAllocateAndWriteStackIR"](this.ptr);
		const text = UTF8ToString(textPtr);
		if (textPtr) {
			_free(textPtr);
		}
		return text;
	}

	/**
	 * Returns the [asm.js](http://asmjs.org/) representation of the module.
	 * @category Emission & Execution
	 */
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

	/**
	 * Returns the module in binary format.
	 * @category Emission & Execution
	 */
	emitBinary(): Uint8Array;
	/**
	 * Returns the module in binary format with a given source map.
	 * @category Emission & Execution
	 */
	emitBinary(sourceMapUrl: string): {binary: Uint8Array, sourceMap: string};
	emitBinary(sourceMapUrl?: string): Uint8Array | {binary: Uint8Array, sourceMap: string} {
		return preserveStack(() => {
			const tempBuffer = stackAlloc(BinaryenObj["_BinaryenSizeofAllocateAndWriteResult"]());
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

	/**
	 * Runs the module in the interpreter, calling the start function.
	 * @category Emission & Execution
	 */
	interpret(): void {
		BinaryenObj["_BinaryenModuleInterpret"](this.ptr);
	}

	/**
	 * Releases the resources held by the module once it isn’t needed anymore.
	 * @category Emission & Execution
	 */
	dispose(): void {
		BinaryenObj["_BinaryenModuleDispose"](this.ptr);
	}

	// ### Validation & Optimization ### //
	/**
	 * Validates the module. Returns `true` if valid, otherwise prints validation errors and returns `false`.
	 * @category Validation & Optimization
	 */
	validate(): number {
		return BinaryenObj["_BinaryenModuleValidate"](this.ptr);
	}

	/**
	 * Optimizes the module using the default optimization passes.
	 * @category Validation & Optimization
	 */
	optimize(): void {
		BinaryenObj["_BinaryenModuleOptimize"](this.ptr);
	}

	/**
	 * Optimizes a single function using the default optimization passes.
	 * @category Validation & Optimization
	 */
	optimizeFunction(func: FunctionRef | string): void {
		if (typeof func === "string") {
			func = this.functions.get(func);
		}
		BinaryenObj["_BinaryenFunctionOptimize"](func, this.ptr);
	}

	/**
	 * Runs the specified passes on the module.
	 * @category Validation & Optimization
	 */
	runPasses(passes: readonly string[]): void {
		preserveStack(() => BinaryenObj["_BinaryenModuleRunPasses"](this.ptr, i32sToStack(passes.map(strToStack)), passes.length));
	}

	/**
	 * Runs the specified passes on a single function.
	 * @category Validation & Optimization
	 */
	runPassesOnFunction(func: string | FunctionRef, passes: readonly string[]): void {
		if (typeof func === "string") {
			func = this.functions.get(func);
		}
		preserveStack(() => BinaryenObj["_BinaryenFunctionRunPasses"](func, this.ptr, i32sToStack(passes.map(strToStack)), passes.length));
	}

	// ### Debugging ### //
	/**
	 * Adds a debug info file name to the module and returns its index.
	 * @category Debugging
	 */
	addDebugInfoFileName(filename: string): number {
		return preserveStack(() => BinaryenObj["_BinaryenModuleAddDebugInfoFileName"](this.ptr, strToStack(filename)));
	}

	/**
	 * Gets the name of the debug info file at the specified index.
	 * @category Debugging
	 */
	getDebugInfoFileName(index: number): string {
		return UTF8ToString(BinaryenObj["_BinaryenModuleGetDebugInfoFileName"](this.ptr, index));
	}

	/**
	 * Sets the debug location of the specified `ExpressionRef` within the specified `FunctionRef`.
	 * @category Debugging
	 */
	setDebugLocation(func: FunctionRef, expr: ExpressionRef, fileIndex: number, lineNumber: number, columnNumber: number): void {
		BinaryenObj["_BinaryenFunctionSetDebugLocation"](func, expr, fileIndex, lineNumber, columnNumber);
	}

	// ### Other ### //
	/** [description] */
	setTypeName(heapType: HeapType, name: string): void {
		preserveStack(() => BinaryenObj["_BinaryenModuleSetTypeName"](this.ptr, heapType, strToStack(name)));
	}

	/** [description] */
	setFieldName(heapType: HeapType, index: number, name: string): void {
		preserveStack(() => BinaryenObj["_BinaryenModuleSetFieldName"](this.ptr, heapType, index, strToStack(name)));
	}

	/** Adds a custom section to the binary. */
	addCustomSection(name: string, contents: Uint8Array): void {
		preserveStack(() => BinaryenObj["_BinaryenAddCustomSection"](this.ptr, strToStack(name), i8sToStack([...contents]), contents.length));
	}

	/** [description] */
	updateMaps(): void {
		BinaryenObj["_BinaryenModuleUpdateMaps"](this.ptr);
	}
}



/**
 * A collection of types and classes related to WASM module manipulation.
 *
 * Each class represents a component of a WASM module,
 * and its corresponding type is included for documentation.
 */
export namespace Module {
	export type Tag = Tag_;
	export type Global = Global_;
	export type Memory = Memory_;
	export type Table = Table_;
	export type Function = Function_;
	export type DataSegment = DataSegment_;
	export type ElementSegment = ElementSegment_;
	export type Import = Import_;
	export type Export = Export_;
}
