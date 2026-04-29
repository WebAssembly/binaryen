import {
	BinaryenObj,
	stackAlloc,
} from "./pre.ts";
import {
	HEAPU32,
	i32sToStack,
	preserveStack,
} from "./utils.ts";



// # Expressions, Types, and Constants # //
// Compile-time types used by TypeScript, Binaryen types, and expression types.



// ## Static Types ## //
export type Type = number;
export type HeapType = number;
export type ElementSegmentRef = number;
export type ExpressionRef = number;
export type FunctionRef = number;
export type GlobalRef = number;
export type ExportRef = number;
export type TableRef = number;
export type TagRef = number;
export type RelooperBlockRef = number;
export type ExpressionRunnerRef = number;
export type TypeBuilderRef = number;



// ## Expression Types ## //
// see https://webassembly.github.io/spec/core/syntax/types.html

// ### Binaryen-Only Types ### //
/** Type with stack effect `[t*] -> [t*]`. */
export const unreachable: Type = BinaryenObj["_BinaryenTypeUnreachable"]();
/** Type with stack effect `[t*] -> []`. Not to be confused with the WASM heap type `none`. */
export const none: Type = BinaryenObj["_BinaryenTypeNone"]();
/** Used only for auto-detecting block types. */
export const auto: Type = BinaryenObj["_BinaryenTypeAuto"]();

// ### Number & Vector Types ### //
export const i32: Type = BinaryenObj["_BinaryenTypeInt32"]();
export const i64: Type = BinaryenObj["_BinaryenTypeInt64"]();
export const f32: Type = BinaryenObj["_BinaryenTypeFloat32"]();
export const f64: Type = BinaryenObj["_BinaryenTypeFloat64"]();
export const v128: Type = BinaryenObj["_BinaryenTypeVec128"]();

// ### Reference Types ### //
/** Reference type `(ref null any)`. */
export const anyref: Type = BinaryenObj["_BinaryenTypeAnyref"]();
/** Reference type `(ref null eq)`. */
export const eqref: Type = BinaryenObj["_BinaryenTypeEqref"]();
/** Reference type `(ref null i31)`. */
export const i31ref: Type = BinaryenObj["_BinaryenTypeI31ref"]();
/** Reference type `(ref null struct)`. */
export const structref: Type = BinaryenObj["_BinaryenTypeStructref"]();
/** Reference type `(ref null array)`. */
export const arrayref: Type = BinaryenObj["_BinaryenTypeArrayref"]();
/** Reference type `(ref null func)`. */
export const funcref: Type = BinaryenObj["_BinaryenTypeFuncref"]();
/** Reference type `(ref null exn)`. */
// export const exnref: Type = BinaryenObj["_BinaryenTypeExnref"](); // TODO: uncomment once supported in Binaryen
/** Reference type `(ref null extern)`. */
export const externref: Type = BinaryenObj["_BinaryenTypeExternref"]();
/** Reference type `(ref null none)`. */
export const nullref: Type = BinaryenObj["_BinaryenTypeNullref"]();
/** Reference type `(ref null nofunc)`. */
export const nullfuncref: Type = BinaryenObj["_BinaryenTypeNullFuncref"]();
/** Reference type `(ref null noexn)`. */
// export const nullexnref: Type = BinaryenObj["_BinaryenTypeNullExnref"](); // TODO: uncomment once supported in Binaryen
/** Reference type `(ref null noextern)`. */
export const nullexternref: Type = BinaryenObj["_BinaryenTypeNullExternref"]();

// ### Packed Types ### //
export const notPacked: Type = BinaryenObj["_BinaryenPackedTypeNotPacked"]();
export const i8: Type = BinaryenObj["_BinaryenPackedTypeInt8"]();
export const i16: Type = BinaryenObj["_BinaryenPackedTypeInt16"]();

// ### Proposed Types ### //
// These types are not yet in the WASM spec. Move them to their respective sections once finalized.
/** Reference type `(ref null string)`. */
export const stringref: Type = BinaryenObj["_BinaryenTypeStringref"]();



export function createType(types: readonly Type[]): Type {
	return preserveStack(() => BinaryenObj["_BinaryenTypeCreate"](i32sToStack(types), types.length));
}

