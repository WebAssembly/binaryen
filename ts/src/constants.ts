// # Expressions, Types, and Constants # //
// Compile-time types used by TypeScript, Binaryen types, expression types, and other enums.



import {
	BinaryenObj,
} from "./-pre.ts";



// ## Static Types ## //
// ### Expressions ### //
export type Type = number;
export type HeapType = number;
export type PackedType = number;
export type ExpressionRef = number;

// ### Module Components ### //
/** Reference to a {@link Module.Tag}. */
export type TagRef = number;
/** Reference to a {@link Module.Global}. */
export type GlobalRef = number;
// no `MemoryRef`
/** Reference to a {@link Module.Table}. */
export type TableRef = number;
/** Reference to a {@link Module.Function}. */
export type FunctionRef = number;
/** Reference to a {@link Module.DataSegment}. */
export type DataSegmentRef = number;
/** Reference to an {@link Module.ElementSegment}. */
export type ElementSegmentRef = number;
// no `ImportRef`
/** Reference to an {@link Module.Export}. */
export type ExportRef = number;



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
/** 32-bit integer. */
export const i32: Type = BinaryenObj["_BinaryenTypeInt32"]();
/** 64-bit integer. */
export const i64: Type = BinaryenObj["_BinaryenTypeInt64"]();
/** 64-bit float. */
export const f32: Type = BinaryenObj["_BinaryenTypeFloat32"]();
/** 64-bit float. */
export const f64: Type = BinaryenObj["_BinaryenTypeFloat64"]();
/** 128-bit vector (SIMD). */
export const v128: Type = BinaryenObj["_BinaryenTypeVec128"]();

// ### Reference Types ### //
/** `(ref null any)` */
export const anyref: Type = BinaryenObj["_BinaryenTypeAnyref"]();
/** `(ref null eq)` */
export const eqref: Type = BinaryenObj["_BinaryenTypeEqref"]();
/** `(ref null i31)` */
export const i31ref: Type = BinaryenObj["_BinaryenTypeI31ref"]();
/** `(ref null struct)` */
export const structref: Type = BinaryenObj["_BinaryenTypeStructref"]();
/** `(ref null array)` */
export const arrayref: Type = BinaryenObj["_BinaryenTypeArrayref"]();
/** `(ref null func)` */
export const funcref: Type = BinaryenObj["_BinaryenTypeFuncref"]();
/** `(ref null exn)` */
// export const exnref: Type = BinaryenObj["_BinaryenTypeExnref"](); // TODO: uncomment once supported in Binaryen
/** `(ref null extern)` */
export const externref: Type = BinaryenObj["_BinaryenTypeExternref"]();
/** `(ref null none)` */
export const nullref: Type = BinaryenObj["_BinaryenTypeNullref"]();
/** `(ref null nofunc)` */
export const nullfuncref: Type = BinaryenObj["_BinaryenTypeNullFuncref"]();
/** `(ref null noexn)` */
// export const nullexnref: Type = BinaryenObj["_BinaryenTypeNullExnref"](); // TODO: uncomment once supported in Binaryen
/** `(ref null noextern)` */
export const nullexternref: Type = BinaryenObj["_BinaryenTypeNullExternref"]();

// ### Packed Types ### //
export const notPacked: PackedType = BinaryenObj["_BinaryenPackedTypeNotPacked"]();
export const i8: PackedType = BinaryenObj["_BinaryenPackedTypeInt8"]();
export const i16: PackedType = BinaryenObj["_BinaryenPackedTypeInt16"]();

// ### Proposed Types ### //
// These types are not yet in the WASM spec. Move them to their respective sections once finalized.
/** `(ref null string)` */
export const stringref: Type = BinaryenObj["_BinaryenTypeStringref"]();



// ## Enumerated Values ## //
/**
 * An enumeration of all the “kinds” of expressions.
 * @see https://webassembly.github.io/spec/core/syntax/instructions.html
 */
export enum ExpressionId {
	// ### Binaryen-Only Instruction Ids ### //
	Invalid = BinaryenObj["_BinaryenInvalidId"](),
	Pop = BinaryenObj["_BinaryenPopId"](),

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
	RefI31 = BinaryenObj["_BinaryenRefI31Id"](),
	I31Get = BinaryenObj["_BinaryenI31GetId"](),

	// ### Aggregate Instruction Ids ### //
	TupleMake = BinaryenObj["_BinaryenTupleMakeId"](),
	TupleExtract = BinaryenObj["_BinaryenTupleExtractId"](),
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

/** Expression side-effects. */
export enum SideEffect {
	None = BinaryenObj["_BinaryenSideEffectNone"](),
	Branches = BinaryenObj["_BinaryenSideEffectBranches"](),
	Calls = BinaryenObj["_BinaryenSideEffectCalls"](),
	ReadsLocal = BinaryenObj["_BinaryenSideEffectReadsLocal"](),
	WritesLocal = BinaryenObj["_BinaryenSideEffectWritesLocal"](),
	ReadsGlobal = BinaryenObj["_BinaryenSideEffectReadsGlobal"](),
	WritesGlobal = BinaryenObj["_BinaryenSideEffectWritesGlobal"](),
	ReadsMemory = BinaryenObj["_BinaryenSideEffectReadsMemory"](),
	WritesMemory = BinaryenObj["_BinaryenSideEffectWritesMemory"](),
	ReadsTable = BinaryenObj["_BinaryenSideEffectReadsTable"](),
	WritesTable = BinaryenObj["_BinaryenSideEffectWritesTable"](),
	ImplicitTrap = BinaryenObj["_BinaryenSideEffectImplicitTrap"](),
	IsAtomic = BinaryenObj["_BinaryenSideEffectIsAtomic"](),
	Throws = BinaryenObj["_BinaryenSideEffectThrows"](),
	DanglingPop = BinaryenObj["_BinaryenSideEffectDanglingPop"](),
	TrapsNeverHappen = BinaryenObj["_BinaryenSideEffectTrapsNeverHappen"](),
	Any = BinaryenObj["_BinaryenSideEffectAny"](),
}

/**
 * External kinds.
 * @see https://webassembly.github.io/spec/core/syntax/modules.html
 */
export enum ExternalKind {
	ExternalTag = BinaryenObj["_BinaryenExternalTag"](),
	ExternalGlobal = BinaryenObj["_BinaryenExternalGlobal"](),
	ExternalMemory = BinaryenObj["_BinaryenExternalMemory"](),
	ExternalTable = BinaryenObj["_BinaryenExternalTable"](),
	ExternalFunction = BinaryenObj["_BinaryenExternalFunction"](),
}
