// export friendly API methods
function preserveStack(func) {
  try {
    var stack = stackSave();
    return func();
  } finally {
    stackRestore(stack);
  }
}

function strToStack(str) {
  if (!str) return 0;
  return allocate(intArrayFromString(str), 'i8', ALLOC_STACK);
}

function i32sToStack(i32s) {
  var ret = stackAlloc(i32s.length << 2);
  for (var i = 0; i < i32s.length; i++) {
    HEAP32[ret + (i << 2) >> 2] = i32s[i];
  }
  return ret;
}

function i8sToStack(i8s) {
  var ret = stackAlloc(i8s.length);
  for (var i = 0; i < i8s.length; i++) {
    HEAP8[ret + i] = i8s[i];
  }
  return ret;
}

// Types
Module['none'] = Module['_BinaryenTypeNone']();
Module['i32'] = Module['_BinaryenTypeInt32']();
Module['i64'] = Module['_BinaryenTypeInt64']();
Module['f32'] = Module['_BinaryenTypeFloat32']();
Module['f64'] = Module['_BinaryenTypeFloat64']();
Module['v128'] = Module['_BinaryenTypeVec128']();
Module['anyref'] = Module['_BinaryenTypeAnyref']();
Module['exnref'] = Module['_BinaryenTypeExnref']();
Module['unreachable'] = Module['_BinaryenTypeUnreachable']();
Module['auto'] = /* deprecated */ Module['undefined'] = Module['_BinaryenTypeAuto']();

Module['createType'] = function(types) {
  return preserveStack(function() {
    var array = i32sToStack(types);
    return Module['_BinaryenTypeCreate'](array, types.length);
  });
};

Module['expandType'] = function(ty) {
  return preserveStack(function() {
    var numTypes = Module['_BinaryenTypeArity'](ty);
    var array = stackAlloc(numTypes << 2);
    Module['_BinaryenTypeExpand'](ty, array);
    var types = [];
    for (var i = 0; i < numTypes; i++) {
      types.push(HEAPU32[(array >>> 2) + i]);
    }
    return types;
  });
};

// Expression ids
Module['InvalidId'] = Module['_BinaryenInvalidId']();
Module['BlockId'] = Module['_BinaryenBlockId']();
Module['IfId'] = Module['_BinaryenIfId']();
Module['LoopId'] = Module['_BinaryenLoopId']();
Module['BreakId'] = Module['_BinaryenBreakId']();
Module['SwitchId'] = Module['_BinaryenSwitchId']();
Module['CallId'] = Module['_BinaryenCallId']();
Module['CallIndirectId'] = Module['_BinaryenCallIndirectId']();
Module['LocalGetId'] = Module['_BinaryenLocalGetId']();
Module['LocalSetId'] = Module['_BinaryenLocalSetId']();
Module['GlobalGetId'] = Module['_BinaryenGlobalGetId']();
Module['GlobalSetId'] = Module['_BinaryenGlobalSetId']();
Module['LoadId'] = Module['_BinaryenLoadId']();
Module['StoreId'] = Module['_BinaryenStoreId']();
Module['ConstId'] = Module['_BinaryenConstId']();
Module['UnaryId'] = Module['_BinaryenUnaryId']();
Module['BinaryId'] = Module['_BinaryenBinaryId']();
Module['SelectId'] = Module['_BinaryenSelectId']();
Module['DropId'] = Module['_BinaryenDropId']();
Module['ReturnId'] = Module['_BinaryenReturnId']();
Module['HostId'] = Module['_BinaryenHostId']();
Module['NopId'] = Module['_BinaryenNopId']();
Module['UnreachableId'] = Module['_BinaryenUnreachableId']();
Module['AtomicCmpxchgId'] = Module['_BinaryenAtomicCmpxchgId']();
Module['AtomicRMWId'] = Module['_BinaryenAtomicRMWId']();
Module['AtomicWaitId'] = Module['_BinaryenAtomicWaitId']();
Module['AtomicNotifyId'] = Module['_BinaryenAtomicNotifyId']();
Module['AtomicFenceId'] = Module['_BinaryenAtomicFenceId']();
Module['SIMDExtractId'] = Module['_BinaryenSIMDExtractId']();
Module['SIMDReplaceId'] = Module['_BinaryenSIMDReplaceId']();
Module['SIMDShuffleId'] = Module['_BinaryenSIMDShuffleId']();
Module['SIMDTernaryId'] = Module['_BinaryenSIMDTernaryId']();
Module['SIMDShiftId'] = Module['_BinaryenSIMDShiftId']();
Module['SIMDLoadId'] = Module['_BinaryenSIMDLoadId']();
Module['MemoryInitId'] = Module['_BinaryenMemoryInitId']();
Module['DataDropId'] = Module['_BinaryenDataDropId']();
Module['MemoryCopyId'] = Module['_BinaryenMemoryCopyId']();
Module['MemoryFillId'] = Module['_BinaryenMemoryFillId']();
Module['TryId'] = Module['_BinaryenTryId']();
Module['ThrowId'] = Module['_BinaryenThrowId']();
Module['RethrowId'] = Module['_BinaryenRethrowId']();
Module['BrOnExnId'] = Module['_BinaryenBrOnExnId']();
Module['PushId'] = Module['_BinaryenPushId']();
Module['PopId'] = Module['_BinaryenPopId']();

// External kinds
Module['ExternalFunction'] = Module['_BinaryenExternalFunction']();
Module['ExternalTable'] = Module['_BinaryenExternalTable']();
Module['ExternalMemory'] = Module['_BinaryenExternalMemory']();
Module['ExternalGlobal'] = Module['_BinaryenExternalGlobal']();
Module['ExternalEvent'] = Module['_BinaryenExternalEvent']();

// Features
Module['Features'] = {
  'MVP': Module['_BinaryenFeatureMVP'](),
  'Atomics': Module['_BinaryenFeatureAtomics'](),
  'BulkMemory': Module['_BinaryenFeatureBulkMemory'](),
  'MutableGlobals': Module['_BinaryenFeatureMutableGlobals'](),
  'NontrappingFPToInt': Module['_BinaryenFeatureNontrappingFPToInt'](),
  'SignExt': Module['_BinaryenFeatureSignExt'](),
  'SIMD128': Module['_BinaryenFeatureSIMD128'](),
  'ExceptionHandling': Module['_BinaryenFeatureExceptionHandling'](),
  'TailCall': Module['_BinaryenFeatureTailCall'](),
  'ReferenceTypes': Module['_BinaryenFeatureReferenceTypes'](),
  'All': Module['_BinaryenFeatureAll']()
};