export function expandType(typ: Type): Type[] {
	return preserveStack(() => {
		const numTypes = BinaryenObj["_BinaryenTypeArity"](typ);
		const array = stackAlloc(numTypes << 2);
		BinaryenObj["_BinaryenTypeExpand"](typ, array);
		const types = new Array(numTypes);
		for (let i = 0; i < numTypes; i++) {
			types[i] = HEAPU32[(array >>> 2) + i];
		}
		return types;
	});
}



// ## Instructions ## //
// see https://webassembly.github.io/spec/core/syntax/instructions.html
export enum ExpressionId {
	// ### Binaryen-Only Instruction Ids ### //
	Invalid = BinaryenObj["_BinaryenInvalidId"](),
	Pop = BinaryenObj["_BinaryenPopId"](),
	TupleMake = BinaryenObj["_BinaryenTupleMakeId"](),
	TupleExtract = BinaryenObj["_BinaryenTupleExtractId"](),

	// ### Parametric Instruction Ids ### //
	Nop = BinaryenObj["_BinaryenNopId"](),
	Unreachable = BinaryenObj["_BinaryenUnreachableId"](),
	Drop = BinaryenObj["_BinaryenDropId"](),
	Select = BinaryenObj["_BinaryenSelectId"](),

	// ### Control Instruction Ids ### //
	Block = BinaryenObj["_BinaryenBlockId"](),
	Loop = BinaryenObj["_BinaryenLoopId"](),
	If = BinaryenObj["_BinaryenIfId"](),
	Break = BinaryenObj["_BinaryenBreakId"](),
	Switch = BinaryenObj["_BinaryenSwitchId"](),
	BrOn = BinaryenObj["_BinaryenBrOnId"](),
	Call = BinaryenObj["_BinaryenCallId"](),
	CallRef = BinaryenObj["_BinaryenCallRefId"](),
	CallIndirect = BinaryenObj["_BinaryenCallIndirectId"](),
	Return = BinaryenObj["_BinaryenReturnId"](),
	Throw = BinaryenObj["_BinaryenThrowId"](),
	Rethrow = BinaryenObj["_BinaryenRethrowId"](),
	Try = BinaryenObj["_BinaryenTryId"](),

	// ### Variable Instruction Ids ### //
	LocalGet = BinaryenObj["_BinaryenLocalGetId"](),
	LocalSet = BinaryenObj["_BinaryenLocalSetId"](),
	GlobalGet = BinaryenObj["_BinaryenGlobalGetId"](),
	GlobalSet = BinaryenObj["_BinaryenGlobalSetId"](),

	// ### Table Instruction Ids ### //
	TableGet = BinaryenObj["_BinaryenTableGetId"](),
	TableSet = BinaryenObj["_BinaryenTableSetId"](),
	TableSize = BinaryenObj["_BinaryenTableSizeId"](),
	TableGrow = BinaryenObj["_BinaryenTableGrowId"](),

	// ### Memory Instruction Ids ### //
	Load = BinaryenObj["_BinaryenLoadId"](),
	Store = BinaryenObj["_BinaryenStoreId"](),
	SIMDLoad = BinaryenObj["_BinaryenSIMDLoadId"](),
	SIMDLoadStoreLane = BinaryenObj["_BinaryenSIMDLoadStoreLaneId"](),
	MemorySize = BinaryenObj["_BinaryenMemorySizeId"](),
	MemoryGrow = BinaryenObj["_BinaryenMemoryGrowId"](),
	MemoryFill = BinaryenObj["_BinaryenMemoryFillId"](),
	MemoryCopy = BinaryenObj["_BinaryenMemoryCopyId"](),
	MemoryInit = BinaryenObj["_BinaryenMemoryInitId"](),
	DataDrop = BinaryenObj["_BinaryenDataDropId"](),

	// ### Reference Instruction Ids ### //
	RefFunc = BinaryenObj["_BinaryenRefFuncId"](),
	RefNull = BinaryenObj["_BinaryenRefNullId"](),
	RefIsNull = BinaryenObj["_BinaryenRefIsNullId"](),
	RefAs = BinaryenObj["_BinaryenRefAsId"](),
	RefEq = BinaryenObj["_BinaryenRefEqId"](),
	RefTest = BinaryenObj["_BinaryenRefTestId"](),
	RefCast = BinaryenObj["_BinaryenRefCastId"](),

