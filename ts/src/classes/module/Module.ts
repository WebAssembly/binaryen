import {
	_free,
	BinaryenObj,
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
	type ExpressionRef,
	type FunctionRef,
	type HeapType,
	type ModuleRef,
	type SideEffect,
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
	CompactImports = BinaryenObj["_BinaryenFeatureCompactImports"](),
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
	/**
	 * The underlying C-API pointer of the wrapped module.
	 * @hidden
	 */
	readonly [PTR]: ModuleRef = BinaryenObj["_BinaryenModuleCreate"]();

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
			throw new Error(`\`Module#pop()\` was called with an unexpected type: \`${ typ }\`.`);
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

	/**
	 * The start function.
	 * @category Module Component Operations
	 */
	get start(): FunctionRef { return BinaryenObj["_BinaryenGetStart"](this[PTR]); }
	set start(start: FunctionRef) { BinaryenObj["_BinaryenSetStart"](this[PTR], start); }

	/** @category Module Component Operations */
	/*
	getMemoryInfo(name: string = ""): Memory_ {
		return new Memory_(this, name);
	}
	*/

	/** @category Module Component Operations */
	/*
	getDataSegmentInfo(segment: DataSegmentRef): DataSegment_ {
		return new DataSegment_(this, segment);
	}
	*/

	// ## Binaryen Operations ## //
	// ### Emission & Execution ### //
	/**
	 * Returns the module in Binaryen’s s-expression text format (not official stack-style text format).
	 * @category Emission & Execution
	 */
	emitText(): string {
		const textPtr = BinaryenObj["_BinaryenModuleAllocateAndWriteText"](this[PTR]);
		try {
			return UTF8ToString(textPtr);
		} finally {
			if (textPtr) {
				_free(textPtr);
			}
		}
	}

	/**
	 * Returns the module in official stack-style text format.
	 * @category Emission & Execution
	 */
	emitStackIR(): string {
		const textPtr = BinaryenObj["_BinaryenModuleAllocateAndWriteStackIR"](this[PTR]);
		try {
			return UTF8ToString(textPtr);
		} finally {
			if (textPtr) {
				_free(textPtr);
			}
		}
	}

	/**
	 * Returns the [asm.js](http://asmjs.org/) representation of the module.
	 * @category Emission & Execution
	 * @deprecated This method no longer returns the asm.js string, but instead logs it to standard output.
	 */
	emitAsmjs(): string {
		BinaryenObj["_BinaryenModulePrintAsmjs"](this[PTR]);
		return ""; // TODO: if keeping console-logging behavior, change return type to `void` and delete this return statement
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
			const binaryPtr = BinaryenObj.HEAPU32[tempBuffer >>> 2];
			const binaryBytes = BinaryenObj.HEAPU32[(tempBuffer >>> 2) + 1];
			const sourceMapPtr = BinaryenObj.HEAPU32[(tempBuffer >>> 2) + 2];
			try {
				const buffer = new Uint8Array(binaryBytes);
				buffer.set(BinaryenObj.HEAPU8.subarray(binaryPtr, binaryPtr + binaryBytes));
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
	/*
	optimizeFunction(func: FunctionRef | string): void {
		if (typeof func === "string") {
			func = this.functions.get(func);
		}
		BinaryenObj["_BinaryenFunctionOptimize"](func, this[PTR]);
	}
	*/

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
	/*
	runPassesOnFunction(func: string | FunctionRef, passes: readonly string[]): void {
		if (typeof func === "string") {
			func = this.functions.get(func);
		}
		preserveStack(() => BinaryenObj["_BinaryenFunctionRunPasses"](func, this[PTR], i32sToStack(passes.map(strToStack)), passes.length));
	}
	*/

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
