// @ts-ignore
import Binaryen from "./binaryen_wasm_ts.js"
const JSModule = await Binaryen();
const _malloc: (size: number) => number = JSModule._malloc;
const _free: (size: number) => void = JSModule._free;
const HEAP8: Int8Array = JSModule.HEAP8;
const HEAPU8: Uint8Array = JSModule.HEAPU8;
const HEAP32: Int32Array = JSModule.HEAP32;
const HEAPU32: Uint32Array = JSModule.HEAPU32;
type Writer = (s: string) => void;
const utils = JSModule['utils'];
const swapOut: (func: Writer) => Writer = utils.swapOut;
const stringToAscii: (s: string, ptr: number) => void = utils.stringToAscii;
const stackSave: () => number = utils.stackSave;
const stackAlloc: (size: number) => number = utils.stackAlloc;
const stackRestore: (ref: number) => void = utils.stackRestore;
const allocateUTF8OnStack: (s: string) => number = utils.allocateUTF8OnStack;
const _BinaryenSizeofLiteral: () => number = utils._BinaryenSizeofLiteral;
const _BinaryenSizeofAllocateAndWriteResult: () => number = utils._BinaryenSizeofAllocateAndWriteResult;
const UTF8ToString: (ptr: number) => string | null = utils.UTF8ToString;
const __i32_store: (offset: number, value: number) => void = JSModule['__i32_store'];
const __i32_load: (offset: number) => number = JSModule['__i32_load'];


function preserveStack<R>(func: () => R): R {
  try {
    var stack = stackSave();
    return func();
  } finally {
    stackRestore(stack);
  }
}

function strToStack(str: string) {
  return str ? allocateUTF8OnStack(str) : 0;
}

function i32sToStack(i32s: ArrayLike<number>): number {
  const ret = stackAlloc(i32s.length << 2);
  HEAP32.set(i32s, ret >>> 2);
  return ret;
}

function i8sToStack(i8s: ArrayLike<number>): number {
  const ret = stackAlloc(i8s.length);
  HEAP8.set(i8s, ret);
  return ret;
}

function getAllNested<T>(ref: ExpressionRef, numFn: (ref: ExpressionRef) => number, getFn: (ref: ExpressionRef, i: number) => T): T[] {
  const num = numFn(ref);
  const ret = new Array<T>(num);
  for (let i = 0; i < num; ++i) ret[i] = getFn(ref, i);
  return ret;
}

export const sizeOfLiteral: number = _BinaryenSizeofLiteral();

export type Type = number;
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
export type HeapType = number;

export const none: Type = JSModule['_BinaryenTypeNone']();
export const i32: Type = JSModule['_BinaryenTypeInt32']();
export const i64: Type = JSModule['_BinaryenTypeInt64']();
export const f32: Type = JSModule['_BinaryenTypeFloat32']();
export const f64: Type = JSModule['_BinaryenTypeFloat64']();
export const v128: Type = JSModule['_BinaryenTypeVec128']();
export const funcref: Type = JSModule['_BinaryenTypeFuncref']();
export const externref: Type = JSModule['_BinaryenTypeExternref']();
export const anyref: Type = JSModule['_BinaryenTypeAnyref']();
export const eqref: Type = JSModule['_BinaryenTypeEqref']();
export const i31ref: Type = JSModule['_BinaryenTypeI31ref']();
export const structref: Type = JSModule['_BinaryenTypeStructref']();
/* explicitly skipping string stuff until it's reprioritized
export const stringref: Type = JSModule['_BinaryenTypeStringref']();
export const stringview_wtf8: Type = JSModule['_BinaryenTypeStringviewWTF8']();
export const stringview_wtf16: Type = JSModule['_BinaryenTypeStringviewWTF16']();
export const stringview_iter: Type = JSModule['_BinaryenTypeStringviewIter']();
*/
export const unreachable: Type = JSModule['_BinaryenTypeUnreachable']();
export const auto: Type = JSModule['_BinaryenTypeAuto']();

export function createType(types: Type[]): Type {
    return preserveStack(() => JSModule['_BinaryenTypeCreate'](i32sToStack(types), types.length));
}
export function expandType(type: Type): Type[] {
    return preserveStack(() => {
        const numTypes = JSModule['_BinaryenTypeArity'](type);
        const array = stackAlloc(numTypes << 2);
        JSModule['_BinaryenTypeExpand'](type, array);
        const types = new Array(numTypes);
        for (let i = 0; i < numTypes; i++) {
          types[i] = HEAPU32[(array >>> 2) + i];
        }
        return types;
    });
}

export enum ExternalKinds {
    Function = JSModule['_BinaryenExternalFunction'](),
    Table = JSModule['_BinaryenExternalTable'](),
    Memory = JSModule['_BinaryenExternalMemory'](),
    Global = JSModule['_BinaryenExternalGlobal'](),
    Tag = JSModule['_BinaryenExternalTag']()
}

