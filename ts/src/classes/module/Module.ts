import {
	_free,
	BinaryenObj,
	HEAPU8,
	HEAPU32,
	UTF8ToString,
	stackAlloc,
} from "../../-pre.ts";
import {
	PTR,
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
	type ModuleRef,
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
	// TODO: CustomDescriptors
	RelaxedAtomics = BinaryenObj["_BinaryenFeatureRelaxedAtomics"](),
	CustomPageSizes = BinaryenObj["_BinaryenFeatureCustomPageSizes"](),
	// TODO: Multibyte
	WideArithmetic = BinaryenObj["_BinaryenFeatureWideArithmetic"](),
	All = BinaryenObj["_BinaryenFeatureAll"](),
}



/**
 * Mark a method as deprecated by logging a warning in the console.
 * @example
 * class Module {
 * 	\@replacedBy("`this.global.addExport`")
 * 	addGlobalExport(...args) {
 * 		return this.global.addExport(...args);
 * 	}
 * }
 *
 * @param replacement the name or signature of the new method replacing the deprecated one
 * @returns a method decorator
 */
function replacedBy<This, Params extends unknown[], Return>(replacement: string = ""): (
	method: (this: This, ...args: Params) => Return,
	context: ClassMethodDecoratorContext<This, typeof method>,
) => (typeof method) | void {
	return (method, context) => function (...args) {
		const message = `WARNING: ${ context.static ? "Static" : "Instance" } method \`${ String(context.name) }\` is deprecated${ replacement && `; use ${ replacement } instead` }.`;
		BinaryenObj.printWarn(message);
		return method.call(this, ...args);
	};
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


	/**
	 * The underlying C-API pointer of the wrapped module.
	 * @hidden
	 */
	readonly [PTR]: ModuleRef = BinaryenObj["_BinaryenModuleCreate"]();

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
			return BinaryenObj["_BinaryenPop"](this[PTR], typ);
		} else {
			throw new Error(`Unexpected type ${ typ }.`);
		}
	}

	/**
	 * Gets the side effects of the specified expression.
	 * @category Expression Manipulation
	 */
	getSideEffects(expr: ExpressionRef): SideEffect {
		return BinaryenObj["_BinaryenExpressionGetSideEffects"](expr, this[PTR]);
	}

	/**
	 * Creates a deep copy of an expression.
	 * @category Expression Manipulation
	 */
	copyExpression(expr: ExpressionRef): ExpressionRef {
		return BinaryenObj["_BinaryenExpressionCopy"](expr, this[PTR]);
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
	get start(): FunctionRef { return BinaryenObj["_BinaryenGetStart"](this[PTR]); }
	set start(start: FunctionRef) { BinaryenObj["_BinaryenSetStart"](this[PTR], start); }

	/**
	 * The WebAssembly features enabled for this module.
	 * Features are a bitmask of `Feature` enum members.
	 * @category Module Component Operations
	 */
	get features(): Feature { return BinaryenObj["_BinaryenModuleGetFeatures"](this[PTR]); }
	set features(features: Feature) { BinaryenObj["_BinaryenModuleSetFeatures"](this[PTR], features); }

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
		const textPtr = BinaryenObj["_BinaryenModuleAllocateAndWriteText"](this[PTR]);
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
		const textPtr = BinaryenObj["_BinaryenModuleAllocateAndWriteStackIR"](this[PTR]);
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
		/*
		 * `out` is Emscripten's `stdout` function (an alias of `console.log`),
		 * called internally by `BinaryenModulePrintAsmjs()` to print its output.
		 * We have to temporarily swap out the function itself
		 * so that when `BinaryenModulePrintAsmjs()` calls it,
		 * it calls our capturing function instead.
		 *
		 * We can’t use `import {out} from "../../-pre.ts";` because ES Module imports can’t be reassigned.
		 * Instead, we reassign directly on `BinaryenObj`.
		 */
		let returned = "";
		const temp_out = BinaryenObj.out;
		BinaryenObj.out = (x: string): void => {
			returned += `${ x }\n`;
		};
		BinaryenObj["_BinaryenModulePrintAsmjs"](this[PTR]);
		BinaryenObj.out = temp_out;
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
			BinaryenObj["_BinaryenModuleAllocateAndWrite"](tempBuffer, this[PTR], strToStack(sourceMapUrl));
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
		BinaryenObj["_BinaryenModuleInterpret"](this[PTR]);
	}

	/**
	 * Releases the resources held by the module once it isn’t needed anymore.
	 * @category Emission & Execution
	 */
	dispose(): void {
		BinaryenObj["_BinaryenModuleDispose"](this[PTR]);
	}

	// ### Validation & Optimization ### //
	/**
	 * Validates the module. Returns `true` if valid, otherwise prints validation errors and returns `false`.
	 * @category Validation & Optimization
	 */
	validate(): number {
		return BinaryenObj["_BinaryenModuleValidate"](this[PTR]);
	}

	/**
	 * Optimizes the module using the default optimization passes.
	 * @category Validation & Optimization
	 */
	optimize(): void {
		BinaryenObj["_BinaryenModuleOptimize"](this[PTR]);
	}

	/**
	 * Optimizes a single function using the default optimization passes.
	 * @category Validation & Optimization
	 */
	optimizeFunction(func: FunctionRef | string): void {
		if (typeof func === "string") {
			func = this.functions.get(func);
		}
		BinaryenObj["_BinaryenFunctionOptimize"](func, this[PTR]);
	}

	/**
	 * Runs the specified passes on the module.
	 * @category Validation & Optimization
	 */
	runPasses(passes: readonly string[]): void {
		preserveStack(() => BinaryenObj["_BinaryenModuleRunPasses"](this[PTR], i32sToStack(passes.map(strToStack)), passes.length));
	}

	/**
	 * Runs the specified passes on a single function.
	 * @category Validation & Optimization
	 */
	runPassesOnFunction(func: string | FunctionRef, passes: readonly string[]): void {
		if (typeof func === "string") {
			func = this.functions.get(func);
		}
		preserveStack(() => BinaryenObj["_BinaryenFunctionRunPasses"](func, this[PTR], i32sToStack(passes.map(strToStack)), passes.length));
	}

	// ### Debugging ### //
	/**
	 * Adds a debug info file name to the module and returns its index.
	 * @category Debugging
	 */
	addDebugInfoFileName(filename: string): number {
		return preserveStack(() => BinaryenObj["_BinaryenModuleAddDebugInfoFileName"](this[PTR], strToStack(filename)));
	}

	/**
	 * Gets the name of the debug info file at the specified index.
	 * @category Debugging
	 */
	getDebugInfoFileName(index: number): string {
		return UTF8ToString(BinaryenObj["_BinaryenModuleGetDebugInfoFileName"](this[PTR], index));
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
		preserveStack(() => BinaryenObj["_BinaryenModuleSetTypeName"](this[PTR], heapType, strToStack(name)));
	}

	/** [description] */
	setFieldName(heapType: HeapType, index: number, name: string): void {
		preserveStack(() => BinaryenObj["_BinaryenModuleSetFieldName"](this[PTR], heapType, index, strToStack(name)));
	}

	/** Adds a custom section to the binary. */
	addCustomSection(name: string, contents: Uint8Array): void {
		preserveStack(() => BinaryenObj["_BinaryenAddCustomSection"](this[PTR], strToStack(name), i8sToStack([...contents]), contents.length));
	}

	/**
	 * Updates the internal name mapping logic in a module.
	 * This must be called after renaming module elements.
	 */
	updateMaps(): void {
		BinaryenObj["_BinaryenModuleUpdateMaps"](this[PTR]);
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



/*
 * The relocation of all `ExpressionBuilder` props from `Module` to `Module#wasm` is a breaking change,
 * so we want to let users access it the old way but with deprecation warnings.
 * The following interface declares typings for TS support, and
 * the function below delegates accesses to those properties at runtime.
 */
export interface Module {
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ nop: ExpressionBuilder["nop"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ unreachable: ExpressionBuilder["unreachable"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ drop: ExpressionBuilder["drop"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ select: ExpressionBuilder["select"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ block: ExpressionBuilder["block"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ loop: ExpressionBuilder["loop"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ if: ExpressionBuilder["if"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ br: ExpressionBuilder["br"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ br_if: ExpressionBuilder["br_if"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ br_table: ExpressionBuilder["br_table"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ br_on_null: ExpressionBuilder["br_on_null"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ br_on_non_null: ExpressionBuilder["br_on_non_null"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ br_on_cast: ExpressionBuilder["br_on_cast"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ br_on_cast_fail: ExpressionBuilder["br_on_cast_fail"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ break: ExpressionBuilder["break"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ switch: ExpressionBuilder["switch"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ call: ExpressionBuilder["call"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ call_ref: ExpressionBuilder["call_ref"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ call_indirect: ExpressionBuilder["call_indirect"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ return: ExpressionBuilder["return"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ return_call: ExpressionBuilder["return_call"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ return_call_ref: ExpressionBuilder["return_call_ref"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ return_call_indirect: ExpressionBuilder["return_call_indirect"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ callIndirect: ExpressionBuilder["callIndirect"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ returnCall: ExpressionBuilder["returnCall"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ returnCallIndirect: ExpressionBuilder["returnCallIndirect"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ throw: ExpressionBuilder["throw"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ throw_ref: ExpressionBuilder["throw_ref"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ try_table: ExpressionBuilder["try_table"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ rethrow: ExpressionBuilder["rethrow"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ try: ExpressionBuilder["try"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ local: ExpressionBuilder["local"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ global: ExpressionBuilder["global"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ table: ExpressionBuilder["table"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ memory: ExpressionBuilder["memory"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ data: ExpressionBuilder["data"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ ref: ExpressionBuilder["ref"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ i31: ExpressionBuilder["i31"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ tuple: ExpressionBuilder["tuple"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ struct: ExpressionBuilder["struct"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ array: ExpressionBuilder["array"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ i32: ExpressionBuilder["i32"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ i64: ExpressionBuilder["i64"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ f32: ExpressionBuilder["f32"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ f64: ExpressionBuilder["f64"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ v128: ExpressionBuilder["v128"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ i8x16: ExpressionBuilder["i8x16"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ i16x8: ExpressionBuilder["i16x8"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ i32x4: ExpressionBuilder["i32x4"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ i64x2: ExpressionBuilder["i64x2"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ f32x4: ExpressionBuilder["f32x4"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ f64x2: ExpressionBuilder["f64x2"];
	/** @deprecated This function moved to {@link Module#wasm}. @hidden */ atomic: ExpressionBuilder["atomic"];
}
Object.keys(new Module().wasm).forEach((key) => {
	if (!Reflect.has(Module.prototype, key)) {
		Reflect.defineProperty(Module.prototype, key, {
			get() {
				BinaryenObj.printWarn(`Module property \`.${ key }\` is deprecated; use \`.wasm.${ key }\` instead.`);
				return (this as Module).wasm[key as keyof ExpressionBuilder];
			},
		});
	}
});