// Operations
Module['ClzInt32'] = Module['_BinaryenClzInt32']();
Module['CtzInt32'] = Module['_BinaryenCtzInt32']();
Module['PopcntInt32'] = Module['_BinaryenPopcntInt32']();
Module['NegFloat32'] = Module['_BinaryenNegFloat32']();
Module['AbsFloat32'] = Module['_BinaryenAbsFloat32']();
Module['CeilFloat32'] = Module['_BinaryenCeilFloat32']();
Module['FloorFloat32'] = Module['_BinaryenFloorFloat32']();
Module['TruncFloat32'] = Module['_BinaryenTruncFloat32']();
Module['NearestFloat32'] = Module['_BinaryenNearestFloat32']();
Module['SqrtFloat32'] = Module['_BinaryenSqrtFloat32']();
Module['EqZInt32'] = Module['_BinaryenEqZInt32']();
Module['ClzInt64'] = Module['_BinaryenClzInt64']();
Module['CtzInt64'] = Module['_BinaryenCtzInt64']();
Module['PopcntInt64'] = Module['_BinaryenPopcntInt64']();
Module['NegFloat64'] = Module['_BinaryenNegFloat64']();
Module['AbsFloat64'] = Module['_BinaryenAbsFloat64']();
Module['CeilFloat64'] = Module['_BinaryenCeilFloat64']();
Module['FloorFloat64'] = Module['_BinaryenFloorFloat64']();
Module['TruncFloat64'] = Module['_BinaryenTruncFloat64']();
Module['NearestFloat64'] = Module['_BinaryenNearestFloat64']();
Module['SqrtFloat64'] = Module['_BinaryenSqrtFloat64']();
Module['EqZInt64'] = Module['_BinaryenEqZInt64']();
Module['ExtendSInt32'] = Module['_BinaryenExtendSInt32']();
Module['ExtendUInt32'] = Module['_BinaryenExtendUInt32']();
Module['WrapInt64'] = Module['_BinaryenWrapInt64']();
Module['TruncSFloat32ToInt32'] = Module['_BinaryenTruncSFloat32ToInt32']();
Module['TruncSFloat32ToInt64'] = Module['_BinaryenTruncSFloat32ToInt64']();
Module['TruncUFloat32ToInt32'] = Module['_BinaryenTruncUFloat32ToInt32']();
Module['TruncUFloat32ToInt64'] = Module['_BinaryenTruncUFloat32ToInt64']();
Module['TruncSFloat64ToInt32'] = Module['_BinaryenTruncSFloat64ToInt32']();
Module['TruncSFloat64ToInt64'] = Module['_BinaryenTruncSFloat64ToInt64']();
Module['TruncUFloat64ToInt32'] = Module['_BinaryenTruncUFloat64ToInt32']();
Module['TruncUFloat64ToInt64'] = Module['_BinaryenTruncUFloat64ToInt64']();
Module['TruncSatSFloat32ToInt32'] = Module['_BinaryenTruncSatSFloat32ToInt32']();
Module['TruncSatSFloat32ToInt64'] = Module['_BinaryenTruncSatSFloat32ToInt64']();
Module['TruncSatUFloat32ToInt32'] = Module['_BinaryenTruncSatUFloat32ToInt32']();
Module['TruncSatUFloat32ToInt64'] = Module['_BinaryenTruncSatUFloat32ToInt64']();
Module['TruncSatSFloat64ToInt32'] = Module['_BinaryenTruncSatSFloat64ToInt32']();
Module['TruncSatSFloat64ToInt64'] = Module['_BinaryenTruncSatSFloat64ToInt64']();
Module['TruncSatUFloat64ToInt32'] = Module['_BinaryenTruncSatUFloat64ToInt32']();
Module['TruncSatUFloat64ToInt64'] = Module['_BinaryenTruncSatUFloat64ToInt64']();
Module['ReinterpretFloat32'] = Module['_BinaryenReinterpretFloat32']();
Module['ReinterpretFloat64'] = Module['_BinaryenReinterpretFloat64']();
Module['ConvertSInt32ToFloat32'] = Module['_BinaryenConvertSInt32ToFloat32']();
Module['ConvertSInt32ToFloat64'] = Module['_BinaryenConvertSInt32ToFloat64']();
Module['ConvertUInt32ToFloat32'] = Module['_BinaryenConvertUInt32ToFloat32']();
Module['ConvertUInt32ToFloat64'] = Module['_BinaryenConvertUInt32ToFloat64']();
Module['ConvertSInt64ToFloat32'] = Module['_BinaryenConvertSInt64ToFloat32']();
Module['ConvertSInt64ToFloat64'] = Module['_BinaryenConvertSInt64ToFloat64']();
Module['ConvertUInt64ToFloat32'] = Module['_BinaryenConvertUInt64ToFloat32']();
Module['ConvertUInt64ToFloat64'] = Module['_BinaryenConvertUInt64ToFloat64']();
Module['PromoteFloat32'] = Module['_BinaryenPromoteFloat32']();
Module['DemoteFloat64'] = Module['_BinaryenDemoteFloat64']();
Module['ReinterpretInt32'] = Module['_BinaryenReinterpretInt32']();
Module['ReinterpretInt64'] = Module['_BinaryenReinterpretInt64']();
Module['ExtendS8Int32'] = Module['_BinaryenExtendS8Int32']();
Module['ExtendS16Int32'] = Module['_BinaryenExtendS16Int32']();
Module['ExtendS8Int64'] = Module['_BinaryenExtendS8Int64']();
Module['ExtendS16Int64'] = Module['_BinaryenExtendS16Int64']();
Module['ExtendS32Int64'] = Module['_BinaryenExtendS32Int64']();
Module['AddInt32'] = Module['_BinaryenAddInt32']();
Module['SubInt32'] = Module['_BinaryenSubInt32']();
Module['MulInt32'] = Module['_BinaryenMulInt32']();
Module['DivSInt32'] = Module['_BinaryenDivSInt32']();
Module['DivUInt32'] = Module['_BinaryenDivUInt32']();
Module['RemSInt32'] = Module['_BinaryenRemSInt32']();
Module['RemUInt32'] = Module['_BinaryenRemUInt32']();
Module['AndInt32'] = Module['_BinaryenAndInt32']();
Module['OrInt32'] = Module['_BinaryenOrInt32']();
Module['XorInt32'] = Module['_BinaryenXorInt32']();
Module['ShlInt32'] = Module['_BinaryenShlInt32']();
Module['ShrUInt32'] = Module['_BinaryenShrUInt32']();
Module['ShrSInt32'] = Module['_BinaryenShrSInt32']();
Module['RotLInt32'] = Module['_BinaryenRotLInt32']();
Module['RotRInt32'] = Module['_BinaryenRotRInt32']();
Module['EqInt32'] = Module['_BinaryenEqInt32']();
Module['NeInt32'] = Module['_BinaryenNeInt32']();
Module['LtSInt32'] = Module['_BinaryenLtSInt32']();
Module['LtUInt32'] = Module['_BinaryenLtUInt32']();
Module['LeSInt32'] = Module['_BinaryenLeSInt32']();
Module['LeUInt32'] = Module['_BinaryenLeUInt32']();
Module['GtSInt32'] = Module['_BinaryenGtSInt32']();
Module['GtUInt32'] = Module['_BinaryenGtUInt32']();
Module['GeSInt32'] = Module['_BinaryenGeSInt32']();
Module['GeUInt32'] = Module['_BinaryenGeUInt32']();
Module['AddInt64'] = Module['_BinaryenAddInt64']();
Module['SubInt64'] = Module['_BinaryenSubInt64']();
Module['MulInt64'] = Module['_BinaryenMulInt64']();
Module['DivSInt64'] = Module['_BinaryenDivSInt64']();
Module['DivUInt64'] = Module['_BinaryenDivUInt64']();
Module['RemSInt64'] = Module['_BinaryenRemSInt64']();
Module['RemUInt64'] = Module['_BinaryenRemUInt64']();
Module['AndInt64'] = Module['_BinaryenAndInt64']();
Module['OrInt64'] = Module['_BinaryenOrInt64']();
Module['XorInt64'] = Module['_BinaryenXorInt64']();
Module['ShlInt64'] = Module['_BinaryenShlInt64']();
Module['ShrUInt64'] = Module['_BinaryenShrUInt64']();
Module['ShrSInt64'] = Module['_BinaryenShrSInt64']();
Module['RotLInt64'] = Module['_BinaryenRotLInt64']();
Module['RotRInt64'] = Module['_BinaryenRotRInt64']();
Module['EqInt64'] = Module['_BinaryenEqInt64']();
Module['NeInt64'] = Module['_BinaryenNeInt64']();
Module['LtSInt64'] = Module['_BinaryenLtSInt64']();
Module['LtUInt64'] = Module['_BinaryenLtUInt64']();
Module['LeSInt64'] = Module['_BinaryenLeSInt64']();
Module['LeUInt64'] = Module['_BinaryenLeUInt64']();
Module['GtSInt64'] = Module['_BinaryenGtSInt64']();
Module['GtUInt64'] = Module['_BinaryenGtUInt64']();
Module['GeSInt64'] = Module['_BinaryenGeSInt64']();
Module['GeUInt64'] = Module['_BinaryenGeUInt64']();
Module['AddFloat32'] = Module['_BinaryenAddFloat32']();
Module['SubFloat32'] = Module['_BinaryenSubFloat32']();
Module['MulFloat32'] = Module['_BinaryenMulFloat32']();
Module['DivFloat32'] = Module['_BinaryenDivFloat32']();
Module['CopySignFloat32'] = Module['_BinaryenCopySignFloat32']();
Module['MinFloat32'] = Module['_BinaryenMinFloat32']();
Module['MaxFloat32'] = Module['_BinaryenMaxFloat32']();
Module['EqFloat32'] = Module['_BinaryenEqFloat32']();
Module['NeFloat32'] = Module['_BinaryenNeFloat32']();
Module['LtFloat32'] = Module['_BinaryenLtFloat32']();
Module['LeFloat32'] = Module['_BinaryenLeFloat32']();
Module['GtFloat32'] = Module['_BinaryenGtFloat32']();
Module['GeFloat32'] = Module['_BinaryenGeFloat32']();
Module['AddFloat64'] = Module['_BinaryenAddFloat64']();
Module['SubFloat64'] = Module['_BinaryenSubFloat64']();
Module['MulFloat64'] = Module['_BinaryenMulFloat64']();
Module['DivFloat64'] = Module['_BinaryenDivFloat64']();
Module['CopySignFloat64'] = Module['_BinaryenCopySignFloat64']();
Module['MinFloat64'] = Module['_BinaryenMinFloat64']();
Module['MaxFloat64'] = Module['_BinaryenMaxFloat64']();
Module['EqFloat64'] = Module['_BinaryenEqFloat64']();
Module['NeFloat64'] = Module['_BinaryenNeFloat64']();
Module['LtFloat64'] = Module['_BinaryenLtFloat64']();
Module['LeFloat64'] = Module['_BinaryenLeFloat64']();
Module['GtFloat64'] = Module['_BinaryenGtFloat64']();
Module['GeFloat64'] = Module['_BinaryenGeFloat64']();
Module['MemorySize'] = Module['_BinaryenMemorySize']();
Module['MemoryGrow'] = Module['_BinaryenMemoryGrow']();
Module['AtomicRMWAdd'] = Module['_BinaryenAtomicRMWAdd']();
Module['AtomicRMWSub'] = Module['_BinaryenAtomicRMWSub']();
Module['AtomicRMWAnd'] = Module['_BinaryenAtomicRMWAnd']();
Module['AtomicRMWOr'] = Module['_BinaryenAtomicRMWOr']();
Module['AtomicRMWXor'] = Module['_BinaryenAtomicRMWXor']();
Module['AtomicRMWXchg'] = Module['_BinaryenAtomicRMWXchg']();
Module['SplatVecI8x16'] = Module['_BinaryenSplatVecI8x16']();
Module['ExtractLaneSVecI8x16'] = Module['_BinaryenExtractLaneSVecI8x16']();
Module['ExtractLaneUVecI8x16'] = Module['_BinaryenExtractLaneUVecI8x16']();
Module['ReplaceLaneVecI8x16'] = Module['_BinaryenReplaceLaneVecI8x16']();
Module['SplatVecI16x8'] = Module['_BinaryenSplatVecI16x8']();
Module['ExtractLaneSVecI16x8'] = Module['_BinaryenExtractLaneSVecI16x8']();
Module['ExtractLaneUVecI16x8'] = Module['_BinaryenExtractLaneUVecI16x8']();
Module['ReplaceLaneVecI16x8'] = Module['_BinaryenReplaceLaneVecI16x8']();
Module['SplatVecI32x4'] = Module['_BinaryenSplatVecI32x4']();
Module['ExtractLaneVecI32x4'] = Module['_BinaryenExtractLaneVecI32x4']();
Module['ReplaceLaneVecI32x4'] = Module['_BinaryenReplaceLaneVecI32x4']();
Module['SplatVecI64x2'] = Module['_BinaryenSplatVecI64x2']();
Module['ExtractLaneVecI64x2'] = Module['_BinaryenExtractLaneVecI64x2']();
Module['ReplaceLaneVecI64x2'] = Module['_BinaryenReplaceLaneVecI64x2']();
Module['SplatVecF32x4'] = Module['_BinaryenSplatVecF32x4']();
Module['ExtractLaneVecF32x4'] = Module['_BinaryenExtractLaneVecF32x4']();
Module['ReplaceLaneVecF32x4'] = Module['_BinaryenReplaceLaneVecF32x4']();
Module['SplatVecF64x2'] = Module['_BinaryenSplatVecF64x2']();
Module['ExtractLaneVecF64x2'] = Module['_BinaryenExtractLaneVecF64x2']();
Module['ReplaceLaneVecF64x2'] = Module['_BinaryenReplaceLaneVecF64x2']();
Module['EqVecI8x16'] = Module['_BinaryenEqVecI8x16']();
Module['NeVecI8x16'] = Module['_BinaryenNeVecI8x16']();
Module['LtSVecI8x16'] = Module['_BinaryenLtSVecI8x16']();
Module['LtUVecI8x16'] = Module['_BinaryenLtUVecI8x16']();
Module['GtSVecI8x16'] = Module['_BinaryenGtSVecI8x16']();
Module['GtUVecI8x16'] = Module['_BinaryenGtUVecI8x16']();
Module['LeSVecI8x16'] = Module['_BinaryenLeSVecI8x16']();
Module['LeUVecI8x16'] = Module['_BinaryenLeUVecI8x16']();
Module['GeSVecI8x16'] = Module['_BinaryenGeSVecI8x16']();
Module['GeUVecI8x16'] = Module['_BinaryenGeUVecI8x16']();
Module['EqVecI16x8'] = Module['_BinaryenEqVecI16x8']();
Module['NeVecI16x8'] = Module['_BinaryenNeVecI16x8']();
Module['LtSVecI16x8'] = Module['_BinaryenLtSVecI16x8']();
Module['LtUVecI16x8'] = Module['_BinaryenLtUVecI16x8']();
Module['GtSVecI16x8'] = Module['_BinaryenGtSVecI16x8']();
Module['GtUVecI16x8'] = Module['_BinaryenGtUVecI16x8']();
Module['LeSVecI16x8'] = Module['_BinaryenLeSVecI16x8']();
Module['LeUVecI16x8'] = Module['_BinaryenLeUVecI16x8']();
Module['GeSVecI16x8'] = Module['_BinaryenGeSVecI16x8']();
Module['GeUVecI16x8'] = Module['_BinaryenGeUVecI16x8']();
Module['EqVecI32x4'] = Module['_BinaryenEqVecI32x4']();
Module['NeVecI32x4'] = Module['_BinaryenNeVecI32x4']();
Module['LtSVecI32x4'] = Module['_BinaryenLtSVecI32x4']();
Module['LtUVecI32x4'] = Module['_BinaryenLtUVecI32x4']();
Module['GtSVecI32x4'] = Module['_BinaryenGtSVecI32x4']();
Module['GtUVecI32x4'] = Module['_BinaryenGtUVecI32x4']();
Module['LeSVecI32x4'] = Module['_BinaryenLeSVecI32x4']();
Module['LeUVecI32x4'] = Module['_BinaryenLeUVecI32x4']();
Module['GeSVecI32x4'] = Module['_BinaryenGeSVecI32x4']();
Module['GeUVecI32x4'] = Module['_BinaryenGeUVecI32x4']();
Module['EqVecF32x4'] = Module['_BinaryenEqVecF32x4']();
Module['NeVecF32x4'] = Module['_BinaryenNeVecF32x4']();
Module['LtVecF32x4'] = Module['_BinaryenLtVecF32x4']();
Module['GtVecF32x4'] = Module['_BinaryenGtVecF32x4']();
Module['LeVecF32x4'] = Module['_BinaryenLeVecF32x4']();
Module['GeVecF32x4'] = Module['_BinaryenGeVecF32x4']();
Module['EqVecF64x2'] = Module['_BinaryenGeVecF32x4']();
Module['NeVecF64x2'] = Module['_BinaryenNeVecF64x2']();
Module['LtVecF64x2'] = Module['_BinaryenLtVecF64x2']();
Module['GtVecF64x2'] = Module['_BinaryenGtVecF64x2']();
Module['LeVecF64x2'] = Module['_BinaryenLeVecF64x2']();
Module['GeVecF64x2'] = Module['_BinaryenGeVecF64x2']();
Module['NotVec128'] = Module['_BinaryenNotVec128']();
Module['AndVec128'] = Module['_BinaryenAndVec128']();
Module['OrVec128'] = Module['_BinaryenOrVec128']();
Module['XorVec128'] = Module['_BinaryenXorVec128']();
Module['AndNotVec128'] = Module['_BinaryenAndNotVec128']();
Module['BitselectVec128'] = Module['_BinaryenBitselectVec128']();
Module['NegVecI8x16'] = Module['_BinaryenNegVecI8x16']();
Module['AnyTrueVecI8x16'] = Module['_BinaryenAnyTrueVecI8x16']();
Module['AllTrueVecI8x16'] = Module['_BinaryenAllTrueVecI8x16']();
Module['ShlVecI8x16'] = Module['_BinaryenShlVecI8x16']();
Module['ShrSVecI8x16'] = Module['_BinaryenShrSVecI8x16']();
Module['ShrUVecI8x16'] = Module['_BinaryenShrUVecI8x16']();
Module['AddVecI8x16'] = Module['_BinaryenAddVecI8x16']();
Module['AddSatSVecI8x16'] = Module['_BinaryenAddSatSVecI8x16']();
Module['AddSatUVecI8x16'] = Module['_BinaryenAddSatUVecI8x16']();
Module['SubVecI8x16'] = Module['_BinaryenSubVecI8x16']();
Module['SubSatSVecI8x16'] = Module['_BinaryenSubSatSVecI8x16']();
Module['SubSatUVecI8x16'] = Module['_BinaryenSubSatUVecI8x16']();
Module['MulVecI8x16'] = Module['_BinaryenMulVecI8x16']();
Module['MinSVecI8x16'] = Module['_BinaryenMinSVecI8x16']();
Module['MinUVecI8x16'] = Module['_BinaryenMinUVecI8x16']();
Module['MaxSVecI8x16'] = Module['_BinaryenMaxSVecI8x16']();
Module['MaxUVecI8x16'] = Module['_BinaryenMaxUVecI8x16']();
Module['NegVecI16x8'] = Module['_BinaryenNegVecI16x8']();
Module['AnyTrueVecI16x8'] = Module['_BinaryenAnyTrueVecI16x8']();
Module['AllTrueVecI16x8'] = Module['_BinaryenAllTrueVecI16x8']();
Module['ShlVecI16x8'] = Module['_BinaryenShlVecI16x8']();
Module['ShrSVecI16x8'] = Module['_BinaryenShrSVecI16x8']();
Module['ShrUVecI16x8'] = Module['_BinaryenShrUVecI16x8']();
Module['AddVecI16x8'] = Module['_BinaryenAddVecI16x8']();
Module['AddSatSVecI16x8'] = Module['_BinaryenAddSatSVecI16x8']();
Module['AddSatUVecI16x8'] = Module['_BinaryenAddSatUVecI16x8']();
Module['SubVecI16x8'] = Module['_BinaryenSubVecI16x8']();
Module['SubSatSVecI16x8'] = Module['_BinaryenSubSatSVecI16x8']();
Module['SubSatUVecI16x8'] = Module['_BinaryenSubSatUVecI16x8']();
Module['MulVecI16x8'] = Module['_BinaryenMulVecI16x8']();
Module['MinSVecI16x8'] = Module['_BinaryenMinSVecI16x8']();
Module['MinUVecI16x8'] = Module['_BinaryenMinUVecI16x8']();
Module['MaxSVecI16x8'] = Module['_BinaryenMaxSVecI16x8']();
Module['MaxUVecI16x8'] = Module['_BinaryenMaxUVecI16x8']();
Module['DotSVecI16x8ToVecI32x4'] = Module['_BinaryenDotSVecI16x8ToVecI32x4']();
Module['NegVecI32x4'] = Module['_BinaryenNegVecI32x4']();
Module['AnyTrueVecI32x4'] = Module['_BinaryenAnyTrueVecI32x4']();
Module['AllTrueVecI32x4'] = Module['_BinaryenAllTrueVecI32x4']();
Module['ShlVecI32x4'] = Module['_BinaryenShlVecI32x4']();
Module['ShrSVecI32x4'] = Module['_BinaryenShrSVecI32x4']();
Module['ShrUVecI32x4'] = Module['_BinaryenShrUVecI32x4']();
Module['AddVecI32x4'] = Module['_BinaryenAddVecI32x4']();
Module['SubVecI32x4'] = Module['_BinaryenSubVecI32x4']();
Module['MulVecI32x4'] = Module['_BinaryenMulVecI32x4']();
Module['MinSVecI32x4'] = Module['_BinaryenMinSVecI32x4']();
Module['MinUVecI32x4'] = Module['_BinaryenMinUVecI32x4']();
Module['MaxSVecI32x4'] = Module['_BinaryenMaxSVecI32x4']();
Module['MaxUVecI32x4'] = Module['_BinaryenMaxUVecI32x4']();
Module['NegVecI64x2'] = Module['_BinaryenNegVecI64x2']();
Module['AnyTrueVecI64x2'] = Module['_BinaryenAnyTrueVecI64x2']();
Module['AllTrueVecI64x2'] = Module['_BinaryenAllTrueVecI64x2']();
Module['ShlVecI64x2'] = Module['_BinaryenShlVecI64x2']();
Module['ShrSVecI64x2'] = Module['_BinaryenShrSVecI64x2']();
Module['ShrUVecI64x2'] = Module['_BinaryenShrUVecI64x2']();
Module['AddVecI64x2'] = Module['_BinaryenAddVecI64x2']();
Module['SubVecI64x2'] = Module['_BinaryenSubVecI64x2']();
Module['AbsVecF32x4'] = Module['_BinaryenAbsVecF32x4']();
Module['NegVecF32x4'] = Module['_BinaryenNegVecF32x4']();
Module['SqrtVecF32x4'] = Module['_BinaryenSqrtVecF32x4']();
Module['QFMAVecF32x4'] = Module['_BinaryenQFMAVecF32x4']();
Module['QFMSVecF32x4'] = Module['_BinaryenQFMSVecF32x4']();
Module['AddVecF32x4'] = Module['_BinaryenAddVecF32x4']();
Module['SubVecF32x4'] = Module['_BinaryenSubVecF32x4']();
Module['MulVecF32x4'] = Module['_BinaryenMulVecF32x4']();
Module['DivVecF32x4'] = Module['_BinaryenDivVecF32x4']();
Module['MinVecF32x4'] = Module['_BinaryenMinVecF32x4']();
Module['MaxVecF32x4'] = Module['_BinaryenMaxVecF32x4']();
Module['AbsVecF64x2'] = Module['_BinaryenAbsVecF64x2']();
Module['NegVecF64x2'] = Module['_BinaryenNegVecF64x2']();
Module['SqrtVecF64x2'] = Module['_BinaryenSqrtVecF64x2']();
Module['QFMAVecF64x2'] = Module['_BinaryenQFMAVecF64x2']();
Module['QFMSVecF64x2'] = Module['_BinaryenQFMSVecF64x2']();
Module['AddVecF64x2'] = Module['_BinaryenAddVecF64x2']();
Module['SubVecF64x2'] = Module['_BinaryenSubVecF64x2']();
Module['MulVecF64x2'] = Module['_BinaryenMulVecF64x2']();
Module['DivVecF64x2'] = Module['_BinaryenDivVecF64x2']();
Module['MinVecF64x2'] = Module['_BinaryenMinVecF64x2']();
Module['MaxVecF64x2'] = Module['_BinaryenMaxVecF64x2']();
Module['TruncSatSVecF32x4ToVecI32x4'] = Module['_BinaryenTruncSatSVecF32x4ToVecI32x4']();
Module['TruncSatUVecF32x4ToVecI32x4'] = Module['_BinaryenTruncSatUVecF32x4ToVecI32x4']();
Module['TruncSatSVecF64x2ToVecI64x2'] = Module['_BinaryenTruncSatSVecF64x2ToVecI64x2']();
Module['TruncSatUVecF64x2ToVecI64x2'] = Module['_BinaryenTruncSatUVecF64x2ToVecI64x2']();
Module['ConvertSVecI32x4ToVecF32x4'] = Module['_BinaryenConvertSVecI32x4ToVecF32x4']();
Module['ConvertUVecI32x4ToVecF32x4'] = Module['_BinaryenConvertUVecI32x4ToVecF32x4']();
Module['ConvertSVecI64x2ToVecF64x2'] = Module['_BinaryenConvertSVecI64x2ToVecF64x2']();
Module['ConvertUVecI64x2ToVecF64x2'] = Module['_BinaryenConvertUVecI64x2ToVecF64x2']();
Module['LoadSplatVec8x16'] = Module['_BinaryenLoadSplatVec8x16']();
Module['LoadSplatVec16x8'] = Module['_BinaryenLoadSplatVec16x8']();
Module['LoadSplatVec32x4'] = Module['_BinaryenLoadSplatVec32x4']();
Module['LoadSplatVec64x2'] = Module['_BinaryenLoadSplatVec64x2']();
Module['LoadExtSVec8x8ToVecI16x8'] = Module['_BinaryenLoadExtSVec8x8ToVecI16x8']();
Module['LoadExtUVec8x8ToVecI16x8'] = Module['_BinaryenLoadExtUVec8x8ToVecI16x8']();
Module['LoadExtSVec16x4ToVecI32x4'] = Module['_BinaryenLoadExtSVec16x4ToVecI32x4']();
Module['LoadExtUVec16x4ToVecI32x4'] = Module['_BinaryenLoadExtUVec16x4ToVecI32x4']();
Module['LoadExtSVec32x2ToVecI64x2'] = Module['_BinaryenLoadExtSVec32x2ToVecI64x2']();
Module['LoadExtUVec32x2ToVecI64x2'] = Module['_BinaryenLoadExtUVec32x2ToVecI64x2']();
Module['NarrowSVecI16x8ToVecI8x16'] = Module['_BinaryenNarrowSVecI16x8ToVecI8x16']();
Module['NarrowUVecI16x8ToVecI8x16'] = Module['_BinaryenNarrowUVecI16x8ToVecI8x16']();
Module['NarrowSVecI32x4ToVecI16x8'] = Module['_BinaryenNarrowSVecI32x4ToVecI16x8']();
Module['NarrowUVecI32x4ToVecI16x8'] = Module['_BinaryenNarrowUVecI32x4ToVecI16x8']();
Module['WidenLowSVecI8x16ToVecI16x8'] = Module['_BinaryenWidenLowSVecI8x16ToVecI16x8']();
Module['WidenHighSVecI8x16ToVecI16x8'] = Module['_BinaryenWidenHighSVecI8x16ToVecI16x8']();
Module['WidenLowUVecI8x16ToVecI16x8'] = Module['_BinaryenWidenLowUVecI8x16ToVecI16x8']();
Module['WidenHighUVecI8x16ToVecI16x8'] = Module['_BinaryenWidenHighUVecI8x16ToVecI16x8']();
Module['WidenLowSVecI16x8ToVecI32x4'] = Module['_BinaryenWidenLowSVecI16x8ToVecI32x4']();
Module['WidenHighSVecI16x8ToVecI32x4'] = Module['_BinaryenWidenHighSVecI16x8ToVecI32x4']();
Module['WidenLowUVecI16x8ToVecI32x4'] = Module['_BinaryenWidenLowUVecI16x8ToVecI32x4']();
Module['WidenHighUVecI16x8ToVecI32x4'] = Module['_BinaryenWidenHighUVecI16x8ToVecI32x4']();
Module['SwizzleVec8x16'] = Module['_BinaryenSwizzleVec8x16']();

