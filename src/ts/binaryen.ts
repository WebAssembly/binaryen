// export friendly API methods

module binaryen {

    declare var HEAP32: Int32Array;
    declare var HEAPU32: Uint32Array;
    declare var stackSave: () => number;
    declare var stackAlloc: (size: number) => number;
    declare var stackRestore: (ref: number) => void;
    declare var allocateUTF8OnStack: (s: string) => number;
    declare var _BinaryenSizeofLiteral: () => number;
    const sizeOfLiteral = _BinaryenSizeofLiteral();
    // avoid name clash with binaryen class Module
    const JSModule = self["Module"] as {};

    function preserveStack<R>(func: () => R): R {
      try {
        var stack = stackSave();
        return func();
      } finally {
        stackRestore(stack);
      }
    }

    function strToStack(str) {
      return str ? allocateUTF8OnStack(str) : 0;
    }

    function i32sToStack(i32s: number[]): number {
      const ret = stackAlloc(i32s.length << 2);
      HEAP32.set(i32s, ret >>> 2);
      return ret;
    }
    /*
    function i8sToStack(i8s) {
      const ret = stackAlloc(i8s.length);
      HEAP8.set(i8s, ret);
      return ret;
    }
    */

    export type Type = number;
    export type ElementSegmentRef = number;
    export type ExpressionRef = number;
    export type FunctionRef = number;
    export type GlobalRef = number;
    export type ExportRef = number;
    export type TableRef = number;
    export type TagRef = number;
    export type RelooperBlockRef = number;


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

    export class Module {

        readonly ptr: number;