export enum Features {
    MVP = JSModule['_BinaryenFeatureMVP'](),
    Atomics = JSModule['_BinaryenFeatureAtomics'](),
    BulkMemory = JSModule['_BinaryenFeatureBulkMemory'](),
    MutableGlobals = JSModule['_BinaryenFeatureMutableGlobals'](),
    NontrappingFPToInt = JSModule['_BinaryenFeatureNontrappingFPToInt'](),
    SignExt = JSModule['_BinaryenFeatureSignExt'](),
    SIMD128 = JSModule['_BinaryenFeatureSIMD128'](),
    ExceptionHandling = JSModule['_BinaryenFeatureExceptionHandling'](),
    TailCall = JSModule['_BinaryenFeatureTailCall'](),
    ReferenceTypes = JSModule['_BinaryenFeatureReferenceTypes'](),
    Multivalue = JSModule['_BinaryenFeatureMultivalue'](),
    GC = JSModule['_BinaryenFeatureGC'](),
    Memory64 = JSModule['_BinaryenFeatureMemory64'](),
    RelaxedSIMD = JSModule['_BinaryenFeatureRelaxedSIMD'](),
    ExtendedConst = JSModule['_BinaryenFeatureExtendedConst'](),
    /* explicitly skipping string stuff until it's reprioritized
    Strings = JSModule['_BinaryenFeatureStrings'](),
    */
    All = JSModule['_BinaryenFeatureAll']()
}
export enum Operations {
    ClzInt32 = JSModule['_BinaryenClzInt32'](),
    CtzInt32 = JSModule['_BinaryenCtzInt32'](),
    PopcntInt32 = JSModule['_BinaryenPopcntInt32'](),
    NegFloat32 = JSModule['_BinaryenNegFloat32'](),
    AbsFloat32 = JSModule['_BinaryenAbsFloat32'](),
    CeilFloat32 = JSModule['_BinaryenCeilFloat32'](),
    FloorFloat32 = JSModule['_BinaryenFloorFloat32'](),
    TruncFloat32 = JSModule['_BinaryenTruncFloat32'](),
    NearestFloat32 = JSModule['_BinaryenNearestFloat32'](),
    SqrtFloat32 = JSModule['_BinaryenSqrtFloat32'](),
    EqZInt32 = JSModule['_BinaryenEqZInt32'](),
    ClzInt64 = JSModule['_BinaryenClzInt64'](),
    CtzInt64 = JSModule['_BinaryenCtzInt64'](),
    PopcntInt64 = JSModule['_BinaryenPopcntInt64'](),
    NegFloat64 = JSModule['_BinaryenNegFloat64'](),
    AbsFloat64 = JSModule['_BinaryenAbsFloat64'](),
    CeilFloat64 = JSModule['_BinaryenCeilFloat64'](),
    FloorFloat64 = JSModule['_BinaryenFloorFloat64'](),
    TruncFloat64 = JSModule['_BinaryenTruncFloat64'](),
    NearestFloat64 = JSModule['_BinaryenNearestFloat64'](),
    SqrtFloat64 = JSModule['_BinaryenSqrtFloat64'](),
    EqZInt64 = JSModule['_BinaryenEqZInt64'](),
    ExtendSInt32 = JSModule['_BinaryenExtendSInt32'](),
    ExtendUInt32 = JSModule['_BinaryenExtendUInt32'](),
    WrapInt64 = JSModule['_BinaryenWrapInt64'](),
    TruncSFloat32ToInt32 = JSModule['_BinaryenTruncSFloat32ToInt32'](),
    TruncSFloat32ToInt64 = JSModule['_BinaryenTruncSFloat32ToInt64'](),
    TruncUFloat32ToInt32 = JSModule['_BinaryenTruncUFloat32ToInt32'](),
    TruncUFloat32ToInt64 = JSModule['_BinaryenTruncUFloat32ToInt64'](),
    TruncSFloat64ToInt32 = JSModule['_BinaryenTruncSFloat64ToInt32'](),
    TruncSFloat64ToInt64 = JSModule['_BinaryenTruncSFloat64ToInt64'](),
    TruncUFloat64ToInt32 = JSModule['_BinaryenTruncUFloat64ToInt32'](),
    TruncUFloat64ToInt64 = JSModule['_BinaryenTruncUFloat64ToInt64'](),
    TruncSatSFloat32ToInt32 = JSModule['_BinaryenTruncSatSFloat32ToInt32'](),
    TruncSatSFloat32ToInt64 = JSModule['_BinaryenTruncSatSFloat32ToInt64'](),
    TruncSatUFloat32ToInt32 = JSModule['_BinaryenTruncSatUFloat32ToInt32'](),
    TruncSatUFloat32ToInt64 = JSModule['_BinaryenTruncSatUFloat32ToInt64'](),
    TruncSatSFloat64ToInt32 = JSModule['_BinaryenTruncSatSFloat64ToInt32'](),
    TruncSatSFloat64ToInt64 = JSModule['_BinaryenTruncSatSFloat64ToInt64'](),
    TruncSatUFloat64ToInt32 = JSModule['_BinaryenTruncSatUFloat64ToInt32'](),
    TruncSatUFloat64ToInt64 = JSModule['_BinaryenTruncSatUFloat64ToInt64'](),
    ReinterpretFloat32 = JSModule['_BinaryenReinterpretFloat32'](),
    ReinterpretFloat64 = JSModule['_BinaryenReinterpretFloat64'](),
    ConvertSInt32ToFloat32 = JSModule['_BinaryenConvertSInt32ToFloat32'](),
    ConvertSInt32ToFloat64 = JSModule['_BinaryenConvertSInt32ToFloat64'](),
    ConvertUInt32ToFloat32 = JSModule['_BinaryenConvertUInt32ToFloat32'](),
    ConvertUInt32ToFloat64 = JSModule['_BinaryenConvertUInt32ToFloat64'](),
    ConvertSInt64ToFloat32 = JSModule['_BinaryenConvertSInt64ToFloat32'](),
    ConvertSInt64ToFloat64 = JSModule['_BinaryenConvertSInt64ToFloat64'](),
    ConvertUInt64ToFloat32 = JSModule['_BinaryenConvertUInt64ToFloat32'](),
    ConvertUInt64ToFloat64 = JSModule['_BinaryenConvertUInt64ToFloat64'](),
    PromoteFloat32 = JSModule['_BinaryenPromoteFloat32'](),
    DemoteFloat64 = JSModule['_BinaryenDemoteFloat64'](),
    ReinterpretInt32 = JSModule['_BinaryenReinterpretInt32'](),
    ReinterpretInt64 = JSModule['_BinaryenReinterpretInt64'](),
    ExtendS8Int32 = JSModule['_BinaryenExtendS8Int32'](),
    ExtendS16Int32 = JSModule['_BinaryenExtendS16Int32'](),
    ExtendS8Int64 = JSModule['_BinaryenExtendS8Int64'](),
    ExtendS16Int64 = JSModule['_BinaryenExtendS16Int64'](),
    ExtendS32Int64 = JSModule['_BinaryenExtendS32Int64'](),
    AddInt32 = JSModule['_BinaryenAddInt32'](),
    SubInt32 = JSModule['_BinaryenSubInt32'](),
    MulInt32 = JSModule['_BinaryenMulInt32'](),
    DivSInt32 = JSModule['_BinaryenDivSInt32'](),
    DivUInt32 = JSModule['_BinaryenDivUInt32'](),
    RemSInt32 = JSModule['_BinaryenRemSInt32'](),
    RemUInt32 = JSModule['_BinaryenRemUInt32'](),
    AndInt32 = JSModule['_BinaryenAndInt32'](),
    OrInt32 = JSModule['_BinaryenOrInt32'](),
    XorInt32 = JSModule['_BinaryenXorInt32'](),
    ShlInt32 = JSModule['_BinaryenShlInt32'](),
    ShrUInt32 = JSModule['_BinaryenShrUInt32'](),
    ShrSInt32 = JSModule['_BinaryenShrSInt32'](),
    RotLInt32 = JSModule['_BinaryenRotLInt32'](),
    RotRInt32 = JSModule['_BinaryenRotRInt32'](),
    EqInt32 = JSModule['_BinaryenEqInt32'](),
    NeInt32 = JSModule['_BinaryenNeInt32'](),
    LtSInt32 = JSModule['_BinaryenLtSInt32'](),
    LtUInt32 = JSModule['_BinaryenLtUInt32'](),
    LeSInt32 = JSModule['_BinaryenLeSInt32'](),
    LeUInt32 = JSModule['_BinaryenLeUInt32'](),
    GtSInt32 = JSModule['_BinaryenGtSInt32'](),
    GtUInt32 = JSModule['_BinaryenGtUInt32'](),
    GeSInt32 = JSModule['_BinaryenGeSInt32'](),
    GeUInt32 = JSModule['_BinaryenGeUInt32'](),
    AddInt64 = JSModule['_BinaryenAddInt64'](),
    SubInt64 = JSModule['_BinaryenSubInt64'](),
    MulInt64 = JSModule['_BinaryenMulInt64'](),
    DivSInt64 = JSModule['_BinaryenDivSInt64'](),
    DivUInt64 = JSModule['_BinaryenDivUInt64'](),
    RemSInt64 = JSModule['_BinaryenRemSInt64'](),
    RemUInt64 = JSModule['_BinaryenRemUInt64'](),
    AndInt64 = JSModule['_BinaryenAndInt64'](),
    OrInt64 = JSModule['_BinaryenOrInt64'](),
    XorInt64 = JSModule['_BinaryenXorInt64'](),
    ShlInt64 = JSModule['_BinaryenShlInt64'](),
    ShrUInt64 = JSModule['_BinaryenShrUInt64'](),
    ShrSInt64 = JSModule['_BinaryenShrSInt64'](),
    RotLInt64 = JSModule['_BinaryenRotLInt64'](),
    RotRInt64 = JSModule['_BinaryenRotRInt64'](),
    EqInt64 = JSModule['_BinaryenEqInt64'](),
    NeInt64 = JSModule['_BinaryenNeInt64'](),
    LtSInt64 = JSModule['_BinaryenLtSInt64'](),
    LtUInt64 = JSModule['_BinaryenLtUInt64'](),
    LeSInt64 = JSModule['_BinaryenLeSInt64'](),
    LeUInt64 = JSModule['_BinaryenLeUInt64'](),
    GtSInt64 = JSModule['_BinaryenGtSInt64'](),
    GtUInt64 = JSModule['_BinaryenGtUInt64'](),
    GeSInt64 = JSModule['_BinaryenGeSInt64'](),
    GeUInt64 = JSModule['_BinaryenGeUInt64'](),
    AddFloat32 = JSModule['_BinaryenAddFloat32'](),
    SubFloat32 = JSModule['_BinaryenSubFloat32'](),
    MulFloat32 = JSModule['_BinaryenMulFloat32'](),
    DivFloat32 = JSModule['_BinaryenDivFloat32'](),
    CopySignFloat32 = JSModule['_BinaryenCopySignFloat32'](),
    MinFloat32 = JSModule['_BinaryenMinFloat32'](),
    MaxFloat32 = JSModule['_BinaryenMaxFloat32'](),
    EqFloat32 = JSModule['_BinaryenEqFloat32'](),
    NeFloat32 = JSModule['_BinaryenNeFloat32'](),
    LtFloat32 = JSModule['_BinaryenLtFloat32'](),
    LeFloat32 = JSModule['_BinaryenLeFloat32'](),
    GtFloat32 = JSModule['_BinaryenGtFloat32'](),
    GeFloat32 = JSModule['_BinaryenGeFloat32'](),
    AddFloat64 = JSModule['_BinaryenAddFloat64'](),
    SubFloat64 = JSModule['_BinaryenSubFloat64'](),
    MulFloat64 = JSModule['_BinaryenMulFloat64'](),
    DivFloat64 = JSModule['_BinaryenDivFloat64'](),
    CopySignFloat64 = JSModule['_BinaryenCopySignFloat64'](),
    MinFloat64 = JSModule['_BinaryenMinFloat64'](),
    MaxFloat64 = JSModule['_BinaryenMaxFloat64'](),
    EqFloat64 = JSModule['_BinaryenEqFloat64'](),
    NeFloat64 = JSModule['_BinaryenNeFloat64'](),
    LtFloat64 = JSModule['_BinaryenLtFloat64'](),
    LeFloat64 = JSModule['_BinaryenLeFloat64'](),
    GtFloat64 = JSModule['_BinaryenGtFloat64'](),
    GeFloat64 = JSModule['_BinaryenGeFloat64'](),
    AtomicRMWAdd = JSModule['_BinaryenAtomicRMWAdd'](),
    AtomicRMWSub = JSModule['_BinaryenAtomicRMWSub'](),
    AtomicRMWAnd = JSModule['_BinaryenAtomicRMWAnd'](),
    AtomicRMWOr = JSModule['_BinaryenAtomicRMWOr'](),
    AtomicRMWXor = JSModule['_BinaryenAtomicRMWXor'](),
    AtomicRMWXchg = JSModule['_BinaryenAtomicRMWXchg'](),
    SplatVecI8x16 = JSModule['_BinaryenSplatVecI8x16'](),
    ExtractLaneSVecI8x16 = JSModule['_BinaryenExtractLaneSVecI8x16'](),
    ExtractLaneUVecI8x16 = JSModule['_BinaryenExtractLaneUVecI8x16'](),
    ReplaceLaneVecI8x16 = JSModule['_BinaryenReplaceLaneVecI8x16'](),
    SplatVecI16x8 = JSModule['_BinaryenSplatVecI16x8'](),
    ExtractLaneSVecI16x8 = JSModule['_BinaryenExtractLaneSVecI16x8'](),
    ExtractLaneUVecI16x8 = JSModule['_BinaryenExtractLaneUVecI16x8'](),
    ReplaceLaneVecI16x8 = JSModule['_BinaryenReplaceLaneVecI16x8'](),
    SplatVecI32x4 = JSModule['_BinaryenSplatVecI32x4'](),
    ExtractLaneVecI32x4 = JSModule['_BinaryenExtractLaneVecI32x4'](),
    ReplaceLaneVecI32x4 = JSModule['_BinaryenReplaceLaneVecI32x4'](),
    SplatVecI64x2 = JSModule['_BinaryenSplatVecI64x2'](),
    ExtractLaneVecI64x2 = JSModule['_BinaryenExtractLaneVecI64x2'](),
    ReplaceLaneVecI64x2 = JSModule['_BinaryenReplaceLaneVecI64x2'](),
    SplatVecF32x4 = JSModule['_BinaryenSplatVecF32x4'](),
    ExtractLaneVecF32x4 = JSModule['_BinaryenExtractLaneVecF32x4'](),
    ReplaceLaneVecF32x4 = JSModule['_BinaryenReplaceLaneVecF32x4'](),
    SplatVecF64x2 = JSModule['_BinaryenSplatVecF64x2'](),
    ExtractLaneVecF64x2 = JSModule['_BinaryenExtractLaneVecF64x2'](),
    ReplaceLaneVecF64x2 = JSModule['_BinaryenReplaceLaneVecF64x2'](),
    EqVecI8x16 = JSModule['_BinaryenEqVecI8x16'](),
    NeVecI8x16 = JSModule['_BinaryenNeVecI8x16'](),
    LtSVecI8x16 = JSModule['_BinaryenLtSVecI8x16'](),
    LtUVecI8x16 = JSModule['_BinaryenLtUVecI8x16'](),
    GtSVecI8x16 = JSModule['_BinaryenGtSVecI8x16'](),
    GtUVecI8x16 = JSModule['_BinaryenGtUVecI8x16'](),
    LeSVecI8x16 = JSModule['_BinaryenLeSVecI8x16'](),
    LeUVecI8x16 = JSModule['_BinaryenLeUVecI8x16'](),
    GeSVecI8x16 = JSModule['_BinaryenGeSVecI8x16'](),
    GeUVecI8x16 = JSModule['_BinaryenGeUVecI8x16'](),
    EqVecI16x8 = JSModule['_BinaryenEqVecI16x8'](),
    NeVecI16x8 = JSModule['_BinaryenNeVecI16x8'](),
    LtSVecI16x8 = JSModule['_BinaryenLtSVecI16x8'](),
    LtUVecI16x8 = JSModule['_BinaryenLtUVecI16x8'](),
    GtSVecI16x8 = JSModule['_BinaryenGtSVecI16x8'](),
    GtUVecI16x8 = JSModule['_BinaryenGtUVecI16x8'](),
    LeSVecI16x8 = JSModule['_BinaryenLeSVecI16x8'](),
    LeUVecI16x8 = JSModule['_BinaryenLeUVecI16x8'](),
    GeSVecI16x8 = JSModule['_BinaryenGeSVecI16x8'](),
    GeUVecI16x8 = JSModule['_BinaryenGeUVecI16x8'](),
    EqVecI32x4 = JSModule['_BinaryenEqVecI32x4'](),
    NeVecI32x4 = JSModule['_BinaryenNeVecI32x4'](),
    LtSVecI32x4 = JSModule['_BinaryenLtSVecI32x4'](),
    LtUVecI32x4 = JSModule['_BinaryenLtUVecI32x4'](),
    GtSVecI32x4 = JSModule['_BinaryenGtSVecI32x4'](),
    GtUVecI32x4 = JSModule['_BinaryenGtUVecI32x4'](),
    LeSVecI32x4 = JSModule['_BinaryenLeSVecI32x4'](),
    LeUVecI32x4 = JSModule['_BinaryenLeUVecI32x4'](),
    GeSVecI32x4 = JSModule['_BinaryenGeSVecI32x4'](),
    GeUVecI32x4 = JSModule['_BinaryenGeUVecI32x4'](),
    EqVecI64x2 = JSModule['_BinaryenEqVecI64x2'](),
    NeVecI64x2 = JSModule['_BinaryenNeVecI64x2'](),
    LtSVecI64x2 = JSModule['_BinaryenLtSVecI64x2'](),
    GtSVecI64x2 = JSModule['_BinaryenGtSVecI64x2'](),
    LeSVecI64x2 = JSModule['_BinaryenLeSVecI64x2'](),
    GeSVecI64x2 = JSModule['_BinaryenGeSVecI64x2'](),
    EqVecF32x4 = JSModule['_BinaryenEqVecF32x4'](),
    NeVecF32x4 = JSModule['_BinaryenNeVecF32x4'](),
    LtVecF32x4 = JSModule['_BinaryenLtVecF32x4'](),
    GtVecF32x4 = JSModule['_BinaryenGtVecF32x4'](),
    LeVecF32x4 = JSModule['_BinaryenLeVecF32x4'](),
    GeVecF32x4 = JSModule['_BinaryenGeVecF32x4'](),
    EqVecF64x2 = JSModule['_BinaryenEqVecF64x2'](),
    NeVecF64x2 = JSModule['_BinaryenNeVecF64x2'](),
    LtVecF64x2 = JSModule['_BinaryenLtVecF64x2'](),
    GtVecF64x2 = JSModule['_BinaryenGtVecF64x2'](),
    LeVecF64x2 = JSModule['_BinaryenLeVecF64x2'](),
    GeVecF64x2 = JSModule['_BinaryenGeVecF64x2'](),
    NotVec128 = JSModule['_BinaryenNotVec128'](),
    AndVec128 = JSModule['_BinaryenAndVec128'](),
    OrVec128 = JSModule['_BinaryenOrVec128'](),
    XorVec128 = JSModule['_BinaryenXorVec128'](),
    AndNotVec128 = JSModule['_BinaryenAndNotVec128'](),
    BitselectVec128 = JSModule['_BinaryenBitselectVec128'](),
    RelaxedFmaVecF32x4 = JSModule['_BinaryenRelaxedFmaVecF32x4'](),
    RelaxedFmsVecF32x4 = JSModule['_BinaryenRelaxedFmsVecF32x4'](),
    RelaxedFmaVecF64x2 = JSModule['_BinaryenRelaxedFmaVecF64x2'](),
    RelaxedFmsVecF64x2 = JSModule['_BinaryenRelaxedFmsVecF64x2'](),
    LaneselectI8x16 = JSModule['_BinaryenLaneselectI8x16'](),
    LaneselectI16x8 = JSModule['_BinaryenLaneselectI16x8'](),
    LaneselectI32x4 = JSModule['_BinaryenLaneselectI32x4'](),
    LaneselectI64x2 = JSModule['_BinaryenLaneselectI64x2'](),
    DotI8x16I7x16AddSToVecI32x4 = JSModule['_BinaryenDotI8x16I7x16AddSToVecI32x4'](),
    AnyTrueVec128 = JSModule['_BinaryenAnyTrueVec128'](),
    PopcntVecI8x16 = JSModule['_BinaryenPopcntVecI8x16'](),
    AbsVecI8x16 = JSModule['_BinaryenAbsVecI8x16'](),
    NegVecI8x16 = JSModule['_BinaryenNegVecI8x16'](),
    AllTrueVecI8x16 = JSModule['_BinaryenAllTrueVecI8x16'](),
    BitmaskVecI8x16 = JSModule['_BinaryenBitmaskVecI8x16'](),
    ShlVecI8x16 = JSModule['_BinaryenShlVecI8x16'](),
    ShrSVecI8x16 = JSModule['_BinaryenShrSVecI8x16'](),
    ShrUVecI8x16 = JSModule['_BinaryenShrUVecI8x16'](),
    AddVecI8x16 = JSModule['_BinaryenAddVecI8x16'](),
    AddSatSVecI8x16 = JSModule['_BinaryenAddSatSVecI8x16'](),
    AddSatUVecI8x16 = JSModule['_BinaryenAddSatUVecI8x16'](),
    SubVecI8x16 = JSModule['_BinaryenSubVecI8x16'](),
    SubSatSVecI8x16 = JSModule['_BinaryenSubSatSVecI8x16'](),
    SubSatUVecI8x16 = JSModule['_BinaryenSubSatUVecI8x16'](),
    MinSVecI8x16 = JSModule['_BinaryenMinSVecI8x16'](),
    MinUVecI8x16 = JSModule['_BinaryenMinUVecI8x16'](),
    MaxSVecI8x16 = JSModule['_BinaryenMaxSVecI8x16'](),
    MaxUVecI8x16 = JSModule['_BinaryenMaxUVecI8x16'](),
    AvgrUVecI8x16 = JSModule['_BinaryenAvgrUVecI8x16'](),
    AbsVecI16x8 = JSModule['_BinaryenAbsVecI16x8'](),
    NegVecI16x8 = JSModule['_BinaryenNegVecI16x8'](),
    AllTrueVecI16x8 = JSModule['_BinaryenAllTrueVecI16x8'](),
    BitmaskVecI16x8 = JSModule['_BinaryenBitmaskVecI16x8'](),
    ShlVecI16x8 = JSModule['_BinaryenShlVecI16x8'](),
    ShrSVecI16x8 = JSModule['_BinaryenShrSVecI16x8'](),
    ShrUVecI16x8 = JSModule['_BinaryenShrUVecI16x8'](),
    AddVecI16x8 = JSModule['_BinaryenAddVecI16x8'](),
    AddSatSVecI16x8 = JSModule['_BinaryenAddSatSVecI16x8'](),
    AddSatUVecI16x8 = JSModule['_BinaryenAddSatUVecI16x8'](),
    SubVecI16x8 = JSModule['_BinaryenSubVecI16x8'](),
    SubSatSVecI16x8 = JSModule['_BinaryenSubSatSVecI16x8'](),
    SubSatUVecI16x8 = JSModule['_BinaryenSubSatUVecI16x8'](),
    MulVecI16x8 = JSModule['_BinaryenMulVecI16x8'](),
    MinSVecI16x8 = JSModule['_BinaryenMinSVecI16x8'](),
    MinUVecI16x8 = JSModule['_BinaryenMinUVecI16x8'](),
    MaxSVecI16x8 = JSModule['_BinaryenMaxSVecI16x8'](),
    MaxUVecI16x8 = JSModule['_BinaryenMaxUVecI16x8'](),
    AvgrUVecI16x8 = JSModule['_BinaryenAvgrUVecI16x8'](),
    Q15MulrSatSVecI16x8 = JSModule['_BinaryenQ15MulrSatSVecI16x8'](),
    ExtMulLowSVecI16x8 = JSModule['_BinaryenExtMulLowSVecI16x8'](),
    ExtMulHighSVecI16x8 = JSModule['_BinaryenExtMulHighSVecI16x8'](),
    ExtMulLowUVecI16x8 = JSModule['_BinaryenExtMulLowUVecI16x8'](),
    ExtMulHighUVecI16x8 = JSModule['_BinaryenExtMulHighUVecI16x8'](),
    DotSVecI16x8ToVecI32x4 = JSModule['_BinaryenDotSVecI16x8ToVecI32x4'](),
    ExtMulLowSVecI32x4 = JSModule['_BinaryenExtMulLowSVecI32x4'](),
    ExtMulHighSVecI32x4 = JSModule['_BinaryenExtMulHighSVecI32x4'](),
    ExtMulLowUVecI32x4 = JSModule['_BinaryenExtMulLowUVecI32x4'](),
    ExtMulHighUVecI32x4 = JSModule['_BinaryenExtMulHighUVecI32x4'](),
    AbsVecI32x4 = JSModule['_BinaryenAbsVecI32x4'](),
    NegVecI32x4 = JSModule['_BinaryenNegVecI32x4'](),
    AllTrueVecI32x4 = JSModule['_BinaryenAllTrueVecI32x4'](),
    BitmaskVecI32x4 = JSModule['_BinaryenBitmaskVecI32x4'](),
    ShlVecI32x4 = JSModule['_BinaryenShlVecI32x4'](),
    ShrSVecI32x4 = JSModule['_BinaryenShrSVecI32x4'](),
    ShrUVecI32x4 = JSModule['_BinaryenShrUVecI32x4'](),
    AddVecI32x4 = JSModule['_BinaryenAddVecI32x4'](),
    SubVecI32x4 = JSModule['_BinaryenSubVecI32x4'](),
    MulVecI32x4 = JSModule['_BinaryenMulVecI32x4'](),
    MinSVecI32x4 = JSModule['_BinaryenMinSVecI32x4'](),
    MinUVecI32x4 = JSModule['_BinaryenMinUVecI32x4'](),
    MaxSVecI32x4 = JSModule['_BinaryenMaxSVecI32x4'](),
    MaxUVecI32x4 = JSModule['_BinaryenMaxUVecI32x4'](),
    AbsVecI64x2 = JSModule['_BinaryenAbsVecI64x2'](),
    NegVecI64x2 = JSModule['_BinaryenNegVecI64x2'](),
    AllTrueVecI64x2 = JSModule['_BinaryenAllTrueVecI64x2'](),
    BitmaskVecI64x2 = JSModule['_BinaryenBitmaskVecI64x2'](),
    ShlVecI64x2 = JSModule['_BinaryenShlVecI64x2'](),
    ShrSVecI64x2 = JSModule['_BinaryenShrSVecI64x2'](),
    ShrUVecI64x2 = JSModule['_BinaryenShrUVecI64x2'](),
    AddVecI64x2 = JSModule['_BinaryenAddVecI64x2'](),
    SubVecI64x2 = JSModule['_BinaryenSubVecI64x2'](),
    MulVecI64x2 = JSModule['_BinaryenMulVecI64x2'](),
    ExtMulLowSVecI64x2 = JSModule['_BinaryenExtMulLowSVecI64x2'](),
    ExtMulHighSVecI64x2 = JSModule['_BinaryenExtMulHighSVecI64x2'](),
    ExtMulLowUVecI64x2 = JSModule['_BinaryenExtMulLowUVecI64x2'](),
    ExtMulHighUVecI64x2 = JSModule['_BinaryenExtMulHighUVecI64x2'](),
    AbsVecF32x4 = JSModule['_BinaryenAbsVecF32x4'](),
    NegVecF32x4 = JSModule['_BinaryenNegVecF32x4'](),
    SqrtVecF32x4 = JSModule['_BinaryenSqrtVecF32x4'](),
    AddVecF32x4 = JSModule['_BinaryenAddVecF32x4'](),
    SubVecF32x4 = JSModule['_BinaryenSubVecF32x4'](),
    MulVecF32x4 = JSModule['_BinaryenMulVecF32x4'](),
    DivVecF32x4 = JSModule['_BinaryenDivVecF32x4'](),
    MinVecF32x4 = JSModule['_BinaryenMinVecF32x4'](),
    MaxVecF32x4 = JSModule['_BinaryenMaxVecF32x4'](),
    PMinVecF32x4 = JSModule['_BinaryenPMinVecF32x4'](),
    PMaxVecF32x4 = JSModule['_BinaryenPMaxVecF32x4'](),
    CeilVecF32x4 = JSModule['_BinaryenCeilVecF32x4'](),
    FloorVecF32x4 = JSModule['_BinaryenFloorVecF32x4'](),
    TruncVecF32x4 = JSModule['_BinaryenTruncVecF32x4'](),
    NearestVecF32x4 = JSModule['_BinaryenNearestVecF32x4'](),
    AbsVecF64x2 = JSModule['_BinaryenAbsVecF64x2'](),
    NegVecF64x2 = JSModule['_BinaryenNegVecF64x2'](),
    SqrtVecF64x2 = JSModule['_BinaryenSqrtVecF64x2'](),
    AddVecF64x2 = JSModule['_BinaryenAddVecF64x2'](),
    SubVecF64x2 = JSModule['_BinaryenSubVecF64x2'](),
    MulVecF64x2 = JSModule['_BinaryenMulVecF64x2'](),
    DivVecF64x2 = JSModule['_BinaryenDivVecF64x2'](),
    MinVecF64x2 = JSModule['_BinaryenMinVecF64x2'](),
    MaxVecF64x2 = JSModule['_BinaryenMaxVecF64x2'](),
    PMinVecF64x2 = JSModule['_BinaryenPMinVecF64x2'](),
    PMaxVecF64x2 = JSModule['_BinaryenPMaxVecF64x2'](),
    CeilVecF64x2 = JSModule['_BinaryenCeilVecF64x2'](),
    FloorVecF64x2 = JSModule['_BinaryenFloorVecF64x2'](),
    TruncVecF64x2 = JSModule['_BinaryenTruncVecF64x2'](),
    NearestVecF64x2 = JSModule['_BinaryenNearestVecF64x2'](),
    ExtAddPairwiseSVecI8x16ToI16x8 = JSModule['_BinaryenExtAddPairwiseSVecI8x16ToI16x8'](),
    ExtAddPairwiseUVecI8x16ToI16x8 = JSModule['_BinaryenExtAddPairwiseUVecI8x16ToI16x8'](),
    ExtAddPairwiseSVecI16x8ToI32x4 = JSModule['_BinaryenExtAddPairwiseSVecI16x8ToI32x4'](),
    ExtAddPairwiseUVecI16x8ToI32x4 = JSModule['_BinaryenExtAddPairwiseUVecI16x8ToI32x4'](),
    TruncSatSVecF32x4ToVecI32x4 = JSModule['_BinaryenTruncSatSVecF32x4ToVecI32x4'](),
    TruncSatUVecF32x4ToVecI32x4 = JSModule['_BinaryenTruncSatUVecF32x4ToVecI32x4'](),
    ConvertSVecI32x4ToVecF32x4 = JSModule['_BinaryenConvertSVecI32x4ToVecF32x4'](),
    ConvertUVecI32x4ToVecF32x4 = JSModule['_BinaryenConvertUVecI32x4ToVecF32x4'](),
    Load8SplatVec128 = JSModule['_BinaryenLoad8SplatVec128'](),
    Load16SplatVec128 = JSModule['_BinaryenLoad16SplatVec128'](),
    Load32SplatVec128 = JSModule['_BinaryenLoad32SplatVec128'](),
    Load64SplatVec128 = JSModule['_BinaryenLoad64SplatVec128'](),
    Load8x8SVec128 = JSModule['_BinaryenLoad8x8SVec128'](),
    Load8x8UVec128 = JSModule['_BinaryenLoad8x8UVec128'](),
    Load16x4SVec128 = JSModule['_BinaryenLoad16x4SVec128'](),
    Load16x4UVec128 = JSModule['_BinaryenLoad16x4UVec128'](),
    Load32x2SVec128 = JSModule['_BinaryenLoad32x2SVec128'](),
    Load32x2UVec128 = JSModule['_BinaryenLoad32x2UVec128'](),
    Load32ZeroVec128 = JSModule['_BinaryenLoad32ZeroVec128'](),
    Load64ZeroVec128 = JSModule['_BinaryenLoad64ZeroVec128'](),
    Load8LaneVec128 = JSModule['_BinaryenLoad8LaneVec128'](),
    Load16LaneVec128 = JSModule['_BinaryenLoad16LaneVec128'](),
    Load32LaneVec128 = JSModule['_BinaryenLoad32LaneVec128'](),
    Load64LaneVec128 = JSModule['_BinaryenLoad64LaneVec128'](),
    Store8LaneVec128 = JSModule['_BinaryenStore8LaneVec128'](),
    Store16LaneVec128 = JSModule['_BinaryenStore16LaneVec128'](),
    Store32LaneVec128 = JSModule['_BinaryenStore32LaneVec128'](),
    Store64LaneVec128 = JSModule['_BinaryenStore64LaneVec128'](),
    NarrowSVecI16x8ToVecI8x16 = JSModule['_BinaryenNarrowSVecI16x8ToVecI8x16'](),
    NarrowUVecI16x8ToVecI8x16 = JSModule['_BinaryenNarrowUVecI16x8ToVecI8x16'](),
    NarrowSVecI32x4ToVecI16x8 = JSModule['_BinaryenNarrowSVecI32x4ToVecI16x8'](),
    NarrowUVecI32x4ToVecI16x8 = JSModule['_BinaryenNarrowUVecI32x4ToVecI16x8'](),
    ExtendLowSVecI8x16ToVecI16x8 = JSModule['_BinaryenExtendLowSVecI8x16ToVecI16x8'](),
    ExtendHighSVecI8x16ToVecI16x8 = JSModule['_BinaryenExtendHighSVecI8x16ToVecI16x8'](),
    ExtendLowUVecI8x16ToVecI16x8 = JSModule['_BinaryenExtendLowUVecI8x16ToVecI16x8'](),
    ExtendHighUVecI8x16ToVecI16x8 = JSModule['_BinaryenExtendHighUVecI8x16ToVecI16x8'](),
    ExtendLowSVecI16x8ToVecI32x4 = JSModule['_BinaryenExtendLowSVecI16x8ToVecI32x4'](),
    ExtendHighSVecI16x8ToVecI32x4 = JSModule['_BinaryenExtendHighSVecI16x8ToVecI32x4'](),
    ExtendLowUVecI16x8ToVecI32x4 = JSModule['_BinaryenExtendLowUVecI16x8ToVecI32x4'](),
    ExtendHighUVecI16x8ToVecI32x4 = JSModule['_BinaryenExtendHighUVecI16x8ToVecI32x4'](),
    ExtendLowSVecI32x4ToVecI64x2 = JSModule['_BinaryenExtendLowSVecI32x4ToVecI64x2'](),
    ExtendHighSVecI32x4ToVecI64x2 = JSModule['_BinaryenExtendHighSVecI32x4ToVecI64x2'](),
    ExtendLowUVecI32x4ToVecI64x2 = JSModule['_BinaryenExtendLowUVecI32x4ToVecI64x2'](),
    ExtendHighUVecI32x4ToVecI64x2 = JSModule['_BinaryenExtendHighUVecI32x4ToVecI64x2'](),
    ConvertLowSVecI32x4ToVecF64x2 = JSModule['_BinaryenConvertLowSVecI32x4ToVecF64x2'](),
    ConvertLowUVecI32x4ToVecF64x2 = JSModule['_BinaryenConvertLowUVecI32x4ToVecF64x2'](),
    TruncSatZeroSVecF64x2ToVecI32x4 = JSModule['_BinaryenTruncSatZeroSVecF64x2ToVecI32x4'](),
    TruncSatZeroUVecF64x2ToVecI32x4 = JSModule['_BinaryenTruncSatZeroUVecF64x2ToVecI32x4'](),
    DemoteZeroVecF64x2ToVecF32x4 = JSModule['_BinaryenDemoteZeroVecF64x2ToVecF32x4'](),
    PromoteLowVecF32x4ToVecF64x2 = JSModule['_BinaryenPromoteLowVecF32x4ToVecF64x2'](),
    RelaxedTruncSVecF32x4ToVecI32x4 = JSModule['_BinaryenRelaxedTruncSVecF32x4ToVecI32x4'](),
    RelaxedTruncUVecF32x4ToVecI32x4 = JSModule['_BinaryenRelaxedTruncUVecF32x4ToVecI32x4'](),
    RelaxedTruncZeroSVecF64x2ToVecI32x4 = JSModule['_BinaryenRelaxedTruncZeroSVecF64x2ToVecI32x4'](),
    RelaxedTruncZeroUVecF64x2ToVecI32x4 = JSModule['_BinaryenRelaxedTruncZeroUVecF64x2ToVecI32x4'](),
    SwizzleVecI8x16 = JSModule['_BinaryenSwizzleVecI8x16'](),
    RelaxedSwizzleVecI8x16 = JSModule['_BinaryenRelaxedSwizzleVecI8x16'](),
    RelaxedMinVecF32x4 = JSModule['_BinaryenRelaxedMinVecF32x4'](),
    RelaxedMaxVecF32x4 = JSModule['_BinaryenRelaxedMaxVecF32x4'](),
    RelaxedMinVecF64x2 = JSModule['_BinaryenRelaxedMinVecF64x2'](),
    RelaxedMaxVecF64x2 = JSModule['_BinaryenRelaxedMaxVecF64x2'](),
    RelaxedQ15MulrSVecI16x8 = JSModule['_BinaryenRelaxedQ15MulrSVecI16x8'](),
    DotI8x16I7x16SToVecI16x8 = JSModule['_BinaryenDotI8x16I7x16SToVecI16x8'](),
    RefAsNonNull = JSModule['_BinaryenRefAsNonNull'](),
    RefAsExternInternalize = JSModule['_BinaryenRefAsExternInternalize'](),
    RefAsExternExternalize = JSModule['_BinaryenRefAsExternExternalize'](),
    BrOnNull = JSModule['_BinaryenBrOnNull'](),
    BrOnNonNull = JSModule['_BinaryenBrOnNonNull'](),
    BrOnCast = JSModule['_BinaryenBrOnCast'](),
    BrOnCastFail = JSModule['_BinaryenBrOnCastFail'](),
    /* explicitly skipping string stuff until it's reprioritized
    StringNewUTF8 = JSModule['_BinaryenStringNewUTF8'](),
    StringNewWTF8 = JSModule['_BinaryenStringNewWTF8'](),
    StringNewLossyUTF8 = JSModule['_BinaryenStringNewLossyUTF8'](),
    StringNewWTF16 = JSModule['_BinaryenStringNewWTF16'](),
    StringNewUTF8Array = JSModule['_BinaryenStringNewUTF8Array'](),
    StringNewWTF8Array = JSModule['_BinaryenStringNewWTF8Array'](),
    StringNewLossyUTF8Array = JSModule['_BinaryenStringNewLossyUTF8Array'](),
    StringNewWTF16Array = JSModule['_BinaryenStringNewWTF16Array'](),
    StringNewFromCodePoint = JSModule['_BinaryenStringNewFromCodePoint'](),
    StringMeasureUTF8 = JSModule['_BinaryenStringMeasureUTF8'](),
    StringMeasureWTF8 = JSModule['_BinaryenStringMeasureWTF8'](),
    StringMeasureWTF16 = JSModule['_BinaryenStringMeasureWTF16'](),
    StringMeasureIsUSV = JSModule['_BinaryenStringMeasureIsUSV'](),
    StringMeasureWTF16View = JSModule['_BinaryenStringMeasureWTF16View'](),
    StringEncodeUTF8 = JSModule['_BinaryenStringEncodeUTF8'](),
    StringEncodeLossyUTF8 = JSModule['_BinaryenStringEncodeLossyUTF8'](),
    StringEncodeWTF8 = JSModule['_BinaryenStringEncodeWTF8'](),
    StringEncodeWTF16 = JSModule['_BinaryenStringEncodeWTF16'](),
    StringEncodeUTF8Array = JSModule['_BinaryenStringEncodeUTF8Array'](),
    StringEncodeLossyUTF8Array = JSModule['_BinaryenStringEncodeLossyUTF8Array'](),
    StringEncodeWTF8Array = JSModule['_BinaryenStringEncodeWTF8Array'](),
    StringEncodeWTF16Array = JSModule['_BinaryenStringEncodeWTF16Array'](),
    StringAsWTF8 = JSModule['_BinaryenStringAsWTF8'](),
    StringAsWTF16 = JSModule['_BinaryenStringAsWTF16'](),
    StringAsIter = JSModule['_BinaryenStringAsIter'](),
    StringIterMoveAdvance = JSModule['_BinaryenStringIterMoveAdvance'](),
    StringIterMoveRewind = JSModule['_BinaryenStringIterMoveRewind'](),
    StringSliceWTF8 = JSModule['_BinaryenStringSliceWTF8'](),
    StringSliceWTF16 = JSModule['_BinaryenStringSliceWTF16'](),
    StringEqEqual = JSModule['_BinaryenStringEqEqual'](),
    StringEqCompare = JSModule['_BinaryenStringEqCompare']()
    */
}