// The size of a single literal in memory as used in Const creation,
// which is a little different: we don't want users to need to make
// their own Literals, as the C API handles them by value, which means
// we would leak them. Instead, Const creation is fused together with
// an intermediate stack allocation of this size to pass the value.
var sizeOfLiteral = _BinaryenSizeofLiteral();

// 'Module' interface
Module['Module'] = function(module) {
  assert(!module); // guard against incorrect old API usage
  var module = Module['_BinaryenModuleCreate']();

  wrapModule(module, this);
};

// Receives a C pointer to a C Module and a JS object, and creates
// the JS wrappings on the object to access the C data.
// This is meant for internal use only, and is necessary as we
// want to access Module from JS that were perhaps not created
// from JS.
function wrapModule(module, self) {
  assert(module); // guard against incorrect old API usage
  if (!self) self = {};

  self['ptr'] = module;

  // 'Expression' creation
  self['block'] = function(name, children, type) {
    return preserveStack(function() {
      return Module['_BinaryenBlock'](module, name ? strToStack(name) : 0,
                                      i32sToStack(children), children.length,
                                      typeof type !== 'undefined' ? type : Module['none']);
    });
  };
  self['if'] = function(condition, ifTrue, ifFalse) {
    return Module['_BinaryenIf'](module, condition, ifTrue, ifFalse);
  };
  self['loop'] = function(label, body) {
    return preserveStack(function() {
      return Module['_BinaryenLoop'](module, strToStack(label), body);
    });
  };
  self['break'] = self['br'] = function(label, condition, value) {
    return preserveStack(function() {
      return Module['_BinaryenBreak'](module, strToStack(label), condition, value);
    });
  };
  self['br_if'] = function(label, condition, value) {
    return self['br'](label, condition, value);
  };
  self['switch'] = function(names, defaultName, condition, value) {
    return preserveStack(function() {
      var namei32s = [];
      names.forEach(function(name) {
        namei32s.push(strToStack(name));
      });
      return Module['_BinaryenSwitch'](module, i32sToStack(namei32s), namei32s.length,
                                       strToStack(defaultName), condition, value);
    });
  };
  self['call'] = function(name, operands, type) {
    return preserveStack(function() {
      return Module['_BinaryenCall'](module, strToStack(name), i32sToStack(operands), operands.length, type);
    });
  };
  self['callIndirect'] = self['call_indirect'] = function(target, operands, params, results) {
    return preserveStack(function() {
      return Module['_BinaryenCallIndirect'](module, target, i32sToStack(operands), operands.length, params, results);
    });
  };
  self['returnCall'] = function(name, operands, type) {
    return preserveStack(function() {
      return Module['_BinaryenReturnCall'](module, strToStack(name), i32sToStack(operands), operands.length, type);
    });
  };
  self['returnCallIndirect'] = function(target, operands, params, results) {
    return preserveStack(function() {
      return Module['_BinaryenReturnCallIndirect'](module, target, i32sToStack(operands), operands.length, params, results);
    });
  };

  self['local'] = {
    'get': function(index, type) {
      return Module['_BinaryenLocalGet'](module, index, type);
    },
    'set': function(index, value) {
      return Module['_BinaryenLocalSet'](module, index, value);
    },
    'tee': function(index, value) {
      return Module['_BinaryenLocalTee'](module, index, value);
    }
  }

  self['global'] = {
    'get': function(name, type) {
      return Module['_BinaryenGlobalGet'](module, strToStack(name), type);
    },
    'set': function(name, value) {
      return Module['_BinaryenGlobalSet'](module, strToStack(name), value);
    }
  }

  self['memory'] = {
    'size': function() {
      return Module['_BinaryenHost'](module, Module['MemorySize']);
    },
    'grow': function(value) {
      return Module['_BinaryenHost'](module, Module['MemoryGrow'], null, i32sToStack([value]), 1);
    },
    'init': function(segment, dest, offset, size) {
      return Module['_BinaryenMemoryInit'](module, segment, dest, offset, size);
    },
    'copy': function(dest, source, size) {
      return Module['_BinaryenMemoryCopy'](module, dest, source, size);
    },
    'fill': function(dest, value, size) {
      return Module['_BinaryenMemoryFill'](module, dest, value, size);
    }
  }

  self['data'] = {
    'drop': function(segment) {
      return Module['_BinaryenDataDrop'](module, segment);
    }
  }

  self['i32'] = {
    'load': function(offset, align, ptr) {
      return Module['_BinaryenLoad'](module, 4, true, offset, align, Module['i32'], ptr);
    },
    'load8_s': function(offset, align, ptr) {
      return Module['_BinaryenLoad'](module, 1, true, offset, align, Module['i32'], ptr);
    },
    'load8_u': function(offset, align, ptr) {
      return Module['_BinaryenLoad'](module, 1, false, offset, align, Module['i32'], ptr);
    },
    'load16_s': function(offset, align, ptr) {
      return Module['_BinaryenLoad'](module, 2, true, offset, align, Module['i32'], ptr);
    },
    'load16_u': function(offset, align, ptr) {
      return Module['_BinaryenLoad'](module, 2, false, offset, align, Module['i32'], ptr);
    },
    'store': function(offset, align, ptr, value) {
      return Module['_BinaryenStore'](module, 4, offset, align, ptr, value, Module['i32']);
    },
    'store8': function(offset, align, ptr, value) {
      return Module['_BinaryenStore'](module, 1, offset, align, ptr, value, Module['i32']);
    },
    'store16': function(offset, align, ptr, value) {
      return Module['_BinaryenStore'](module, 2, offset, align, ptr, value, Module['i32']);
    },
    'const': function(x) {
      return preserveStack(function() {
        var tempLiteral = stackAlloc(sizeOfLiteral);
        Module['_BinaryenLiteralInt32'](tempLiteral, x);
        return Module['_BinaryenConst'](module, tempLiteral);
      });
    },
    'clz': function(value) {
      return Module['_BinaryenUnary'](module, Module['ClzInt32'], value);
    },
    'ctz': function(value) {
      return Module['_BinaryenUnary'](module, Module['CtzInt32'], value);
    },
    'popcnt': function(value) {
      return Module['_BinaryenUnary'](module, Module['PopcntInt32'], value);
    },
    'eqz': function(value) {
      return Module['_BinaryenUnary'](module, Module['EqZInt32'], value);
    },
    'trunc_s': {
      'f32': function(value) {
        return Module['_BinaryenUnary'](module, Module['TruncSFloat32ToInt32'], value);
      },
      'f64': function(value) {
        return Module['_BinaryenUnary'](module, Module['TruncSFloat64ToInt32'], value);
      },
    },
    'trunc_u': {
      'f32': function(value) {
        return Module['_BinaryenUnary'](module, Module['TruncUFloat32ToInt32'], value);
      },
      'f64': function(value) {
        return Module['_BinaryenUnary'](module, Module['TruncUFloat64ToInt32'], value);
      },
    },
    'trunc_s_sat': {
      'f32': function(value) {
        return Module['_BinaryenUnary'](module, Module['TruncSatSFloat32ToInt32'], value);
      },
      'f64': function(value) {
        return Module['_BinaryenUnary'](module, Module['TruncSatSFloat64ToInt32'], value);
      },
    },
    'trunc_u_sat': {
      'f32': function(value) {
        return Module['_BinaryenUnary'](module, Module['TruncSatUFloat32ToInt32'], value);
      },
      'f64': function(value) {
        return Module['_BinaryenUnary'](module, Module['TruncSatUFloat64ToInt32'], value);
      },
    },
    'reinterpret': function(value) {
      return Module['_BinaryenUnary'](module, Module['ReinterpretFloat32'], value);
    },
    'extend8_s': function(value) {
      return Module['_BinaryenUnary'](module, Module['ExtendS8Int32'], value);
    },
    'extend16_s': function(value) {
      return Module['_BinaryenUnary'](module, Module['ExtendS16Int32'], value);
    },
    'wrap': function(value) {
      return Module['_BinaryenUnary'](module, Module['WrapInt64'], value);
    },
    'add': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AddInt32'], left, right);
    },
    'sub': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['SubInt32'], left, right);
    },
    'mul': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MulInt32'], left, right);
    },
    'div_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['DivSInt32'], left, right);
    },
    'div_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['DivUInt32'], left, right);
    },
    'rem_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['RemSInt32'], left, right);
    },
    'rem_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['RemUInt32'], left, right);
    },
    'and': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AndInt32'], left, right);
    },
    'or': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['OrInt32'], left, right);
    },
    'xor': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['XorInt32'], left, right);
    },
    'shl': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['ShlInt32'], left, right);
    },
    'shr_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['ShrUInt32'], left, right);
    },
    'shr_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['ShrSInt32'], left, right);
    },
    'rotl': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['RotLInt32'], left, right);
    },
    'rotr': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['RotRInt32'], left, right);
    },
    'eq': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['EqInt32'], left, right);
    },
    'ne': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['NeInt32'], left, right);
    },
    'lt_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LtSInt32'], left, right);
    },
    'lt_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LtUInt32'], left, right);
    },
    'le_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LeSInt32'], left, right);
    },
    'le_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LeUInt32'], left, right);
    },
    'gt_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GtSInt32'], left, right);
    },
    'gt_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GtUInt32'], left, right);
    },
    'ge_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GeSInt32'], left, right);
    },
    'ge_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GeUInt32'], left, right);
    },
    'atomic': {
      'load': function(offset, ptr) {
        return Module['_BinaryenAtomicLoad'](module, 4, offset, Module['i32'], ptr);
      },
      'load8_u': function(offset, ptr) {
        return Module['_BinaryenAtomicLoad'](module, 1, offset, Module['i32'], ptr);
      },
      'load16_u': function(offset, ptr) {
        return Module['_BinaryenAtomicLoad'](module, 2, offset, Module['i32'], ptr);
      },
      'store': function(offset, ptr, value) {
        return Module['_BinaryenAtomicStore'](module, 4, offset, ptr, value, Module['i32']);
      },
      'store8': function(offset, ptr, value) {
        return Module['_BinaryenAtomicStore'](module, 1, offset, ptr, value, Module['i32']);
      },
      'store16': function(offset, ptr, value) {
        return Module['_BinaryenAtomicStore'](module, 2, offset, ptr, value, Module['i32']);
      },
      'rmw': {
        'add': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWAdd'], 4, offset, ptr, value, Module['i32']);
        },
        'sub': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWSub'], 4, offset, ptr, value, Module['i32']);
        },
        'and': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWAnd'], 4, offset, ptr, value, Module['i32']);
        },
        'or': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWOr'], 4, offset, ptr, value, Module['i32']);
        },
        'xor': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWXor'], 4, offset, ptr, value, Module['i32']);
        },
        'xchg': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWXchg'], 4, offset, ptr, value, Module['i32']);
        },
        'cmpxchg': function(offset, ptr, expected, replacement) {
          return Module['_BinaryenAtomicCmpxchg'](module, 4, offset, ptr, expected, replacement, Module['i32'])
        },
      },
      'rmw8_u': {
        'add': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWAdd'], 1, offset, ptr, value, Module['i32']);
        },
        'sub': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWSub'], 1, offset, ptr, value, Module['i32']);
        },
        'and': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWAnd'], 1, offset, ptr, value, Module['i32']);
        },
        'or': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWOr'], 1, offset, ptr, value, Module['i32']);
        },
        'xor': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWXor'], 1, offset, ptr, value, Module['i32']);
        },
        'xchg': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWXchg'], 1, offset, ptr, value, Module['i32']);
        },
        'cmpxchg': function(offset, ptr, expected, replacement) {
          return Module['_BinaryenAtomicCmpxchg'](module, 1, offset, ptr, expected, replacement, Module['i32'])
        },
      },
      'rmw16_u': {
        'add': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWAdd'], 2, offset, ptr, value, Module['i32']);
        },
        'sub': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWSub'], 2, offset, ptr, value, Module['i32']);
        },
        'and': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWAnd'], 2, offset, ptr, value, Module['i32']);
        },
        'or': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWOr'], 2, offset, ptr, value, Module['i32']);
        },
        'xor': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWXor'], 2, offset, ptr, value, Module['i32']);
        },
        'xchg': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWXchg'], 2, offset, ptr, value, Module['i32']);
        },
        'cmpxchg': function(offset, ptr, expected, replacement) {
          return Module['_BinaryenAtomicCmpxchg'](module, 2, offset, ptr, expected, replacement, Module['i32'])
        },
      },
      'wait': function(ptr, expected, timeout) {
        return Module['_BinaryenAtomicWait'](module, ptr, expected, timeout, Module['i32']);
      }
    },
    'pop': function() {
      return Module['_BinaryenPop'](module, Module['i32']);
    }
  };

  self['i64'] = {
    'load': function(offset, align, ptr) {
      return Module['_BinaryenLoad'](module, 8, true, offset, align, Module['i64'], ptr);
    },
    'load8_s': function(offset, align, ptr) {
      return Module['_BinaryenLoad'](module, 1, true, offset, align, Module['i64'], ptr);
    },
    'load8_u': function(offset, align, ptr) {
      return Module['_BinaryenLoad'](module, 1, false, offset, align, Module['i64'], ptr);
    },
    'load16_s': function(offset, align, ptr) {
      return Module['_BinaryenLoad'](module, 2, true, offset, align, Module['i64'], ptr);
    },
    'load16_u': function(offset, align, ptr) {
      return Module['_BinaryenLoad'](module, 2, false, offset, align, Module['i64'], ptr);
    },
    'load32_s': function(offset, align, ptr) {
      return Module['_BinaryenLoad'](module, 4, true, offset, align, Module['i64'], ptr);
    },
    'load32_u': function(offset, align, ptr) {
      return Module['_BinaryenLoad'](module, 4, false, offset, align, Module['i64'], ptr);
    },
    'store': function(offset, align, ptr, value) {
      return Module['_BinaryenStore'](module, 8, offset, align, ptr, value, Module['i64']);
    },
    'store8': function(offset, align, ptr, value) {
      return Module['_BinaryenStore'](module, 1, offset, align, ptr, value, Module['i64']);
    },
    'store16': function(offset, align, ptr, value) {
      return Module['_BinaryenStore'](module, 2, offset, align, ptr, value, Module['i64']);
    },
    'store32': function(offset, align, ptr, value) {
      return Module['_BinaryenStore'](module, 4, offset, align, ptr, value, Module['i64']);
    },
    'const': function(x, y) {
      return preserveStack(function() {
        var tempLiteral = stackAlloc(sizeOfLiteral);
        Module['_BinaryenLiteralInt64'](tempLiteral, x, y);
        return Module['_BinaryenConst'](module, tempLiteral);
      });
    },
    'clz': function(value) {
      return Module['_BinaryenUnary'](module, Module['ClzInt64'], value);
    },
    'ctz': function(value) {
      return Module['_BinaryenUnary'](module, Module['CtzInt64'], value);
    },
    'popcnt': function(value) {
      return Module['_BinaryenUnary'](module, Module['PopcntInt64'], value);
    },
    'eqz': function(value) {
      return Module['_BinaryenUnary'](module, Module['EqZInt64'], value);
    },
    'trunc_s': {
      'f32': function(value) {
        return Module['_BinaryenUnary'](module, Module['TruncSFloat32ToInt64'], value);
      },
      'f64': function(value) {
        return Module['_BinaryenUnary'](module, Module['TruncSFloat64ToInt64'], value);
      },
    },
    'trunc_u': {
      'f32': function(value) {
        return Module['_BinaryenUnary'](module, Module['TruncUFloat32ToInt64'], value);
      },
      'f64': function(value) {
        return Module['_BinaryenUnary'](module, Module['TruncUFloat64ToInt64'], value);
      },
    },
    'trunc_s_sat': {
      'f32': function(value) {
        return Module['_BinaryenUnary'](module, Module['TruncSatSFloat32ToInt64'], value);
      },
      'f64': function(value) {
        return Module['_BinaryenUnary'](module, Module['TruncSatSFloat64ToInt64'], value);
      },
    },
    'trunc_u_sat': {
      'f32': function(value) {
        return Module['_BinaryenUnary'](module, Module['TruncSatUFloat32ToInt64'], value);
      },
      'f64': function(value) {
        return Module['_BinaryenUnary'](module, Module['TruncSatUFloat64ToInt64'], value);
      },
    },
    'reinterpret': function(value) {
      return Module['_BinaryenUnary'](module, Module['ReinterpretFloat64'], value);
    },
    'extend8_s': function(value) {
      return Module['_BinaryenUnary'](module, Module['ExtendS8Int64'], value);
    },
    'extend16_s': function(value) {
      return Module['_BinaryenUnary'](module, Module['ExtendS16Int64'], value);
    },
    'extend32_s': function(value) {
      return Module['_BinaryenUnary'](module, Module['ExtendS32Int64'], value);
    },
    'extend_s': function(value) {
      return Module['_BinaryenUnary'](module, Module['ExtendSInt32'], value);
    },
    'extend_u': function(value) {
      return Module['_BinaryenUnary'](module, Module['ExtendUInt32'], value);
    },
    'add': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AddInt64'], left, right);
    },
    'sub': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['SubInt64'], left, right);
    },
    'mul': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MulInt64'], left, right);
    },
    'div_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['DivSInt64'], left, right);
    },
    'div_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['DivUInt64'], left, right);
    },
    'rem_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['RemSInt64'], left, right);
    },
    'rem_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['RemUInt64'], left, right);
    },
    'and': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AndInt64'], left, right);
    },
    'or': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['OrInt64'], left, right);
    },
    'xor': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['XorInt64'], left, right);
    },
    'shl': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['ShlInt64'], left, right);
    },
    'shr_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['ShrUInt64'], left, right);
    },
    'shr_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['ShrSInt64'], left, right);
    },
    'rotl': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['RotLInt64'], left, right);
    },
    'rotr': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['RotRInt64'], left, right);
    },
    'eq': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['EqInt64'], left, right);
    },
    'ne': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['NeInt64'], left, right);
    },
    'lt_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LtSInt64'], left, right);
    },
    'lt_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LtUInt64'], left, right);
    },
    'le_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LeSInt64'], left, right);
    },
    'le_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LeUInt64'], left, right);
    },
    'gt_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GtSInt64'], left, right);
    },
    'gt_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GtUInt64'], left, right);
    },
    'ge_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GeSInt64'], left, right);
    },
    'ge_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GeUInt64'], left, right);
    },
    'atomic': {
      'load': function(offset, ptr) {
        return Module['_BinaryenAtomicLoad'](module, 8, offset, Module['i64'], ptr);
      },
      'load8_u': function(offset, ptr) {
        return Module['_BinaryenAtomicLoad'](module, 1, offset, Module['i64'], ptr);
      },
      'load16_u': function(offset, ptr) {
        return Module['_BinaryenAtomicLoad'](module, 2, offset, Module['i64'], ptr);
      },
      'load32_u': function(offset, ptr) {
        return Module['_BinaryenAtomicLoad'](module, 4, offset, Module['i64'], ptr);
      },
      'store': function(offset, ptr, value) {
        return Module['_BinaryenAtomicStore'](module, 8, offset, ptr, value, Module['i64']);
      },
      'store8': function(offset, ptr, value) {
        return Module['_BinaryenAtomicStore'](module, 1, offset, ptr, value, Module['i64']);
      },
      'store16': function(offset, ptr, value) {
        return Module['_BinaryenAtomicStore'](module, 2, offset, ptr, value, Module['i64']);
      },
      'store32': function(offset, ptr, value) {
        return Module['_BinaryenAtomicStore'](module, 4, offset, ptr, value, Module['i64']);
      },
      'rmw': {
        'add': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWAdd'], 8, offset, ptr, value, Module['i64']);
        },
        'sub': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWSub'], 8, offset, ptr, value, Module['i64']);
        },
        'and': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWAnd'], 8, offset, ptr, value, Module['i64']);
        },
        'or': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWOr'], 8, offset, ptr, value, Module['i64']);
        },
        'xor': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWXor'], 8, offset, ptr, value, Module['i64']);
        },
        'xchg': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWXchg'], 8, offset, ptr, value, Module['i64']);
        },
        'cmpxchg': function(offset, ptr, expected, replacement) {
          return Module['_BinaryenAtomicCmpxchg'](module, 8, offset, ptr, expected, replacement, Module['i64'])
        },
      },
      'rmw8_u': {
        'add': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWAdd'], 1, offset, ptr, value, Module['i64']);
        },
        'sub': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWSub'], 1, offset, ptr, value, Module['i64']);
        },
        'and': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWAnd'], 1, offset, ptr, value, Module['i64']);
        },
        'or': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWOr'], 1, offset, ptr, value, Module['i64']);
        },
        'xor': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWXor'], 1, offset, ptr, value, Module['i64']);
        },
        'xchg': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWXchg'], 1, offset, ptr, value, Module['i64']);
        },
        'cmpxchg': function(offset, ptr, expected, replacement) {
          return Module['_BinaryenAtomicCmpxchg'](module, 1, offset, ptr, expected, replacement, Module['i64'])
        },
      },
      'rmw16_u': {
        'add': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWAdd'], 2, offset, ptr, value, Module['i64']);
        },
        'sub': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWSub'], 2, offset, ptr, value, Module['i64']);
        },
        'and': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWAnd'], 2, offset, ptr, value, Module['i64']);
        },
        'or': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWOr'], 2, offset, ptr, value, Module['i64']);
        },
        'xor': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWXor'], 2, offset, ptr, value, Module['i64']);
        },
        'xchg': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWXchg'], 2, offset, ptr, value, Module['i64']);
        },
        'cmpxchg': function(offset, ptr, expected, replacement) {
          return Module['_BinaryenAtomicCmpxchg'](module, 2, offset, ptr, expected, replacement, Module['i64'])
        },
      },
      'rmw32_u': {
        'add': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWAdd'], 4, offset, ptr, value, Module['i64']);
        },
        'sub': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWSub'], 4, offset, ptr, value, Module['i64']);
        },
        'and': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWAnd'], 4, offset, ptr, value, Module['i64']);
        },
        'or': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWOr'], 4, offset, ptr, value, Module['i64']);
        },
        'xor': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWXor'], 4, offset, ptr, value, Module['i64']);
        },
        'xchg': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWXchg'], 4, offset, ptr, value, Module['i64']);
        },
        'cmpxchg': function(offset, ptr, expected, replacement) {
          return Module['_BinaryenAtomicCmpxchg'](module, 4, offset, ptr, expected, replacement, Module['i64'])
        },
      },
      'wait': function(ptr, expected, timeout) {
        return Module['_BinaryenAtomicWait'](module, ptr, expected, timeout, Module['i64']);
      }
    },
    'pop': function() {
      return Module['_BinaryenPop'](module, Module['i64']);
    }
  };

  self['f32'] = {
    'load': function(offset, align, ptr) {
      return Module['_BinaryenLoad'](module, 4, true, offset, align, Module['f32'], ptr);
    },
    'store': function(offset, align, ptr, value) {
      return Module['_BinaryenStore'](module, 4, offset, align, ptr, value, Module['f32']);
    },
    'const': function(x) {
      return preserveStack(function() {
        var tempLiteral = stackAlloc(sizeOfLiteral);
        Module['_BinaryenLiteralFloat32'](tempLiteral, x);
        return Module['_BinaryenConst'](module, tempLiteral);
      });
    },
    'const_bits': function(x) {
      return preserveStack(function() {
        var tempLiteral = stackAlloc(sizeOfLiteral);
        Module['_BinaryenLiteralFloat32Bits'](tempLiteral, x);
        return Module['_BinaryenConst'](module, tempLiteral);
      });
    },
    'neg': function(value) {
      return Module['_BinaryenUnary'](module, Module['NegFloat32'], value);
    },
    'abs': function(value) {
      return Module['_BinaryenUnary'](module, Module['AbsFloat32'], value);
    },
    'ceil': function(value) {
      return Module['_BinaryenUnary'](module, Module['CeilFloat32'], value);
    },
    'floor': function(value) {
      return Module['_BinaryenUnary'](module, Module['FloorFloat32'], value);
    },
    'trunc': function(value) {
      return Module['_BinaryenUnary'](module, Module['TruncFloat32'], value);
    },
    'nearest': function(value) {
      return Module['_BinaryenUnary'](module, Module['NearestFloat32'], value);
    },
    'sqrt': function(value) {
      return Module['_BinaryenUnary'](module, Module['SqrtFloat32'], value);
    },
    'reinterpret': function(value) {
      return Module['_BinaryenUnary'](module, Module['ReinterpretInt32'], value);
    },
    'convert_s': {
      'i32': function(value) {
        return Module['_BinaryenUnary'](module, Module['ConvertSInt32ToFloat32'], value);
      },
      'i64': function(value) {
        return Module['_BinaryenUnary'](module, Module['ConvertSInt64ToFloat32'], value);
      },
    },
    'convert_u': {
      'i32': function(value) {
        return Module['_BinaryenUnary'](module, Module['ConvertUInt32ToFloat32'], value);
      },
      'i64': function(value) {
        return Module['_BinaryenUnary'](module, Module['ConvertUInt64ToFloat32'], value);
      },
    },
    'demote': function(value) {
      return Module['_BinaryenUnary'](module, Module['DemoteFloat64'], value);
    },
    'add': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AddFloat32'], left, right);
    },
    'sub': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['SubFloat32'], left, right);
    },
    'mul': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MulFloat32'], left, right);
    },
    'div': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['DivFloat32'], left, right);
    },
    'copysign': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['CopySignFloat32'], left, right);
    },
    'min': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MinFloat32'], left, right);
    },
    'max': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MaxFloat32'], left, right);
    },
    'eq': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['EqFloat32'], left, right);
    },
    'ne': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['NeFloat32'], left, right);
    },
    'lt': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LtFloat32'], left, right);
    },
    'le': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LeFloat32'], left, right);
    },
    'gt': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GtFloat32'], left, right);
    },
    'ge': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GeFloat32'], left, right);
    },
    'pop': function() {
      return Module['_BinaryenPop'](module, Module['f32']);
    }
  };

  self['f64'] = {
    'load': function(offset, align, ptr) {
      return Module['_BinaryenLoad'](module, 8, true, offset, align, Module['f64'], ptr);
    },
    'store': function(offset, align, ptr, value) {
      return Module['_BinaryenStore'](module, 8, offset, align, ptr, value, Module['f64']);
    },
    'const': function(x) {
      return preserveStack(function() {
        var tempLiteral = stackAlloc(sizeOfLiteral);
        Module['_BinaryenLiteralFloat64'](tempLiteral, x);
        return Module['_BinaryenConst'](module, tempLiteral);
      });
    },
    'const_bits': function(x, y) {
      return preserveStack(function() {
        var tempLiteral = stackAlloc(sizeOfLiteral);
        Module['_BinaryenLiteralFloat64Bits'](tempLiteral, x, y);
        return Module['_BinaryenConst'](module, tempLiteral);
      });
    },
    'neg': function(value) {
      return Module['_BinaryenUnary'](module, Module['NegFloat64'], value);
    },
    'abs': function(value) {
      return Module['_BinaryenUnary'](module, Module['AbsFloat64'], value);
    },
    'ceil': function(value) {
      return Module['_BinaryenUnary'](module, Module['CeilFloat64'], value);
    },
    'floor': function(value) {
      return Module['_BinaryenUnary'](module, Module['FloorFloat64'], value);
    },
    'trunc': function(value) {
      return Module['_BinaryenUnary'](module, Module['TruncFloat64'], value);
    },
    'nearest': function(value) {
      return Module['_BinaryenUnary'](module, Module['NearestFloat64'], value);
    },
    'sqrt': function(value) {
      return Module['_BinaryenUnary'](module, Module['SqrtFloat64'], value);
    },
    'reinterpret': function(value) {
      return Module['_BinaryenUnary'](module, Module['ReinterpretInt64'], value);
    },
    'convert_s': {
      'i32': function(value) {
        return Module['_BinaryenUnary'](module, Module['ConvertSInt32ToFloat64'], value);
      },
      'i64': function(value) {
        return Module['_BinaryenUnary'](module, Module['ConvertSInt64ToFloat64'], value);
      },
    },
    'convert_u': {
      'i32': function(value) {
        return Module['_BinaryenUnary'](module, Module['ConvertUInt32ToFloat64'], value);
      },
      'i64': function(value) {
        return Module['_BinaryenUnary'](module, Module['ConvertUInt64ToFloat64'], value);
      },
    },
    'promote': function(value) {
      return Module['_BinaryenUnary'](module, Module['PromoteFloat32'], value);
    },
    'add': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AddFloat64'], left, right);
    },
    'sub': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['SubFloat64'], left, right);
    },
    'mul': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MulFloat64'], left, right);
    },
    'div': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['DivFloat64'], left, right);
    },
    'copysign': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['CopySignFloat64'], left, right);
    },
    'min': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MinFloat64'], left, right);
    },
    'max': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MaxFloat64'], left, right);
    },
    'eq': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['EqFloat64'], left, right);
    },
    'ne': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['NeFloat64'], left, right);
    },
    'lt': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LtFloat64'], left, right);
    },
    'le': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LeFloat64'], left, right);
    },
    'gt': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GtFloat64'], left, right);
    },
    'ge': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GeFloat64'], left, right);
    },
    'pop': function() {
      return Module['_BinaryenPop'](module, Module['f64']);
    }
  };

  self['v128'] = {
    'load': function(offset, align, ptr) {
      return Module['_BinaryenLoad'](module, 16, false, offset, align, Module['v128'], ptr);
    },
    'store': function(offset, align, ptr, value) {
      return Module['_BinaryenStore'](module, 16, offset, align, ptr, value, Module['v128']);
    },
    'const': function(i8s) {
      return preserveStack(function() {
        var tempLiteral = stackAlloc(sizeOfLiteral);
        Module['_BinaryenLiteralVec128'](tempLiteral, i8sToStack(i8s));
        return Module['_BinaryenConst'](module, tempLiteral);
      });
    },
    'not': function(value) {
      return Module['_BinaryenUnary'](module, Module['NotVec128'], value);
    },
    'and': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AndVec128'], left, right);
    },
    'or': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['OrVec128'], left, right);
    },
    'xor': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['XorVec128'], left, right);
    },
    'andnot': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AndNotVec128'], left, right);
    },
    'bitselect': function(left, right, cond) {
      return Module['_BinaryenSIMDTernary'](module, Module['BitselectVec128'], left, right, cond);
    },
    'pop': function() {
      return Module['_BinaryenPop'](module, Module['v128']);
    }
  };

  self['i8x16'] = {
    'splat': function(value) {
      return Module['_BinaryenUnary'](module, Module['SplatVecI8x16'], value);
    },
    'extract_lane_s': function(vec, index) {
      return Module['_BinaryenSIMDExtract'](module, Module['ExtractLaneSVecI8x16'], vec, index);
    },
    'extract_lane_u': function(vec, index) {
      return Module['_BinaryenSIMDExtract'](module, Module['ExtractLaneUVecI8x16'], vec, index);
    },
    'replace_lane': function(vec, index, value) {
      return Module['_BinaryenSIMDReplace'](module, Module['ReplaceLaneVecI8x16'], vec, index, value);
    },
    'eq': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['EqVecI8x16'], left, right);
    },
    'ne': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['NeVecI8x16'], left, right);
    },
    'lt_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LtSVecI8x16'], left, right);
    },
    'lt_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LtUVecI8x16'], left, right);
    },
    'gt_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GtSVecI8x16'], left, right);
    },
    'gt_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GtUVecI8x16'], left, right);
    },
    'le_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LeSVecI8x16'], left, right);
    },
    'le_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LeUVecI8x16'], left, right);
    },
    'ge_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GeSVecI8x16'], left, right);
    },
    'ge_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GeUVecI8x16'], left, right);
    },
    'neg': function(value) {
      return Module['_BinaryenUnary'](module, Module['NegVecI8x16'], value);
    },
    'any_true': function(value) {
      return Module['_BinaryenUnary'](module, Module['AnyTrueVecI8x16'], value);
    },
    'all_true': function(value) {
      return Module['_BinaryenUnary'](module, Module['AllTrueVecI8x16'], value);
    },
    'shl': function(vec, shift) {
      return Module['_BinaryenSIMDShift'](module, Module['ShlVecI8x16'], vec, shift);
    },
    'shr_s': function(vec, shift) {
      return Module['_BinaryenSIMDShift'](module, Module['ShrSVecI8x16'], vec, shift);
    },
    'shr_u': function(vec, shift) {
      return Module['_BinaryenSIMDShift'](module, Module['ShrUVecI8x16'], vec, shift);
    },
    'add': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AddVecI8x16'], left, right);
    },
    'add_saturate_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AddSatSVecI8x16'], left, right);
    },
    'add_saturate_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AddSatUVecI8x16'], left, right);
    },
    'sub': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['SubVecI8x16'], left, right);
    },
    'sub_saturate_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['SubSatSVecI8x16'], left, right);
    },
    'sub_saturate_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['SubSatUVecI8x16'], left, right);
    },
    'mul': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MulVecI8x16'], left, right);
    },
    'min_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MinSVecI8x16'], left, right);
    },
    'min_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MinUVecI8x16'], left, right);
    },
    'max_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MaxSVecI8x16'], left, right);
    },
    'max_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MaxUVecI8x16'], left, right);
    },
    'narrow_i16x8_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['NarrowSVecI16x8ToVecI8x16'], left, right);
    },
    'narrow_i16x8_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['NarrowUVecI16x8ToVecI8x16'], left, right);
    },
  };

  self['i16x8'] = {
    'splat': function(value) {
      return Module['_BinaryenUnary'](module, Module['SplatVecI16x8'], value);
    },
    'extract_lane_s': function(vec, index) {
      return Module['_BinaryenSIMDExtract'](module, Module['ExtractLaneSVecI16x8'], vec, index);
    },
    'extract_lane_u': function(vec, index) {
      return Module['_BinaryenSIMDExtract'](module, Module['ExtractLaneUVecI16x8'], vec, index);
    },
    'replace_lane': function(vec, index, value) {
      return Module['_BinaryenSIMDReplace'](module, Module['ReplaceLaneVecI16x8'], vec, index, value);
    },
    'eq': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['EqVecI16x8'], left, right);
    },
    'ne': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['NeVecI16x8'], left, right);
    },
    'lt_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LtSVecI16x8'], left, right);
    },
    'lt_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LtUVecI16x8'], left, right);
    },
    'gt_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GtSVecI16x8'], left, right);
    },
    'gt_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GtUVecI16x8'], left, right);
    },
    'le_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LeSVecI16x8'], left, right);
    },
    'le_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LeUVecI16x8'], left, right);
    },
    'ge_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GeSVecI16x8'], left, right);
    },
    'ge_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GeUVecI16x8'], left, right);
    },
    'neg': function(value) {
      return Module['_BinaryenUnary'](module, Module['NegVecI16x8'], value);
    },
    'any_true': function(value) {
      return Module['_BinaryenUnary'](module, Module['AnyTrueVecI16x8'], value);
    },
    'all_true': function(value) {
      return Module['_BinaryenUnary'](module, Module['AllTrueVecI16x8'], value);
    },
    'shl': function(vec, shift) {
      return Module['_BinaryenSIMDShift'](module, Module['ShlVecI16x8'], vec, shift);
    },
    'shr_s': function(vec, shift) {
      return Module['_BinaryenSIMDShift'](module, Module['ShrSVecI16x8'], vec, shift);
    },
    'shr_u': function(vec, shift) {
      return Module['_BinaryenSIMDShift'](module, Module['ShrUVecI16x8'], vec, shift);
    },
    'add': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AddVecI16x8'], left, right);
    },
    'add_saturate_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AddSatSVecI16x8'], left, right);
    },
    'add_saturate_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AddSatUVecI16x8'], left, right);
    },
    'sub': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['SubVecI16x8'], left, right);
    },
    'sub_saturate_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['SubSatSVecI16x8'], left, right);
    },
    'sub_saturate_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['SubSatUVecI16x8'], left, right);
    },
    'mul': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MulVecI16x8'], left, right);
    },
    'min_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MinSVecI16x8'], left, right);
    },
    'min_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MinUVecI16x8'], left, right);
    },
    'max_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MaxSVecI16x8'], left, right);
    },
    'max_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MaxUVecI16x8'], left, right);
    },
    'narrow_i32x4_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['NarrowSVecI32x4ToVecI16x8'], left, right);
    },
    'narrow_i32x4_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['NarrowUVecI32x4ToVecI16x8'], left, right);
    },
    'widen_low_i8x16_s': function(value) {
      return Module['_BinaryenUnary'](module, Module['WidenLowSVecI8x16ToVecI16x8'], value);
    },
    'widen_high_i8x16_s': function(value) {
      return Module['_BinaryenUnary'](module, Module['WidenHighSVecI8x16ToVecI16x8'], value);
    },
    'widen_low_i8x16_u': function(value) {
      return Module['_BinaryenUnary'](module, Module['WidenLowUVecI8x16ToVecI16x8'], value);
    },
    'widen_high_i8x16_u': function(value) {
      return Module['_BinaryenUnary'](module, Module['WidenHighUVecI8x16ToVecI16x8'], value);
    },
    'load8x8_s': function(offset, align, ptr) {
      return Module['_BinaryenSIMDLoad'](module, Module['LoadExtSVec8x8ToVecI16x8'], offset, align, ptr);
    },
    'load8x8_u': function(offset, align, ptr) {
      return Module['_BinaryenSIMDLoad'](module, Module['LoadExtUVec8x8ToVecI16x8'], offset, align, ptr);
    },
  };

  self['i32x4'] = {
    'splat': function(value) {
      return Module['_BinaryenUnary'](module, Module['SplatVecI32x4'], value);
    },
    'extract_lane': function(vec, index) {
      return Module['_BinaryenSIMDExtract'](module, Module['ExtractLaneVecI32x4'], vec, index);
    },
    'replace_lane': function(vec, index, value) {
      return Module['_BinaryenSIMDReplace'](module, Module['ReplaceLaneVecI32x4'], vec, index, value);
    },
    'eq': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['EqVecI32x4'], left, right);
    },
    'ne': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['NeVecI32x4'], left, right);
    },
    'lt_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LtSVecI32x4'], left, right);
    },
    'lt_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LtUVecI32x4'], left, right);
    },
    'gt_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GtSVecI32x4'], left, right);
    },
    'gt_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GtUVecI32x4'], left, right);
    },
    'le_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LeSVecI32x4'], left, right);
    },
    'le_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LeUVecI32x4'], left, right);
    },
    'ge_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GeSVecI32x4'], left, right);
    },
    'ge_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GeUVecI32x4'], left, right);
    },
    'neg': function(value) {
      return Module['_BinaryenUnary'](module, Module['NegVecI32x4'], value);
    },
    'any_true': function(value) {
      return Module['_BinaryenUnary'](module, Module['AnyTrueVecI32x4'], value);
    },
    'all_true': function(value) {
      return Module['_BinaryenUnary'](module, Module['AllTrueVecI32x4'], value);
    },
    'shl': function(vec, shift) {
      return Module['_BinaryenSIMDShift'](module, Module['ShlVecI32x4'], vec, shift);
    },
    'shr_s': function(vec, shift) {
      return Module['_BinaryenSIMDShift'](module, Module['ShrSVecI32x4'], vec, shift);
    },
    'shr_u': function(vec, shift) {
      return Module['_BinaryenSIMDShift'](module, Module['ShrUVecI32x4'], vec, shift);
    },
    'add': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AddVecI32x4'], left, right);
    },
    'sub': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['SubVecI32x4'], left, right);
    },
    'mul': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MulVecI32x4'], left, right);
    },
    'min_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MinSVecI32x4'], left, right);
    },
    'min_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MinUVecI32x4'], left, right);
    },
    'max_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MaxSVecI32x4'], left, right);
    },
    'max_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MaxUVecI32x4'], left, right);
    },
    'dot_i16x8_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['DotSVecI16x8ToVecI32x4'], left, right);
    },
    'trunc_sat_f32x4_s': function(value) {
      return Module['_BinaryenUnary'](module, Module['TruncSatSVecF32x4ToVecI32x4'], value);
    },
    'trunc_sat_f32x4_u': function(value) {
      return Module['_BinaryenUnary'](module, Module['TruncSatUVecF32x4ToVecI32x4'], value);
    },
    'widen_low_i16x8_s': function(value) {
      return Module['_BinaryenUnary'](module, Module['WidenLowSVecI16x8ToVecI32x4'], value);
    },
    'widen_high_i16x8_s': function(value) {
      return Module['_BinaryenUnary'](module, Module['WidenHighSVecI16x8ToVecI32x4'], value);
    },
    'widen_low_i16x8_u': function(value) {
      return Module['_BinaryenUnary'](module, Module['WidenLowUVecI16x8ToVecI32x4'], value);
    },
    'widen_high_i16x8_u': function(value) {
      return Module['_BinaryenUnary'](module, Module['WidenHighUVecI16x8ToVecI32x4'], value);
    },
    'load16x4_s': function(offset, align, ptr) {
      return Module['_BinaryenSIMDLoad'](module, Module['LoadExtSVec16x4ToVecI32x4'], offset, align, ptr);
    },
    'load16x4_u': function(offset, align, ptr) {
      return Module['_BinaryenSIMDLoad'](module, Module['LoadExtUVec16x4ToVecI32x4'], offset, align, ptr);
    },
  };

  self['i64x2'] = {
    'splat': function(value) {
      return Module['_BinaryenUnary'](module, Module['SplatVecI64x2'], value);
    },
    'extract_lane': function(vec, index) {
      return Module['_BinaryenSIMDExtract'](module, Module['ExtractLaneVecI64x2'], vec, index);
    },
    'replace_lane': function(vec, index, value) {
      return Module['_BinaryenSIMDReplace'](module, Module['ReplaceLaneVecI64x2'], vec, index, value);
    },
    'neg': function(value) {
      return Module['_BinaryenUnary'](module, Module['NegVecI64x2'], value);
    },
    'any_true': function(value) {
      return Module['_BinaryenUnary'](module, Module['AnyTrueVecI64x2'], value);
    },
    'all_true': function(value) {
      return Module['_BinaryenUnary'](module, Module['AllTrueVecI64x2'], value);
    },
    'shl': function(vec, shift) {
      return Module['_BinaryenSIMDShift'](module, Module['ShlVecI64x2'], vec, shift);
    },
    'shr_s': function(vec, shift) {
      return Module['_BinaryenSIMDShift'](module, Module['ShrSVecI64x2'], vec, shift);
    },
    'shr_u': function(vec, shift) {
      return Module['_BinaryenSIMDShift'](module, Module['ShrUVecI64x2'], vec, shift);
    },
    'add': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AddVecI64x2'], left, right);
    },
    'sub': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['SubVecI64x2'], left, right);
    },
    'trunc_sat_f64x2_s': function(value) {
      return Module['_BinaryenUnary'](module, Module['TruncSatSVecF64x2ToVecI64x2'], value);
    },
    'trunc_sat_f64x2_u': function(value) {
      return Module['_BinaryenUnary'](module, Module['TruncSatUVecF64x2ToVecI64x2'], value);
    },
    'load32x2_s': function(offset, align, ptr) {
      return Module['_BinaryenSIMDLoad'](module, Module['LoadExtSVec32x2ToVecI64x2'], offset, align, ptr);
    },
    'load32x2_u': function(offset, align, ptr) {
      return Module['_BinaryenSIMDLoad'](module, Module['LoadExtUVec32x2ToVecI64x2'], offset, align, ptr);
    },
  };

  self['f32x4'] = {
    'splat': function(value) {
      return Module['_BinaryenUnary'](module, Module['SplatVecF32x4'], value);
    },
    'extract_lane': function(vec, index) {
      return Module['_BinaryenSIMDExtract'](module, Module['ExtractLaneVecF32x4'], vec, index);
    },
    'replace_lane': function(vec, index, value) {
      return Module['_BinaryenSIMDReplace'](module, Module['ReplaceLaneVecF32x4'], vec, index, value);
    },
    'eq': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['EqVecF32x4'], left, right);
    },
    'ne': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['NeVecF32x4'], left, right);
    },
    'lt': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LtVecF32x4'], left, right);
    },
    'gt': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GtVecF32x4'], left, right);
    },
    'le': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LeVecF32x4'], left, right);
    },
    'ge': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GeVecF32x4'], left, right);
    },
    'abs': function(value) {
      return Module['_BinaryenUnary'](module, Module['AbsVecF32x4'], value);
    },
    'neg': function(value) {
      return Module['_BinaryenUnary'](module, Module['NegVecF32x4'], value);
    },
    'sqrt': function(value) {
      return Module['_BinaryenUnary'](module, Module['SqrtVecF32x4'], value);
    },
    'qfma': function(a, b, c) {
      return Module['_BinaryenSIMDTernary'](module, Module['QFMAVecF32x4'], a, b, c);
    },
    'qfms': function(a, b, c) {
      return Module['_BinaryenSIMDTernary'](module, Module['QFMSVecF32x4'], a, b, c);
    },
    'add': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AddVecF32x4'], left, right);
    },
    'sub': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['SubVecF32x4'], left, right);
    },
    'mul': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MulVecF32x4'], left, right);
    },
    'div': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['DivVecF32x4'], left, right);
    },
    'min': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MinVecF32x4'], left, right);
    },
    'max': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MaxVecF32x4'], left, right);
    },
    'convert_i32x4_s': function(value) {
      return Module['_BinaryenUnary'](module, Module['ConvertSVecI32x4ToVecF32x4'], value);
    },
    'convert_i32x4_u': function(value) {
      return Module['_BinaryenUnary'](module, Module['ConvertUVecI32x4ToVecF32x4'], value);
    },
  };

  self['f64x2'] = {
    'splat': function(value) {
      return Module['_BinaryenUnary'](module, Module['SplatVecF64x2'], value);
    },
    'extract_lane': function(vec, index) {
      return Module['_BinaryenSIMDExtract'](module, Module['ExtractLaneVecF64x2'], vec, index);
    },
    'replace_lane': function(vec, index, value) {
      return Module['_BinaryenSIMDReplace'](module, Module['ReplaceLaneVecF64x2'], vec, index, value);
    },
    'eq': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['EqVecF64x2'], left, right);
    },
    'ne': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['NeVecF64x2'], left, right);
    },
    'lt': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LtVecF64x2'], left, right);
    },
    'gt': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GtVecF64x2'], left, right);
    },
    'le': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LeVecF64x2'], left, right);
    },
    'ge': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GeVecF64x2'], left, right);
    },
    'abs': function(value) {
      return Module['_BinaryenUnary'](module, Module['AbsVecF64x2'], value);
    },
    'neg': function(value) {
      return Module['_BinaryenUnary'](module, Module['NegVecF64x2'], value);
    },
    'sqrt': function(value) {
      return Module['_BinaryenUnary'](module, Module['SqrtVecF64x2'], value);
    },
    'qfma': function(a, b, c) {
      return Module['_BinaryenSIMDTernary'](module, Module['QFMAVecF64x2'], a, b, c);
    },
    'qfms': function(a, b, c) {
      return Module['_BinaryenSIMDTernary'](module, Module['QFMSVecF64x2'], a, b, c);
    },
    'add': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AddVecF64x2'], left, right);
    },
    'sub': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['SubVecF64x2'], left, right);
    },
    'mul': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MulVecF64x2'], left, right);
    },
    'div': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['DivVecF64x2'], left, right);
    },
    'min': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MinVecF64x2'], left, right);
    },
    'max': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MaxVecF64x2'], left, right);
    },
    'convert_i64x2_s': function(value) {
      return Module['_BinaryenUnary'](module, Module['ConvertSVecI64x2ToVecF64x2'], value);
    },
    'convert_i64x2_u': function(value) {
      return Module['_BinaryenUnary'](module, Module['ConvertUVecI64x2ToVecF64x2'], value);
    },
  };

  self['v8x16'] = {
    'shuffle': function(left, right, mask) {
      return preserveStack(function() {
        return Module['_BinaryenSIMDShuffle'](module, left, right, i8sToStack(mask));
      });
    },
    'swizzle': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['SwizzleVec8x16'], left, right);
    },
    'load_splat': function(offset, align, ptr) {
      return Module['_BinaryenSIMDLoad'](module, Module['LoadSplatVec8x16'], offset, align, ptr);
    },
  };

  self['v16x8'] = {
    'load_splat': function(offset, align, ptr) {
      return Module['_BinaryenSIMDLoad'](module, Module['LoadSplatVec16x8'], offset, align, ptr);
    },
  };

  self['v32x4'] = {
    'load_splat': function(offset, align, ptr) {
      return Module['_BinaryenSIMDLoad'](module, Module['LoadSplatVec32x4'], offset, align, ptr);
    },
  };

  self['v64x2'] = {
    'load_splat': function(offset, align, ptr) {
      return Module['_BinaryenSIMDLoad'](module, Module['LoadSplatVec64x2'], offset, align, ptr);
    },
  };

  self['anyref'] = {
    'pop': function() {
      return Module['_BinaryenPop'](module, Module['anyref']);
    }
  };

  self['exnref'] = {
    'pop': function() {
      return Module['_BinaryenPop'](module, Module['exnref']);
    }
  };

  self['select'] = function(condition, ifTrue, ifFalse) {
    return Module['_BinaryenSelect'](module, condition, ifTrue, ifFalse);
  };
  self['drop'] = function(value) {
    return Module['_BinaryenDrop'](module, value);
  };
  self['return'] = function(value) {
    return Module['_BinaryenReturn'](module, value);
  };
  self['host'] = function(op, name, operands) {
    if (!operands) operands = [];
    return preserveStack(function() {
      return Module['_BinaryenHost'](module, op, strToStack(name), i32sToStack(operands), operands.length);
    });
  };
  self['nop'] = function() {
    return Module['_BinaryenNop'](module);
  };
  self['unreachable'] = function() {
    return Module['_BinaryenUnreachable'](module);
  };

  self['atomic'] = {
    'notify': function(ptr, notifyCount) {
      return Module['_BinaryenAtomicNotify'](module, ptr, notifyCount);
    },
    'fence': function() {
      return Module['_BinaryenAtomicFence'](module);
    }
  };

  self['try'] = function(body, catchBody) {
    return Module['_BinaryenTry'](module, body, catchBody);
  };
  self['throw'] = function(event_, operands) {
    return preserveStack(function() {
      return Module['_BinaryenThrow'](module, strToStack(event_), i32sToStack(operands), operands.length);
    });
  };
  self['rethrow'] = function(exnref) {
    return Module['_BinaryenRethrow'](module, exnref);
  };
  self['br_on_exn'] = function(label, event_, exnref) {
    return preserveStack(function() {
      return Module['_BinaryenBrOnExn'](module, strToStack(label), strToStack(event_), exnref);
    });
  };
  self['push'] = function(value) {
    return Module['_BinaryenPush'](module, value);
  };

  // 'Module' operations
  self['addFunction'] = function(name, params, results, varTypes, body) {
    return preserveStack(function() {
      return Module['_BinaryenAddFunction'](module, strToStack(name), params, results, i32sToStack(varTypes), varTypes.length, body);
    });
  };
  self['getFunction'] = function(name) {
    return preserveStack(function() {
      return Module['_BinaryenGetFunction'](module, strToStack(name));
    });
  };
  self['removeFunction'] = function(name) {
    return preserveStack(function() {
      return Module['_BinaryenRemoveFunction'](module, strToStack(name));
    });
  };
  self['addGlobal'] = function(name, type, mutable, init) {
    return preserveStack(function() {
      return Module['_BinaryenAddGlobal'](module, strToStack(name), type, mutable, init);
    });
  }
  self['getGlobal'] = function(name) {
    return preserveStack(function() {
      return Module['_BinaryenGetGlobal'](module, strToStack(name));
    });
  };
  self['removeGlobal'] = function(name) {
    return preserveStack(function() {
      return Module['_BinaryenRemoveGlobal'](module, strToStack(name));
    });
  }
  self['addEvent'] = function(name, attribute, params, results) {
    return preserveStack(function() {
      return Module['_BinaryenAddEvent'](module, strToStack(name), attribute, params, results);
    });
  };
  self['getEvent'] = function(name) {
    return preserveStack(function() {
      return Module['_BinaryenGetEvent'](module, strToStack(name));
    });
  };
  self['removeEvent'] = function(name) {
    return preserveStack(function() {
      return Module['_BinaryenRemoveEvent'](module, strToStack(name));
    });
  };
  self['addFunctionImport'] = function(internalName, externalModuleName, externalBaseName, params, results) {
    return preserveStack(function() {
      return Module['_BinaryenAddFunctionImport'](module, strToStack(internalName), strToStack(externalModuleName), strToStack(externalBaseName), params, results);
    });
  };
  self['addTableImport'] = function(internalName, externalModuleName, externalBaseName) {
    return preserveStack(function() {
      return Module['_BinaryenAddTableImport'](module, strToStack(internalName), strToStack(externalModuleName), strToStack(externalBaseName));
    });
  };
  self['addMemoryImport'] = function(internalName, externalModuleName, externalBaseName, shared) {
    return preserveStack(function() {
      return Module['_BinaryenAddMemoryImport'](module, strToStack(internalName), strToStack(externalModuleName), strToStack(externalBaseName), shared);
    });
  };
  self['addGlobalImport'] = function(internalName, externalModuleName, externalBaseName, globalType, mutable) {
    return preserveStack(function() {
      return Module['_BinaryenAddGlobalImport'](module, strToStack(internalName), strToStack(externalModuleName), strToStack(externalBaseName), globalType, mutable);
    });
  };
  self['addEventImport'] = function(internalName, externalModuleName, externalBaseName, attribute, params, results) {
    return preserveStack(function() {
      return Module['_BinaryenAddEventImport'](module, strToStack(internalName), strToStack(externalModuleName), strToStack(externalBaseName), attribute, params, results);
    });
  };
  self['addExport'] = // deprecated
  self['addFunctionExport'] = function(internalName, externalName) {
    return preserveStack(function() {
      return Module['_BinaryenAddFunctionExport'](module, strToStack(internalName), strToStack(externalName));
    });
  };
  self['addTableExport'] = function(internalName, externalName) {
    return preserveStack(function() {
      return Module['_BinaryenAddTableExport'](module, strToStack(internalName), strToStack(externalName));
    });
  };
  self['addMemoryExport'] = function(internalName, externalName) {
    return preserveStack(function() {
      return Module['_BinaryenAddMemoryExport'](module, strToStack(internalName), strToStack(externalName));
    });
  };
  self['addGlobalExport'] = function(internalName, externalName) {
    return preserveStack(function() {
      return Module['_BinaryenAddGlobalExport'](module, strToStack(internalName), strToStack(externalName));
    });
  };
  self['addEventExport'] = function(internalName, externalName) {
    return preserveStack(function() {
      return Module['_BinaryenAddEventExport'](module, strToStack(internalName), strToStack(externalName));
    });
  };
  self['removeExport'] = function(externalName) {
    return preserveStack(function() {
      return Module['_BinaryenRemoveExport'](module, strToStack(externalName));
    });
  };
  self['setFunctionTable'] = function(initial, maximum, funcNames, offset) {
    return preserveStack(function() {
      return Module['_BinaryenSetFunctionTable'](module, initial, maximum,
        i32sToStack(funcNames.map(strToStack)),
        funcNames.length,
        offset || self['i32']['const'](0)
      );
    });
  };
  self['setMemory'] = function(initial, maximum, exportName, segments, shared) {
    // segments are assumed to be { passive: bool, offset: expression ref, data: array of 8-bit data }
    if (!segments) segments = [];
    return preserveStack(function() {
      return Module['_BinaryenSetMemory'](
        module, initial, maximum, strToStack(exportName),
        i32sToStack(
          segments.map(function(segment) {
            return allocate(segment.data, 'i8', ALLOC_STACK);
          })
        ),
        i8sToStack(
          segments.map(function(segment) {
            return segment.passive;
          })
        ),
        i32sToStack(
          segments.map(function(segment) {
            return segment.offset;
          })
        ),
        i32sToStack(
          segments.map(function(segment) {
            return segment.data.length;
          })
        ),
        segments.length,
        shared
      );
    });
  };
  self['getNumMemorySegments'] = function() {
    return Module['_BinaryenGetNumMemorySegments'](module);
  }
  self['getMemorySegmentInfoByIndex'] = function(id) {
    return {
      'byteOffset': Module['_BinaryenGetMemorySegmentByteOffset'](module, id),
      'data': (function(){
        var size = Module['_BinaryenGetMemorySegmentByteLength'](module, id);
        var ptr = _malloc(size);
        Module['_BinaryenCopyMemorySegmentData'](module, id, ptr);
        var res = new Uint8Array(size);
        res.set(new Uint8Array(buffer, ptr, size));
        _free(ptr);
        return res.buffer;
      })()
    };
  }
  self['setStart'] = function(start) {
    return Module['_BinaryenSetStart'](module, start);
  };
  self['getFeatures'] = function() {
    return Module['_BinaryenModuleGetFeatures'](module);
  };
  self['setFeatures'] = function(features) {
    Module['_BinaryenModuleSetFeatures'](module, features);
  };
  self['addCustomSection'] = function(name, contents) {
    return preserveStack(function() {
      return Module['_BinaryenAddCustomSection'](module, strToStack(name), i8sToStack(contents), contents.length);
    });
  };
  self['getNumExports'] = function() {
    return Module['_BinaryenGetNumExports'](module);
  }
  self['getExportByIndex'] = function(id) {
    return Module['_BinaryenGetExportByIndex'](module, id);
  }
  self['getNumFunctions'] = function() {
    return Module['_BinaryenGetNumFunctions'](module);
  }
  self['getFunctionByIndex'] = function(id) {
    return Module['_BinaryenGetFunctionByIndex'](module, id);
  }
  self['emitText'] = function() {
    var old = out;
    var ret = '';
    out = function(x) { ret += x + '\n' };
    Module['_BinaryenModulePrint'](module);
    out = old;
    return ret;
  };
  self['emitStackIR'] = function(optimize) {
    self['runPasses'](['generate-stack-ir']);
    if (optimize) self['runPasses'](['optimize-stack-ir']);
    var old = out;
    var ret = '';
    out = function(x) { ret += x + '\n' };
    self['runPasses'](['print-stack-ir']);
    out = old;
    return ret;
  };
  self['emitAsmjs'] = function() {
    var old = out;
    var ret = '';
    out = function(x) { ret += x + '\n' };
    Module['_BinaryenModulePrintAsmjs'](module);
    out = old;
    return ret;
  };
  self['validate'] = function() {
    return Module['_BinaryenModuleValidate'](module);
  };
  self['optimize'] = function() {
    return Module['_BinaryenModuleOptimize'](module);
  };
  self['optimizeFunction'] = function(func) {
    if (typeof func === 'string') func = self['getFunction'](func);
    return Module['_BinaryenFunctionOptimize'](func, module);
  };
  self['runPasses'] = function(passes) {
    return preserveStack(function() {
      return Module['_BinaryenModuleRunPasses'](module, i32sToStack(
        passes.map(strToStack)
      ), passes.length);
    });
  };
  self['runPassesOnFunction'] = function(func, passes) {
    if (typeof func === 'string') func = self['getFunction'](func);
    return preserveStack(function() {
      return Module['_BinaryenFunctionRunPasses'](func, module, i32sToStack(
        passes.map(strToStack)
      ), passes.length);
    });
  };
  self['autoDrop'] = function() {
    return Module['_BinaryenModuleAutoDrop'](module);
  };
  self['dispose'] = function() {
    Module['_BinaryenModuleDispose'](module);
  };
  self['emitBinary'] = function(sourceMapUrl) {
    return preserveStack(function() {
      var tempBuffer = stackAlloc(_BinaryenSizeofAllocateAndWriteResult());
      Module['_BinaryenModuleAllocateAndWrite'](tempBuffer, module, strToStack(sourceMapUrl));
      var binaryPtr    = HEAPU32[ tempBuffer >>> 2     ];
      var binaryBytes  = HEAPU32[(tempBuffer >>> 2) + 1];
      var sourceMapPtr = HEAPU32[(tempBuffer >>> 2) + 2];
      try {
        var buffer = new Uint8Array(binaryBytes);
        buffer.set(HEAPU8.subarray(binaryPtr, binaryPtr + binaryBytes));
        return typeof sourceMapUrl === 'undefined'
          ? buffer
          : { 'binary': buffer, 'sourceMap': UTF8ToString(sourceMapPtr) };
      } finally {
        _free(binaryPtr);
        if (sourceMapPtr) _free(sourceMapPtr);
      }
    });
  };
  self['interpret'] = function() {
    return Module['_BinaryenModuleInterpret'](module);
  };
  self['addDebugInfoFileName'] = function(filename) {
    return preserveStack(function() {
      return Module['_BinaryenModuleAddDebugInfoFileName'](module, strToStack(filename));
    });
  };
  self['getDebugInfoFileName'] = function(index) {
    return UTF8ToString(Module['_BinaryenModuleGetDebugInfoFileName'](module, index));
  };
  self['setDebugLocation'] = function(func, expr, fileIndex, lineNumber, columnNumber) {
    return Module['_BinaryenFunctionSetDebugLocation'](func, expr, fileIndex, lineNumber, columnNumber);
  };

  return self;
}
Module['wrapModule'] = wrapModule;