        constructor() {
            this.ptr = JSModule['_BinaryenModuleCreate']();
        }
        block(label: string | null, children: ExpressionRef[], resultType?: Type): ExpressionRef {
            return preserveStack(() => JSModule['_BinaryenBlock'](
                this.ptr, label ?  strToStack(label) : 0,
                i32sToStack(children),
                children.length,
                typeof resultType !== 'undefined' ? resultType : binaryen.none));
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
        get local () {
            return {
                get: (index: number, type: Type) => JSModule['_BinaryenLocalGet'](this.ptr, index, type) as ExpressionRef,
                set: (index: number, value: ExpressionRef) => JSModule['_BinaryenLocalSet'](this.ptr, index, value) as ExpressionRef,
                tee: (index: number, value: ExpressionRef, type: Type) => {
                    if (typeof type === 'undefined') {
                        throw new Error("local.tee's type should be defined");
                    }
                    return JSModule['_BinaryenLocalTee'](this.ptr, index, value, type) as ExpressionRef;
                }
            };
        }
        get global () {
            return {
                get: (name: string, type: Type) => JSModule['_BinaryenLocalGet'](this.ptr, strToStack(name), type) as ExpressionRef,
                set: (name: string, value: ExpressionRef) => JSModule['_BinaryenGlobalSet'](this.ptr, strToStack(name), value) as ExpressionRef
            };
        }
        get table () {
            return {
                get: (name: string, index: ExpressionRef, type: Type) => JSModule['_BinaryenTableGet'](this.ptr, strToStack(name), index, type) as ExpressionRef,
                set: (name: string, index: ExpressionRef, value: ExpressionRef) => JSModule['_BinaryenTableSet'](this.ptr, strToStack(name), index, value) as ExpressionRef,
                size: (name: string) => JSModule['_BinaryenTableSize'](this.ptr, strToStack(name)) as ExpressionRef,
                grow: (name: string, value: ExpressionRef, delta: ExpressionRef) => JSModule['_BinaryenTableGrow'](this.ptr, strToStack(name), value, delta) as ExpressionRef
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
        get memory () {
            return {
                size: (name?: string, memory64?: boolean) => JSModule['_BinaryenMemorySize'](this.ptr, strToStack(name), memory64) as ExpressionRef,
                grow: (value: ExpressionRef, name?: string, memory64?: boolean) => JSModule['_BinaryenMemoryGrow'](this.ptr, value, strToStack(name), memory64) as ExpressionRef,
                init: (segment: number, dest: ExpressionRef, offset: ExpressionRef, size: ExpressionRef, name?: string) =>
                    preserveStack(() => JSModule['_BinaryenMemoryInit'](this.ptr, strToStack(segment), dest, offset, size, strToStack(name))) as ExpressionRef,
                copy: (dest: ExpressionRef, source: ExpressionRef, size: ExpressionRef, destName?: string, sourceName?: string) =>
                    JSModule['_BinaryenMemoryCopy'](this.ptr, dest, source, size, strToStack(destName), strToStack(sourceName)) as ExpressionRef,
                fill: (dest: ExpressionRef, value: ExpressionRef, size: ExpressionRef, name?: string) =>
                    JSModule['_BinaryenMemoryFill'](this.ptr, dest, value, size, strToStack(name)) as ExpressionRef,
                atomic: {
                    notify: (ptr: ExpressionRef, notifyCount: ExpressionRef, name?: string) =>
                        JSModule['_BinaryenAtomicNotify'](this.ptr, ptr, notifyCount, strToStack(name)) as ExpressionRef,
                    wait32: (ptr: ExpressionRef, expected: ExpressionRef, timeout: ExpressionRef, name?: string) =>
                        JSModule['_BinaryenAtomicWait'](this.ptr, ptr, expected, timeout, Module['i32'], strToStack(name)) as ExpressionRef,
                    wait64: (ptr: ExpressionRef, expected: ExpressionRef, timeout: ExpressionRef, name?: string) =>
                        JSModule['_BinaryenAtomicWait'](this.ptr, ptr, expected, timeout, Module['i64'], strToStack(name)) as ExpressionRef
                }
            };
        }
        get data () {
            return {
                drop: (segment: number) => preserveStack(() => JSModule['_BinaryenDataDrop'](this.ptr, strToStack(segment))) as ExpressionRef
            };
        };
        get i32 () {
            const unary = (op: Operations, value: ExpressionRef) =>
                JSModule['_BinaryenUnary'](this.ptr, op, value) as ExpressionRef;
            const binary = (op: Operations, left: ExpressionRef, right: ExpressionRef) =>
                JSModule['_BinaryenBinary'](this.ptr, op, left, right) as ExpressionRef;
            const load = (size: number, signed: boolean, offset: number, align: number, ptr: ExpressionRef, name: string) =>
                JSModule['_BinaryenLoad'](this.ptr, size, signed, offset, align, i32, ptr, strToStack(name)) as ExpressionRef;
            const store = (size: number, offset: number, align: number, ptr: ExpressionRef, value: ExpressionRef, name: string) =>
                JSModule['_BinaryenStore'](this.ptr, size, offset, align, ptr, value, i32, strToStack(name)) as ExpressionRef;
            const atomic_load = (size: number, offset: number, ptr: ExpressionRef, name: string) =>
                JSModule['_BinaryenAtomicLoad'](this.ptr, size, offset, i32, ptr, strToStack(name)) as ExpressionRef;
            const atomic_store = (size: number, offset: number, ptr: ExpressionRef, value: ExpressionRef, name: string) =>
                JSModule['_BinaryenAtomicStore'](this.ptr, size, offset, ptr, value, i32, strToStack(name)) as ExpressionRef;
            const atomic_rmw = (op: Operations, size: number, offset: number, ptr: ExpressionRef, value: ExpressionRef, name: string) =>
                JSModule['_BinaryenAtomicRMW'](this.ptr, op, size, offset, ptr, value, i32, strToStack(name)) as ExpressionRef;
            return {
                load: (offset: number, align: number, ptr: ExpressionRef, name?: string) => load(4, true, offset, align, ptr, name) as ExpressionRef,
                load8_s: (offset: number, align: number, ptr: ExpressionRef, name?: string) => load(1, true, offset, align, ptr, name) as ExpressionRef,
                load8_u: (offset: number, align: number, ptr: ExpressionRef, name?: string) => load(1, false, offset, align, ptr, name) as ExpressionRef,
                load16_s: (offset: number, align: number, ptr: ExpressionRef, name?: string) => load(2, true, offset, align, ptr, name) as ExpressionRef,
                load16_u: (offset: number, align: number, ptr: ExpressionRef, name?: string) => load(2, false, offset, align, ptr, name) as ExpressionRef,
                store: (offset: number, align: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) => store(4, offset, align, ptr, value, name) as ExpressionRef,
                store8: (offset: number, align: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) => store(1, offset, align, ptr, value, name) as ExpressionRef,
                store16: (offset: number, align: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) => store(2, offset, align, ptr, value, name) as ExpressionRef,
                const: (value: number) => preserveStack(() => {
                                                  const tempLiteral = stackAlloc(sizeOfLiteral);
                                                  JSModule['_BinaryenLiteralInt32'](tempLiteral, value);
                                                  return JSModule['_BinaryenConst'](this.ptr, tempLiteral);
                                                }),
                clz: (value: ExpressionRef) => unary(Operations.ClzInt32, value),
                ctz: (value: ExpressionRef) => unary(Operations.CtzInt32, value),
                popcnt: (value: ExpressionRef) => unary(Operations.PopcntInt32, value),
                eqz: (value: ExpressionRef) => unary(Operations.EqZInt32, value),
                trunc_s: {
                    f32: (value: ExpressionRef) => unary(Operations.TruncSFloat32ToInt32, value),
                    f64: (value: ExpressionRef) => unary(Operations.TruncSFloat64ToInt32, value)
                },
                trunc_u: {
                    f32: (value: ExpressionRef) => unary(Operations.TruncUFloat32ToInt32, value),
                    f64: (value: ExpressionRef) => unary(Operations.TruncUFloat64ToInt32, value)
                },
                trunc_s_sat: {
                    f32: (value: ExpressionRef) => unary(Operations.TruncSatSFloat32ToInt32, value),
                    f64: (value: ExpressionRef) => unary(Operations.TruncSatSFloat64ToInt32, value)
                },
                trunc_u_sat: {
                    f32: (value: ExpressionRef) => unary(Operations.TruncSatUFloat32ToInt32, value),
                    f64: (value: ExpressionRef) => unary(Operations.TruncSatUFloat64ToInt32, value)
                },
                reinterpret_f32: (value: ExpressionRef) => unary(Operations.ReinterpretFloat32, value),
                extend8_s: (value: ExpressionRef) => unary(Operations.ExtendS8Int32, value),
                extend16_s: (value: ExpressionRef) => unary(Operations.ExtendS16Int32, value),
                wrap_i64: (value: ExpressionRef) => unary(Operations.WrapInt64, value),
                add: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.AddInt32, left, right),
                sub: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.SubInt32, left, right),
                mul: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.MulInt32, left, right),
                div_s: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.DivSInt32, left, right),
                div_u: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.DivUInt32, left, right),
                rem_s: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.RemSInt32, left, right),
                rem_u: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.RemUInt32, left, right),
                and: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.AndInt32, left, right),
                or: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.OrInt32, left, right),
                xor: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.XorInt32, left, right),
                shl: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.ShlInt32, left, right),
                shr_u: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.ShrUInt32, left, right),
                shr_s: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.ShrSInt32, left, right),
                rotl: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.RotLInt32, left, right),
                rotr: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.RotRInt32, left, right),
                eq: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.EqInt32, left, right),
                ne: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.NeInt32, left, right),
                lt_s: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.LtSInt32, left, right),
                lt_u: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.LtUInt32, left, right),
                le_s: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.LeSInt32, left, right),
                le_u: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.LeUInt32, left, right),
                gt_s: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.GtSInt32, left, right),
                gt_u: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.GtUInt32, left, right),
                ge_s: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.GeSInt32, left, right),
                ge_u: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.GeUInt32, left, right),
                pop: () => JSModule['_BinaryenPop'](this.ptr, i32) as ExpressionRef,
                atomic: {
                    load: (offset: number, ptr: ExpressionRef, name?: string) => atomic_load(4, offset, ptr, name),
                    load8_u: (offset: number, ptr: ExpressionRef, name?: string) => atomic_load(1, offset, ptr, name),
                    load16_u: (offset: number, ptr: ExpressionRef, name?: string) => atomic_load(2, offset, ptr, name),
                    store: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) => atomic_store(4, offset, ptr, value, name),
                    store8: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) => atomic_store(1, offset, ptr, value, name),
                    store16: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) => atomic_store(2, offset, ptr, value, name),
                    rmw: {
                        add: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWAdd, 4, offset, ptr, value, name),
                        sub: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWSub, 4, offset, ptr, value, name),
                        and: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWAnd, 4, offset, ptr, value, name),
                        or: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWOr, 4, offset, ptr, value, name),
                        xor: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWXor, 4, offset, ptr, value, name),
                        xchg: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWXchg, 4, offset, ptr, value, name),
                        cmpxchg: (offset: number, ptr: ExpressionRef, expected: ExpressionRef, replacement: ExpressionRef, name?: string) =>
                            JSModule['_BinaryenAtomicCmpxchg'](this.ptr, 4, offset, ptr, expected, replacement, i32, strToStack(name)) as ExpressionRef
                    },
                    rmw8_u: {
                        add: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWAdd, 1, offset, ptr, value, name),
                        sub: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWSub, 1, offset, ptr, value, name),
                        and: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWAnd, 1, offset, ptr, value, name),
                        or: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWOr, 1, offset, ptr, value, name),
                        xor: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWXor, 1, offset, ptr, value, name),
                        xchg: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWXchg, 1, offset, ptr, value, name),
                        cmpxchg: (offset: number, ptr: ExpressionRef, expected: ExpressionRef, replacement: ExpressionRef, name?: string) =>
                            JSModule['_BinaryenAtomicCmpxchg'](this.ptr, 1, offset, ptr, expected, replacement, i32, strToStack(name)) as ExpressionRef
                    },
                    rmw16_u: {
                        add: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWAdd, 2, offset, ptr, value, name),
                        sub: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWSub, 2, offset, ptr, value, name),
                        and: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWAnd, 2, offset, ptr, value, name),
                        or: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWOr, 2, offset, ptr, value, name),
                        xor: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWXor, 2, offset, ptr, value, name),
                        xchg: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWXchg, 2, offset, ptr, value, name),
                        cmpxchg: (offset: number, ptr: ExpressionRef, expected: ExpressionRef, replacement: ExpressionRef, name?: string) =>
                            JSModule['_BinaryenAtomicCmpxchg'](this.ptr, 2, offset, ptr, expected, replacement, i32, strToStack(name)) as ExpressionRef
                    }
                }
            };
        }
        get i64 () {
            const unary = (op: Operations, value: ExpressionRef) =>
                JSModule['_BinaryenUnary'](this.ptr, op, value) as ExpressionRef;
            const binary = (op: Operations, left: ExpressionRef, right: ExpressionRef) =>
                JSModule['_BinaryenBinary'](this.ptr, op, left, right) as ExpressionRef;
            const load = (size: number, signed: boolean, offset: number, align: number, ptr: ExpressionRef, name: string) =>
                JSModule['_BinaryenLoad'](this.ptr, size, signed, offset, align, i64, ptr, strToStack(name)) as ExpressionRef;
            const store = (size: number, offset: number, align: number, ptr: ExpressionRef, value: ExpressionRef, name: string) =>
                JSModule['_BinaryenStore'](this.ptr, size, offset, align, ptr, value, i64, strToStack(name)) as ExpressionRef;
            const atomic_load = (size: number, offset: number, ptr: ExpressionRef, name: string) =>
                JSModule['_BinaryenAtomicLoad'](this.ptr, size, offset, i64, ptr, strToStack(name)) as ExpressionRef;
            const atomic_store = (size: number, offset: number, ptr: ExpressionRef, value: ExpressionRef, name: string) =>
                JSModule['_BinaryenAtomicStore'](this.ptr, size, offset, ptr, value, i64, strToStack(name)) as ExpressionRef;
            const atomic_rmw = (op: Operations, size: number, offset: number, ptr: ExpressionRef, value: ExpressionRef, name: string) =>
                JSModule['_BinaryenAtomicRMW'](this.ptr, op, size, offset, ptr, value, i64, strToStack(name)) as ExpressionRef;
            return {
                load: (offset: number, align: number, ptr: ExpressionRef, name?: string) => load(8, true, offset, align, ptr, name) as ExpressionRef,
                load8_s: (offset: number, align: number, ptr: ExpressionRef, name?: string) => load(1, true, offset, align, ptr, name) as ExpressionRef,
                load8_u: (offset: number, align: number, ptr: ExpressionRef, name?: string) => load(1, false, offset, align, ptr, name) as ExpressionRef,
                load16_s: (offset: number, align: number, ptr: ExpressionRef, name?: string) => load(2, true, offset, align, ptr, name) as ExpressionRef,
                load16_u: (offset: number, align: number, ptr: ExpressionRef, name?: string) => load(2, false, offset, align, ptr, name) as ExpressionRef,
                load32_s: (offset: number, align: number, ptr: ExpressionRef, name?: string) => load(4, true, offset, align, ptr, name) as ExpressionRef,
                load32_u: (offset: number, align: number, ptr: ExpressionRef, name?: string) => load(4, false, offset, align, ptr, name) as ExpressionRef,
                store: (offset: number, align: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) => store(4, offset, align, ptr, value, name) as ExpressionRef,
                store8: (offset: number, align: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) => store(1, offset, align, ptr, value, name) as ExpressionRef,
                store16: (offset: number, align: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) => store(2, offset, align, ptr, value, name) as ExpressionRef,
                store32: (offset: number, align: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) => store(4, offset, align, ptr, value, name) as ExpressionRef,
                const: (low: number, high: number) => preserveStack(() => {
                                                  const tempLiteral = stackAlloc(sizeOfLiteral);
                                                  JSModule['_BinaryenLiteralInt64'](tempLiteral, low, high);
                                                  return JSModule['_BinaryenConst'](this.ptr, tempLiteral);
                                                }),
                clz: (value: ExpressionRef) => unary(Operations.ClzInt64, value),
                ctz: (value: ExpressionRef) => unary(Operations.CtzInt64, value),
                popcnt: (value: ExpressionRef) => unary(Operations.PopcntInt64, value),
                eqz: (value: ExpressionRef) => unary(Operations.EqZInt64, value),
                trunc_s: {
                    f32: (value: ExpressionRef) => unary(Operations.TruncSFloat32ToInt64, value),
                    f64: (value: ExpressionRef) => unary(Operations.TruncSFloat64ToInt64, value)
                },
                trunc_u: {
                    f32: (value: ExpressionRef) => unary(Operations.TruncUFloat32ToInt64, value),
                    f64: (value: ExpressionRef) => unary(Operations.TruncUFloat64ToInt64, value)
                },
                trunc_s_sat: {
                    f32: (value: ExpressionRef) => unary(Operations.TruncSatSFloat32ToInt64, value),
                    f64: (value: ExpressionRef) => unary(Operations.TruncSatSFloat64ToInt64, value)
                },
                trunc_u_sat: {
                    f32: (value: ExpressionRef) => unary(Operations.TruncSatUFloat32ToInt64, value),
                    f64: (value: ExpressionRef) => unary(Operations.TruncSatUFloat64ToInt64, value)
                },
                reinterpret_f64: (value: ExpressionRef) => unary(Operations.ReinterpretFloat64, value),
                extend8_s: (value: ExpressionRef) => unary(Operations.ExtendS8Int64, value),
                extend16_s: (value: ExpressionRef) => unary(Operations.ExtendS16Int64, value),
                extend32_s: (value: ExpressionRef) => unary(Operations.ExtendS32Int64, value),
                extend_s: (value: ExpressionRef) => unary(Operations.ExtendSInt32, value),
                extend_u: (value: ExpressionRef) => unary(Operations.ExtendUInt32, value),
                add: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.AddInt64, left, right),
                sub: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.SubInt64, left, right),
                mul: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.MulInt32, left, right),
                div_s: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.DivSInt64, left, right),
                div_u: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.DivUInt64, left, right),
                rem_s: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.RemSInt64, left, right),
                rem_u: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.RemUInt64, left, right),
                and: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.AndInt64, left, right),
                or: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.OrInt64, left, right),
                xor: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.XorInt64, left, right),
                shl: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.ShlInt64, left, right),
                shr_u: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.ShrUInt64, left, right),
                shr_s: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.ShrSInt64, left, right),
                rotl: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.RotLInt64, left, right),
                rotr: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.RotRInt64, left, right),
                eq: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.EqInt64, left, right),
                ne: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.NeInt64, left, right),
                lt_s: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.LtSInt64, left, right),
                lt_u: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.LtUInt64, left, right),
                le_s: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.LeSInt64, left, right),
                le_u: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.LeUInt64, left, right),
                gt_s: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.GtSInt64, left, right),
                gt_u: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.GtUInt64, left, right),
                ge_s: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.GeSInt64, left, right),
                ge_u: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.GeUInt64, left, right),
                pop: () => JSModule['_BinaryenPop'](this.ptr, i64) as ExpressionRef,
                atomic: {
                    load: (offset: number, ptr: ExpressionRef, name?: string) => atomic_load(8, offset, ptr, name),
                    load8_u: (offset: number, ptr: ExpressionRef, name?: string) => atomic_load(1, offset, ptr, name),
                    load16_u: (offset: number, ptr: ExpressionRef, name?: string) => atomic_load(2, offset, ptr, name),
                    load32_u: (offset: number, ptr: ExpressionRef, name?: string) => atomic_load(4, offset, ptr, name),
                    store: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) => atomic_store(4, offset, ptr, value, name),
                    store8: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) => atomic_store(1, offset, ptr, value, name),
                    store16: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) => atomic_store(2, offset, ptr, value, name),
                    store32: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) => atomic_store(4, offset, ptr, value, name),
                    rmw: {
                        add: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWAdd, 8, offset, ptr, value, name),
                        sub: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWSub, 8, offset, ptr, value, name),
                        and: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWAnd, 8, offset, ptr, value, name),
                        or: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWOr, 8, offset, ptr, value, name),
                        xor: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWXor, 8, offset, ptr, value, name),
                        xchg: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWXchg, 8, offset, ptr, value, name),
                        cmpxchg: (offset: number, ptr: ExpressionRef, expected: ExpressionRef, replacement: ExpressionRef, name?: string) =>
                            JSModule['_BinaryenAtomicCmpxchg'](this.ptr, 8, offset, ptr, expected, replacement, i64, strToStack(name)) as ExpressionRef
                    },
                    rmw8_u: {
                        add: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWAdd, 1, offset, ptr, value, name),
                        sub: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWSub, 1, offset, ptr, value, name),
                        and: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWAnd, 1, offset, ptr, value, name),
                        or: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWOr, 1, offset, ptr, value, name),
                        xor: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWXor, 1, offset, ptr, value, name),
                        xchg: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWXchg, 1, offset, ptr, value, name),
                        cmpxchg: (offset: number, ptr: ExpressionRef, expected: ExpressionRef, replacement: ExpressionRef, name?: string) =>
                            JSModule['_BinaryenAtomicCmpxchg'](this.ptr, 1, offset, ptr, expected, replacement, i64, strToStack(name)) as ExpressionRef
                    },
                    rmw16_u: {
                        add: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWAdd, 2, offset, ptr, value, name),
                        sub: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWSub, 2, offset, ptr, value, name),
                        and: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWAnd, 2, offset, ptr, value, name),
                        or: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWOr, 2, offset, ptr, value, name),
                        xor: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWXor, 2, offset, ptr, value, name),
                        xchg: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWXchg, 2, offset, ptr, value, name),
                        cmpxchg: (offset: number, ptr: ExpressionRef, expected: ExpressionRef, replacement: ExpressionRef, name?: string) =>
                            JSModule['_BinaryenAtomicCmpxchg'](this.ptr, 2, offset, ptr, expected, replacement, i32, strToStack(name)) as ExpressionRef
                    },
                    rmw32_u: {
                        add: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWAdd, 4, offset, ptr, value, name),
                        sub: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWSub, 4, offset, ptr, value, name),
                        and: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWAnd, 4, offset, ptr, value, name),
                        or: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWOr, 4, offset, ptr, value, name),
                        xor: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWXor, 4, offset, ptr, value, name),
                        xchg: (offset: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                            atomic_rmw(Operations.AtomicRMWXchg, 4, offset, ptr, value, name),
                        cmpxchg: (offset: number, ptr: ExpressionRef, expected: ExpressionRef, replacement: ExpressionRef, name?: string) =>
                            JSModule['_BinaryenAtomicCmpxchg'](this.ptr, 4, offset, ptr, expected, replacement, i32, strToStack(name)) as ExpressionRef
                    }
                }
            };
        }
        get f32 () {
            const unary = (op: Operations, value: ExpressionRef) =>
                JSModule['_BinaryenUnary'](this.ptr, op, value) as ExpressionRef;
            const binary = (op: Operations, left: ExpressionRef, right: ExpressionRef) =>
                JSModule['_BinaryenBinary'](this.ptr, op, left, right) as ExpressionRef;
            return {
                load: (offset: number, align: number, ptr: ExpressionRef, name?: string) =>
                    Module['_BinaryenLoad'](this.ptr, 4, true, offset, align, f32, ptr, strToStack(name)) as ExpressionRef,
                store: (offset: number, align: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                    Module['_BinaryenStore'](this.ptr, 4, offset, align, ptr, value, f32, strToStack(name)) as ExpressionRef,
                const: (value: number) =>
                    preserveStack(() => {
                            const tempLiteral = stackAlloc(sizeOfLiteral);
                            Module['_BinaryenLiteralFloat32'](tempLiteral, value);
                            return Module['_BinaryenConst'](this.ptr, tempLiteral);
                          }) as ExpressionRef,
                const_bits: (value: number) =>
                    preserveStack(() => {
                            const tempLiteral = stackAlloc(sizeOfLiteral);
                            Module['_BinaryenLiteralFloat32Bits'](tempLiteral, value);
                            return Module['_BinaryenConst'](this.ptr, tempLiteral);
                          }) as ExpressionRef,
                neg: (value: ExpressionRef) => unary(Operations.NegFloat32, value),
                abs: (value: ExpressionRef) => unary(Operations.AbsFloat32, value),
                ceil: (value: ExpressionRef) => unary(Operations.CeilFloat32, value),
                floor: (value: ExpressionRef) => unary(Operations.FloorFloat32, value),
                trunc: (value: ExpressionRef) => unary(Operations.TruncFloat32, value),
                nearest: (value: ExpressionRef) => unary(Operations.NearestFloat32, value),
                sqrt: (value: ExpressionRef) => unary(Operations.SqrtFloat32, value),
                reinterpret_i32: (value: ExpressionRef) => unary(Operations.ReinterpretInt32, value),
                convert_s: {
                    i32: (value: ExpressionRef) => unary(Operations.ConvertSInt32ToFloat32, value),
                    i64: (value: ExpressionRef) => unary(Operations.ConvertSInt64ToFloat32, value)
                },
                convert_u: {
                    i32: (value: ExpressionRef) => unary(Operations.ConvertUInt32ToFloat32, value),
                    i64: (value: ExpressionRef) => unary(Operations.ConvertUInt64ToFloat32, value)
                },
                demote_f64: (value: ExpressionRef)=> unary(Operations.DemoteFloat64, value),
                add: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.AddFloat32, left, right),
                sub: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.SubFloat32, left, right),
                mul: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.MulFloat32, left, right),
                div: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.DivFloat32, left, right),
                copysign: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.CopySignFloat32, left, right),
                min: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.MinFloat32, left, right),
                max: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.MaxFloat32, left, right),
                eq: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.EqFloat32, left, right),
                ne: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.NeFloat32, left, right),
                lt: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.LtFloat32, left, right),
                le: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.LeFloat32, left, right),
                gt: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.GtFloat32, left, right),
                ge: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.GeFloat32, left, right),
                pop: () => JSModule['_BinaryenPop'](this.ptr, f32) as ExpressionRef
            };
        }
        get f64 () {
            const unary = (op: Operations, value: ExpressionRef) =>
                JSModule['_BinaryenUnary'](this.ptr, op, value) as ExpressionRef;
            const binary = (op: Operations, left: ExpressionRef, right: ExpressionRef) =>
                JSModule['_BinaryenBinary'](this.ptr, op, left, right) as ExpressionRef;
            return {
                load: (offset: number, align: number, ptr: ExpressionRef, name?: string) =>
                    Module['_BinaryenLoad'](this.ptr, 8, true, offset, align, f64, ptr, strToStack(name)) as ExpressionRef,
                store: (offset: number, align: number, ptr: ExpressionRef, value: ExpressionRef, name?: string) =>
                    Module['_BinaryenStore'](this.ptr, 8, offset, align, ptr, value, f64, strToStack(name)) as ExpressionRef,
                const: (value: number) =>
                    preserveStack(() => {
                            const tempLiteral = stackAlloc(sizeOfLiteral);
                            Module['_BinaryenLiteralFloat64'](tempLiteral, value);
                            return Module['_BinaryenConst'](this.ptr, tempLiteral);
                          }) as ExpressionRef,
                const_bits: (value: number) =>
                    preserveStack(() => {
                            const tempLiteral = stackAlloc(sizeOfLiteral);
                            Module['_BinaryenLiteralFloat64Bits'](tempLiteral, value);
                            return Module['_BinaryenConst'](this.ptr, tempLiteral);
                          }) as ExpressionRef,
                neg: (value: ExpressionRef) => unary(Operations.NegFloat64, value),
                abs: (value: ExpressionRef) => unary(Operations.AbsFloat64, value),
                ceil: (value: ExpressionRef) => unary(Operations.CeilFloat64, value),
                floor: (value: ExpressionRef) => unary(Operations.FloorFloat64, value),
                trunc: (value: ExpressionRef) => unary(Operations.TruncFloat64, value),
                nearest: (value: ExpressionRef) => unary(Operations.NearestFloat64, value),
                sqrt: (value: ExpressionRef) => unary(Operations.SqrtFloat64, value),
                reinterpret_i64: (value: ExpressionRef) => unary(Operations.ReinterpretInt64, value),
                convert_s: {
                    i32: (value: ExpressionRef) => unary(Operations.ConvertSInt32ToFloat64, value),
                    i64: (value: ExpressionRef) => unary(Operations.ConvertSInt64ToFloat64, value)
                },
                convert_u: {
                    i32: (value: ExpressionRef) => unary(Operations.ConvertUInt32ToFloat64, value),
                    i64: (value: ExpressionRef) => unary(Operations.ConvertUInt64ToFloat64, value)
                },
                promote_f32: (value: ExpressionRef)=> unary(Operations.PromoteFloat32, value),
                add: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.AddFloat64, left, right),
                sub: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.SubFloat64, left, right),
                mul: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.MulFloat64, left, right),
                div: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.DivFloat64, left, right),
                copysign: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.CopySignFloat64, left, right),
                min: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.MinFloat64, left, right),
                max: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.MaxFloat64, left, right),
                eq: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.EqFloat64, left, right),
                ne: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.NeFloat64, left, right),
                lt: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.LtFloat64, left, right),
                le: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.LeFloat64, left, right),
                gt: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.GtFloat64, left, right),
                ge: (left: ExpressionRef, right: ExpressionRef) => binary(Operations.GeFloat64, left, right),
                pop: () => JSModule['_BinaryenPop'](this.ptr, f64) as ExpressionRef
            };
        }
    }
}