export enum SideEffects {
    None = JSModule['_BinaryenSideEffectNone'](),
    Branches = JSModule['_BinaryenSideEffectBranches'](),
    Calls = JSModule['_BinaryenSideEffectCalls'](),
    ReadsLocal = JSModule['_BinaryenSideEffectReadsLocal'](),
    WritesLocal = JSModule['_BinaryenSideEffectWritesLocal'](),
    ReadsGlobal = JSModule['_BinaryenSideEffectReadsGlobal'](),
    WritesGlobal = JSModule['_BinaryenSideEffectWritesGlobal'](),
    ReadsMemory = JSModule['_BinaryenSideEffectReadsMemory'](),
    WritesMemory = JSModule['_BinaryenSideEffectWritesMemory'](),
    ReadsTable = JSModule['_BinaryenSideEffectReadsTable'](),
    WritesTable = JSModule['_BinaryenSideEffectWritesTable'](),
    ImplicitTrap = JSModule['_BinaryenSideEffectImplicitTrap'](),
    IsAtomic = JSModule['_BinaryenSideEffectIsAtomic'](),
    Throws = JSModule['_BinaryenSideEffectThrows'](),
    DanglingPop = JSModule['_BinaryenSideEffectDanglingPop'](),
    TrapsNeverHappen = JSModule['_BinaryenSideEffectTrapsNeverHappen'](),
    Any = JSModule['_BinaryenSideEffectAny']()
}

export enum PackedType {
    NotPacked = JSModule['_BinaryenPackedTypeNotPacked'](),
    Int8 = JSModule['_BinaryenPackedTypeInt8'](),
    Int16 = JSModule['_BinaryenPackedTypeInt16']()
}

export class Function {

    readonly func: FunctionRef;

    constructor(func: FunctionRef) {
        this.func = func;
    }

    getName(): string {
        return UTF8ToString(JSModule['_BinaryenFunctionGetName'](this.func));
    }
    getParams(): Type {
        return JSModule['_BinaryenFunctionGetParams'](this.func);
    }
    getResults(): Type {
        return JSModule['_BinaryenFunctionGetResults'](this.func);
    }
    getNumVars(): number {
        return JSModule['_BinaryenFunctionGetNumVars'](this.func);
    }
    getVar(index: number): Type {
        return JSModule['_BinaryenFunctionGetVar'](this.func, index);
    }
    getNumLocals(): number {
        return JSModule['_BinaryenFunctionGetNumLocals'](this.func);
    }
    hasLocalName(index: number): boolean {
        return Boolean(JSModule['_BinaryenFunctionHasLocalName'](this.func, index));
    }
    getLocalName(index: number): string {
        return UTF8ToString(JSModule['_BinaryenFunctionGetLocalName'](this.func, index));
    }
    setLocalName(index: number, name: string): void {
        preserveStack(() => {
              JSModule['_BinaryenFunctionSetLocalName'](this.func, index, strToStack(name));
            });
    }
    getBody(): ExpressionRef {
        return JSModule['_BinaryenFunctionGetBody'](this.func);
    }
    setBody(bodyExpr: ExpressionRef): void {
        JSModule['_BinaryenFunctionSetBody'](this.func, bodyExpr);
    }
    setDebugLocation(expr: ExpressionRef, fileIndex: number, lineNumber: number, columnNumber: number): void {
        JSModule['_BinaryenFunctionSetDebugLocation'](this.func, expr, fileIndex, lineNumber, columnNumber);
    }
    getInfo(): FunctionInfo {
        return {
            'name': this.getName(),
            'module': UTF8ToString(JSModule['_BinaryenFunctionImportGetModule'](this.func)),
            'base': UTF8ToString(JSModule['_BinaryenFunctionImportGetBase'](this.func)),
            'params': this.getParams(),
            'results': this.getResults(),
            'vars': getAllNested<Type>(this.func, this.getNumVars, this.getVar),
            'body':this.getBody()
        };
    }
}

export interface FunctionInfo {
    name: string;
    module: string | null;
    base: string | null;
    params: Type;
    results: Type;
    vars: Type[];
    body: ExpressionRef;
}

export interface TableInfo {
    name: string;
    module: string | null;
    base: string | null;
    initial: number;
    max?: number;
}

export interface ElementSegmentInfo {
    name: string,
    table: string,
    offset: number,
    data: string[]
}

export interface GlobalInfo {
    name: string;
    module: string | null;
    base: string | null;
    type: Type;
    mutable: boolean;
    init: ExpressionRef;
}

export interface TagInfo {
    name: string;
    module: string | null;
    base: string | null;
    params: Type;
    results: Type;
}

export interface ExportInfo {
    kind: ExternalKinds;
    name: string;
    value: string;
}

function getOptimizeLevel(): number {
    return JSModule['_BinaryenGetOptimizeLevel']();
}
function setOptimizeLevel(level: number): void {
    JSModule['_BinaryenSetOptimizeLevel'](level);
}
function getShrinkLevel(): number {
    return JSModule['_BinaryenGetShrinkLevel']();
}
function setShrinkLevel(level: number): void {
    JSModule['_BinaryenSetShrinkLevel'](level);
}
function getDebugInfo(): boolean {
    return Boolean(JSModule['_BinaryenGetDebugInfo']());
}
function setDebugInfo(on: boolean): void {
    JSModule['_BinaryenSetDebugInfo'](on);
}
function getLowMemoryUnused(): boolean {
    return Boolean(JSModule['_BinaryenGetLowMemoryUnused']());
}
function setLowMemoryUnused(on: boolean): void {
    JSModule['_BinaryenSetLowMemoryUnused'](on);
}
function getZeroFilledMemory(): boolean {
    return Boolean(JSModule['_BinaryenGetZeroFilledMemory']());
}
function setZeroFilledMemory(on: boolean): void {
    JSModule['_BinaryenSetZeroFilledMemory'](on);
}
function getFastMath(): boolean {
    return Boolean(JSModule['_BinaryenGetFastMath']());
}
function setFastMath(on: boolean): void {
    JSModule['_BinaryenSetFastMath'](on);
}
function getPassArgument(key: string): string | null {
    return preserveStack(() => {
        const ret = JSModule['_BinaryenGetPassArgument'](strToStack(key));
        return ret !== 0 ? UTF8ToString(ret) : null;
      });
}
function setPassArgument(key: string, value: string | null): void {
    preserveStack(() => { JSModule['_BinaryenSetPassArgument'](strToStack(key), strToStack(value)) });
}
function clearPassArguments(): void {
    JSModule['_BinaryenClearPassArguments']();
}
function getAlwaysInlineMaxSize(): number {
    return JSModule['_BinaryenGetAlwaysInlineMaxSize']();
}
function setAlwaysInlineMaxSize(size: number): void {
    JSModule['_BinaryenSetAlwaysInlineMaxSize'](size);
}
function getFlexibleInlineMaxSize(): number {
    return JSModule['_BinaryenGetFlexibleInlineMaxSize']();
}
function setFlexibleInlineMaxSize(size: number): void {
    JSModule['_BinaryenSetFlexibleInlineMaxSize'](size);
}
function getOneCallerInlineMaxSize(): number {
    return JSModule['_BinaryenGetOneCallerInlineMaxSize']();
}
function setOneCallerInlineMaxSize(size: number): void {
    JSModule['_BinaryenSetOneCallerInlineMaxSize'](size);
}
function getAllowInliningFunctionsWithLoops(): boolean {
    return Boolean(JSModule['_BinaryenGetAllowInliningFunctionsWithLoops']());
}
function setAllowInliningFunctionsWithLoops(on: boolean): void {
    JSModule['_BinaryenSetAllowInliningFunctionsWithLoops'](on);
}
function exit(status: number): void {
    if (status != 0)
        throw new Error('Exiting due to error: ' + status);
}

export class Module {

    static readBinary(data: Uint8Array): Module {
          const buffer = _malloc(data.length);
          HEAP8.set(data, buffer);
          const ptr = JSModule['_BinaryenModuleRead'](buffer, data.length);
          _free(buffer);
          return new Module(ptr);
    }

    static parseText(text: string): Module {
          const buffer = _malloc(text.length + 1);
          stringToAscii(text, buffer);
          const ptr = JSModule['_BinaryenModuleParse'](buffer);
          _free(buffer);
          return new Module(ptr);
    }

    readonly ptr: number;