// 'Relooper' interface
Module['Relooper'] = function(module) {
  assert(module && typeof module === 'object' && module['ptr'] && module['block'] && module['if']); // guard against incorrect old API usage
  var relooper = Module['_RelooperCreate'](module['ptr']);
  this['ptr'] = relooper;

  this['addBlock'] = function(code) {
    return Module['_RelooperAddBlock'](relooper, code);
  };
  this['addBranch'] = function(from, to, condition, code) {
    return Module['_RelooperAddBranch'](from, to, condition, code);
  };
  this['addBlockWithSwitch'] = function(code, condition) {
    return Module['_RelooperAddBlockWithSwitch'](relooper, code, condition);
  };
  this['addBranchForSwitch'] = function(from, to, indexes, code) {
    return preserveStack(function() {
      return Module['_RelooperAddBranchForSwitch'](from, to, i32sToStack(indexes), indexes.length, code);
    });
  };
  this['renderAndDispose'] = function(entry, labelHelper) {
    return Module['_RelooperRenderAndDispose'](relooper, entry, labelHelper);
  };
};

function getAllNested(ref, numFn, getFn) {
  var num = numFn(ref);
  var ret = new Array(num);
  for (var i = 0; i < num; ++i) ret[i] = getFn(ref, i);
  return ret;
}

