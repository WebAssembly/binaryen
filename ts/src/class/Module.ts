import {BinaryenObj} from "../-pre.ts";
import {block} from "./expression/Block.ts";



/**
 * The size of a single literal in memory as used in Const creation,
 * which is a little different: we don’t want users to need to make
 * their own Literals, as the C API handles them by value, which means
 * we would leak them. Instead, Const creation is fused together with
 * an intermediate stack allocation of this size to pass the value.
 */
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
/** @deprecated Enum name is now singular. */
export const Features = Feature;



export class Module {
	readonly ptr: number = BinaryenObj["_BinaryenModuleCreate"]();

	// ## Expression Creation ## //
	// ### Control Instructions ### //
	block = block;

	// ## Module Operations ## //
	// see https://webassembly.github.io/spec/core/syntax/modules.html

	// ### Tags ### //
	addTag() {}

	getTag() {}

	removeTag() {}

	// ### Globals ### //
	addGlobal() {}

	getGlobal() {}

	getGlobalByIndex() {}

	getNumGlobals() {}

	removeGlobal() {}

	// ### Memories ### //
	setMemory() {}

	hasMemory() {}

	getMemoryInfo() {}

	// ### Tables ### //
	addTable() {}

	getTable() {}

	getTableByIndex() {}

	getNumTables() {}

	getTableSegments() {}

	removeTable() {}

	// ### Functions ### //
	addFunction() {}

	getFunction() {}

	removeFunction() {}

	getNumFunctions() {}

	getFunctionByIndex() {}

	// ### Data Segments ### //
	getNumDataSegments() {}

	getDataSegment() {}

	getDataSegmentByIndex() {}

	getDataSegmentInfo() {}

	// ### Element Segments ### //
	addActiveElementSegment() {}

	addPassiveElementSegment() {}

	getElementSegment() {}

	getElementSegmentByIndex() {}

	getNumElementSegments() {}

	removeElementSegment() {}

	// ### Start Function ### //
	getStart() {}

	// ### Imports ### //
	addTagImport() {}

	addGlobalImport() {}

	addMemoryImport() {}

	addTableImport() {}

	addFunctionImport() {}

	// ### Exports ### //
	addTagExport() {}

	addGlobalExport() {}

	addMemoryExport() {}

	addTableExport() {}

	addFunctionExport() {}

	getExport() {}

	getNumExports() {}

	getExportByIndex() {}

	removeExport() {}

	// ## Binaryen Operations ## //
	emitText() {}

	emitStackIR() {}

	emitAsmjs() {}

	emitBinary() {}

	getFeatures() {}

	setFeatures() {}

	setTypeName() {}

	setFieldName() {}

	addCustomSection() {}

	interpret() {}

	validate() {}

	optimize() {}

	optimizeFunction() {}

	updateMaps() {}

	runPasses() {}

	runPassesOnFunction() {}

	dispose() {}

	addDebugInfoFileName() {}

	getDebugInfoFileName() {}

	setDebugLocation() {}

	copyExpression() {}
}



export function getTagInfo() {}

export function getGlobalInfo() {}

export function getTableInfo() {}

export function getFunctionInfo() {}

export function getElementSegmentInfo() {}

export function getExportInfo() {}