    constructor(ptr?: number) {
        this.ptr = ptr || JSModule['_BinaryenModuleCreate']();
    }
    dispose(): void {
        JSModule['_BinaryenModuleDispose'](this.ptr);
    }
    setStart(start: FunctionRef): void {
        JSModule['_BinaryenSetStart'](this.ptr, start);
    }
    setFeatures(features: Features): void {
        JSModule['_BinaryenModuleSetFeatures'](this.ptr, features);
    }
    getFeatures(): Features {
        return JSModule['_BinaryenModuleGetFeatures'](this.ptr);
    }
    autoDrop(): void {
        JSModule['_BinaryenModuleAutoDrop'](this.ptr);
    }
    addCustomSection(name: string, contents: Uint8Array): void {
        preserveStack(() =>
              JSModule['_BinaryenAddCustomSection'](this.ptr, strToStack(name), i8sToStack(contents), contents.length)
            );
    }
    addDebugInfoFileName(filename: string): number {
        return preserveStack(() => JSModule['_BinaryenModuleAddDebugInfoFileName'](this.ptr, strToStack(filename)));
    }
    getDebugInfoFileName(index: number): string | null {
        return UTF8ToString(JSModule['_BinaryenModuleGetDebugInfoFileName'](this.ptr, index));
    }
    validate(): number {
        return JSModule['_BinaryenModuleValidate'](this.ptr);
    }
    optimize(): void {
        return JSModule['_BinaryenModuleOptimize'](this.ptr);
    }
    optimizeFunction(func: string | FunctionRef): void {
        if (typeof func === 'string')
            func = this.functions.getRefByName(func);
        return JSModule['_BinaryenFunctionOptimize'](func, this.ptr);
    }
    runPasses(passes: string[]): void {
        preserveStack(() =>
              JSModule['_BinaryenModuleRunPasses'](this.ptr, i32sToStack(passes.map(strToStack)), passes.length)
            );
    }
    runPassesOnFunction(func: string | FunctionRef, passes: string[]): void {
        if (typeof func === 'string')
            func = this.functions.getRefByName(func);
        preserveStack(() =>
              JSModule['_BinaryenFunctionRunPasses'](func, this.ptr, i32sToStack(passes.map(strToStack)), passes.length)
            );
    }
    emitText(): string {
        const textPtr = JSModule['_BinaryenModuleAllocateAndWriteText'](this.ptr);
        const text = textPtr ? UTF8ToString(textPtr) : null;
        if (textPtr)
            _free(textPtr);
        return text;
    }
    emitStackIR(optimize?: boolean): string {
        const textPtr = JSModule['_BinaryenModuleAllocateAndWriteStackIR'](this.ptr, optimize);
        const text = textPtr ? UTF8ToString(textPtr) : null;
        if (textPtr)
            _free(textPtr);
        return text;
    }
    emitAsmjs(): string {
       let text = '';
       const old = swapOut(s => { text += s + '\n' });
       JSModule['_BinaryenModulePrintAsmjs'](this.ptr);
       swapOut(old);
       return text;
    }
    emitBinary(): Uint8Array;
    emitBinary(sourceMapUrl: string): { binary: Uint8Array; sourceMap: string; };
    emitBinary(sourceMapUrl?: string): Uint8Array | { binary: Uint8Array; sourceMap: string; } {
        return preserveStack(() => {
            const tempBuffer = stackAlloc(_BinaryenSizeofAllocateAndWriteResult());
            JSModule['_BinaryenModuleAllocateAndWrite'](tempBuffer, this.ptr, strToStack(sourceMapUrl));
            const binaryPtr    = HEAPU32[ tempBuffer >>> 2     ];
            const binaryBytes  = HEAPU32[(tempBuffer >>> 2) + 1];
            const sourceMapPtr = HEAPU32[(tempBuffer >>> 2) + 2];
            try {
                const buffer = new Uint8Array(binaryBytes);
                buffer.set(HEAPU8.subarray(binaryPtr, binaryPtr + binaryBytes));
                return typeof sourceMapUrl === 'undefined' ? buffer : { 'binary': buffer, 'sourceMap': UTF8ToString(sourceMapPtr) };
           } finally {
             _free(binaryPtr);
             if (sourceMapPtr)
                _free(sourceMapPtr);
           }
         });
    }
    interpret(): void {
        JSModule['_BinaryenModuleInterpret'](this.ptr);
    }
    block(label: string | null, children: ExpressionRef[], resultType?: Type): ExpressionRef {
        return preserveStack(() => JSModule['_BinaryenBlock'](
            this.ptr, label ?  strToStack(label) : 0,
            i32sToStack(children),
            children.length,
            typeof resultType !== 'undefined' ? resultType : none));
    }
    if(condition: ExpressionRef, ifTrue: ExpressionRef, ifFalse?: ExpressionRef): ExpressionRef {
        return JSModule['_BinaryenIf'](this.ptr, condition, ifTrue, ifFalse);
    }
    loop(label: string | null, body: ExpressionRef): ExpressionRef {
        return preserveStack(() => JSModule['_BinaryenLoop'](this.ptr, strToStack(label), body));
    }
    br(label: string, condition?: ExpressionRef, value?: ExpressionRef): ExpressionRef {
        return preserveStack(() => JSModule['_BinaryenBreak'](this.ptr, strToStack(label), condition, value));
    }
    br_if(label: string, condition?: ExpressionRef, value?: ExpressionRef): ExpressionRef {
        return this.br(label, condition, value);
    }
    switch(labels: string[], defaultLabel: string, condition: ExpressionRef, value?: ExpressionRef): ExpressionRef {
        return preserveStack(() =>
            JSModule['_BinaryenSwitch'](this.ptr, i32sToStack(labels.map(strToStack)), labels.length, strToStack(defaultLabel), condition, value)
        );
    }
    call(name: string, operands: ExpressionRef[], returnType: Type): ExpressionRef {
        return preserveStack(() => JSModule['_BinaryenCall'](this.ptr, strToStack(name), i32sToStack(operands), operands.length, returnType));
    }
    call_indirect(table: string, target: ExpressionRef, operands: ExpressionRef[], params: Type, results: Type): ExpressionRef {
        return preserveStack(() =>
            JSModule['_BinaryenCallIndirect'](this.ptr, strToStack(table), target, i32sToStack(operands), operands.length, params, results)
        );
    }
    return_call(name: string, operands: ExpressionRef[], returnType: Type): ExpressionRef {
        return preserveStack(() =>
            JSModule['_BinaryenReturnCall'](this.ptr, strToStack(name), i32sToStack(operands), operands.length, returnType)
        );
    }
    return_call_indirect(table: string, target: ExpressionRef, operands: ExpressionRef[], params: Type, results: Type): ExpressionRef {
        return preserveStack(() =>
            JSModule['_BinaryenReturnCallIndirect'](this.ptr, strToStack(table), target, i32sToStack(operands), operands.length, params, results)
        );
    }
    select(condition: ExpressionRef, ifTrue: ExpressionRef, ifFalse: ExpressionRef, type?: Type): ExpressionRef {
        return JSModule['_BinaryenSelect'](this.ptr, condition, ifTrue, ifFalse, typeof type !== 'undefined' ? type : JSModule['auto']);
    }
    drop(value: ExpressionRef): ExpressionRef {
        return JSModule['_BinaryenDrop'](this.ptr, value);
    }
    return(value?: ExpressionRef): ExpressionRef {
        return JSModule['_BinaryenReturn'](this.ptr, value);
    }
    nop(): ExpressionRef {
        return JSModule['_BinaryenNop'](this.ptr);
    }
    unreachable(): ExpressionRef {
        return JSModule['_BinaryenUnreachable'](this.ptr);
    }
    try(name: string, body: ExpressionRef, catchTags: string[], catchBodies: ExpressionRef[], delegateTarget?: string): ExpressionRef {
        return preserveStack(() =>
          JSModule['_BinaryenTry'](this.ptr, name ? strToStack(name) : 0, body, i32sToStack(catchTags.map(strToStack)), catchTags.length, i32sToStack(catchBodies), catchBodies.length, delegateTarget ? strToStack(delegateTarget) : 0));
    }
    throw(tag: string, operands: ExpressionRef[]): ExpressionRef {
        return preserveStack(() => JSModule['_BinaryenThrow'](this.ptr, strToStack(tag), i32sToStack(operands), operands.length));
    }
    rethrow(target: string): ExpressionRef {
        return JSModule['_BinaryenRethrow'](this.ptr, strToStack(target));
    }
    get i32 () {
        const unary = (op: Operations, value: ExpressionRef) =>
            JSModule['_BinaryenUnary'](this.ptr, op, value);
        const binary = (op: Operations, left: ExpressionRef, right: ExpressionRef) =>
            JSModule['_BinaryenBinary'](this.ptr, op, left, right);
        const load = (size: number, signed: boolean, offset: number, align: number, ptr: ExpressionRef, name: string) =>
            JSModule['_BinaryenLoad'](this.ptr, size, signed, offset, align, i32, ptr, strToStack(name));
        const store = (size: number, offset: number, align: number, ptr: ExpressionRef, value: ExpressionRef, name: string) =>
            JSModule['_BinaryenStore'](this.ptr, size, offset, align, ptr, value, i32, strToStack(name));
        const atomic_load = (size: number, offset: number, ptr: ExpressionRef, name: string) =>
            JSModule['_BinaryenAtomicLoad'](this.ptr, size, offset, i32, ptr, strToStack(name));
        const atomic_store = (size: number, offset: number, ptr: ExpressionRef, value: ExpressionRef, name: string) =>
            JSModule['_BinaryenAtomicStore'](this.ptr, size, offset, ptr, value, i32, strToStack(name));
        const atomic_rmw = (op: Operations, size: number, offset: number, ptr: ExpressionRef, value: ExpressionRef, name: string) =>
            JSModule['_BinaryenAtomicRMW'](this.ptr, op, size, offset, ptr, value, i32, strToStack(name));
        return {
            load: (offset: number, align: number, ptr: ExpressionRef, name?: string): ExpressionRef => load(4, true, offset, align, ptr, name),
            load8_s: (offset: number, align: number, ptr: ExpressionRef, name?: string): ExpressionRef => load(1, true, offset, align, ptr, name),
            load8_u: (offset: number, align: number, ptr: ExpressionRef, name?: string): ExpressionRef => load(1, false, offset, align, ptr, name),
            load16_s: (offset: number, align: number, ptr: ExpressionRef, name?: string): ExpressionRef => load(2, true, offset, align, ptr, name),
            load16_u: (offset: number, align: number, ptr: ExpressionRef, name?: string): ExpressionRef => load(2, false, offset, align, ptr, name),
            store: (offset: number, align: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef => store(4, offset, align, ptr, value, name),
            store8: (offset: number, align: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef => store(1, offset, align, ptr, value, name),
            store16: (offset: number, align: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef => store(2, offset, align, ptr, value, name),
            const: (value: number): ExpressionRef => preserveStack(() => {
                                              const tempLiteral = stackAlloc(sizeOfLiteral);
                                              JSModule['_BinaryenLiteralInt32'](tempLiteral, value);
                                              return JSModule['_BinaryenConst'](this.ptr, tempLiteral);
                                            }),
            clz: (value: ExpressionRef): ExpressionRef => unary(Operations.ClzInt32, value),
            ctz: (value: ExpressionRef): ExpressionRef => unary(Operations.CtzInt32, value),
            popcnt: (value: ExpressionRef): ExpressionRef => unary(Operations.PopcntInt32, value),
            eqz: (value: ExpressionRef): ExpressionRef => unary(Operations.EqZInt32, value),
            trunc_s: {
                f32: (value: ExpressionRef): ExpressionRef => unary(Operations.TruncSFloat32ToInt32, value),
                f64: (value: ExpressionRef): ExpressionRef => unary(Operations.TruncSFloat64ToInt32, value)
            },
            trunc_u: {
                f32: (value: ExpressionRef): ExpressionRef => unary(Operations.TruncUFloat32ToInt32, value),
                f64: (value: ExpressionRef): ExpressionRef => unary(Operations.TruncUFloat64ToInt32, value)
            },
            trunc_s_sat: {
                f32: (value: ExpressionRef): ExpressionRef => unary(Operations.TruncSatSFloat32ToInt32, value),
                f64: (value: ExpressionRef): ExpressionRef => unary(Operations.TruncSatSFloat64ToInt32, value)
            },
            trunc_u_sat: {
                f32: (value: ExpressionRef): ExpressionRef => unary(Operations.TruncSatUFloat32ToInt32, value),
                f64: (value: ExpressionRef): ExpressionRef => unary(Operations.TruncSatUFloat64ToInt32, value)
            },
            reinterpret_f32: (value: ExpressionRef): ExpressionRef => unary(Operations.ReinterpretFloat32, value),
            extend8_s: (value: ExpressionRef): ExpressionRef => unary(Operations.ExtendS8Int32, value),
            extend16_s: (value: ExpressionRef): ExpressionRef => unary(Operations.ExtendS16Int32, value),
            wrap_i64: (value: ExpressionRef): ExpressionRef => unary(Operations.WrapInt64, value),
            add: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.AddInt32, left, right),
            sub: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.SubInt32, left, right),
            mul: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.MulInt32, left, right),
            div_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.DivSInt32, left, right),
            div_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.DivUInt32, left, right),
            rem_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.RemSInt32, left, right),
            rem_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.RemUInt32, left, right),
            and: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.AndInt32, left, right),
            or: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.OrInt32, left, right),
            xor: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.XorInt32, left, right),
            shl: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.ShlInt32, left, right),
            shr_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.ShrUInt32, left, right),
            shr_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.ShrSInt32, left, right),
            rotl: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.RotLInt32, left, right),
            rotr: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.RotRInt32, left, right),
            eq: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.EqInt32, left, right),
            ne: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.NeInt32, left, right),
            lt_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.LtSInt32, left, right),
            lt_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.LtUInt32, left, right),
            le_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.LeSInt32, left, right),
            le_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.LeUInt32, left, right),
            gt_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.GtSInt32, left, right),
            gt_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.GtUInt32, left, right),
            ge_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.GeSInt32, left, right),
            ge_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.GeUInt32, left, right),
            pop: (): ExpressionRef => JSModule['_BinaryenPop'](this.ptr, i32),
            atomic: {
                load: (offset: number, ptr: ExpressionRef, name?: string): ExpressionRef => atomic_load(4, offset, ptr, name),
                load8_u: (offset: number, ptr: ExpressionRef, name?: string): ExpressionRef => atomic_load(1, offset, ptr, name),
                load16_u: (offset: number, ptr: ExpressionRef, name?: string): ExpressionRef => atomic_load(2, offset, ptr, name),
                store: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef => atomic_store(4, offset, ptr, value, name),
                store8: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef => atomic_store(1, offset, ptr, value, name),
                store16: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef => atomic_store(2, offset, ptr, value, name),
                rmw: {
                    add: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWAdd, 4, offset, ptr, value, name),
                    sub: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWSub, 4, offset, ptr, value, name),
                    and: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWAnd, 4, offset, ptr, value, name),
                    or: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWOr, 4, offset, ptr, value, name),
                    xor: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWXor, 4, offset, ptr, value, name),
                    xchg: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWXchg, 4, offset, ptr, value, name),
                    cmpxchg: (offset: number, ptr: ExpressionRef, expected: ExpressionRef, replacement: ExpressionRef, name?: string): ExpressionRef =>
                        JSModule['_BinaryenAtomicCmpxchg'](this.ptr, 4, offset, ptr, expected, replacement, i32, strToStack(name))
                },
                rmw8_u: {
                    add: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWAdd, 1, offset, ptr, value, name),
                    sub: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWSub, 1, offset, ptr, value, name),
                    and: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWAnd, 1, offset, ptr, value, name),
                    or: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWOr, 1, offset, ptr, value, name),
                    xor: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWXor, 1, offset, ptr, value, name),
                    xchg: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWXchg, 1, offset, ptr, value, name),
                    cmpxchg: (offset: number, ptr: ExpressionRef, expected: ExpressionRef, replacement: ExpressionRef, name?: string): ExpressionRef =>
                        JSModule['_BinaryenAtomicCmpxchg'](this.ptr, 1, offset, ptr, expected, replacement, i32, strToStack(name))
                },
                rmw16_u: {
                    add: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWAdd, 2, offset, ptr, value, name),
                    sub: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWSub, 2, offset, ptr, value, name),
                    and: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWAnd, 2, offset, ptr, value, name),
                    or: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWOr, 2, offset, ptr, value, name),
                    xor: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWXor, 2, offset, ptr, value, name),
                    xchg: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWXchg, 2, offset, ptr, value, name),
                    cmpxchg: (offset: number, ptr: ExpressionRef, expected: ExpressionRef, replacement: ExpressionRef, name?: string): ExpressionRef =>
                        JSModule['_BinaryenAtomicCmpxchg'](this.ptr, 2, offset, ptr, expected, replacement, i32, strToStack(name))
                }
            }
        };
    }
    get i64 () {
        const unary = (op: Operations, value: ExpressionRef) =>
            JSModule['_BinaryenUnary'](this.ptr, op, value);
        const binary = (op: Operations, left: ExpressionRef, right: ExpressionRef) =>
            JSModule['_BinaryenBinary'](this.ptr, op, left, right);
        const load = (size: number, signed: boolean, offset: number, align: number, ptr: ExpressionRef, name: string): ExpressionRef =>
            JSModule['_BinaryenLoad'](this.ptr, size, signed, offset, align, i64, ptr, strToStack(name));
        const store = (size: number, offset: number, align: number, ptr: ExpressionRef, value: ExpressionRef, name: string) =>
            JSModule['_BinaryenStore'](this.ptr, size, offset, align, ptr, value, i64, strToStack(name));
        const atomic_load = (size: number, offset: number, ptr: ExpressionRef, name: string) =>
            JSModule['_BinaryenAtomicLoad'](this.ptr, size, offset, i64, ptr, strToStack(name));
        const atomic_store = (size: number, offset: number, ptr: ExpressionRef, value: ExpressionRef, name: string) =>
            JSModule['_BinaryenAtomicStore'](this.ptr, size, offset, ptr, value, i64, strToStack(name));
        const atomic_rmw = (op: Operations, size: number, offset: number, ptr: ExpressionRef, value: ExpressionRef, name: string) =>
            JSModule['_BinaryenAtomicRMW'](this.ptr, op, size, offset, ptr, value, i64, strToStack(name));
        return {
            load: (offset: number, align: number, ptr: ExpressionRef, name?: string): ExpressionRef => load(8, true, offset, align, ptr, name),
            load8_s: (offset: number, align: number, ptr: ExpressionRef, name?: string): ExpressionRef => load(1, true, offset, align, ptr, name),
            load8_u: (offset: number, align: number, ptr: ExpressionRef, name?: string): ExpressionRef => load(1, false, offset, align, ptr, name),
            load16_s: (offset: number, align: number, ptr: ExpressionRef, name?: string): ExpressionRef => load(2, true, offset, align, ptr, name),
            load16_u: (offset: number, align: number, ptr: ExpressionRef, name?: string): ExpressionRef => load(2, false, offset, align, ptr, name),
            load32_s: (offset: number, align: number, ptr: ExpressionRef, name?: string): ExpressionRef => load(4, true, offset, align, ptr, name),
            load32_u: (offset: number, align: number, ptr: ExpressionRef, name?: string): ExpressionRef => load(4, false, offset, align, ptr, name),
            store: (offset: number, align: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef => store(4, offset, align, ptr, value, name),
            store8: (offset: number, align: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef => store(1, offset, align, ptr, value, name),
            store16: (offset: number, align: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef => store(2, offset, align, ptr, value, name),
            store32: (offset: number, align: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef => store(4, offset, align, ptr, value, name),
            const: (low: number, high: number): ExpressionRef => preserveStack(() => {
                                              const tempLiteral = stackAlloc(sizeOfLiteral);
                                              JSModule['_BinaryenLiteralInt64'](tempLiteral, low, high);
                                              return JSModule['_BinaryenConst'](this.ptr, tempLiteral);
                                            }),
            clz: (value: ExpressionRef): ExpressionRef => unary(Operations.ClzInt64, value),
            ctz: (value: ExpressionRef): ExpressionRef => unary(Operations.CtzInt64, value),
            popcnt: (value: ExpressionRef): ExpressionRef => unary(Operations.PopcntInt64, value),
            eqz: (value: ExpressionRef): ExpressionRef => unary(Operations.EqZInt64, value),
            trunc_s: {
                f32: (value: ExpressionRef): ExpressionRef => unary(Operations.TruncSFloat32ToInt64, value),
                f64: (value: ExpressionRef): ExpressionRef => unary(Operations.TruncSFloat64ToInt64, value)
            },
            trunc_u: {
                f32: (value: ExpressionRef): ExpressionRef => unary(Operations.TruncUFloat32ToInt64, value),
                f64: (value: ExpressionRef): ExpressionRef => unary(Operations.TruncUFloat64ToInt64, value)
            },
            trunc_s_sat: {
                f32: (value: ExpressionRef): ExpressionRef => unary(Operations.TruncSatSFloat32ToInt64, value),
                f64: (value: ExpressionRef): ExpressionRef => unary(Operations.TruncSatSFloat64ToInt64, value)
            },
            trunc_u_sat: {
                f32: (value: ExpressionRef): ExpressionRef => unary(Operations.TruncSatUFloat32ToInt64, value),
                f64: (value: ExpressionRef): ExpressionRef => unary(Operations.TruncSatUFloat64ToInt64, value)
            },
            reinterpret_f64: (value: ExpressionRef): ExpressionRef => unary(Operations.ReinterpretFloat64, value),
            extend8_s: (value: ExpressionRef): ExpressionRef => unary(Operations.ExtendS8Int64, value),
            extend16_s: (value: ExpressionRef): ExpressionRef => unary(Operations.ExtendS16Int64, value),
            extend32_s: (value: ExpressionRef): ExpressionRef => unary(Operations.ExtendS32Int64, value),
            extend_s: (value: ExpressionRef): ExpressionRef => unary(Operations.ExtendSInt32, value),
            extend_u: (value: ExpressionRef): ExpressionRef => unary(Operations.ExtendUInt32, value),
            add: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.AddInt64, left, right),
            sub: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.SubInt64, left, right),
            mul: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.MulInt32, left, right),
            div_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.DivSInt64, left, right),
            div_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.DivUInt64, left, right),
            rem_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.RemSInt64, left, right),
            rem_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.RemUInt64, left, right),
            and: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.AndInt64, left, right),
            or: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.OrInt64, left, right),
            xor: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.XorInt64, left, right),
            shl: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.ShlInt64, left, right),
            shr_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.ShrUInt64, left, right),
            shr_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.ShrSInt64, left, right),
            rotl: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.RotLInt64, left, right),
            rotr: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.RotRInt64, left, right),
            eq: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.EqInt64, left, right),
            ne: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.NeInt64, left, right),
            lt_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.LtSInt64, left, right),
            lt_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.LtUInt64, left, right),
            le_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.LeSInt64, left, right),
            le_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.LeUInt64, left, right),
            gt_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.GtSInt64, left, right),
            gt_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.GtUInt64, left, right),
            ge_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.GeSInt64, left, right),
            ge_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.GeUInt64, left, right),
            pop: (): ExpressionRef => JSModule['_BinaryenPop'](this.ptr, i64),
            atomic: {
                load: (offset: number, ptr: ExpressionRef, name?: string): ExpressionRef => atomic_load(8, offset, ptr, name),
                load8_u: (offset: number, ptr: ExpressionRef, name?: string): ExpressionRef => atomic_load(1, offset, ptr, name),
                load16_u: (offset: number, ptr: ExpressionRef, name?: string): ExpressionRef => atomic_load(2, offset, ptr, name),
                load32_u: (offset: number, ptr: ExpressionRef, name?: string): ExpressionRef => atomic_load(4, offset, ptr, name),
                store: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef => atomic_store(4, offset, ptr, value, name),
                store8: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef => atomic_store(1, offset, ptr, value, name),
                store16: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef => atomic_store(2, offset, ptr, value, name),
                store32: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef => atomic_store(4, offset, ptr, value, name),
                rmw: {
                    add: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWAdd, 8, offset, ptr, value, name),
                    sub: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWSub, 8, offset, ptr, value, name),
                    and: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWAnd, 8, offset, ptr, value, name),
                    or: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWOr, 8, offset, ptr, value, name),
                    xor: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWXor, 8, offset, ptr, value, name),
                    xchg: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWXchg, 8, offset, ptr, value, name),
                    cmpxchg: (offset: number, ptr: ExpressionRef, expected: ExpressionRef, replacement: ExpressionRef, name?: string): ExpressionRef =>
                        JSModule['_BinaryenAtomicCmpxchg'](this.ptr, 8, offset, ptr, expected, replacement, i64, strToStack(name))
                },
                rmw8_u: {
                    add: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWAdd, 1, offset, ptr, value, name),
                    sub: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWSub, 1, offset, ptr, value, name),
                    and: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWAnd, 1, offset, ptr, value, name),
                    or: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWOr, 1, offset, ptr, value, name),
                    xor: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWXor, 1, offset, ptr, value, name),
                    xchg: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWXchg, 1, offset, ptr, value, name),
                    cmpxchg: (offset: number, ptr: ExpressionRef, expected: ExpressionRef, replacement: ExpressionRef, name?: string): ExpressionRef =>
                        JSModule['_BinaryenAtomicCmpxchg'](this.ptr, 1, offset, ptr, expected, replacement, i64, strToStack(name))
                },
                rmw16_u: {
                    add: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWAdd, 2, offset, ptr, value, name),
                    sub: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWSub, 2, offset, ptr, value, name),
                    and: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWAnd, 2, offset, ptr, value, name),
                    or: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWOr, 2, offset, ptr, value, name),
                    xor: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWXor, 2, offset, ptr, value, name),
                    xchg: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWXchg, 2, offset, ptr, value, name),
                    cmpxchg: (offset: number, ptr: ExpressionRef, expected: ExpressionRef, replacement: ExpressionRef, name?: string): ExpressionRef =>
                        JSModule['_BinaryenAtomicCmpxchg'](this.ptr, 2, offset, ptr, expected, replacement, i32, strToStack(name))
                },
                rmw32_u: {
                    add: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWAdd, 4, offset, ptr, value, name),
                    sub: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWSub, 4, offset, ptr, value, name),
                    and: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWAnd, 4, offset, ptr, value, name),
                    or: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWOr, 4, offset, ptr, value, name),
                    xor: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWXor, 4, offset, ptr, value, name),
                    xchg: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                        atomic_rmw(Operations.AtomicRMWXchg, 4, offset, ptr, value, name),
                    cmpxchg: (offset: number, ptr: ExpressionRef, expected: ExpressionRef, replacement: ExpressionRef, name?: string): ExpressionRef =>
                        JSModule['_BinaryenAtomicCmpxchg'](this.ptr, 4, offset, ptr, expected, replacement, i32, strToStack(name))
                }
            }
        };
    }
    get f32 () {
        const unary = (op: Operations, value: ExpressionRef) =>
            JSModule['_BinaryenUnary'](this.ptr, op, value);
        const binary = (op: Operations, left: ExpressionRef, right: ExpressionRef) =>
            JSModule['_BinaryenBinary'](this.ptr, op, left, right);
        return {
            load: (offset: number, align: number, ptr: ExpressionRef, name?: string): ExpressionRef =>
                JSModule['_BinaryenLoad'](this.ptr, 4, true, offset, align, f32, ptr, strToStack(name)),
            store: (offset: number, align: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                JSModule['_BinaryenStore'](this.ptr, 4, offset, align, ptr, value, f32, strToStack(name)),
            const: (value: number): ExpressionRef =>
                preserveStack(() => {
                        const tempLiteral = stackAlloc(sizeOfLiteral);
                        JSModule['_BinaryenLiteralFloat32'](tempLiteral, value);
                        return JSModule['_BinaryenConst'](this.ptr, tempLiteral);
                      }),
            const_bits: (value: number): ExpressionRef =>
                preserveStack(() => {
                        const tempLiteral = stackAlloc(sizeOfLiteral);
                        JSModule['_BinaryenLiteralFloat32Bits'](tempLiteral, value);
                        return JSModule['_BinaryenConst'](this.ptr, tempLiteral);
                      }),
            neg: (value: ExpressionRef): ExpressionRef => unary(Operations.NegFloat32, value),
            abs: (value: ExpressionRef): ExpressionRef => unary(Operations.AbsFloat32, value),
            ceil: (value: ExpressionRef): ExpressionRef => unary(Operations.CeilFloat32, value),
            floor: (value: ExpressionRef): ExpressionRef => unary(Operations.FloorFloat32, value),
            trunc: (value: ExpressionRef): ExpressionRef => unary(Operations.TruncFloat32, value),
            nearest: (value: ExpressionRef): ExpressionRef => unary(Operations.NearestFloat32, value),
            sqrt: (value: ExpressionRef): ExpressionRef => unary(Operations.SqrtFloat32, value),
            reinterpret_i32: (value: ExpressionRef): ExpressionRef => unary(Operations.ReinterpretInt32, value),
            convert_s: {
                i32: (value: ExpressionRef): ExpressionRef => unary(Operations.ConvertSInt32ToFloat32, value),
                i64: (value: ExpressionRef): ExpressionRef => unary(Operations.ConvertSInt64ToFloat32, value)
            },
            convert_u: {
                i32: (value: ExpressionRef): ExpressionRef => unary(Operations.ConvertUInt32ToFloat32, value),
                i64: (value: ExpressionRef): ExpressionRef => unary(Operations.ConvertUInt64ToFloat32, value)
            },
            demote_f64: (value: ExpressionRef): ExpressionRef => unary(Operations.DemoteFloat64, value),
            add: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.AddFloat32, left, right),
            sub: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.SubFloat32, left, right),
            mul: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.MulFloat32, left, right),
            div: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.DivFloat32, left, right),
            copysign: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.CopySignFloat32, left, right),
            min: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.MinFloat32, left, right),
            max: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.MaxFloat32, left, right),
            eq: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.EqFloat32, left, right),
            ne: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.NeFloat32, left, right),
            lt: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.LtFloat32, left, right),
            le: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.LeFloat32, left, right),
            gt: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.GtFloat32, left, right),
            ge: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.GeFloat32, left, right),
            pop: (): ExpressionRef => JSModule['_BinaryenPop'](this.ptr, f32)
        };
    }
    get f64 () {
        const unary = (op: Operations, value: ExpressionRef) =>
            JSModule['_BinaryenUnary'](this.ptr, op, value);
        const binary = (op: Operations, left: ExpressionRef, right: ExpressionRef) =>
            JSModule['_BinaryenBinary'](this.ptr, op, left, right);
        return {
            load: (offset: number, align: number, ptr: ExpressionRef, name?: string): ExpressionRef =>
                JSModule['_BinaryenLoad'](this.ptr, 8, true, offset, align, f64, ptr, strToStack(name)),
            store: (offset: number, align: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                JSModule['_BinaryenStore'](this.ptr, 8, offset, align, ptr, value, f64, strToStack(name)),
            const: (value: number): ExpressionRef =>
                preserveStack(() => {
                        const tempLiteral = stackAlloc(sizeOfLiteral);
                        JSModule['_BinaryenLiteralFloat64'](tempLiteral, value);
                        return JSModule['_BinaryenConst'](this.ptr, tempLiteral);
                      }),
            const_bits: (value: number): ExpressionRef =>
                preserveStack(() => {
                        const tempLiteral = stackAlloc(sizeOfLiteral);
                        JSModule['_BinaryenLiteralFloat64Bits'](tempLiteral, value);
                        return JSModule['_BinaryenConst'](this.ptr, tempLiteral);
                      }),
            neg: (value: ExpressionRef): ExpressionRef => unary(Operations.NegFloat64, value),
            abs: (value: ExpressionRef): ExpressionRef => unary(Operations.AbsFloat64, value),
            ceil: (value: ExpressionRef): ExpressionRef => unary(Operations.CeilFloat64, value),
            floor: (value: ExpressionRef): ExpressionRef => unary(Operations.FloorFloat64, value),
            trunc: (value: ExpressionRef): ExpressionRef => unary(Operations.TruncFloat64, value),
            nearest: (value: ExpressionRef): ExpressionRef => unary(Operations.NearestFloat64, value),
            sqrt: (value: ExpressionRef): ExpressionRef => unary(Operations.SqrtFloat64, value),
            reinterpret_i64: (value: ExpressionRef): ExpressionRef => unary(Operations.ReinterpretInt64, value),
            convert_s: {
                i32: (value: ExpressionRef): ExpressionRef => unary(Operations.ConvertSInt32ToFloat64, value),
                i64: (value: ExpressionRef): ExpressionRef => unary(Operations.ConvertSInt64ToFloat64, value)
            },
            convert_u: {
                i32: (value: ExpressionRef): ExpressionRef => unary(Operations.ConvertUInt32ToFloat64, value),
                i64: (value: ExpressionRef): ExpressionRef => unary(Operations.ConvertUInt64ToFloat64, value)
            },
            promote_f32: (value: ExpressionRef): ExpressionRef => unary(Operations.PromoteFloat32, value),
            add: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.AddFloat64, left, right),
            sub: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.SubFloat64, left, right),
            mul: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.MulFloat64, left, right),
            div: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.DivFloat64, left, right),
            copysign: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.CopySignFloat64, left, right),
            min: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.MinFloat64, left, right),
            max: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.MaxFloat64, left, right),
            eq: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.EqFloat64, left, right),
            ne: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.NeFloat64, left, right),
            lt: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.LtFloat64, left, right),
            le: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.LeFloat64, left, right),
            gt: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.GtFloat64, left, right),
            ge: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => binary(Operations.GeFloat64, left, right),
            pop: (): ExpressionRef => JSModule['_BinaryenPop'](this.ptr, f64)
        };
    }
    get v128 () {
        const simd_load = (op: Operations, offset: number, align: number, ptr: ExpressionRef, name: string): ExpressionRef =>
            JSModule['_BinaryenSIMDLoad'](this.ptr, op, offset, align, ptr, strToStack(name));
        const simd_lane = (op: Operations, offset: number, align: number, index: number, ptr: ExpressionRef, vec: number, name: string): ExpressionRef =>
            JSModule['_BinaryenSIMDLoadStoreLane'](this.ptr, op, offset, align, index, ptr, vec, strToStack(name));
        return {
            load: (offset: number, align: number, ptr: ExpressionRef, name?: string): ExpressionRef =>
                JSModule['_BinaryenLoad'](this.ptr, 16, false, offset, align, v128, ptr, strToStack(name)),
            load8_splat: (offset: number, align: number, ptr: ExpressionRef, name?: string): ExpressionRef =>
                simd_load(Operations.Load8SplatVec128, offset, align, ptr, name),
            load16_splat: (offset: number, align: number, ptr: ExpressionRef, name?: string): ExpressionRef =>
                simd_load(Operations.Load16SplatVec128, offset, align, ptr, name),
            load32_splat: (offset: number, align: number, ptr: ExpressionRef, name?: string): ExpressionRef =>
                simd_load(Operations.Load32SplatVec128, offset, align, ptr, name),
            load64_splat: (offset: number, align: number, ptr: ExpressionRef, name?: string): ExpressionRef =>
                simd_load(Operations.Load64SplatVec128, offset, align, ptr, name),
            load8x8_s: (offset: number, align: number, ptr: ExpressionRef, name?: string): ExpressionRef =>
                simd_load(Operations.Load8x8SVec128, offset, align, ptr, name),
            load8x8_u: (offset: number, align: number, ptr: ExpressionRef, name?: string): ExpressionRef =>
                simd_load(Operations.Load8x8UVec128, offset, align, ptr, name),
            load16x4_s: (offset: number, align: number, ptr: ExpressionRef, name?: string): ExpressionRef =>
                simd_load(Operations.Load16x4SVec128, offset, align, ptr, name),
            load16x4_u: (offset: number, align: number, ptr: ExpressionRef, name?: string): ExpressionRef =>
                simd_load(Operations.Load16x4UVec128, offset, align, ptr, name),
            load32x2_s: (offset: number, align: number, ptr: ExpressionRef, name?: string): ExpressionRef =>
                simd_load(Operations.Load32x2SVec128, offset, align, ptr, name),
            load32x2_u: (offset: number, align: number, ptr: ExpressionRef, name?: string): ExpressionRef =>
                simd_load(Operations.Load32x2UVec128, offset, align, ptr, name),
            load32_zero: (offset: number, align: number, ptr: ExpressionRef, name?: string): ExpressionRef =>
                simd_load(Operations.Load32ZeroVec128, offset, align, ptr, name),
            load64_zero: (offset: number, align: number, ptr: ExpressionRef, name?: string): ExpressionRef =>
                simd_load(Operations.Load64ZeroVec128, offset, align, ptr, name),
            load8_lane: (offset: number, align: number, index: number, ptr: ExpressionRef, vec: ExpressionRef, name?: string): ExpressionRef =>
                simd_lane(Operations.Load8LaneVec128, offset, align, index, ptr, vec, name),
            load16_lane: (offset: number, align: number, index: number, ptr: ExpressionRef, vec: ExpressionRef, name?: string): ExpressionRef =>
                simd_lane(Operations.Load16LaneVec128, offset, align, index, ptr, vec, name),
            load32_lane: (offset: number, align: number, index: number, ptr: ExpressionRef, vec: ExpressionRef, name?: string): ExpressionRef =>
                simd_lane(Operations.Load32LaneVec128, offset, align, index, ptr, vec, name),
            load64_lane: (offset: number, align: number, index: number, ptr: ExpressionRef, vec: ExpressionRef, name?: string): ExpressionRef =>
                simd_lane(Operations.Load64LaneVec128, offset, align, index, ptr, vec, name),
            store8_lane: (offset: number, align: number, index: number, ptr: ExpressionRef, vec: ExpressionRef, name?: string): ExpressionRef =>
                simd_lane(Operations.Store8LaneVec128, offset, align, index, ptr, vec, name),
            store16_lane: (offset: number, align: number, index: number, ptr: ExpressionRef, vec: ExpressionRef, name?: string): ExpressionRef =>
                simd_lane(Operations.Store16LaneVec128, offset, align, index, ptr, vec, name),
            store32_lane: (offset: number, align: number, index: number, ptr: ExpressionRef, vec: ExpressionRef, name?: string): ExpressionRef =>
                simd_lane(Operations.Store32LaneVec128, offset, align, index, ptr, vec, name),
            store64_lane: (offset: number, align: number, index: number, ptr: ExpressionRef, vec: ExpressionRef, name?: string): ExpressionRef =>
                simd_lane(Operations.Store64LaneVec128, offset, align, index, ptr, vec, name),
            store: (offset: number, align: number, ptr: ExpressionRef, value: ExpressionRef, name?: string): ExpressionRef =>
                JSModule['_BinaryenStore'](this.ptr, 16, offset, align, ptr, value, v128, strToStack(name)),
            const: (i8s: ArrayLike<number>): ExpressionRef => {
                       const tempLiteral = stackAlloc(sizeOfLiteral);
                       JSModule['_BinaryenLiteralVec128'](tempLiteral, i8sToStack(i8s));
                       return JSModule['_BinaryenConst'](this.ptr, tempLiteral);
                     },
            not: (value: ExpressionRef): ExpressionRef => JSModule['_BinaryenUnary'](this.ptr, Operations.NotVec128, value),
            any_true: (value: ExpressionRef): ExpressionRef => JSModule['_BinaryenUnary'](this.ptr, Operations.AnyTrueVec128, value),
            and: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => JSModule['_BinaryenBinary'](this.ptr, Operations.AndVec128, left, right),
            or: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => JSModule['_BinaryenBinary'](this.ptr, Operations.OrVec128, left, right),
            xor: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => JSModule['_BinaryenBinary'](this.ptr, Operations.XorVec128, left, right),
            andnot: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => JSModule['_BinaryenBinary'](this.ptr, Operations.AndNotVec128, left, right),
            bitselect: (left: ExpressionRef, right: ExpressionRef, cond: ExpressionRef): ExpressionRef => JSModule['_BinaryenBinary'](this.ptr, Operations.BitselectVec128, left, right),
            pop: (): ExpressionRef => JSModule['_BinaryenPop'](this.ptr, v128)
        };
    }
    get i8x16 () {
        const unary = (op: Operations, value: ExpressionRef) =>
             JSModule['_BinaryenUnary'](this.ptr, op, value);
        const binary = (op: Operations, left: ExpressionRef, right: ExpressionRef) =>
            JSModule['_BinaryenBinary'](this.ptr, op, left, right);
        return {
            shuffle: (left: ExpressionRef, right: ExpressionRef, mask: ArrayLike<number>): ExpressionRef =>
                preserveStack(() => JSModule['_BinaryenSIMDShuffle'](this.ptr, left, right, i8sToStack(mask))),
            swizzle: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.SwizzleVecI8x16, left, right),
            splat: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.SplatVecI8x16, value),
            extract_lane_s: (vec: ExpressionRef, index: ExpressionRef): ExpressionRef =>
                JSModule['_BinaryenSIMDExtract'](this.ptr, Operations.ExtractLaneSVecI8x16, vec, index),
            extract_lane_u: (vec: ExpressionRef, index: ExpressionRef): ExpressionRef =>
                JSModule['_BinaryenSIMDExtract'](this.ptr, Operations.ExtractLaneUVecI8x16, vec, index),
            replace_lane: (vec: ExpressionRef, index: ExpressionRef, value: ExpressionRef): ExpressionRef =>
                JSModule['_BinaryenSIMDReplace'](this.ptr, JSModule['ReplaceLaneVecI8x16'], vec, index, value),
            eq: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.EqVecI8x16, left, right),
            ne: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.NeVecI8x16, left, right),
            lt_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.LtSVecI8x16, left, right),
            lt_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.LtUVecI8x16, left, right),
            gt_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.GtSVecI8x16, left, right),
            gt_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.GtUVecI8x16, left, right),
            le_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.LeSVecI8x16, left, right),
            le_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.LeUVecI8x16, left, right),
            ge_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.GeSVecI8x16, left, right),
            ge_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.GeUVecI8x16, left, right),
            abs: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.AbsVecI8x16, value),
            neg: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.NegVecI8x16, value),
            all_true: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.AllTrueVecI8x16, value),
            bitmask: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.BitmaskVecI8x16, value),
            popcnt: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.PopcntVecI8x16, value),
            shl: (vec: ExpressionRef, shift: ExpressionRef): ExpressionRef =>
                JSModule['_BinaryenSIMDShift'](this.ptr, Operations.ShlVecI8x16, vec, shift),
            shr_s: (vec: ExpressionRef, shift: ExpressionRef): ExpressionRef =>
                JSModule['_BinaryenSIMDShift'](this.ptr, Operations.ShrSVecI8x16, vec, shift),
            shr_u: (vec: ExpressionRef, shift: ExpressionRef): ExpressionRef =>
                JSModule['_BinaryenSIMDShift'](this.ptr, Operations.ShrUVecI8x16, vec, shift),
            add: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.AddVecI8x16, left, right),
            add_saturate_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.AddSatSVecI8x16, left, right),
            add_saturate_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.AddSatUVecI8x16, left, right),
            sub: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.SubVecI8x16, left, right),
            sub_saturate_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.SubSatSVecI8x16, left, right),
            sub_saturate_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.SubSatUVecI8x16, left, right),
            min_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.MinSVecI8x16, left, right),
            min_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.MinUVecI8x16, left, right),
            max_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.MaxSVecI8x16, left, right),
            max_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.MaxUVecI8x16, left, right),
            avgr_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.AvgrUVecI8x16, left, right),
            narrow_i16x8_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.NarrowSVecI16x8ToVecI8x16, left, right),
            narrow_i16x8_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.NarrowUVecI16x8ToVecI8x16, left, right)
        };
    }
    get i16x8 () {
        const unary = (op: Operations, value: ExpressionRef) =>
             JSModule['_BinaryenUnary'](this.ptr, op, value);
        const binary = (op: Operations, left: ExpressionRef, right: ExpressionRef) =>
            JSModule['_BinaryenBinary'](this.ptr, op, left, right);
        return {
            splat: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.SplatVecI16x8, value),
            extract_lane_s: (vec: ExpressionRef, index: ExpressionRef): ExpressionRef =>
                JSModule['_BinaryenSIMDExtract'](this.ptr, Operations.ExtractLaneSVecI16x8, vec, index),
            extract_lane_u: (vec: ExpressionRef, index: ExpressionRef): ExpressionRef =>
                JSModule['_BinaryenSIMDExtract'](this.ptr, Operations.ExtractLaneUVecI16x8, vec, index),
            replace_lane: (vec: ExpressionRef, index: ExpressionRef, value: ExpressionRef): ExpressionRef =>
                JSModule['_BinaryenSIMDReplace'](this.ptr, Operations.ReplaceLaneVecI16x8, vec, index, value),
            eq: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.EqVecI16x8, left, right),
            ne: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.NeVecI16x8, left, right),
            lt_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.LtSVecI16x8, left, right),
            lt_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.LtUVecI16x8, left, right),
            gt_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.GtSVecI16x8, left, right),
            gt_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.GtUVecI16x8, left, right),
            le_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.LeSVecI16x8, left, right),
            le_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.LeUVecI16x8, left, right),
            ge_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.GeSVecI16x8, left, right),
            ge_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.GeUVecI16x8, left, right),
            abs: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.AbsVecI16x8, value),
            neg: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.NegVecI16x8, value),
            all_true: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.AllTrueVecI16x8, value),
            bitmask: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.BitmaskVecI16x8, value),
            shl: (vec: ExpressionRef, shift: ExpressionRef): ExpressionRef =>
                JSModule['_BinaryenSIMDShift'](this.ptr, Operations.ShlVecI16x8, vec, shift),
            shr_s: (vec: ExpressionRef, shift: ExpressionRef): ExpressionRef =>
                JSModule['_BinaryenSIMDShift'](this.ptr, Operations.ShrSVecI16x8, vec, shift),
            shr_u: (vec: ExpressionRef, shift: ExpressionRef): ExpressionRef =>
                JSModule['_BinaryenSIMDShift'](this.ptr, Operations.ShrUVecI16x8, vec, shift),
            add: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.AddVecI16x8, left, right),
            add_saturate_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.AddSatSVecI16x8, left, right),
            add_saturate_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.AddSatUVecI16x8, left, right),
            sub: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.SubVecI16x8, left, right),
            sub_saturate_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.SubSatSVecI16x8, left, right),
            sub_saturate_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.SubSatUVecI16x8, left, right),
            mul: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.MulVecI16x8, left, right),
            min_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.MinSVecI16x8, left, right),
            min_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.MinUVecI16x8, left, right),
            max_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.MaxSVecI16x8, left, right),
            max_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.MaxUVecI16x8, left, right),
            q15mulr_sat_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.Q15MulrSatSVecI16x8, left, right),
            extmul_low_i8x16_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.ExtMulLowSVecI16x8, left, right),
            extmul_high_i8x16_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.ExtMulHighSVecI16x8, left, right),
            extmul_low_i8x16_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.ExtMulLowUVecI16x8, left, right),
            extmul_high_i8x16_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.ExtMulHighUVecI16x8, left, right),
            extadd_pairwise_i8x16_s: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.ExtAddPairwiseSVecI8x16ToI16x8, value),
            extadd_pairwise_i8x16_u: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.ExtAddPairwiseUVecI8x16ToI16x8, value),
            narrow_i32x4_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.NarrowSVecI32x4ToVecI16x8, left, right),
            narrow_i32x4_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.NarrowUVecI32x4ToVecI16x8, left, right),
            extend_low_i8x16_s: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.ExtendLowSVecI8x16ToVecI16x8, value),
            extend_high_i8x16_s: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.ExtendHighSVecI8x16ToVecI16x8, value),
            extend_low_i8x16_u: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.ExtendLowUVecI8x16ToVecI16x8, value),
            extend_high_i8x16_u: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.ExtendHighUVecI8x16ToVecI16x8, value)
        };
    }
    get i32x4 () {
        const unary = (op: Operations, value: ExpressionRef) =>
             JSModule['_BinaryenUnary'](this.ptr, op, value);
        const binary = (op: Operations, left: ExpressionRef, right: ExpressionRef) =>
            JSModule['_BinaryenBinary'](this.ptr, op, left, right);
        return {
            splat: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.SplatVecI32x4, value),
            extract_lane: (vec: ExpressionRef, index: ExpressionRef): ExpressionRef =>
                JSModule['_BinaryenSIMDExtract'](this.ptr, Operations.ExtractLaneVecI32x4, vec, index),
            replace_lane: (vec: ExpressionRef, index: ExpressionRef, value: ExpressionRef): ExpressionRef =>
                JSModule['_BinaryenSIMDReplace'](this.ptr, Operations.ReplaceLaneVecI32x4, vec, index, value),
            eq: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.EqVecI32x4, left, right),
            ne: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.NeVecI32x4, left, right),
            lt_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.LtSVecI32x4, left, right),
            lt_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.LtUVecI32x4, left, right),
            gt_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.GtSVecI32x4, left, right),
            gt_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.GtUVecI32x4, left, right),
            le_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.LeSVecI32x4, left, right),
            le_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.LeUVecI32x4, left, right),
            ge_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.GeSVecI32x4, left, right),
            ge_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.GeUVecI32x4, left, right),
            abs: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.AbsVecI32x4, value),
            neg: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.NegVecI32x4, value),
            all_true: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.AllTrueVecI32x4, value),
            bitmask: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.BitmaskVecI32x4, value),
            shl: (vec: ExpressionRef, shift: ExpressionRef): ExpressionRef =>
                JSModule['_BinaryenSIMDShift'](this.ptr, Operations.ShlVecI32x4, vec, shift),
            shr_s: (vec: ExpressionRef, shift: ExpressionRef): ExpressionRef =>
                JSModule['_BinaryenSIMDShift'](this.ptr, Operations.ShrSVecI32x4, vec, shift),
            shr_u: (vec: ExpressionRef, shift: ExpressionRef): ExpressionRef =>
                JSModule['_BinaryenSIMDShift'](this.ptr, Operations.ShrUVecI32x4, vec, shift),
            add: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.AddVecI32x4, left, right),
            sub: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.SubVecI32x4, left, right),
            mul: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.MulVecI32x4, left, right),
            min_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.MinSVecI32x4, left, right),
            min_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.MinUVecI32x4, left, right),
            max_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.MaxSVecI32x4, left, right),
            max_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.MaxUVecI32x4, left, right),
            dot_i16x8_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.DotSVecI16x8ToVecI32x4, left, right),
            extmul_low_i16x8_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.ExtMulLowSVecI32x4, left, right),
            extmul_high_i16x8_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.ExtMulHighSVecI32x4, left, right),
            extmul_low_i16x8_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.ExtMulLowUVecI32x4, left, right),
            extmul_high_i16x8_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.ExtMulHighUVecI32x4, left, right),
            extadd_pairwise_i16x8_s: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.ExtAddPairwiseSVecI16x8ToI32x4, value),
            extadd_pairwise_i16x8_u: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.ExtAddPairwiseUVecI16x8ToI32x4, value),
            trunc_sat_f32x4_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.TruncSatSVecF32x4ToVecI32x4, left, right),
            trunc_sat_f32x4_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.TruncSatUVecF32x4ToVecI32x4, left, right),
            extend_low_i16x8_s: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.ExtendLowSVecI16x8ToVecI32x4, value),
            extend_high_i16x8_s: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.ExtendHighSVecI16x8ToVecI32x4, value),
            extend_low_i16x8_u: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.ExtendLowUVecI16x8ToVecI32x4, value),
            extend_high_i16x8_u: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.ExtendHighUVecI16x8ToVecI32x4, value),
            trunc_sat_f64x2_s_zero: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.TruncSatZeroSVecF64x2ToVecI32x4, left, right),
            trunc_sat_f64x2_u_zero: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.TruncSatZeroUVecF64x2ToVecI32x4, left, right)
        };
    }
    get i64x2 () {
        const unary = (op: Operations, value: ExpressionRef) =>
             JSModule['_BinaryenUnary'](this.ptr, op, value);
        const binary = (op: Operations, left: ExpressionRef, right: ExpressionRef) =>
            JSModule['_BinaryenBinary'](this.ptr, op, left, right);
        return {
            splat: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.SplatVecI64x2, value),
            extract_lane: (vec: ExpressionRef, index: ExpressionRef): ExpressionRef =>
                JSModule['_BinaryenSIMDExtract'](this.ptr, Operations.ExtractLaneVecI64x2, vec, index),
            replace_lane: (vec: ExpressionRef, index: ExpressionRef, value: ExpressionRef): ExpressionRef =>
                JSModule['_BinaryenSIMDReplace'](this.ptr, Operations.ReplaceLaneVecI64x2, vec, index, value),
            eq: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.EqVecI64x2, left, right),
            ne: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.NeVecI64x2, left, right),
            lt_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.LtSVecI64x2, left, right),
            gt_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.GtSVecI64x2, left, right),
            le_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.LeSVecI64x2, left, right),
            ge_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.GeSVecI64x2, left, right),
            abs: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.AbsVecI64x2, value),
            neg: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.NegVecI64x2, value),
            all_true: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.AllTrueVecI64x2, value),
            bitmask: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.BitmaskVecI64x2, value),
            shl: (vec: ExpressionRef, shift: ExpressionRef): ExpressionRef =>
                JSModule['_BinaryenSIMDShift'](this.ptr, Operations.ShlVecI64x2, vec, shift),
            shr_s: (vec: ExpressionRef, shift: ExpressionRef): ExpressionRef =>
                JSModule['_BinaryenSIMDShift'](this.ptr, Operations.ShrSVecI64x2, vec, shift),
            shr_u: (vec: ExpressionRef, shift: ExpressionRef): ExpressionRef =>
                JSModule['_BinaryenSIMDShift'](this.ptr, Operations.ShrUVecI64x2, vec, shift),
            add: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.AddVecI64x2, left, right),
            sub: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.SubVecI64x2, left, right),
            mul: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.MulVecI64x2, left, right),
            extmul_low_i32x4_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.ExtMulLowSVecI64x2, left, right),
            extmul_high_i32x4_s: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.ExtMulHighSVecI64x2, left, right),
            extmul_low_i32x4_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.ExtMulLowUVecI64x2, left, right),
            extmul_high_i32x4_u: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.ExtMulHighUVecI64x2, left, right),
            extend_low_i32x4_s: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.ExtendLowSVecI32x4ToVecI64x2, value),
            extend_high_i32x4_s: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.ExtendHighSVecI32x4ToVecI64x2, value),
            extend_low_i32x4_u: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.ExtendLowUVecI32x4ToVecI64x2, value),
            extend_high_i32x4_u: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.ExtendHighUVecI32x4ToVecI64x2, value)
        };
    }
    get f32x4 () {
        const unary = (op: Operations, value: ExpressionRef) =>
             JSModule['_BinaryenUnary'](this.ptr, op, value);
        const binary = (op: Operations, left: ExpressionRef, right: ExpressionRef) =>
            JSModule['_BinaryenBinary'](this.ptr, op, left, right);
        return {
            splat: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.SplatVecF32x4, value),
            extract_lane: (vec: ExpressionRef, index: ExpressionRef): ExpressionRef =>
                JSModule['_BinaryenSIMDExtract'](this.ptr, Operations.ExtractLaneVecF32x4, vec, index),
            replace_lane: (vec: ExpressionRef, index: ExpressionRef, value: ExpressionRef): ExpressionRef =>
                JSModule['_BinaryenSIMDReplace'](this.ptr, Operations.ReplaceLaneVecF32x4, vec, index, value),
            eq: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.EqVecF32x4, left, right),
            ne: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.NeVecF32x4, left, right),
            lt: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.LtVecF32x4, left, right),
            gt: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.GtVecF32x4, left, right),
            le: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.LeVecF32x4, left, right),
            ge: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.GeVecF32x4, left, right),
            abs: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.AbsVecF32x4, value),
            neg: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.NegVecF32x4, value),
            sqrt: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.SqrtVecF32x4, value),
            add: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.AddVecF32x4, left, right),
            sub: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.SubVecF32x4, left, right),
            mul: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.MulVecF32x4, left, right),
            div: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                     binary(Operations.DivVecF32x4, left, right),
            min: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.MinVecF32x4, left, right),
            max: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.MaxVecF32x4, left, right),
            pmin: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.PMinVecF32x4, left, right),
            pmax: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.PMaxVecF32x4, left, right),
            ceil: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.CeilVecF32x4, value),
            floor: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.FloorVecF32x4, value),
            trunc: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.TruncVecF32x4, value),
            nearest: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.NearestVecF32x4, value),
            convert_i32x4_s: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.ConvertSVecI32x4ToVecF32x4, value),
            convert_i32x4_u: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.ConvertUVecI32x4ToVecF32x4, value),
            demote_f64x2_zero: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.DemoteZeroVecF64x2ToVecF32x4, value)
        };
    }
    get f64x2 () {
        const unary = (op: Operations, value: ExpressionRef) =>
             JSModule['_BinaryenUnary'](this.ptr, op, value);
        const binary = (op: Operations, left: ExpressionRef, right: ExpressionRef) =>
            JSModule['_BinaryenBinary'](this.ptr, op, left, right);
        return {
            splat: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.SplatVecF64x2, value),
            extract_lane: (vec: ExpressionRef, index: ExpressionRef): ExpressionRef =>
                JSModule['_BinaryenSIMDExtract'](this.ptr, Operations.ExtractLaneVecF64x2, vec, index),
            replace_lane: (vec: ExpressionRef, index: ExpressionRef, value: ExpressionRef): ExpressionRef =>
                JSModule['_BinaryenSIMDReplace'](this.ptr, Operations.ReplaceLaneVecF64x2, vec, index, value),
            eq: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.EqVecF64x2, left, right),
            ne: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.NeVecF64x2, left, right),
            lt: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.LtVecF64x2, left, right),
            gt: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.GtVecF64x2, left, right),
            le: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.LeVecF64x2, left, right),
            ge: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.GeVecF64x2, left, right),
            abs: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.AbsVecF64x2, value),
            neg: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.NegVecF64x2, value),
            sqrt: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.SqrtVecF64x2, value),
            add: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.AddVecF64x2, left, right),
            sub: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.SubVecF64x2, left, right),
            mul: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.MulVecF64x2, left, right),
            div: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                     binary(Operations.DivVecF64x2, left, right),
            min: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.MinVecF64x2, left, right),
            max: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.MaxVecF64x2, left, right),
            pmin: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.PMinVecF64x2, left, right),
            pmax: (left: ExpressionRef, right: ExpressionRef): ExpressionRef =>
                binary(Operations.PMaxVecF64x2, left, right),
            ceil: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.CeilVecF64x2, value),
            floor: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.FloorVecF64x2, value),
            trunc: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.TruncVecF64x2, value),
            nearest: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.NearestVecF64x2, value),
            convert_low_i32x4_s: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.ConvertLowSVecI32x4ToVecF64x2, value),
            convert_low_i32x4_u: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.ConvertLowUVecI32x4ToVecF64x2, value),
            promote_low_f32x4: (value: ExpressionRef): ExpressionRef =>
                unary(Operations.PromoteLowVecF32x4ToVecF64x2, value)
        };
    }
    get funcref() {
        return {
            pop: (): ExpressionRef => JSModule['_BinaryenPop'](this.ptr, funcref)
        };
    }
    get externref() {
        return {
            pop: (): ExpressionRef => JSModule['_BinaryenPop'](this.ptr, externref)
        };
    }
    get anyref() {
        return {
            pop: (): ExpressionRef => JSModule['_BinaryenPop'](this.ptr, anyref)
        };
    }
    get eqref() {
        return {
            pop: (): ExpressionRef => JSModule['_BinaryenPop'](this.ptr, eqref)
        };
    }
    get i31ref() {
        return {
            pop: (): ExpressionRef => JSModule['_BinaryenPop'](this.ptr, i31ref)
        };
    }
    get structref() {
        return {
            pop: (): ExpressionRef => JSModule['_BinaryenPop'](this.ptr, structref)
        };
    }
    /* explicitly skipping string stuff until it's reprioritized
    get stringref() {
        return {
            pop: () => JSModule['_BinaryenPop'](this.ptr, stringref)
        }
    }
    get stringview_wtf8() {
        return {
            pop: () => JSModule['_BinaryenPop'](this.ptr, stringview_wtf8)
        }
    }
    get stringview_wtf16() {
        return {
            pop: () => JSModule['_BinaryenPop'](this.ptr, stringview_wtf16)
        }
    }
    get stringview_iter() {
        return {
            pop: () => JSModule['_BinaryenPop'](this.ptr, stringview_iter)
        }
    }
    */
    get ref() {
        return {
            null: (type: Type): ExpressionRef => JSModule['_BinaryenRefNull'](this.ptr, type),
            is_null: (value: ExpressionRef): ExpressionRef => JSModule['_BinaryenRefIsNull'](this.ptr, value),
            i31: (value: ExpressionRef): ExpressionRef => JSModule['_BinaryenRefI31'](this.ptr, value),
            func: (name: string, type: Type): ExpressionRef => JSModule['_BinaryenRefFunc'](this.ptr, strToStack(name), type),
            eq: (left: ExpressionRef, right: ExpressionRef): ExpressionRef => JSModule['_BinaryenRefEq'](this.ptr, left, right),
            as_non_null: (value: ExpressionRef): ExpressionRef => JSModule['_BinaryenRefAs'](this.ptr, Operations.RefAsNonNull, value)
        };
    }
    get i31 () {
         return {
            get_s: (i31: ExpressionRef): ExpressionRef => JSModule['_BinaryenI31Get'](this.ptr, i31, 1),
            get_u: (i31: ExpressionRef): ExpressionRef => JSModule['_BinaryenI31Get'](this.ptr, i31, 0)
         };
    }
    get atomic () {
        return {
            fence: (): ExpressionRef =>  JSModule['_BinaryenAtomicFence'](this.ptr)
        };
    }
    get locals () {
        return {
            get: (index: number, type: Type): ExpressionRef => JSModule['_BinaryenLocalGet'](this.ptr, index, type),
            set: (index: number, value: ExpressionRef): ExpressionRef => JSModule['_BinaryenLocalSet'](this.ptr, index, value),
            tee: (index: number, value: ExpressionRef, type: Type): ExpressionRef => {
                if (typeof type === 'undefined') {
                    throw new Error("local.tee's type should be defined");
                }
                return JSModule['_BinaryenLocalTee'](this.ptr, index, value, type);
            }
        };
    }
    get globals () {
        return {
            add: (name: string, type: Type, mutable: boolean, init: ExpressionRef): GlobalRef =>
                preserveStack(() => JSModule['_BinaryenAddGlobal'](this.ptr, strToStack(name), type, mutable, init)),
            getRefByName: (name: string): GlobalRef => preserveStack(() => JSModule['_BinaryenGetGlobal'](this.ptr, strToStack(name))),
            getRefByIndex: (index: number): GlobalRef => JSModule['_BinaryenGetGlobalByIndex'](this.ptr, index),
            remove: (name: string): void => preserveStack(() => JSModule['_BinaryenRemoveGlobal'](this.ptr, strToStack(name))),
            count: (): number => JSModule['_BinaryenGetNumGlobals'](this.ptr),
            set: (name: string, value: ExpressionRef): ExpressionRef => JSModule['_BinaryenGlobalSet'](this.ptr, strToStack(name), value),
            get: (name: string, type: Type): ExpressionRef => JSModule['_BinaryenGlobalGet'](this.ptr, strToStack(name), type),
            addImport: (internalName: string, externalModuleName: string, externalBaseName: string, globalType: Type, mutable: boolean): void =>
                preserveStack(() => JSModule['_BinaryenAddGlobalImport'](this.ptr, strToStack(internalName), strToStack(externalModuleName), strToStack(externalBaseName), globalType, mutable)),
            addExport: (internalName: string, externalName: string): ExportRef =>
                preserveStack(() => JSModule['_BinaryenAddGlobalExport'](this.ptr, strToStack(internalName), strToStack(externalName))),
            getInfo: (ref: GlobalRef): GlobalInfo => {
                return {
                    'name': UTF8ToString(JSModule['_BinaryenGlobalGetName'](ref)),
                    'module': UTF8ToString(JSModule['_BinaryenGlobalImportGetModule'](ref)),
                    'base': UTF8ToString(JSModule['_BinaryenGlobalImportGetBase'](ref)),
                    'type': JSModule['_BinaryenGlobalGetType'](ref),
                    'mutable': Boolean(JSModule['_BinaryenGlobalIsMutable'](ref)),
                    'init': JSModule['_BinaryenGlobalGetInitExpr'](ref)
                };
            }
        };
    }
    get tables () {
        return {
            add: (name: string, initial: number, maximum: number, type: Type): TableRef =>
                preserveStack(() => JSModule['_BinaryenAddTable'](this.ptr, strToStack(name), initial, maximum, type)),
            getRefByName: (name: string): TableRef =>
                preserveStack(() => JSModule['_BinaryenGetTable'](this.ptr, strToStack(name))),
            getRefByIndex: (index: number): TableRef => JSModule['_BinaryenGetTableByIndex'](this.ptr, index),
            remove: (name: string): void =>
                preserveStack(() => JSModule['_BinaryenRemoveTable'](this.ptr, strToStack(name))),
            count: (): number => JSModule['_BinaryenGetNumTables'](this.ptr),
            get: (name: string, index: ExpressionRef, type: Type): ExpressionRef => JSModule['_BinaryenTableGet'](this.ptr, strToStack(name), index, type),
            set: (name: string, index: ExpressionRef, value: ExpressionRef): ExpressionRef => JSModule['_BinaryenTableSet'](this.ptr, strToStack(name), index, value),
            size: (name: string): ExpressionRef => JSModule['_BinaryenTableSize'](this.ptr, strToStack(name)),
            grow: (name: string, value: ExpressionRef, delta: ExpressionRef): ExpressionRef => JSModule['_BinaryenTableGrow'](this.ptr, strToStack(name), value, delta),
            addImport: (internalName: string, externalModuleName: string, externalBaseName: string): void =>
                preserveStack(() => JSModule['_BinaryenAddTableImport'](this.ptr, strToStack(internalName), strToStack(externalModuleName), strToStack(externalBaseName))),
            addExport: (internalName: string, externalName: string): ExportRef =>
                preserveStack(() => JSModule['_BinaryenAddTableExport'](this.ptr, strToStack(internalName), strToStack(externalName))),
            getInfo: (table: TableRef): TableInfo => {
                    const hasMax = Boolean(JSModule['_BinaryenTableHasMax'](this.ptr, table));
                    const withMax = hasMax ? { max: JSModule['_BinaryenTableGetMax'](this.ptr, table)} : {};
                    return Object.assign({
                        'name': UTF8ToString(JSModule['_BinaryenTableGetName'](table)),
                        'module': UTF8ToString(JSModule['_BinaryenTableImportGetModule'](table)),
                        'base': UTF8ToString(JSModule['_BinaryenTableImportGetBase'](table)),
                        'initial': JSModule['_BinaryenTableGetInitial'](table),
                    }, withMax);
            }
        };
        /* TODO
        a._BinaryenTableGetName = Q.My;
        a._BinaryenTableSetName = Q.Ny;
        a._BinaryenTableGetInitial = Q.Oy;
        a._BinaryenTableSetInitial = Q.Py;
        a._BinaryenTableHasMax = Q.Qy;
        a._BinaryenTableGetMax = Q.Ry;
        a._BinaryenTableSetMax = Q.Sy;
        a._BinaryenTableGetType = Q.Ty;
        a._BinaryenTableSetType = Q.Uy;
        */
    }
    get tuples () {
        return {
            make: (elements: ExportRef[]): ExpressionRef =>
                preserveStack(() => JSModule['_BinaryenTupleMake'](this.ptr, i32sToStack(elements), elements.length)),
            extract: (tuple: ExpressionRef, index: number): ExpressionRef =>
                JSModule['_BinaryenTupleExtract'](this.ptr, tuple, index)
        };
    }
    get functions () {
        return {
            add: (name: string, params: Type, results: Type, varTypes: Type[], body: ExpressionRef): FunctionRef =>
                preserveStack(() =>
                      JSModule['_BinaryenAddFunction'](this.ptr, strToStack(name), params, results, i32sToStack(varTypes), varTypes.length, body)),
            getRefByName: (name: string): FunctionRef =>
                preserveStack(() => JSModule['_BinaryenGetFunction'](this.ptr, strToStack(name))),
            getRefByIndex: (index: number): FunctionRef =>
                JSModule['_BinaryenGetFunctionByIndex'](this.ptr, index),
            remove: (name: string): void =>
                preserveStack(() => JSModule['_BinaryenRemoveFunction'](this.ptr, strToStack(name))),
            count: (): number => JSModule['_BinaryenGetNumFunctions'](this.ptr),
            addImport: (internalName: string, externalModuleName: string, externalBaseName: string, params: Type, results: Type): void =>
                preserveStack(() =>
                      JSModule['_BinaryenAddFunctionImport'](this.ptr, strToStack(internalName), strToStack(externalModuleName), strToStack(externalBaseName), params, results)
                    ),
            addExport: (internalName: string, externalName: string): ExportRef =>
                preserveStack(() => JSModule['_BinaryenAddFunctionExport'](this.ptr, strToStack(internalName), strToStack(externalName)))
          };
    }
    get tags() {
        return {
            add: (name: string, params: Type, results: Type): TagRef =>
                preserveStack(() => JSModule['_BinaryenAddTag'](this.ptr, strToStack(name), params, results)),
            getRefByName: (name: string): TagRef =>
                preserveStack(() => JSModule['_BinaryenGetTag'](this.ptr, strToStack(name))),
            remove: (name: string): void =>
                preserveStack(() => JSModule['_BinaryenRemoveTag'](this.ptr, strToStack(name))),
            addImport: (internalName: string, externalModuleName: string, externalBaseName: string, params: Type, results: Type): void =>
                preserveStack(() => JSModule['_BinaryenAddTagImport'](this.ptr, strToStack(internalName), strToStack(externalModuleName), strToStack(externalBaseName), params, results)),
            addExport: (internalName: string, externalName: string): ExportRef =>
                preserveStack(() => JSModule['_BinaryenAddTagExport'](this.ptr, strToStack(internalName), strToStack(externalName))),
            getInfo: (tag: TagRef): TagInfo => {
                return {
                    'name': UTF8ToString(JSModule['_BinaryenTagGetName'](tag)),
                    'module': UTF8ToString(JSModule['_BinaryenTagImportGetModule'](tag)),
                    'base': UTF8ToString(JSModule['_BinaryenTagImportGetBase'](tag)),
                    'params': JSModule['_BinaryenTagGetParams'](tag),
                    'results': JSModule['_BinaryenTagGetResults'](tag)
                  };
            }
        };
    }
    get memory () {
        return {
            init: (segment: string, dest: ExpressionRef, offset: ExpressionRef, size: ExpressionRef, name?: string): ExpressionRef =>
                preserveStack(() => JSModule['_BinaryenMemoryInit'](this.ptr, strToStack(segment), dest, offset, size, strToStack(name))),
            has: () => Boolean(JSModule['_BinaryenHasMemory'](this.ptr)),
            size: (name?: string, memory64?: boolean): ExpressionRef => JSModule['_BinaryenMemorySize'](this.ptr, strToStack(name), memory64),
            grow: (value: ExpressionRef, name?: string, memory64?: boolean): ExpressionRef => JSModule['_BinaryenMemoryGrow'](this.ptr, value, strToStack(name), memory64),
            copy: (dest: ExpressionRef, source: ExpressionRef, size: ExpressionRef, destName?: string, sourceName?: string): ExpressionRef =>
                JSModule['_BinaryenMemoryCopy'](this.ptr, dest, source, size, strToStack(destName), strToStack(sourceName)),
            fill: (dest: ExpressionRef, value: ExpressionRef, size: ExpressionRef, name?: string): ExpressionRef =>
                JSModule['_BinaryenMemoryFill'](this.ptr, dest, value, size, strToStack(name)),
            set: (initial: number, maximum: number, exportName?: string | null, segments?: SegmentInfo[] | null, shared?: boolean, memory64?: boolean, internalName?: string): void =>
                preserveStack(() => {
                      const segmentsLen = segments ? segments.length : 0;
                      const segmentData = new Array(segmentsLen);
                      const segmentDataLen = new Array(segmentsLen);
                      const segmentPassive = new Array(segmentsLen);
                      const segmentOffset = new Array(segmentsLen);
                      for (let i = 0; i < segmentsLen; i++) {
                        const { data, offset, passive } = segments[i];
                        segmentData[i] = _malloc(data.length);
                        HEAP8.set(data, segmentData[i]);
                        segmentDataLen[i] = data.length;
                        segmentPassive[i] = passive;
                        segmentOffset[i] = offset;
                      }
                      const ret = JSModule['_BinaryenSetMemory'](
                        this.ptr, initial, maximum, strToStack(exportName),
                        i32sToStack(segmentData),
                        i8sToStack(segmentPassive),
                        i32sToStack(segmentOffset),
                        i32sToStack(segmentDataLen),
                        segmentsLen,
                        shared,
                        memory64,
                        strToStack(internalName)
                      );
                      for (let i = 0; i < segmentsLen; i++) {
                        _free(segmentData[i]);
                      }
                      return ret;
                    }),
            getInfo: (name?: string): MemoryInfo => {
                    const hasMax = Boolean(JSModule['_BinaryenMemoryHasMax'](this.ptr, strToStack(name)));
                    const withMax = hasMax ? { max: JSModule['_BinaryenMemoryGetMax'](this.ptr, strToStack(name))} : {};
                    return Object.assign({
                        module: UTF8ToString(JSModule['_BinaryenMemoryImportGetModule'](this.ptr, strToStack(name))),
                        base: UTF8ToString(JSModule['_BinaryenMemoryImportGetBase'](this.ptr, strToStack(name))),
                        initial: JSModule['_BinaryenMemoryGetInitial'](this.ptr, strToStack(name)),
                        shared: Boolean(JSModule['_BinaryenMemoryIsShared'](this.ptr, strToStack(name))),
                        is64: Boolean(JSModule['_BinaryenMemoryIs64'](this.ptr, strToStack(name))),
                    }, withMax);
                },
            countSegments: (): number => JSModule['_BinaryenGetNumMemorySegments'](this.ptr),
            getSegmentInfoByIndex: (index: number): SegmentInfo => {
                    const passive = Boolean(JSModule['_BinaryenGetMemorySegmentPassive'](this.ptr, index));
                    const offset = passive ? 0 : JSModule['_BinaryenGetMemorySegmentByteOffset'](this.ptr, index);
                    const size = JSModule['_BinaryenGetMemorySegmentByteLength'](this.ptr, index);
                    const ptr = _malloc(size);
                    JSModule['_BinaryenCopyMemorySegmentData'](this.ptr, index, ptr);
                    const data = new Uint8Array(size);
                    data.set(HEAP8.subarray(ptr, ptr + size));
                    _free(ptr);
                    return { offset, data, passive };
                },
            countElementSegments: (): number => JSModule['_BinaryenGetNumElementSegments'](this.ptr),
            getElementSegmentByIndex: (index: number): ElementSegmentRef => JSModule['_BinaryenGetElementSegmentByIndex'](this.ptr, index),
            getElementSegmentInfo: (segment: ElementSegmentRef): ElementSegmentInfo => {
                  const segmentLength = JSModule['_BinaryenElementSegmentGetLength'](segment);
                  const names = new Array(segmentLength);
                  for (let j = 0; j < segmentLength; j++) {
                    names[j] = UTF8ToString(JSModule['_BinaryenElementSegmentGetData'](segment, j));
                  }
                  return {
                    'name': UTF8ToString(JSModule['_BinaryenElementSegmentGetName'](segment)),
                    'table': UTF8ToString(JSModule['_BinaryenElementSegmentGetTable'](segment)),
                    'offset': JSModule['_BinaryenElementSegmentGetOffset'](segment),
                    'data': names
                  };
                },
            addImport: (internalName: string, externalModuleName: string, externalBaseName: string, shared: boolean): void =>
                preserveStack(() => JSModule['_BinaryenAddMemoryImport'](this.ptr, strToStack(internalName), strToStack(externalModuleName), strToStack(externalBaseName), shared)),
            addExport: (internalName: string, externalName: string): ExportRef =>
                preserveStack(() => JSModule['_BinaryenAddMemoryExport'](this.ptr, strToStack(internalName), strToStack(externalName))),
            atomic: {
                notify: (ptr: ExpressionRef, notifyCount: ExpressionRef, name?: string): ExpressionRef =>
                    JSModule['_BinaryenAtomicNotify'](this.ptr, ptr, notifyCount, strToStack(name)),
                wait32: (ptr: ExpressionRef, expected: ExpressionRef, timeout: ExpressionRef, name?: string): ExpressionRef =>
                    JSModule['_BinaryenAtomicWait'](this.ptr, ptr, expected, timeout, JSModule['i32'], strToStack(name)),
                wait64: (ptr: ExpressionRef, expected: ExpressionRef, timeout: ExpressionRef, name?: string): ExpressionRef =>
                    JSModule['_BinaryenAtomicWait'](this.ptr, ptr, expected, timeout, JSModule['i64'], strToStack(name))
            }
        };
    }
    get data () {
        return {
            drop: (segment: string): ExpressionRef => preserveStack(() => JSModule['_BinaryenDataDrop'](this.ptr, strToStack(segment)))
        };
    }
    get exports () {
        return {
            getRefByName: (externalName: string): ExportRef =>
                preserveStack(() => JSModule['_BinaryenGetExport'](this.ptr, strToStack(externalName))),
            getRefByIndex: (index: number): ExportRef => JSModule['_BinaryenGetExportByIndex'](this.ptr, index),
            remove: (externalName: string): void => preserveStack(() => JSModule['_BinaryenRemoveExport'](this.ptr, strToStack(externalName))),
            count: (): number => JSModule['_BinaryenGetNumExports'](this.ptr),
            getInfo: (export_: ExportRef): ExportInfo => {
                  return {
                    'kind': JSModule['_BinaryenExportGetKind'](export_),
                    'name': UTF8ToString(JSModule['_BinaryenExportGetName'](export_)),
                    'value': UTF8ToString(JSModule['_BinaryenExportGetValue'](export_))
                  };
            }

        };
    }
    get expressions () {
        return {
            copy: (expr: ExpressionRef): ExpressionRef => JSModule['_BinaryenExpressionCopy'](expr, this.ptr),
            getType: (expression: ExpressionRef): Type => JSModule['_BinaryenExpressionGetType'](expression),
            getInfo: (expression: ExpressionRef): ExpressionInfo => getExpressionInfo(expression),
            getSideEffects: (expression: ExpressionRef): SideEffects => JSModule['_BinaryenExpressionGetSideEffects'](expression, this.ptr),
            emitText: (expression: ExpressionRef): string => {
                  let text = '';
                  const old = swapOut(s => { text += s + '\n' });
                  JSModule['_BinaryenExpressionPrint'](expression);
                  swapOut(old);
                  return text;
            }
       };
   }
   get arrays () {
        return {
            fromValues: (heapType: HeapType, values: ExpressionRef[]): ExpressionRef => {
                const ptr = _malloc(Math.max(8, values.length * 4));
                let offset = ptr;
                values.forEach(value => {
                    __i32_store(offset, value);
                    offset += 4;
                })
                return JSModule['_BinaryenArrayNewFixed'](this.ptr, heapType, ptr, values.length);
             }


        }
   }
}