	// ### Aggregate Instruction Ids ### //
	StructNew = BinaryenObj["_BinaryenStructNewId"](),
	StructGet = BinaryenObj["_BinaryenStructGetId"](),
	StructSet = BinaryenObj["_BinaryenStructSetId"](),
	ArrayNew = BinaryenObj["_BinaryenArrayNewId"](),
	ArrayNewFixed = BinaryenObj["_BinaryenArrayNewFixedId"](),
	ArrayNewData = BinaryenObj["_BinaryenArrayNewDataId"](),
	ArrayNewElem = BinaryenObj["_BinaryenArrayNewElemId"](),
	ArrayGet = BinaryenObj["_BinaryenArrayGetId"](),
	ArraySet = BinaryenObj["_BinaryenArraySetId"](),
	ArrayLen = BinaryenObj["_BinaryenArrayLenId"](),
	ArrayFill = BinaryenObj["_BinaryenArrayFillId"](),
	ArrayCopy = BinaryenObj["_BinaryenArrayCopyId"](),
	ArrayInitData = BinaryenObj["_BinaryenArrayInitDataId"](),
	ArrayInitElem = BinaryenObj["_BinaryenArrayInitElemId"](),
	RefI31 = BinaryenObj["_BinaryenRefI31Id"](),
	I31Get = BinaryenObj["_BinaryenI31GetId"](),

	// ### Numeric & Vector Instruction Ids ### //
	Const = BinaryenObj["_BinaryenConstId"](),
	Unary = BinaryenObj["_BinaryenUnaryId"](),
	Binary = BinaryenObj["_BinaryenBinaryId"](),
	SIMDTernary = BinaryenObj["_BinaryenSIMDTernaryId"](),
	SIMDShift = BinaryenObj["_BinaryenSIMDShiftId"](),
	SIMDShuffle = BinaryenObj["_BinaryenSIMDShuffleId"](),
	SIMDExtract = BinaryenObj["_BinaryenSIMDExtractId"](),
	SIMDReplace = BinaryenObj["_BinaryenSIMDReplaceId"](),

	// ### Atomic Instruction Ids ### //
	AtomicCmpxchg = BinaryenObj["_BinaryenAtomicCmpxchgId"](),
	AtomicRMW = BinaryenObj["_BinaryenAtomicRMWId"](),
	AtomicWait = BinaryenObj["_BinaryenAtomicWaitId"](),
	AtomicNotify = BinaryenObj["_BinaryenAtomicNotifyId"](),
	AtomicFence = BinaryenObj["_BinaryenAtomicFenceId"](),

	// ### Proposed Instruction Ids ### //
	// These insructions are not yet in the WASM spec. Move them to their respective sections once finalized.
	StringNew = BinaryenObj["_BinaryenStringNewId"](),
	StringConst = BinaryenObj["_BinaryenStringConstId"](),
	StringMeasure = BinaryenObj["_BinaryenStringMeasureId"](),
	StringEncode = BinaryenObj["_BinaryenStringEncodeId"](),
	StringConcat = BinaryenObj["_BinaryenStringConcatId"](),
	StringEq = BinaryenObj["_BinaryenStringEqId"](),
	StringWTF16Get = BinaryenObj["_BinaryenStringWTF16GetId"](),
	StringSliceWTF = BinaryenObj["_BinaryenStringSliceWTFId"](),
}



// ## Externals ## //
// see https://webassembly.github.io/spec/core/syntax/modules.html
export enum ExternalKind {
	ExternalTag = BinaryenObj["_BinaryenExternalTag"](),
	ExternalGlobal = BinaryenObj["_BinaryenExternalGlobal"](),
	ExternalMemory = BinaryenObj["_BinaryenExternalMemory"](),
	ExternalTable = BinaryenObj["_BinaryenExternalTable"](),
	ExternalFunction = BinaryenObj["_BinaryenExternalFunction"](),
}



export enum MemoryOrder {
	unordered = BinaryenObj["_BinaryenMemoryOrderUnordered"](),
	seqcst = BinaryenObj["_BinaryenMemoryOrderSeqCst"](),
	acqrel = BinaryenObj["_BinaryenMemoryOrderAcqRel"](),
}