// Gets the specific id of an 'Expression'
Module['getExpressionId'] = function(expr) {
  return Module['_BinaryenExpressionGetId'](expr);
};

// Gets the result type of an 'Expression'
Module['getExpressionType'] = function(expr) {
  return Module['_BinaryenExpressionGetType'](expr);
};

// Obtains information about an 'Expression'
Module['getExpressionInfo'] = function(expr) {
  var id = Module['_BinaryenExpressionGetId'](expr);
  var type = Module['_BinaryenExpressionGetType'](expr);
  switch (id) {
    case Module['BlockId']:
      return {
        'id': id,
        'type': type,
        'name': UTF8ToString(Module['_BinaryenBlockGetName'](expr)),
        'children': getAllNested(expr, Module['_BinaryenBlockGetNumChildren'], Module['_BinaryenBlockGetChild'])
      };
    case Module['IfId']:
      return {
        'id': id,
        'type': type,
        'condition': Module['_BinaryenIfGetCondition'](expr),
        'ifTrue': Module['_BinaryenIfGetIfTrue'](expr),
        'ifFalse': Module['_BinaryenIfGetIfFalse'](expr)
      };
    case Module['LoopId']:
      return {
        'id': id,
        'type': type,
        'name': UTF8ToString(Module['_BinaryenLoopGetName'](expr)),
        'body': Module['_BinaryenLoopGetBody'](expr)
      };
    case Module['BreakId']:
      return {
        'id': id,
        'type': type,
        'name': UTF8ToString(Module['_BinaryenBreakGetName'](expr)),
        'condition': Module['_BinaryenBreakGetCondition'](expr),
        'value': Module['_BinaryenBreakGetValue'](expr)
      };
    case Module['SwitchId']:
      return {
        'id': id,
        'type': type,
        'names': getAllNested(expr, Module['_BinaryenSwitchGetNumNames'], Module['_BinaryenSwitchGetName']).map(UTF8ToString),
        'defaultName': UTF8ToString(Module['_BinaryenSwitchGetDefaultName'](expr)),
        'condition': Module['_BinaryenSwitchGetCondition'](expr),
        'value': Module['_BinaryenSwitchGetValue'](expr)
      };
    case Module['CallId']:
      return {
        'id': id,
        'type': type,
        'target': UTF8ToString(Module['_BinaryenCallGetTarget'](expr)),
        'operands': getAllNested(expr, Module[ '_BinaryenCallGetNumOperands'], Module['_BinaryenCallGetOperand'])
      };
    case Module['CallIndirectId']:
      return {
        'id': id,
        'type': type,
        'target': Module['_BinaryenCallIndirectGetTarget'](expr),
        'operands': getAllNested(expr, Module['_BinaryenCallIndirectGetNumOperands'], Module['_BinaryenCallIndirectGetOperand'])
      };
    case Module['LocalGetId']:
      return {
        'id': id,
        'type': type,
        'index': Module['_BinaryenLocalGetGetIndex'](expr)
      };
    case Module['LocalSetId']:
      return {
        'id': id,
        'type': type,
        'isTee': Boolean(Module['_BinaryenLocalSetIsTee'](expr)),
        'index': Module['_BinaryenLocalSetGetIndex'](expr),
        'value': Module['_BinaryenLocalSetGetValue'](expr)
      };
    case Module['GlobalGetId']:
      return {
        'id': id,
        'type': type,
        'name': UTF8ToString(Module['_BinaryenGlobalGetGetName'](expr))
      };
    case Module['GlobalSetId']:
      return {
        'id': id,
        'type': type,
        'name': UTF8ToString(Module['_BinaryenGlobalSetGetName'](expr)),
        'value': Module['_BinaryenGlobalSetGetValue'](expr)
      };
    case Module['LoadId']:
      return {
        'id': id,
        'type': type,
        'isAtomic': Boolean(Module['_BinaryenLoadIsAtomic'](expr)),
        'isSigned': Boolean(Module['_BinaryenLoadIsSigned'](expr)),
        'offset': Module['_BinaryenLoadGetOffset'](expr),
        'bytes': Module['_BinaryenLoadGetBytes'](expr),
        'align': Module['_BinaryenLoadGetAlign'](expr),
        'ptr': Module['_BinaryenLoadGetPtr'](expr)
      };
    case Module['StoreId']:
      return {
        'id': id,
        'type': type,
        'isAtomic': Boolean(Module['_BinaryenStoreIsAtomic'](expr)),
        'offset': Module['_BinaryenStoreGetOffset'](expr),
        'bytes': Module['_BinaryenStoreGetBytes'](expr),
        'align': Module['_BinaryenStoreGetAlign'](expr),
        'ptr': Module['_BinaryenStoreGetPtr'](expr),
        'value': Module['_BinaryenStoreGetValue'](expr)
      };
    case Module['ConstId']: {
      var value;
      switch (type) {
        case Module['i32']: value = Module['_BinaryenConstGetValueI32'](expr); break;
        case Module['i64']: value = { 'low': Module['_BinaryenConstGetValueI64Low'](expr), 'high': Module['_BinaryenConstGetValueI64High'](expr) }; break;
        case Module['f32']: value = Module['_BinaryenConstGetValueF32'](expr); break;
        case Module['f64']: value = Module['_BinaryenConstGetValueF64'](expr); break;
        case Module['v128']: {
          preserveStack(function() {
            var tempBuffer = stackAlloc(16);
            Module['_BinaryenConstGetValueV128'](expr, tempBuffer);
            value = new Array(16);
            for (var i = 0 ; i < 16; i++) {
              value[i] = HEAPU8[tempBuffer + i];
            }
          });
          break;
        }
        default: throw Error('unexpected type: ' + type);
      }
      return {
        'id': id,
        'type': type,
        'value': value
      };
    }
    case Module['UnaryId']:
      return {
        'id': id,
        'type': type,
        'op': Module['_BinaryenUnaryGetOp'](expr),
        'value': Module['_BinaryenUnaryGetValue'](expr)
      };
    case Module['BinaryId']:
      return {
        'id': id,
        'type': type,
        'op': Module['_BinaryenBinaryGetOp'](expr),
        'left': Module['_BinaryenBinaryGetLeft'](expr),
        'right':  Module['_BinaryenBinaryGetRight'](expr)
      };
    case Module['SelectId']:
      return {
        'id': id,
        'type': type,
        'ifTrue': Module['_BinaryenSelectGetIfTrue'](expr),
        'ifFalse': Module['_BinaryenSelectGetIfFalse'](expr),
        'condition': Module['_BinaryenSelectGetCondition'](expr)
      };
    case Module['DropId']:
      return {
        'id': id,
        'type': type,
        'value': Module['_BinaryenDropGetValue'](expr)
      };
    case Module['ReturnId']:
      return {
        'id': id,
        'type': type,
        'value': Module['_BinaryenReturnGetValue'](expr)
      };
    case Module['NopId']:
    case Module['UnreachableId']:
    case Module['PopId']:
      return {
        'id': id,
        'type': type
      };
    case Module['HostId']:
      return {
        'id': id,
        'type': type,
        'op': Module['_BinaryenHostGetOp'](expr),
        'nameOperand': UTF8ToString(Module['_BinaryenHostGetNameOperand'](expr)),
        'operands': getAllNested(expr, Module['_BinaryenHostGetNumOperands'], Module['_BinaryenHostGetOperand'])
      };
    case Module['AtomicRMWId']:
      return {
        'id': id,
        'type': type,
        'op': Module['_BinaryenAtomicRMWGetOp'](expr),
        'bytes': Module['_BinaryenAtomicRMWGetBytes'](expr),
        'offset': Module['_BinaryenAtomicRMWGetOffset'](expr),
        'ptr': Module['_BinaryenAtomicRMWGetPtr'](expr),
        'value': Module['_BinaryenAtomicRMWGetValue'](expr)
      };
    case Module['AtomicCmpxchgId']:
      return {
        'id': id,
        'type': type,
        'bytes': Module['_BinaryenAtomicCmpxchgGetBytes'](expr),
        'offset': Module['_BinaryenAtomicCmpxchgGetOffset'](expr),
        'ptr': Module['_BinaryenAtomicCmpxchgGetPtr'](expr),
        'expected': Module['_BinaryenAtomicCmpxchgGetExpected'](expr),
        'replacement': Module['_BinaryenAtomicCmpxchgGetReplacement'](expr)
      };
    case Module['AtomicWaitId']:
      return {
        'id': id,
        'type': type,
        'ptr': Module['_BinaryenAtomicWaitGetPtr'](expr),
        'expected': Module['_BinaryenAtomicWaitGetExpected'](expr),
        'timeout': Module['_BinaryenAtomicWaitGetTimeout'](expr),
        'expectedType': Module['_BinaryenAtomicWaitGetExpectedType'](expr)
      };
    case Module['AtomicNotifyId']:
      return {
        'id': id,
        'type': type,
        'ptr': Module['_BinaryenAtomicNotifyGetPtr'](expr),
        'notifyCount': Module['_BinaryenAtomicNotifyGetNotifyCount'](expr)
      };
    case Module['AtomicFenceId']:
      return {
        'id': id,
        'type': type,
        'order': Module['_BinaryenAtomicFenceGetOrder'](expr)
      };
    case Module['SIMDExtractId']:
      return {
        'id': id,
        'type': type,
        'op': Module['_BinaryenSIMDExtractGetOp'](expr),
        'vec': Module['_BinaryenSIMDExtractGetVec'](expr),
        'index': Module['_BinaryenSIMDExtractGetIndex'](expr)
      };
    case Module['SIMDReplaceId']:
      return {
        'id': id,
        'type': type,
        'op': Module['_BinaryenSIMDReplaceGetOp'](expr),
        'vec': Module['_BinaryenSIMDReplaceGetVec'](expr),
        'index': Module['_BinaryenSIMDReplaceGetIndex'](expr),
        'value': Module['_BinaryenSIMDReplaceGetValue'](expr)
      };
    case Module['SIMDShuffleId']:
      return preserveStack(function() {
        var tempBuffer = stackAlloc(16);
        Module['_BinaryenSIMDShuffleGetMask'](expr, tempBuffer);
        var mask = new Array(16);
        for (var i = 0 ; i < 16; i++) {
          mask[i] = HEAPU8[tempBuffer + i];
        }
        return {
          'id': id,
          'type': type,
          'left': Module['_BinaryenSIMDShuffleGetLeft'](expr),
          'right': Module['_BinaryenSIMDShuffleGetRight'](expr),
          'mask': mask
        };
      });
    case Module['SIMDTernaryId']:
      return {
        'id': id,
        'type': type,
        'op': Module['_BinaryenSIMDTernaryGetOp'](expr),
        'a': Module['_BinaryenSIMDTernaryGetA'](expr),
        'b': Module['_BinaryenSIMDTernaryGetB'](expr),
        'c': Module['_BinaryenSIMDTernaryGetC'](expr)
      };
    case Module['SIMDShiftId']:
      return {
        'id': id,
        'type': type,
        'op': Module['_BinaryenSIMDShiftGetOp'](expr),
        'vec': Module['_BinaryenSIMDShiftGetVec'](expr),
        'shift': Module['_BinaryenSIMDShiftGetShift'](expr)
      };
    case Module['SIMDLoadId']:
      return {
        'id': id,
        'type': type,
        'op': Module['_BinaryenSIMDLoadGetOp'](expr),
        'offset': Module['_BinaryenSIMDLoadGetOffset'](expr),
        'align': Module['_BinaryenSIMDLoadGetAlign'](expr),
        'ptr': Module['_BinaryenSIMDLoadGetPtr'](expr)
      };
    case Module['MemoryInitId']:
      return {
        'id': id,
        'segment': Module['_BinaryenMemoryInitGetSegment'](expr),
        'dest': Module['_BinaryenMemoryInitGetDest'](expr),
        'offset': Module['_BinaryenMemoryInitGetOffset'](expr),
        'size': Module['_BinaryenMemoryInitGetSize'](expr)
      };
    case Module['DataDropId']:
      return {
        'id': id,
        'segment': Module['_BinaryenDataDropGetSegment'](expr),
      };
    case Module['MemoryCopyId']:
      return {
        'id': id,
        'dest': Module['_BinaryenMemoryCopyGetDest'](expr),
        'source': Module['_BinaryenMemoryCopyGetSource'](expr),
        'size': Module['_BinaryenMemoryCopyGetSize'](expr)
      };
    case Module['MemoryFillId']:
      return {
        'id': id,
        'dest': Module['_BinaryenMemoryFillGetDest'](expr),
        'value': Module['_BinaryenMemoryFillGetValue'](expr),
        'size': Module['_BinaryenMemoryFillGetSize'](expr)
      };
    case Module['TryId']:
      return {
        'id': id,
        'type': type,
        'body': Module['_BinaryenTryGetBody'](expr),
        'catchBody': Module['_BinaryenTryGetCatchBody'](expr)
      };
    case Module['ThrowId']:
      return {
        'id': id,
        'type': type,
        'event': UTF8ToString(Module['_BinaryenThrowGetEvent'](expr)),
        'operands': getAllNested(expr, Module['_BinaryenThrowGetNumOperands'], Module['_BinaryenThrowGetOperand'])
      };
    case Module['RethrowId']:
      return {
        'id': id,
        'type': type,
        'exnref': Module['_BinaryenRethrowGetExnref'](expr)
      };
    case Module['BrOnExnId']:
      return {
        'id': id,
        'type': type,
        'name': UTF8ToString(Module['_BinaryenBrOnExnGetName'](expr)),
        'event': UTF8ToString(Module['_BinaryenBrOnExnGetEvent'](expr)),
        'exnref': Module['_BinaryenBrOnExnGetExnref'](expr)
      };
    case Module['PushId']:
      return {
        'id': id,
        'value': Module['_BinaryenPushGetValue'](expr)
      };

    default:
      throw Error('unexpected id: ' + id);
  }
};