export class Relooper {

    readonly ref: RelooperBlockRef

    constructor(module: Module, ref?: RelooperBlockRef) {
        this.ref = ref || JSModule['_RelooperCreate'](module.ptr);
    }
    addBlock(code: ExpressionRef): RelooperBlockRef {
        return JSModule['_RelooperAddBlock'](this.ref, code);
    }
    addBranch(from: RelooperBlockRef, to: RelooperBlockRef, condition: ExpressionRef, code: ExpressionRef): void {
        JSModule['_RelooperAddBranch'](from, to, condition, code);
    }
    addBlockWithSwitch(code: ExpressionRef, condition: ExpressionRef): RelooperBlockRef {
        return JSModule['_RelooperAddBlockWithSwitch'](this.ref, code, condition);
    }
    addBranchForSwitch(from: RelooperBlockRef, to: RelooperBlockRef, indexes: number[], code: ExpressionRef): void {
        preserveStack(() => JSModule['_RelooperAddBranchForSwitch'](from, to, i32sToStack(indexes), indexes.length, code));
    }
    renderAndDispose(entry: RelooperBlockRef, labelHelper: number): ExpressionRef {
        return JSModule['_RelooperRenderAndDispose'](this.ref, entry, labelHelper);
    }
}

export enum ExpressionRunnerFlags {
    Default = JSModule['_ExpressionRunnerFlagsDefault'](),
    PreserveSideEffects = JSModule['_ExpressionRunnerFlagsPreserveSideeffects'](),
    TraverseCalls = JSModule['_ExpressionRunnerFlagsTraverseCalls']()
}

