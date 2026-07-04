import {
	BinaryenObj,
} from "../../-pre.ts";
import {
	PTR,
} from "../../-utils.ts";
import type {
	ModuleRef,
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
}