// Obtains information about a 'Function'
Module['getFunctionInfo'] = function(func) {
  return {
    'name': UTF8ToString(Module['_BinaryenFunctionGetName'](func)),
    'module': UTF8ToString(Module['_BinaryenFunctionImportGetModule'](func)),
    'base': UTF8ToString(Module['_BinaryenFunctionImportGetBase'](func)),
    'params': Module['_BinaryenFunctionGetParams'](func),
    'results': Module['_BinaryenFunctionGetResults'](func),
    'vars': getAllNested(func, Module['_BinaryenFunctionGetNumVars'], Module['_BinaryenFunctionGetVar']),
    'body': Module['_BinaryenFunctionGetBody'](func)
  };
};

// Obtains information about a 'Global'
Module['getGlobalInfo'] = function(global) {
  return {
    'name': UTF8ToString(Module['_BinaryenGlobalGetName'](global)),
    'module': UTF8ToString(Module['_BinaryenGlobalImportGetModule'](global)),
    'base': UTF8ToString(Module['_BinaryenGlobalImportGetBase'](global)),
    'type': Module['_BinaryenGlobalGetType'](global),
    'mutable': Boolean(Module['_BinaryenGlobalIsMutable'](global)),
    'init': Module['_BinaryenGlobalGetInitExpr'](global)
  };
};