export class ExpressionRunner {

    readonly ref: ExpressionRunnerRef;

    constructor(module: Module, flags: ExpressionRunnerFlags, maxDepth: number, maxLoopIterations: number) {
        this.ref = JSModule['_ExpressionRunnerCreate'](module.ptr, flags, maxDepth, maxLoopIterations);
    }
    setLocalValue(index: number, valueExpr: ExpressionRef): boolean {
        return Boolean(JSModule['_ExpressionRunnerSetLocalValue'](this.ref, index, valueExpr));
    }
    setGlobalValue(name: string, valueExpr: ExpressionRef): boolean {
        return preserveStack(() => Boolean(JSModule['_ExpressionRunnerSetGlobalValue'](this.ref, strToStack(name), valueExpr)));
    }
    runAndDispose(expr: ExpressionRef): ExpressionRef {
        return JSModule['_ExpressionRunnerRunAndDispose'](this.ref, expr);
    }
}

export interface TypeBuilderResult {
    heapTypes: HeapType[];
    errorIndex: number | null;
    errorReason: number | null;
}

export class TypeBuilder {

    static typeFromTempHeapType(heapType: HeapType, nullable: boolean): Type {
        return JSModule['_BinaryenTypeFromHeapType'](heapType, nullable);
    }

    readonly ref: TypeBuilderRef;

    constructor(slots: number) {
        this.ref = JSModule['_TypeBuilderCreate'](slots);
    }

    setArrayType(slot: number, elementType: Type, elementPackedType: PackedType, mutable: boolean): TypeBuilder {
        JSModule['_TypeBuilderSetArrayType'](this.ref, slot, elementType, elementPackedType, mutable);
        return this;
    }

    getTempHeapType(slot: number): HeapType {
        return JSModule['_TypeBuilderGetTempHeapType'](this.ref, slot);
    }

    buildAndDispose(): TypeBuilderResult {
        const size = JSModule['_TypeBuilderGetSize'](this.ref) as number;
        const ptr = _malloc( 4 + 4 + (4 * size)); // assume 4-bytes memory reference
        const errorIndexPtr = ptr;
        const errorReasonPtr = ptr + 4;
        const heapTypesPtr = ptr + 8;
        const ok = JSModule['_TypeBuilderBuildAndDispose'](this.ref, heapTypesPtr, errorIndexPtr, errorReasonPtr);
        const errorIndex = __i32_load(errorIndexPtr);
        const errorReason = __i32_load(errorReasonPtr);
        const heapTypes: HeapType[] = [];
        if (ok) {
            for(let i=0, offset = heapTypesPtr;i < size; i++, offset += 4) {
                const type = __i32_load(offset);
                heapTypes.push(type);
            }
        }
        _free(ptr);
        return { heapTypes, errorIndex, errorReason};
    }

}


export interface SegmentInfo {
    offset: ExpressionRef;
    data: Uint8Array;
    passive?: boolean;
}

export interface MemoryInfo {
    module: string | null;
    base: string | null;
    shared: boolean;
    is64: boolean;
    initial: number;
    max?: number;
}

export interface ExpressionInfo {
    id: number;
    type: Type;
  }

export interface BlockInfo extends ExpressionInfo {
    name: string;
    children: ExpressionRef[];
  }

export interface IfInfo extends ExpressionInfo {
    condition: ExpressionRef;
    ifTrue: ExpressionRef;
    ifFalse: ExpressionRef;
  }

export interface LoopInfo extends ExpressionInfo {
    name: string;
    body: ExpressionRef;
  }

export interface BreakInfo extends ExpressionInfo {
    name: string;
    condition: ExpressionRef;
    value: ExpressionRef;
  }

export interface SwitchInfo extends ExpressionInfo {
    names: string[];
    defaultName: string | null;
    condition: ExpressionRef;
    value: ExpressionRef;
  }

export interface CallInfo extends ExpressionInfo {
    isReturn: boolean;
    target: string;
    operands: ExpressionRef[];
  }

export interface CallIndirectInfo extends ExpressionInfo {
    isReturn: boolean;
    target: ExpressionRef;
    operands: ExpressionRef[];
  }

export interface LocalGetInfo extends ExpressionInfo {
    index: number;
  }

export interface LocalSetInfo extends ExpressionInfo {
    isTee: boolean;
    index: number;
    value: ExpressionRef;
  }

export interface GlobalGetInfo extends ExpressionInfo {
    name: string;
  }

export interface GlobalSetInfo extends ExpressionInfo {
    name: string;
    value: ExpressionRef;
  }

export interface TableGetInfo extends ExpressionInfo {
    table: string;
    index: ExpressionRef;
  }

export interface TableSetInfo extends ExpressionInfo {
    table: string;
    index: ExpressionRef;
    value: ExpressionRef;
  }

export interface TableSizeInfo extends ExpressionInfo {
    table: string;
  }

export interface TableGrowInfo extends ExpressionInfo {
    table: string;
    value: ExpressionRef;
    delta: ExpressionRef;
  }

export interface LoadInfo extends ExpressionInfo {
    isAtomic: boolean;
    isSigned: boolean;
    offset: number;
    bytes: number;
    align: number;
    ptr: ExpressionRef;
  }

export interface StoreInfo extends ExpressionInfo {
    isAtomic: boolean;
    offset: number;
    bytes: number;
    align: number;
    ptr: ExpressionRef;
    value: ExpressionRef;
  }

export interface ConstInfo extends ExpressionInfo {
    value: number | { low: number, high: number } | Array<number>;
  }

export interface UnaryInfo extends ExpressionInfo {
    op: Operations;
    value: ExpressionRef;
  }

export interface BinaryInfo extends ExpressionInfo {
    op: Operations;
    left: ExpressionRef;
    right: ExpressionRef;
  }

export interface SelectInfo extends ExpressionInfo {
    ifTrue: ExpressionRef;
    ifFalse: ExpressionRef;
    condition: ExpressionRef;
  }

export interface DropInfo extends ExpressionInfo {
    value: ExpressionRef;
  }

export interface ReturnInfo extends ExpressionInfo {
    value: ExpressionRef;
  }

export interface NopInfo extends ExpressionInfo {
  }

export interface UnreachableInfo extends ExpressionInfo {
  }

export interface PopInfo extends ExpressionInfo {
  }

export interface MemorySizeInfo extends ExpressionInfo {
  }

export interface MemoryGrowInfo extends ExpressionInfo {
    delta: ExpressionRef;
  }

export interface AtomicRMWInfo extends ExpressionInfo {
    op: Operations;
    bytes: number;
    offset: number;
    ptr: ExpressionRef;
    value: ExpressionRef;
  }

export interface AtomicCmpxchgInfo extends ExpressionInfo {
    bytes: number;
    offset: number;
    ptr: ExpressionRef;
    expected: ExpressionRef;
    replacement: ExpressionRef;
  }

export interface AtomicWaitInfo extends ExpressionInfo {
    ptr: ExpressionRef;
    expected: ExpressionRef;
    timeout: ExpressionRef;
    expectedType: Type;
  }

export interface AtomicNotifyInfo extends ExpressionInfo {
    ptr: ExpressionRef;
    notifyCount: ExpressionRef;
  }

export interface AtomicFenceInfo extends ExpressionInfo {
    order: number;
  }

export interface SIMDExtractInfo extends ExpressionInfo {
    op: Operations;
    vec: ExpressionRef;
    index: ExpressionRef;
  }

export interface SIMDReplaceInfo extends ExpressionInfo {
    op: Operations;
    vec: ExpressionRef;
    index: ExpressionRef;
    value: ExpressionRef;
  }

export interface SIMDShuffleInfo extends ExpressionInfo {
    left: ExpressionRef;
    right: ExpressionRef;
    mask: number[];
  }

export interface SIMDTernaryInfo extends ExpressionInfo {
    op: Operations;
    a: ExpressionRef;
    b: ExpressionRef;
    c: ExpressionRef;
  }

export interface SIMDShiftInfo extends ExpressionInfo {
    op: Operations;
    vec: ExpressionRef;
    shift: ExpressionRef;
  }

export interface SIMDLoadInfo extends ExpressionInfo {
    op: Operations;
    offset: number;
    align: number;
    ptr: ExpressionRef;
  }

export interface SIMDLoadStoreLaneInfo extends ExpressionInfo {
    op: Operations;
    offset: number;
    align: number;
    index: number;
    ptr: ExpressionRef;
    vec: ExpressionRef;
  }

export interface MemoryInitInfo extends ExpressionInfo {
    segment: string;
    dest: ExpressionRef;
    offset: ExpressionRef;
    size: ExpressionRef;
  }

export interface DataDropInfo extends ExpressionInfo {
    segment: string;
  }

export interface MemoryCopyInfo extends ExpressionInfo {
    dest: ExpressionRef;
    source: ExpressionRef;
    size: ExpressionRef;
  }

export interface MemoryFillInfo extends ExpressionInfo {
    dest: ExpressionRef;
    value: ExpressionRef;
    size: ExpressionRef;
  }

export interface RefNullInfo extends ExpressionInfo {
  }

export interface RefIsNullInfo extends ExpressionInfo {
    op: Operations;
    value: ExpressionRef;
  }

export interface RefAsInfo extends ExpressionInfo {
    op: Operations;
    value: ExpressionRef;
  }

export interface RefFuncInfo extends ExpressionInfo {
    func: string;
  }

export interface RefEqInfo extends ExpressionInfo {
    left: ExpressionRef;
    right: ExpressionRef;
  }