// Obtains information about a 'Event'
Module['getEventInfo'] = function(event_) {
  return {
    'name': UTF8ToString(Module['_BinaryenEventGetName'](event_)),
    'module': UTF8ToString(Module['_BinaryenEventImportGetModule'](event_)),
    'base': UTF8ToString(Module['_BinaryenEventImportGetBase'](event_)),
    'attribute': Module['_BinaryenEventGetAttribute'](event_),
    'params': Module['_BinaryenEventGetParams'](event_),
    'results': Module['_BinaryenEventGetResults'](event_)
  };
};

// Obtains information about an 'Export'
Module['getExportInfo'] = function(export_) {
  return {
    'kind': Module['_BinaryenExportGetKind'](export_),
    'name': UTF8ToString(Module['_BinaryenExportGetName'](export_)),
    'value': UTF8ToString(Module['_BinaryenExportGetValue'](export_))
  };
};

// Emits text format of an expression or a module
Module['emitText'] = function(expr) {
  if (typeof expr === 'object') {
    return expr.emitText();
  }
  var old = out;
  var ret = '';
  out = function(x) { ret += x + '\n' };
  Module['_BinaryenExpressionPrint'](expr);
  out = old;
  return ret;
};

// Parses a binary to a module

// If building with Emscripten ASSERTIONS, there is a property added to
// Module to guard against users mistakening using the removed readBinary()
// API. We must defuse that carefully.
Object.defineProperty(Module, 'readBinary', { writable: true });

Module['readBinary'] = function(data) {
  var buffer = allocate(data, 'i8', ALLOC_NORMAL);
  var ptr = Module['_BinaryenModuleRead'](buffer, data.length);
  _free(buffer);
  return wrapModule(ptr);
};

// Parses text format to a module
Module['parseText'] = function(text) {
  var buffer = _malloc(text.length + 1);
  writeAsciiToMemory(text, buffer);
  var ptr = Module['_BinaryenModuleParse'](buffer);
  _free(buffer);
  return wrapModule(ptr);
};

// Gets the currently set optimize level. 0, 1, 2 correspond to -O0, -O1, -O2, etc.
Module['getOptimizeLevel'] = function() {
  return Module['_BinaryenGetOptimizeLevel']();
};

// Sets the optimization level to use. 0, 1, 2 correspond to -O0, -O1, -O2, etc.
Module['setOptimizeLevel'] = function(level) {
  return Module['_BinaryenSetOptimizeLevel'](level);
};

// Gets the currently set shrink level. 0, 1, 2 correspond to -O0, -Os, -Oz.
Module['getShrinkLevel'] = function() {
  return Module['_BinaryenGetShrinkLevel']();
};

// Sets the shrink level to use. 0, 1, 2 correspond to -O0, -Os, -Oz.
Module['setShrinkLevel'] = function(level) {
  return Module['_BinaryenSetShrinkLevel'](level);
};

// Gets whether generating debug information is currently enabled or not.
Module['getDebugInfo'] = function() {
  return Boolean(Module['_BinaryenGetDebugInfo']());
};

// Enables or disables debug information in emitted binaries.
Module['setDebugInfo'] = function(on) {
  return Module['_BinaryenSetDebugInfo'](on);
};

// Enables or disables C-API tracing
Module['setAPITracing'] = function(on) {
  return Module['_BinaryenSetAPITracing'](on);
};

// Additional customizations

Module['exit'] = function(status) {
  // Instead of exiting silently on errors, always show an error with
  // a stack trace, for debuggability.
  if (status != 0) throw new Error('exiting due to error: ' + status);
};