export interface TryInfo extends ExpressionInfo {
    name: string;
    body: ExpressionRef;
    catchTags: string[];
    catchBodies: ExpressionRef[];
    hasCatchAll: boolean;
    delegateTarget: string;
    isDelegate: boolean;
  }

export interface ThrowInfo extends ExpressionInfo {
    tag: string;
    operands: ExpressionRef[];
  }

export interface RethrowInfo extends ExpressionInfo {
    target: string;
  }

export interface TupleMakeInfo extends ExpressionInfo {
    operands: ExpressionRef[];
  }

export interface TupleExtractInfo extends ExpressionInfo {
    tuple: ExpressionRef;
    index: number;
  }

export interface RefI31Info extends ExpressionInfo {
    value: ExpressionRef;
  }

export interface I31GetInfo extends ExpressionInfo {
    i31: ExpressionRef;
    isSigned: boolean;
  }

function getExpressionInfo(expression: ExpressionRef) {
  const id = JSModule['_BinaryenExpressionGetId'](expression);
  const type = JSModule['_BinaryenExpressionGetType'](expression);
  switch (id) {
  case JSModule['BlockId']:
      return {
      'id': id,
      'type': type,
      'name': UTF8ToString(JSModule['_BinaryenBlockGetName'](expression)),
      'children': getAllNested<ExpressionRef>(expression, JSModule['_BinaryenBlockGetNumChildren'], JSModule['_BinaryenBlockGetChildAt'])
      } as BlockInfo;
  case JSModule['IfId']:
      return {
      'id': id,
      'type': type,
      'condition': JSModule['_BinaryenIfGetCondition'](expression),
      'ifTrue': JSModule['_BinaryenIfGetIfTrue'](expression),
      'ifFalse': JSModule['_BinaryenIfGetIfFalse'](expression)
      } as IfInfo;
  case JSModule['LoopId']:
      return {
      'id': id,
      'type': type,
      'name': UTF8ToString(JSModule['_BinaryenLoopGetName'](expression)),
      'body': JSModule['_BinaryenLoopGetBody'](expression)
      } as LoopInfo;
  case JSModule['BreakId']:
      return {
      'id': id,
      'type': type,
      'name': UTF8ToString(JSModule['_BinaryenBreakGetName'](expression)),
      'condition': JSModule['_BinaryenBreakGetCondition'](expression),
      'value': JSModule['_BinaryenBreakGetValue'](expression)
      } as BreakInfo;
  case JSModule['SwitchId']:
      return {
      'id': id,
      'type': type,
      // Do not pass the index as the second parameter to UTF8ToString as that will cut off the string.
      'names': getAllNested<ExpressionRef>(expression, JSModule['_BinaryenSwitchGetNumNames'], JSModule['_BinaryenSwitchGetNameAt']).map(p => UTF8ToString(p)),
      'defaultName': UTF8ToString(JSModule['_BinaryenSwitchGetDefaultName'](expression)),
      'condition': JSModule['_BinaryenSwitchGetCondition'](expression),
      'value': JSModule['_BinaryenSwitchGetValue'](expression)
      } as SwitchInfo;
  case JSModule['CallId']:
      return {
      'id': id,
      'type': type,
      'isReturn': Boolean(JSModule['_BinaryenCallIsReturn'](expression)),
      'target': UTF8ToString(JSModule['_BinaryenCallGetTarget'](expression)),
      'operands': getAllNested<ExpressionRef>(expression, JSModule[ '_BinaryenCallGetNumOperands'], JSModule['_BinaryenCallGetOperandAt'])
      } as CallInfo;
  case JSModule['CallIndirectId']:
      return {
      'id': id,
      'type': type,
      'isReturn': Boolean(JSModule['_BinaryenCallIndirectIsReturn'](expression)),
      'target': JSModule['_BinaryenCallIndirectGetTarget'](expression),
      'table': JSModule['_BinaryenCallIndirectGetTable'](expression),
      'operands': getAllNested<ExpressionRef>(expression, JSModule['_BinaryenCallIndirectGetNumOperands'], JSModule['_BinaryenCallIndirectGetOperandAt'])
      } as CallIndirectInfo;
  case JSModule['LocalGetId']:
      return {
      'id': id,
      'type': type,
      'index': JSModule['_BinaryenLocalGetGetIndex'](expression)
      } as LocalGetInfo;
  case JSModule['LocalSetId']:
      return {
      'id': id,
      'type': type,
      'isTee': Boolean(JSModule['_BinaryenLocalSetIsTee'](expression)),
      'index': JSModule['_BinaryenLocalSetGetIndex'](expression),
      'value': JSModule['_BinaryenLocalSetGetValue'](expression)
      } as LocalSetInfo;
  case JSModule['GlobalGetId']:
      return {
      'id': id,
      'type': type,
      'name': UTF8ToString(JSModule['_BinaryenGlobalGetGetName'](expression))
      } as GlobalGetInfo;
  case JSModule['GlobalSetId']:
      return {
      'id': id,
      'type': type,
      'name': UTF8ToString(JSModule['_BinaryenGlobalSetGetName'](expression)),
      'value': JSModule['_BinaryenGlobalSetGetValue'](expression)
      } as GlobalSetInfo;
  case JSModule['TableGetId']:
      return {
      'id': id,
      'type': type,
      'table': UTF8ToString(JSModule['_BinaryenTableGetGetTable'](expression)),
      'index': JSModule['_BinaryenTableGetGetIndex'](expression)
      } as TableGetInfo;
  case JSModule['TableSetId']:
      return {
      'id': id,
      'type': type,
      'table': UTF8ToString(JSModule['_BinaryenTableSetGetTable'](expression)),
      'index': JSModule['_BinaryenTableSetGetIndex'](expression),
      'value': JSModule['_BinaryenTableSetGetValue'](expression)
      } as TableSetInfo;
  case JSModule['TableSizeId']:
      return {
      'id': id,
      'type': type,
      'table': UTF8ToString(JSModule['_BinaryenTableSizeGetTable'](expression)),
      } as TableSizeInfo;
  case JSModule['TableGrowId']:
      return {
      'id': id,
      'type': type,
      'table': UTF8ToString(JSModule['_BinaryenTableGrowGetTable'](expression)),
      'value': JSModule['_BinaryenTableGrowGetValue'](expression),
      'delta': JSModule['_BinaryenTableGrowGetDelta'](expression),
      } as TableGrowInfo;
  case JSModule['LoadId']:
      return {
      'id': id,
      'type': type,
      'isAtomic': Boolean(JSModule['_BinaryenLoadIsAtomic'](expression)),
      'isSigned': Boolean(JSModule['_BinaryenLoadIsSigned'](expression)),
      'offset': JSModule['_BinaryenLoadGetOffset'](expression),
      'bytes': JSModule['_BinaryenLoadGetBytes'](expression),
      'align': JSModule['_BinaryenLoadGetAlign'](expression),
      'ptr': JSModule['_BinaryenLoadGetPtr'](expression)
      } as LoadInfo;
  case JSModule['StoreId']:
      return {
      'id': id,
      'type': type,
      'isAtomic': Boolean(JSModule['_BinaryenStoreIsAtomic'](expression)),
      'offset': JSModule['_BinaryenStoreGetOffset'](expression),
      'bytes': JSModule['_BinaryenStoreGetBytes'](expression),
      'align': JSModule['_BinaryenStoreGetAlign'](expression),
      'ptr': JSModule['_BinaryenStoreGetPtr'](expression),
      'value': JSModule['_BinaryenStoreGetValue'](expression)
      } as StoreInfo;
  case JSModule['ConstId']: {
      let value;
      switch (type) {
      case i32:
          value = JSModule['_BinaryenConstGetValueI32'](expression);
          break;
      case i64:
          value = {
          'low':  JSModule['_BinaryenConstGetValueI64Low'](expression),
          'high': JSModule['_BinaryenConstGetValueI64High'](expression)
          };
          break;
      case f32:
          value = JSModule['_BinaryenConstGetValueF32'](expression);
          break;
      case f64:
          value = JSModule['_BinaryenConstGetValueF64'](expression);
          break;
      case v128: {
          preserveStack(() => {
                  const tempBuffer = stackAlloc(16);
                  JSModule['_BinaryenConstGetValueV128'](expression, tempBuffer);
                  value = new Array(16);
                  for (let i = 0; i < 16; i++) {
                    value[i] = HEAPU8[tempBuffer + i];
                  }
              });
          }
          break;
      default:
          throw new Error('unexpected type: ' + type);
      }
      return {
      'id': id,
      'type': type,
      'value': value
      } as ConstInfo;
  }
  case JSModule['UnaryId']:
      return {
      'id': id,
      'type': type,
      'op': JSModule['_BinaryenUnaryGetOp'](expression),
      'value': JSModule['_BinaryenUnaryGetValue'](expression)
      } as UnaryInfo;
  case JSModule['BinaryId']:
      return {
      'id': id,
      'type': type,
      'op': JSModule['_BinaryenBinaryGetOp'](expression),
      'left': JSModule['_BinaryenBinaryGetLeft'](expression),
      'right':  JSModule['_BinaryenBinaryGetRight'](expression)
      } as BinaryInfo;
  case JSModule['SelectId']:
      return {
      'id': id,
      'type': type,
      'ifTrue': JSModule['_BinaryenSelectGetIfTrue'](expression),
      'ifFalse': JSModule['_BinaryenSelectGetIfFalse'](expression),
      'condition': JSModule['_BinaryenSelectGetCondition'](expression)
      } as SelectInfo;
  case JSModule['DropId']:
      return {
      'id': id,
      'type': type,
      'value': JSModule['_BinaryenDropGetValue'](expression)
      } as DropInfo;
  case JSModule['ReturnId']:
      return {
      'id': id,
      'type': type,
      'value': JSModule['_BinaryenReturnGetValue'](expression)
      } as ReturnInfo;
  case JSModule['NopId']:
      return {
      'id': id,
      'type': type
      } as NopInfo;
  case JSModule['UnreachableId']:
      return {
      'id': id,
      'type': type
      } as UnreachableInfo;
  case JSModule['PopId']:
      return {
      'id': id,
      'type': type
      } as PopInfo;
  case JSModule['MemorySizeId']:
      return {
      'id': id,
      'type': type
      } as MemorySizeInfo;
  case JSModule['MemoryGrowId']:
      return {
      'id': id,
      'type': type,
      'delta': JSModule['_BinaryenMemoryGrowGetDelta'](expression)
      } as MemoryGrowInfo;
  case JSModule['AtomicRMWId']:
      return {
      'id': id,
      'type': type,
      'op': JSModule['_BinaryenAtomicRMWGetOp'](expression),
      'bytes': JSModule['_BinaryenAtomicRMWGetBytes'](expression),
      'offset': JSModule['_BinaryenAtomicRMWGetOffset'](expression),
      'ptr': JSModule['_BinaryenAtomicRMWGetPtr'](expression),
      'value': JSModule['_BinaryenAtomicRMWGetValue'](expression)
      } as AtomicRMWInfo;
  case JSModule['AtomicCmpxchgId']:
      return {
      'id': id,
      'type': type,
      'bytes': JSModule['_BinaryenAtomicCmpxchgGetBytes'](expression),
      'offset': JSModule['_BinaryenAtomicCmpxchgGetOffset'](expression),
      'ptr': JSModule['_BinaryenAtomicCmpxchgGetPtr'](expression),
      'expected': JSModule['_BinaryenAtomicCmpxchgGetExpected'](expression),
      'replacement': JSModule['_BinaryenAtomicCmpxchgGetReplacement'](expression)
      } as AtomicCmpxchgInfo;
  case JSModule['AtomicWaitId']:
      return {
      'id': id,
      'type': type,
      'ptr': JSModule['_BinaryenAtomicWaitGetPtr'](expression),
      'expected': JSModule['_BinaryenAtomicWaitGetExpected'](expression),
      'timeout': JSModule['_BinaryenAtomicWaitGetTimeout'](expression),
      'expectedType': JSModule['_BinaryenAtomicWaitGetExpectedType'](expression)
      } as AtomicWaitInfo;
  case JSModule['AtomicNotifyId']:
      return {
      'id': id,
      'type': type,
      'ptr': JSModule['_BinaryenAtomicNotifyGetPtr'](expression),
      'notifyCount': JSModule['_BinaryenAtomicNotifyGetNotifyCount'](expression)
      } as AtomicNotifyInfo;
  case JSModule['AtomicFenceId']:
      return {
      'id': id,
      'type': type,
      'order': JSModule['_BinaryenAtomicFenceGetOrder'](expression)
      } as AtomicFenceInfo;
  case JSModule['SIMDExtractId']:
      return {
      'id': id,
      'type': type,
      'op': JSModule['_BinaryenSIMDExtractGetOp'](expression),
      'vec': JSModule['_BinaryenSIMDExtractGetVec'](expression),
      'index': JSModule['_BinaryenSIMDExtractGetIndex'](expression)
      } as SIMDExtractInfo;
  case JSModule['SIMDReplaceId']:
      return {
      'id': id,
      'type': type,
      'op': JSModule['_BinaryenSIMDReplaceGetOp'](expression),
      'vec': JSModule['_BinaryenSIMDReplaceGetVec'](expression),
      'index': JSModule['_BinaryenSIMDReplaceGetIndex'](expression),
      'value': JSModule['_BinaryenSIMDReplaceGetValue'](expression)
      } as SIMDReplaceInfo;
  case JSModule['SIMDShuffleId']:
      return preserveStack(() => {
          const tempBuffer = stackAlloc(16);
          JSModule['_BinaryenSIMDShuffleGetMask'](expression, tempBuffer);
          const mask = new Array(16);
          for (let i = 0; i < 16; i++) {
              mask[i] = HEAPU8[tempBuffer + i];
          }
          return {
          'id': id,
          'type': type,
          'left': JSModule['_BinaryenSIMDShuffleGetLeft'](expression),
          'right': JSModule['_BinaryenSIMDShuffleGetRight'](expression),
          'mask': mask
          } as SIMDShuffleInfo;
      });
  case JSModule['SIMDTernaryId']:
      return {
      'id': id,
      'type': type,
      'op': JSModule['_BinaryenSIMDTernaryGetOp'](expression),
      'a': JSModule['_BinaryenSIMDTernaryGetA'](expression),
      'b': JSModule['_BinaryenSIMDTernaryGetB'](expression),
      'c': JSModule['_BinaryenSIMDTernaryGetC'](expression)
      } as SIMDTernaryInfo;
  case JSModule['SIMDShiftId']:
      return {
      'id': id,
      'type': type,
      'op': JSModule['_BinaryenSIMDShiftGetOp'](expression),
      'vec': JSModule['_BinaryenSIMDShiftGetVec'](expression),
      'shift': JSModule['_BinaryenSIMDShiftGetShift'](expression)
      } as SIMDShiftInfo;
  case JSModule['SIMDLoadId']:
      return {
      'id': id,
      'type': type,
      'op': JSModule['_BinaryenSIMDLoadGetOp'](expression),
      'offset': JSModule['_BinaryenSIMDLoadGetOffset'](expression),
      'align': JSModule['_BinaryenSIMDLoadGetAlign'](expression),
      'ptr': JSModule['_BinaryenSIMDLoadGetPtr'](expression)
      } as SIMDLoadInfo;
  case JSModule['SIMDLoadStoreLaneId']:
      return {
      'id': id,
      'type': type,
      'op': JSModule['_BinaryenSIMDLoadStoreLaneGetOp'](expression),
      'offset': JSModule['_BinaryenSIMDLoadStoreLaneGetOffset'](expression),
      'align': JSModule['_BinaryenSIMDLoadStoreLaneGetAlign'](expression),
      'index': JSModule['_BinaryenSIMDLoadStoreLaneGetIndex'](expression),
      'ptr': JSModule['_BinaryenSIMDLoadStoreLaneGetPtr'](expression),
      'vec': JSModule['_BinaryenSIMDLoadStoreLaneGetVec'](expression)
      } as SIMDLoadStoreLaneInfo;
  case JSModule['MemoryInitId']:
      return {
      'id': id,
      'type': type,
      'segment': UTF8ToString(JSModule['_BinaryenMemoryInitGetSegment'](expression)),
      'dest': JSModule['_BinaryenMemoryInitGetDest'](expression),
      'offset': JSModule['_BinaryenMemoryInitGetOffset'](expression),
      'size': JSModule['_BinaryenMemoryInitGetSize'](expression)
      } as MemoryInitInfo;
  case JSModule['DataDropId']:
      return {
      'id': id,
      'type': type,
      'segment': UTF8ToString(JSModule['_BinaryenDataDropGetSegment'](expression)),
      } as DataDropInfo;
  case JSModule['MemoryCopyId']:
      return {
      'id': id,
      'type': type,
      'dest': JSModule['_BinaryenMemoryCopyGetDest'](expression),
      'source': JSModule['_BinaryenMemoryCopyGetSource'](expression),
      'size': JSModule['_BinaryenMemoryCopyGetSize'](expression)
      } as MemoryCopyInfo;
  case JSModule['MemoryFillId']:
      return {
      'id': id,
      'type': type,
      'dest': JSModule['_BinaryenMemoryFillGetDest'](expression),
      'value': JSModule['_BinaryenMemoryFillGetValue'](expression),
      'size': JSModule['_BinaryenMemoryFillGetSize'](expression)
      } as MemoryFillInfo;
  case JSModule['RefNullId']:
      return {
      'id': id,
      'type': type
      } as RefNullInfo;
  case JSModule['RefIsNullId']:
      return {
      'id': id,
      'type': type,
      'value': JSModule['_BinaryenRefIsNullGetValue'](expression)
      } as RefIsNullInfo;
  case JSModule['RefAsId']:
      return {
      'id': id,
      'type': type,
      'op': JSModule['_BinaryenRefAsGetOp'](expression),
      'value': JSModule['_BinaryenRefAsGetValue'](expression)
      } as RefAsInfo;
  case JSModule['RefFuncId']:
      return {
      'id': id,
      'type': type,
      'func': UTF8ToString(JSModule['_BinaryenRefFuncGetFunc'](expression)),
      } as RefFuncInfo;
  case JSModule['RefEqId']:
      return {
      'id': id,
      'type': type,
      'left': JSModule['_BinaryenRefEqGetLeft'](expression),
      'right': JSModule['_BinaryenRefEqGetRight'](expression)
      } as RefEqInfo;
  case JSModule['TryId']:
      return {
      'id': id,
      'type': type,
      'name': UTF8ToString(JSModule['_BinaryenTryGetName'](expression)),
      'body': JSModule['_BinaryenTryGetBody'](expression),
      'catchTags': getAllNested<string>(expression, JSModule['_BinaryenTryGetNumCatchTags'], JSModule['_BinaryenTryGetCatchTagAt']),
      'catchBodies': getAllNested<ExpressionRef>(expression, JSModule['_BinaryenTryGetNumCatchBodies'], JSModule['_BinaryenTryGetCatchBodyAt']),
      'hasCatchAll': JSModule['_BinaryenTryHasCatchAll'](expression) as boolean,
      'delegateTarget': UTF8ToString(JSModule['_BinaryenTryGetDelegateTarget'](expression)) as string,
      'isDelegate': JSModule['_BinaryenTryIsDelegate'](expression) as boolean
      } as TryInfo;
  case JSModule['ThrowId']:
      return {
      'id': id,
      'type': type,
      'tag': UTF8ToString(JSModule['_BinaryenThrowGetTag'](expression)),
      'operands': getAllNested(expression, JSModule['_BinaryenThrowGetNumOperands'], JSModule['_BinaryenThrowGetOperandAt'])
      } as ThrowInfo;
  case JSModule['RethrowId']:
      return {
      'id': id,
      'type': type,
      'target': UTF8ToString(JSModule['_BinaryenRethrowGetTarget'](expression))
      } as RethrowInfo;
  case JSModule['TupleMakeId']:
      return {
      'id': id,
      'type': type,
      'operands': getAllNested(expression, JSModule['_BinaryenTupleMakeGetNumOperands'], JSModule['_BinaryenTupleMakeGetOperandAt'])
      } as TupleMakeInfo;
  case JSModule['TupleExtractId']:
      return {
      'id': id,
      'type': type,
      'tuple': JSModule['_BinaryenTupleExtractGetTuple'](expression),
      'index': JSModule['_BinaryenTupleExtractGetIndex'](expression)
      } as TupleExtractInfo;
  case JSModule['RefI31Id']:
      return {
      'id': id,
      'type': type,
      'value': JSModule['_BinaryenRefI31GetValue'](expression)
      } as RefI31Info;
  case JSModule['I31GetId']:
      return {
      'id': id,
      'type': type,
      'i31': JSModule['_BinaryenI31GetGetI31'](expression),
      'isSigned': Boolean(JSModule['_BinaryenI31GetIsSigned'](expression))
      } as I31GetInfo;
  default:
      throw Error('unexpected id: ' + id);
  }
}
