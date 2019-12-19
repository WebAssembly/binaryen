// kitchen sink, tests the full API

function cleanInfo(info) {
  var ret = {};
  for (var x in info) {
    if (x !== 'value') {
      ret[x] = info[x];
    }
  }
  return ret;
}

var module;

// helpers

var v128_bytes = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];

function assert(x) {
  if (!x) throw 'error!';
}

function makeInt32(x) {
  return module.i32.const(x);
}

function makeFloat32(x) {
  return module.f32.const(x);
}

function makeInt64(l, h) {
  return module.i64.const(l, h);
}

function makeFloat64(x) {
  return module.f64.const(x);
}

function makeVec128(i8s) {
  return module.v128.const(i8s)
}

function makeSomething() {
  return makeInt32(1337);
}

function makeDroppedInt32(x) {
  return module.drop(module.i32.const(x));
}

// tests

function test_types() {
  console.log("  // BinaryenTypeNone: " + Binaryen.none);
  console.log("  //", Binaryen.expandType(Binaryen.none));

  console.log("  // BinaryenTypeUnreachable: " + Binaryen.unreachable);
  console.log("  //", Binaryen.expandType(Binaryen.unreachable));

  console.log("  // BinaryenTypeInt32: " + Binaryen.i32);
  console.log("  //", Binaryen.expandType(Binaryen.i32));

  console.log("  // BinaryenTypeInt64: " + Binaryen.i64);
  console.log("  //", Binaryen.expandType(Binaryen.i64));

  console.log("  // BinaryenTypeFloat32: " + Binaryen.f32);
  console.log("  //", Binaryen.expandType(Binaryen.f32));

  console.log("  // BinaryenTypeFloat64: " + Binaryen.f64);
  console.log("  //", Binaryen.expandType(Binaryen.f64));

  console.log("  // BinaryenTypeVec128: " + Binaryen.v128);
  console.log("  //", Binaryen.expandType(Binaryen.v128));

  console.log("  // BinaryenTypeAnyref: " + Binaryen.anyref);
  console.log("  //", Binaryen.expandType(Binaryen.anyref));

  console.log("  // BinaryenTypeExnref: " + Binaryen.exnref);
  console.log("  //", Binaryen.expandType(Binaryen.exnref));

  console.log("  // BinaryenTypeAuto: " + Binaryen.auto);

  var i32_pair = Binaryen.createType([Binaryen.i32, Binaryen.i32]);
  console.log("  //", i32_pair, Binaryen.expandType(i32_pair));

  var duplicate_pair = Binaryen.createType([Binaryen.i32, Binaryen.i32]);
  console.log("  //", duplicate_pair, Binaryen.expandType(duplicate_pair));

  var f32_pair = Binaryen.createType([Binaryen.f32, Binaryen.f32]);
  console.log("  //", f32_pair, Binaryen.expandType(f32_pair));
}

function test_features() {
  console.log("Binaryen.Features.MVP: " + Binaryen.Features.MVP);
  console.log("Binaryen.Features.Atomics: " + Binaryen.Features.Atomics);
  console.log("Binaryen.Features.BulkMemory: " + Binaryen.Features.BulkMemory);
  console.log("Binaryen.Features.MutableGlobals: " + Binaryen.Features.MutableGlobals);
  console.log("Binaryen.Features.NontrappingFPToInt: " + Binaryen.Features.NontrappingFPToInt);
  console.log("Binaryen.Features.SignExt: " + Binaryen.Features.SignExt);
  console.log("Binaryen.Features.SIMD128: " + Binaryen.Features.SIMD128);
  console.log("Binaryen.Features.ExceptionHandling: " + Binaryen.Features.ExceptionHandling);
  console.log("Binaryen.Features.TailCall: " + Binaryen.Features.TailCall);
  console.log("Binaryen.Features.ReferenceTypes: " + Binaryen.Features.ReferenceTypes);
  console.log("Binaryen.Features.All: " + Binaryen.Features.All);
}

function test_ids() {
  console.log("BinaryenInvalidId: " + Binaryen.InvalidId);
  console.log("BinaryenBlockId: " + Binaryen.BlockId);
  console.log("BinaryenIfId: " + Binaryen.IfId);
  console.log("BinaryenLoopId: " + Binaryen.LoopId);
  console.log("BinaryenBreakId: " + Binaryen.BreakId);
  console.log("BinaryenSwitchId: " + Binaryen.SwitchId);
  console.log("BinaryenCallId: " + Binaryen.CallId);
  console.log("BinaryenCallIndirectId: " + Binaryen.CallIndirectId);
  console.log("BinaryenLocalGetId: " + Binaryen.LocalGetId);
  console.log("BinaryenLocalSetId: " + Binaryen.LocalSetId);
  console.log("BinaryenGlobalGetId: " + Binaryen.GlobalGetId);
  console.log("BinaryenGlobalSetId: " + Binaryen.GlobalSetId);
  console.log("BinaryenLoadId: " + Binaryen.LoadId);
  console.log("BinaryenStoreId: " + Binaryen.StoreId);
  console.log("BinaryenConstId: " + Binaryen.ConstId);
  console.log("BinaryenUnaryId: " + Binaryen.UnaryId);
  console.log("BinaryenBinaryId: " + Binaryen.BinaryId);
  console.log("BinaryenSelectId: " + Binaryen.SelectId);
  console.log("BinaryenDropId: " + Binaryen.DropId);
  console.log("BinaryenReturnId: " + Binaryen.ReturnId);
  console.log("BinaryenHostId: " + Binaryen.HostId);
  console.log("BinaryenNopId: " + Binaryen.NopId);
  console.log("BinaryenUnreachableId: " + Binaryen.UnreachableId);
  console.log("BinaryenAtomicCmpxchgId: " + Binaryen.AtomicCmpxchgId);
  console.log("BinaryenAtomicRMWId: " + Binaryen.AtomicRMWId);
  console.log("BinaryenAtomicWaitId: " + Binaryen.AtomicWaitId);
  console.log("BinaryenAtomicNotifyId: " + Binaryen.AtomicNotifyId);
  console.log("BinaryenSIMDExtractId: " + Binaryen.SIMDExtractId);
  console.log("BinaryenSIMDReplaceId: " + Binaryen.SIMDReplaceId);
  console.log("BinaryenSIMDShuffleId: " + Binaryen.SIMDShuffleId);
  console.log("BinaryenSIMDTernaryId: " + Binaryen.SIMDTernaryId);
  console.log("BinaryenSIMDShiftId: " + Binaryen.SIMDShiftId);
  console.log("BinaryenSIMDLoadId: " + Binaryen.SIMDLoadId);
  console.log("MemoryInitId: " + Binaryen.MemoryInitId);
  console.log("DataDropId: " + Binaryen.DataDropId);
  console.log("MemoryCopyId: " + Binaryen.MemoryCopyId);
  console.log("MemoryFillId: " + Binaryen.MemoryFillId);
  console.log("TryId: " + Binaryen.TryId);
  console.log("ThrowId: " + Binaryen.ThrowId);
  console.log("RethrowId: " + Binaryen.RethrowId);
  console.log("BrOnExnId: " + Binaryen.BrOnExnId);
  console.log("PushId: " + Binaryen.PushId);
  console.log("PopId: " + Binaryen.PopId);
}

function test_core() {

  // Module creation

  module = new Binaryen.Module();

  // Create an event
  var event_ = module.addEvent("a-event", 0, Binaryen.i32, Binaryen.none);

  // Literals and consts

  var constI32 = module.i32.const(1),
      constI64 = module.i64.const(2),
      constF32 = module.f32.const(3.14),
      constF64 = module.f64.const(2.1828),
      constF32Bits = module.f32.const_bits(0xffff1234),
      constF64Bits = module.f64.const_bits(0x5678abcd, 0xffff1234);

  var iIfF = Binaryen.createType([Binaryen.i32, Binaryen.i64, Binaryen.f32, Binaryen.f64])

  var temp1 = makeInt32(1), temp2 = makeInt32(2), temp3 = makeInt32(3),
      temp4 = makeInt32(4), temp5 = makeInt32(5),
      temp6 = makeInt32(0), temp7 = makeInt32(1),
      temp8 = makeInt32(0), temp9 = makeInt32(1),
      temp10 = makeInt32(1), temp11 = makeInt32(3), temp12 = makeInt32(5),
      temp13 = makeInt32(10), temp14 = makeInt32(11),
      temp15 = makeInt32(110), temp16 = makeInt64(111);

  var valueList = [
    // Unary
    module.i32.clz(module.i32.const(-10)),
    module.i64.ctz(module.i64.const(-22, -1)),
    module.i32.popcnt(module.i32.const(-10)),
    module.f32.neg(module.f32.const(-33.612)),
    module.f64.abs(module.f64.const(-9005.841)),
    module.f32.ceil(module.f32.const(-33.612)),
    module.f64.floor(module.f64.const(-9005.841)),
    module.f32.trunc(module.f32.const(-33.612)),
    module.f32.nearest(module.f32.const(-33.612)),
    module.f64.sqrt(module.f64.const(-9005.841)),
    module.i32.eqz(module.i32.const(-10)),
    module.i64.extend_s(module.i32.const(-10)),
    module.i64.extend_u(module.i32.const(-10)),
    module.i32.wrap(module.i64.const(-22, -1)),
    module.i32.trunc_s.f32(module.f32.const(-33.612)),
    module.i64.trunc_s.f32(module.f32.const(-33.612)),
    module.i32.trunc_u.f32(module.f32.const(-33.612)),
    module.i64.trunc_u.f32(module.f32.const(-33.612)),
    module.i32.trunc_s.f64(module.f64.const(-9005.841)),
    module.i64.trunc_s.f64(module.f64.const(-9005.841)),
    module.i32.trunc_u.f64(module.f64.const(-9005.841)),
    module.i64.trunc_u.f64(module.f64.const(-9005.841)),
    module.i32.trunc_s_sat.f32(module.f32.const(-33.612)),
    module.i64.trunc_s_sat.f32(module.f32.const(-33.612)),
    module.i32.trunc_u_sat.f32(module.f32.const(-33.612)),
    module.i64.trunc_u_sat.f32(module.f32.const(-33.612)),
    module.i32.trunc_s_sat.f64(module.f64.const(-9005.841)),
    module.i64.trunc_s_sat.f64(module.f64.const(-9005.841)),
    module.i32.trunc_u_sat.f64(module.f64.const(-9005.841)),
    module.i64.trunc_u_sat.f64(module.f64.const(-9005.841)),
    module.i32.reinterpret(module.f32.const(-33.612)),
    module.i64.reinterpret(module.f64.const(-9005.841)),
    module.f32.convert_s.i32(module.i32.const(-10)),
    module.f64.convert_s.i32(module.i32.const(-10)),
    module.f32.convert_u.i32(module.i32.const(-10)),
    module.f64.convert_u.i32(module.i32.const(-10)),
    module.f32.convert_s.i64(module.i64.const(-22, -1)),
    module.f64.convert_s.i64(module.i64.const(-22, -1)),
    module.f32.convert_u.i64(module.i64.const(-22, -1)),
    module.f64.convert_u.i64(module.i64.const(-22, -1)),
    module.f64.promote(module.f32.const(-33.612)),
    module.f32.demote(module.f64.const(-9005.841)),
    module.f32.reinterpret(module.i32.const(-10)),
    module.f64.reinterpret(module.i64.const(-22, -1)),
    module.i8x16.splat(module.i32.const(42)),
    module.i16x8.splat(module.i32.const(42)),
    module.i32x4.splat(module.i32.const(42)),
    module.i64x2.splat(module.i64.const(123, 456)),
    module.f32x4.splat(module.f32.const(42.0)),
    module.f64x2.splat(module.f64.const(42.0)),
    module.v128.not(module.v128.const(v128_bytes)),
    module.i8x16.neg(module.v128.const(v128_bytes)),
    module.i8x16.any_true(module.v128.const(v128_bytes)),
    module.i8x16.all_true(module.v128.const(v128_bytes)),
    module.i16x8.neg(module.v128.const(v128_bytes)),
    module.i16x8.any_true(module.v128.const(v128_bytes)),
    module.i16x8.all_true(module.v128.const(v128_bytes)),
    module.i32x4.neg(module.v128.const(v128_bytes)),
    module.i32x4.any_true(module.v128.const(v128_bytes)),
    module.i32x4.all_true(module.v128.const(v128_bytes)),
    module.i64x2.neg(module.v128.const(v128_bytes)),
    module.i64x2.any_true(module.v128.const(v128_bytes)),
    module.i64x2.all_true(module.v128.const(v128_bytes)),
    module.f32x4.abs(module.v128.const(v128_bytes)),
    module.f32x4.neg(module.v128.const(v128_bytes)),
    module.f32x4.sqrt(module.v128.const(v128_bytes)),
    module.f64x2.abs(module.v128.const(v128_bytes)),
    module.f64x2.neg(module.v128.const(v128_bytes)),
    module.f64x2.sqrt(module.v128.const(v128_bytes)),
    module.i32x4.trunc_sat_f32x4_s(module.v128.const(v128_bytes)),
    module.i32x4.trunc_sat_f32x4_u(module.v128.const(v128_bytes)),
    module.i64x2.trunc_sat_f64x2_s(module.v128.const(v128_bytes)),
    module.i64x2.trunc_sat_f64x2_u(module.v128.const(v128_bytes)),
    module.f32x4.convert_i32x4_s(module.v128.const(v128_bytes)),
    module.f32x4.convert_i32x4_u(module.v128.const(v128_bytes)),
    module.f64x2.convert_i64x2_s(module.v128.const(v128_bytes)),
    module.f64x2.convert_i64x2_u(module.v128.const(v128_bytes)),
    module.i16x8.widen_low_i8x16_s(module.v128.const(v128_bytes)),
    module.i16x8.widen_high_i8x16_s(module.v128.const(v128_bytes)),
    module.i16x8.widen_low_i8x16_u(module.v128.const(v128_bytes)),
    module.i16x8.widen_high_i8x16_u(module.v128.const(v128_bytes)),
    module.i32x4.widen_low_i16x8_s(module.v128.const(v128_bytes)),
    module.i32x4.widen_high_i16x8_s(module.v128.const(v128_bytes)),
    module.i32x4.widen_low_i16x8_u(module.v128.const(v128_bytes)),
    module.i32x4.widen_high_i16x8_u(module.v128.const(v128_bytes)),
    // Binary
    module.i32.add(module.i32.const(-10), module.i32.const(-11)),
    module.f64.sub(module.f64.const(-9005.841), module.f64.const(-9007.333)),
    module.i32.div_s(module.i32.const(-10), module.i32.const(-11)),
    module.i64.div_u(module.i64.const(-22, 0), module.i64.const(-23, 0)),
    module.i64.rem_s(module.i64.const(-22, 0), module.i64.const(-23, 0)),
    module.i32.rem_u(module.i32.const(-10), module.i32.const(-11)),
    module.i32.and(module.i32.const(-10), module.i32.const(-11)),
    module.i64.or(module.i64.const(-22, 0), module.i64.const(-23, 0)),
    module.i32.xor(module.i32.const(-10), module.i32.const(-11)),
    module.i64.shl(module.i64.const(-22, 0), module.i64.const(-23, 0)),
    module.i64.shr_u(module.i64.const(-22, 0), module.i64.const(-23, 0)),
    module.i32.shr_s(module.i32.const(-10), module.i32.const(-11)),
    module.i32.rotl(module.i32.const(-10), module.i32.const(-11)),
    module.i64.rotr(module.i64.const(-22, 0), module.i64.const(-23, 0)),
    module.f32.div(module.f32.const(-33.612), module.f32.const(-62.5)),
    module.f64.copysign(module.f64.const(-9005.841), module.f64.const(-9007.333)),
    module.f32.min(module.f32.const(-33.612), module.f32.const(-62.5)),
    module.f64.max(module.f64.const(-9005.841), module.f64.const(-9007.333)),
    module.i32.eq(module.i32.const(-10), module.i32.const(-11)),
    module.f32.ne(module.f32.const(-33.612), module.f32.const(-62.5)),
    module.i32.lt_s(module.i32.const(-10), module.i32.const(-11)),
    module.i64.lt_u(module.i64.const(-22, 0), module.i64.const(-23, 0)),
    module.i64.le_s(module.i64.const(-22, 0), module.i64.const(-23, 0)),
    module.i32.le_u(module.i32.const(-10), module.i32.const(-11)),
    module.i64.gt_s(module.i64.const(-22, 0), module.i64.const(-23, 0)),
    module.i32.gt_u(module.i32.const(-10), module.i32.const(-11)),
    module.i32.ge_s(module.i32.const(-10), module.i32.const(-11)),
    module.i64.ge_u(module.i64.const(-22, 0), module.i64.const(-23, 0)),
    module.f32.lt(module.f32.const(-33.612), module.f32.const(-62.5)),
    module.f64.le(module.f64.const(-9005.841), module.f64.const(-9007.333)),
    module.f64.gt(module.f64.const(-9005.841), module.f64.const(-9007.333)),
    module.f32.ge(module.f32.const(-33.612), module.f32.const(-62.5)),
    module.i8x16.eq(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i8x16.ne(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i8x16.lt_s(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i8x16.lt_u(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i8x16.gt_s(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i8x16.gt_u(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i8x16.le_s(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i8x16.le_u(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i8x16.ge_s(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i8x16.ge_u(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i16x8.eq(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i16x8.ne(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i16x8.lt_s(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i16x8.lt_u(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i16x8.gt_s(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i16x8.gt_u(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i16x8.le_s(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i16x8.le_u(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i16x8.ge_s(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i16x8.ge_u(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i32x4.eq(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i32x4.ne(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i32x4.lt_s(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i32x4.lt_u(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i32x4.gt_s(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i32x4.gt_u(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i32x4.le_s(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i32x4.le_u(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i32x4.ge_s(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i32x4.ge_u(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.f32x4.eq(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.f32x4.ne(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.f32x4.lt(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.f32x4.gt(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.f32x4.le(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.f32x4.ge(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.f64x2.eq(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.f64x2.ne(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.f64x2.lt(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.f64x2.gt(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.f64x2.le(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.f64x2.ge(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.v128.and(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.v128.or(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.v128.xor(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.v128.andnot(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i8x16.add(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i8x16.add_saturate_s(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i8x16.add_saturate_u(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i8x16.sub(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i8x16.sub_saturate_s(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i8x16.sub_saturate_u(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i8x16.mul(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i8x16.min_s(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i8x16.min_u(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i8x16.max_s(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i8x16.max_u(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i8x16.avgr_u(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i16x8.add(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i16x8.add_saturate_s(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i16x8.add_saturate_u(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i16x8.sub(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i16x8.sub_saturate_s(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i16x8.sub_saturate_u(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i16x8.mul(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i16x8.min_s(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i16x8.min_u(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i16x8.max_s(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i16x8.max_u(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i16x8.avgr_u(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i32x4.add(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i32x4.sub(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i32x4.mul(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i32x4.min_s(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i32x4.min_u(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i32x4.max_s(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i32x4.max_u(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i32x4.dot_i16x8_s(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i64x2.add(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i64x2.sub(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.f32x4.add(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.f32x4.sub(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.f32x4.mul(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.f32x4.div(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.f32x4.min(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.f32x4.max(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.f64x2.add(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.f64x2.sub(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.f64x2.mul(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.f64x2.div(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.f64x2.min(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.f64x2.max(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i8x16.narrow_i16x8_s(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i8x16.narrow_i16x8_u(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i16x8.narrow_i32x4_s(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i16x8.narrow_i32x4_u(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.v8x16.swizzle(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    // SIMD lane manipulation
    module.i8x16.extract_lane_s(module.v128.const(v128_bytes), 1),
    module.i8x16.extract_lane_u(module.v128.const(v128_bytes), 1),
    module.i16x8.extract_lane_s(module.v128.const(v128_bytes), 1),
    module.i16x8.extract_lane_u(module.v128.const(v128_bytes), 1),
    module.i32x4.extract_lane(module.v128.const(v128_bytes), 1),
    module.i64x2.extract_lane(module.v128.const(v128_bytes), 1),
    module.f32x4.extract_lane(module.v128.const(v128_bytes), 1),
    module.f64x2.extract_lane(module.v128.const(v128_bytes), 1),
    module.i16x8.replace_lane(module.v128.const(v128_bytes), 1, module.i32.const(42)),
    module.i8x16.replace_lane(module.v128.const(v128_bytes), 1, module.i32.const(42)),
    module.i32x4.replace_lane(module.v128.const(v128_bytes), 1, module.i32.const(42)),
    module.i64x2.replace_lane(module.v128.const(v128_bytes), 1, module.i64.const(42, 43)),
    module.f32x4.replace_lane(module.v128.const(v128_bytes), 1, module.f32.const(42)),
    module.f64x2.replace_lane(module.v128.const(v128_bytes), 1, module.f64.const(42)),
    // SIMD shift
    module.i8x16.shl(module.v128.const(v128_bytes), module.i32.const(1)),
    module.i8x16.shr_s(module.v128.const(v128_bytes), module.i32.const(1)),
    module.i8x16.shr_u(module.v128.const(v128_bytes), module.i32.const(1)),
    module.i16x8.shl(module.v128.const(v128_bytes), module.i32.const(1)),
    module.i16x8.shr_s(module.v128.const(v128_bytes), module.i32.const(1)),
    module.i16x8.shr_u(module.v128.const(v128_bytes), module.i32.const(1)),
    module.i32x4.shl(module.v128.const(v128_bytes), module.i32.const(1)),
    module.i32x4.shr_s(module.v128.const(v128_bytes), module.i32.const(1)),
    module.i32x4.shr_u(module.v128.const(v128_bytes), module.i32.const(1)),
    module.i64x2.shl(module.v128.const(v128_bytes), module.i32.const(1)),
    module.i64x2.shr_s(module.v128.const(v128_bytes), module.i32.const(1)),
    module.i64x2.shr_u(module.v128.const(v128_bytes), module.i32.const(1)),
    // SIMD load
    module.v8x16.load_splat(0, 1, module.i32.const(128)),
    module.v16x8.load_splat(16, 1, module.i32.const(128)),
    module.v32x4.load_splat(16, 4, module.i32.const(128)),
    module.v64x2.load_splat(0, 4, module.i32.const(128)),
    module.i16x8.load8x8_s(0, 8, module.i32.const(128)),
    module.i16x8.load8x8_u(0, 8, module.i32.const(128)),
    module.i32x4.load16x4_s(0, 8, module.i32.const(128)),
    module.i32x4.load16x4_u(0, 8, module.i32.const(128)),
    module.i64x2.load32x2_s(0, 8, module.i32.const(128)),
    module.i64x2.load32x2_u(0, 8, module.i32.const(128)),
    // Other SIMD
    module.v8x16.shuffle(module.v128.const(v128_bytes), module.v128.const(v128_bytes), v128_bytes),
    module.v128.bitselect(module.v128.const(v128_bytes), module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.f32x4.qfma(module.v128.const(v128_bytes), module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.f32x4.qfms(module.v128.const(v128_bytes), module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.f64x2.qfma(module.v128.const(v128_bytes), module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.f64x2.qfms(module.v128.const(v128_bytes), module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    // Bulk memory
    module.memory.init(0, makeInt32(1024), makeInt32(0), makeInt32(12)),
    module.data.drop(0),
    module.memory.copy(makeInt32(2048), makeInt32(1024), makeInt32(12)),
    module.memory.fill(makeInt32(0), makeInt32(42), makeInt32(1024)),
    // All the rest
    module.block('', []), // block with no name
    module.if(temp1, temp2, temp3),
    module.if(temp4, temp5),
    module.loop("in", makeInt32(0)),
    module.loop(null, makeInt32(0)),
    module.break("the-value", temp6, temp7),
    module.break("the-nothing", makeInt32(2)),
    module.break("the-value", null, makeInt32(3)),
    module.break("the-nothing"),
    module.switch([ "the-value" ], "the-value", temp8, temp9),
    module.switch([ "the-nothing" ], "the-nothing", makeInt32(2)),
    module.i32.eqz( // check the output type of the call node
      module.call("kitchen()sinker", [ makeInt32(13), makeInt64(37, 0), makeFloat32(1.3), makeFloat64(3.7) ], Binaryen.i32)
    ),
    module.i32.eqz( // check the output type of the call node
      module.i32.trunc_s.f32(
        module.call("an-imported", [ makeInt32(13), makeFloat64(3.7) ], Binaryen.f32)
      )
    ),
    module.i32.eqz( // check the output type of the call node
      module.callIndirect(makeInt32(2449), [ makeInt32(13), makeInt64(37, 0), makeFloat32(1.3), makeFloat64(3.7) ], iIfF, Binaryen.i32)
    ),
    module.drop(module.local.get(0, Binaryen.i32)),
    module.local.set(0, makeInt32(101)),
    module.drop(module.local.tee(0, makeInt32(102), Binaryen.i32)),
    module.i32.load(0, 0, makeInt32(1)),
    module.i64.load16_s(2, 1, makeInt32(8)),
    module.f32.load(0, 0, makeInt32(2)),
    module.f64.load(2, 8, makeInt32(9)),
    module.i32.store(0, 0, temp13, temp14),
    module.i64.store(2, 4, temp15, temp16),
    module.select(temp10, temp11, temp12),
    module.return(makeInt32(1337)),
    // Tail Call
    module.returnCall("kitchen()sinker", [ makeInt32(13), makeInt64(37, 0), makeFloat32(1.3), makeFloat64(3.7) ], Binaryen.i32),
    module.returnCallIndirect(makeInt32(2449), [ makeInt32(13), makeInt64(37, 0), makeFloat32(1.3), makeFloat64(3.7) ], iIfF, Binaryen.i32),

    // Exception handling
    module.try(
      module.throw("a-event", [module.i32.const(0)]),
      module.block(null, [
        module.local.set(5, module.exnref.pop()),
        module.drop(
          module.block("try-block", [
            module.rethrow(
              module.br_on_exn("try-block", "a-event",
                module.local.get(5, Binaryen.exnref)),
            )
          ], Binaryen.i32)
        )
      ]
      )
    ),

    // Atomics
    module.i32.atomic.store(0,
      module.i32.const(0),
      module.i32.atomic.load(0,
        module.i32.const(0)
      )
    ),
    module.drop(
      module.i32.atomic.wait(
        module.i32.const(0),
        module.i32.const(0),
        module.i64.const(0)
      )
    ),
    module.drop(
      module.atomic.notify(
        module.i32.const(0),
        module.i32.const(0)
      )
    ),
    module.atomic.fence(),

    // Push and pop
    module.push(module.i32.pop()),
    module.push(module.i64.pop()),
    module.push(module.f32.pop()),
    module.push(module.f64.pop()),
    module.push(module.v128.pop()),
    module.push(module.anyref.pop()),
    module.push(module.exnref.pop()),
    // TODO: Host
    module.nop(),
    module.unreachable(),
  ];

  // Test expression utility
  console.log("getExpressionInfo=" + JSON.stringify(cleanInfo(Binaryen.getExpressionInfo(valueList[3]))));
  console.log(Binaryen.emitText(valueList[3])); // test printing a standalone expression

  console.log("getExpressionInfo(i32.const)=" + JSON.stringify(Binaryen.getExpressionInfo(module.i32.const(5))));
  console.log("getExpressionInfo(i64.const)=" + JSON.stringify(Binaryen.getExpressionInfo(module.i64.const(6, 7))));
  console.log("getExpressionInfo(f32.const)=" + JSON.stringify(Binaryen.getExpressionInfo(module.f32.const(8.5))));
  console.log("getExpressionInfo(f64.const)=" + JSON.stringify(Binaryen.getExpressionInfo(module.f64.const(9.5))));

  // Make the main body of the function. and one block with a return value, one without
  var value = module.block("the-value", valueList);
  var droppedValue = module.drop(value);
  var nothing = module.block("the-nothing", [ droppedValue ]);
  var body = module.block("the-body", [ nothing, makeInt32(42) ]);

  // Create the function
  var sinker = module.addFunction("kitchen()sinker", iIfF, Binaryen.i32, [ Binaryen.i32, Binaryen.exnref ], body);

  // Create a global
  var initExpr = module.i32.const(1);
  var global = module.addGlobal("a-global", Binaryen.i32, false, initExpr)

  // Imports

  var iF = Binaryen.createType([Binaryen.i32, Binaryen.f64]);
  module.addFunctionImport("an-imported", "module", "base", iF, Binaryen.f32);
  module.addGlobalImport("a-global-imp", "module", "base", Binaryen.i32, false);
  module.addGlobalImport("a-mut-global-imp", "module", "base", Binaryen.i32, true);
  module.addEventImport("a-event-imp", "module", "base", 0, Binaryen.i32, Binaryen.none);

  // Exports

  module.addFunctionExport("kitchen()sinker", "kitchen_sinker");
  module.addGlobalExport("a-global", "a-global-exp");
  module.addEventExport("a-event", "a-event-exp");

  // Function table. One per module

  module.setFunctionTable(1, 0xffffffff, [ Binaryen.getFunctionInfo(sinker).name ]);

  // Memory. One per module

  module.setMemory(1, 256, "mem", [
    {
      passive: false,
      offset: module.i32.const(10),
      data: "hello, world".split('').map(function(x) { return x.charCodeAt(0) })
    },
    {
      passive: true,
      offset: null,
      data: "I am passive".split('').map(function(x) { return x.charCodeAt(0) })
    }
  ], true);

  // Start function. One per module
  var starter = module.addFunction("starter", Binaryen.none, Binaryen.none, [], module.nop());
  module.setStart(starter);

  // A bunch of our code needs drop, auto-add it
  module.autoDrop();

  var features = Binaryen.Features.All;
  module.setFeatures(features);
  assert(module.getFeatures() == features);
  console.log(module.emitText());

  // Verify it validates
  assert(module.validate());

  // Print it out
  console.log(module.emitText());

  // Clean up the module, which owns all the objects we created above
  module.dispose();
}

function makeCallCheck(x) {
  return module.call("check", [ makeInt32(x) ], Binaryen.None);
}

function test_relooper() {
  module = new Binaryen.Module();
  var localTypes = [ Binaryen.i32 ];

  module.addFunctionImport("check", "module", "check", Binaryen.i32, Binaryen.none);

  { // trivial: just one block
    var relooper = new Binaryen.Relooper(module);
    var block = relooper.addBlock(makeCallCheck(1337));
    var body = relooper.renderAndDispose(block, 0, module);
    module.addFunction("just-one-block", Binaryen.none, Binaryen.none, localTypes, body);
  }
  { // two blocks
    var relooper = new Binaryen.Relooper(module);
    var block0 = relooper.addBlock(makeCallCheck(0));
    var block1 = relooper.addBlock(makeCallCheck(1));
    relooper.addBranch(block0, block1); // no condition, no code on branch
    var body = relooper.renderAndDispose(block0, 0, module);
    module.addFunction("two-blocks", Binaryen.none, Binaryen.none, localTypes, body);
  }
  { // two blocks with code between them
    var relooper = new Binaryen.Relooper(module);
    var block0 = relooper.addBlock(makeCallCheck(0));
    var block1 = relooper.addBlock(makeCallCheck(1));
    relooper.addBranch(block0, block1, null, makeDroppedInt32(77)); // code on branch
    var body = relooper.renderAndDispose(block0, 0, module);
    module.addFunction("two-blocks-plus-code", Binaryen.none, Binaryen.none, localTypes, body);
  }
  { // two blocks in a loop
    var relooper = new Binaryen.Relooper(module);
    var block0 = relooper.addBlock(makeCallCheck(0));
    var block1 = relooper.addBlock(makeCallCheck(1));
    relooper.addBranch(block0, block1, null, null);
    relooper.addBranch(block1, block0, null, null);
    var body = relooper.renderAndDispose(block0, 0, module);
    module.addFunction("loop", Binaryen.none, Binaryen.none, localTypes, body);
  }
  { // two blocks in a loop with codes
    var relooper = new Binaryen.Relooper(module);
    var block0 = relooper.addBlock(makeCallCheck(0));
    var block1 = relooper.addBlock(makeCallCheck(1));
    relooper.addBranch(block0, block1, null, makeDroppedInt32(33));
    relooper.addBranch(block1, block0, null, makeDroppedInt32(-66));
    var body = relooper.renderAndDispose(block0, 0, module);
    module.addFunction("loop-plus-code", Binaryen.none, Binaryen.none, localTypes, body);
  }
  { // split
    var relooper = new Binaryen.Relooper(module);
    var block0 = relooper.addBlock(makeCallCheck(0));
    var block1 = relooper.addBlock(makeCallCheck(1));
    var block2 = relooper.addBlock(makeCallCheck(2));
    relooper.addBranch(block0, block1, makeInt32(55), null);
    relooper.addBranch(block0, block2, null, null);
    var body = relooper.renderAndDispose(block0, 0, module);
    module.addFunction("split", Binaryen.none, Binaryen.none, localTypes, body);
  }
  { // split + code
    var relooper = new Binaryen.Relooper(module);
    var block0 = relooper.addBlock(makeCallCheck(0));
    var block1 = relooper.addBlock(makeCallCheck(1));
    var block2 = relooper.addBlock(makeCallCheck(2));
    temp = makeDroppedInt32(10);
    relooper.addBranch(block0, block1, makeInt32(55), temp);
    relooper.addBranch(block0, block2, null, makeDroppedInt32(20));
    var body = relooper.renderAndDispose(block0, 0, module);
    module.addFunction("split-plus-code", Binaryen.none, Binaryen.none, localTypes, body);
  }
  { // if
    var relooper = new Binaryen.Relooper(module);
    var block0 = relooper.addBlock(makeCallCheck(0));
    var block1 = relooper.addBlock(makeCallCheck(1));
    var block2 = relooper.addBlock(makeCallCheck(2));
    relooper.addBranch(block0, block1, makeInt32(55), null);
    relooper.addBranch(block0, block2, null, null);
    relooper.addBranch(block1, block2, null, null);
    var body = relooper.renderAndDispose(block0, 0, module);
    module.addFunction("if", Binaryen.none, Binaryen.none, localTypes, body);
  }
  { // if + code
    var relooper = new Binaryen.Relooper(module);
    var block0 = relooper.addBlock(makeCallCheck(0));
    var block1 = relooper.addBlock(makeCallCheck(1));
    var block2 = relooper.addBlock(makeCallCheck(2));
    temp = makeDroppedInt32(-1);
    relooper.addBranch(block0, block1, makeInt32(55), temp);
    relooper.addBranch(block0, block2, null, makeDroppedInt32(-2));
    relooper.addBranch(block1, block2, null, makeDroppedInt32(-3));
    var body = relooper.renderAndDispose(block0, 0, module);
    module.addFunction("if-plus-code", Binaryen.none, Binaryen.none, localTypes, body);
  }
  { // if-else
    var relooper = new Binaryen.Relooper(module);
    var block0 = relooper.addBlock(makeCallCheck(0));
    var block1 = relooper.addBlock(makeCallCheck(1));
    var block2 = relooper.addBlock(makeCallCheck(2));
    var block3 = relooper.addBlock(makeCallCheck(3));
    relooper.addBranch(block0, block1, makeInt32(55), null);
    relooper.addBranch(block0, block2, null, null);
    relooper.addBranch(block1, block3, null, null);
    relooper.addBranch(block2, block3, null, null);
    var body = relooper.renderAndDispose(block0, 0, module);
    module.addFunction("if-else", Binaryen.none, Binaryen.none, localTypes, body);
  }
  { // loop+tail
    var relooper = new Binaryen.Relooper(module);
    var block0 = relooper.addBlock(makeCallCheck(0));
    var block1 = relooper.addBlock(makeCallCheck(1));
    var block2 = relooper.addBlock(makeCallCheck(2));
    relooper.addBranch(block0, block1, null, null);
    relooper.addBranch(block1, block0, makeInt32(10), null);
    relooper.addBranch(block1, block2, null, null);
    var body = relooper.renderAndDispose(block0, 0, module);
    module.addFunction("loop-tail", Binaryen.none, Binaryen.none, localTypes, body);
  }
  { // nontrivial loop + phi to head
    var relooper = new Binaryen.Relooper(module);
    var block0 = relooper.addBlock(makeCallCheck(0));
    var block1 = relooper.addBlock(makeCallCheck(1));
    var block2 = relooper.addBlock(makeCallCheck(2));
    var block3 = relooper.addBlock(makeCallCheck(3));
    var block4 = relooper.addBlock(makeCallCheck(4));
    var block5 = relooper.addBlock(makeCallCheck(5));
    var block6 = relooper.addBlock(makeCallCheck(6));
    relooper.addBranch(block0, block1, null, makeDroppedInt32(10));
    relooper.addBranch(block1, block2, makeInt32(-2), null);
    relooper.addBranch(block1, block6, null, makeDroppedInt32(20));
    relooper.addBranch(block2, block3, makeInt32(-6), null);
    relooper.addBranch(block2, block1, null, makeDroppedInt32(30));
    relooper.addBranch(block3, block4, makeInt32(-10), null);
    relooper.addBranch(block3, block5, null, null);
    relooper.addBranch(block4, block5, null, null);
    relooper.addBranch(block5, block6, null, makeDroppedInt32(40));
    var body = relooper.renderAndDispose(block0, 0, module);
    module.addFunction("nontrivial-loop-plus-phi-to-head", Binaryen.none, Binaryen.none, localTypes, body);
  }
  { // switch
    var relooper = new Binaryen.Relooper(module);
    temp = makeInt32(-99);
    var block0 = relooper.addBlockWithSwitch(makeCallCheck(0), temp);
    var block1 = relooper.addBlock(makeCallCheck(1));
    var block2 = relooper.addBlock(makeCallCheck(2));
    var block3 = relooper.addBlock(makeCallCheck(3));
    relooper.addBranchForSwitch(block0, block1, [ 2, 5 ]);
    relooper.addBranchForSwitch(block0, block2, [4], makeDroppedInt32(55));
    relooper.addBranchForSwitch(block0, block3, [], null);
    var body = relooper.renderAndDispose(block0, 0, module);
    module.addFunction("switch", Binaryen.none, Binaryen.none, localTypes, body);
  }
  { // duff's device
    var relooper = new Binaryen.Relooper(module);
    var block0 = relooper.addBlock(makeCallCheck(0));
    var block1 = relooper.addBlock(makeCallCheck(1));
    var block2 = relooper.addBlock(makeCallCheck(2));
    relooper.addBranch(block0, block1, makeInt32(10), null);
    relooper.addBranch(block0, block2, null, null);
    relooper.addBranch(block1, block2, null, null);
    relooper.addBranch(block2, block1, null, null);
    var body = relooper.renderAndDispose(block0, 3, module); // use $3 as the helper var
    module.addFunction("duffs-device", Binaryen.none, Binaryen.none, [ Binaryen.i32, Binaryen.i32, Binaryen.i64, Binaryen.i32, Binaryen.f32, Binaryen.f64, Binaryen.i32 ], body);
  }

  { // return in a block
    var relooper = new Binaryen.Relooper(module);
    var list = module.block("the-list", [ makeCallCheck(42), module.return(makeInt32(1337)) ]);
    var block = relooper.addBlock(list);
    var body = relooper.renderAndDispose(block, 0, module);
    module.addFunction("return", Binaryen.none, Binaryen.i32, localTypes, body);
  }

  console.log("raw:");
  console.log(module.emitText());

  assert(module.validate());

  module.runPasses(["precompute"]);

  assert(module.validate());

  module.optimize();

  assert(module.validate());

  console.log("optimized:");
  console.log(module.emitText());

  module.dispose();
}

function test_binaries() {
  var buffer, size;

  { // create a module and write it to binary
    module = new Binaryen.Module();
    module.setFeatures(Binaryen.Features.All);
    var ii = Binaryen.createType([Binaryen.i32, Binaryen.i32]);
    var x = module.local.get(0, Binaryen.i32),
        y = module.local.get(1, Binaryen.i32);
    var add = module.i32.add(x, y);
    var adder = module.addFunction("adder", ii, Binaryen.i32, [], add);
    var initExpr = module.i32.const(3);
    var global = module.addGlobal("a-global", Binaryen.i32, false, initExpr)
    var event_ = module.addEvent("a-event", 0, Binaryen.createType([Binaryen.i32, Binaryen.i32]), Binaryen.none);
    Binaryen.setDebugInfo(true); // include names section
    buffer = module.emitBinary();
    Binaryen.setDebugInfo(false);
    size = buffer.length; // write out the module
    module.dispose();
  }

  assert(size > 0);
  assert(size < 512); // this is a tiny module

  // read the module from the binary
  module = Binaryen.readBinary(buffer);
  module.setFeatures(Binaryen.Features.All);

  // validate, print, and free
  assert(module.validate());
  console.log("module loaded from binary form:");
  console.log(module.emitText());
  module.dispose();
}

function test_interpret() {
  // create a simple module with a start method that prints a number, and interpret it, printing that number.
  module = new Binaryen.Module();

  module.addFunctionImport("print-i32", "spectest", "print", Binaryen.i32, Binaryen.none);
  call = module.call("print-i32", [ makeInt32(1234) ], Binaryen.None);
  var starter = module.addFunction("starter", Binaryen.none, Binaryen.none, [], call);
  module.setStart(starter);

  console.log(module.emitText());
  assert(module.validate());
  module.interpret();
  module.dispose();
}

function test_nonvalid() {
  // create a module that fails to validate
  module = new Binaryen.Module();

  var func = module.addFunction("func", Binaryen.none, Binaryen.none, [ Binaryen.i32 ],
    module.local.set(0, makeInt64(1234, 0)) // wrong type!
  );

  console.log(module.emitText());
  console.log("validation: " + module.validate());

  module.dispose();
}

function test_tracing() {
  Binaryen.setAPITracing(1);
  test_core();
  test_relooper();
  test_types();
  Binaryen.setAPITracing(0);
}

function test_parsing() {
  var text;

  // create a module and write it to text
  module = new Binaryen.Module();
  module.setFeatures(Binaryen.Features.All);

  var ii = Binaryen.createType([Binaryen.i32, Binaryen.i32]);
  var x = module.local.get(0, Binaryen.i32),
      y = module.local.get(1, Binaryen.i32);
  var add = module.i32.add(x, y);
  var adder = module.addFunction("adder", ii, Binaryen.i32, [], add);
  var initExpr = module.i32.const(3);
  var global = module.addGlobal("a-global", Binaryen.i32, false, initExpr)
  var event_ = module.addEvent("a-event", 0, Binaryen.i32, Binaryen.none);
  text = module.emitText();
  module.dispose();
  module = null;
  console.log('test_parsing text:\n' + text);

  text = text.replace('adder', 'ADD_ER');

  var module2 = Binaryen.parseText(text);
  module2.setFeatures(Binaryen.Features.All);
  assert(module2.validate());
  console.log("module loaded from text form:");
  console.log(module2.emitText());
  module2.dispose();
}

function test_internals() {
  console.log('sizeof Literal: ' + Binaryen['_BinaryenSizeofLiteral']());
}

function test_for_each() {
  module = new Binaryen.Module();

  var fns = [
    module.addFunction("fn0", Binaryen.none, Binaryen.none, [], module.nop()),
    module.addFunction("fn1", Binaryen.none, Binaryen.none, [], module.nop()),
    module.addFunction("fn2", Binaryen.none, Binaryen.none, [], module.nop())
  ];

  var i;
  for (i = 0 ; i < module.getNumFunctions() ; i++) {
    assert(module.getFunctionByIndex(i) === fns[i]);
  }

  var exps = [
    module.addFunctionExport("fn0", "export0"),
    module.addFunctionExport("fn1", "export1"),
    module.addFunctionExport("fn2", "export2")
  ];

  for (i = 0 ; i < module.getNumExports() ; i++) {
    assert(module.getExportByIndex(i) === exps[i]);
  }

  var expected_offsets = [10, 125];
  var expected_data = ["hello, world", "segment data 2"];

  var global = module.addGlobal("a-global", Binaryen.i32, false, module.i32.const(expected_offsets[1]))
  module.setMemory(1, 256, "mem", [
    {
      passive: false,
      offset: module.i32.const(expected_offsets[0]),
      data: expected_data[0].split('').map(function(x) { return x.charCodeAt(0) })
    },
    {
      passive: false,
      offset: module.global.get("a-global"),
      data: expected_data[1].split('').map(function(x) { return x.charCodeAt(0) })
    }
  ], false);
  for (i = 0 ; i < module.getNumMemorySegments() ; i++) {
    var segment = module.getMemorySegmentInfoByIndex(i);
    assert(expected_offsets[i] === segment.byteOffset);
    var data8 = new Uint8Array(segment.data);
    var str = String.fromCharCode.apply(null, data8);
    assert(expected_data[i] === str);
  }

  console.log(module.emitText());
  module.dispose();
}

function test_expression_info() {
  module = new Binaryen.Module();

  // Issue #2392
  console.log("getExpressionInfo(memory.grow)=" + JSON.stringify(Binaryen.getExpressionInfo(module.memory.grow(1))));

  // Issue #2396
  console.log("getExpressionInfo(memory.grow)=" + JSON.stringify(Binaryen.getExpressionInfo(module.switch([ "label" ], "label", 0))));

  module.dispose();
}

function main() {
  // Tracing must be first so it starts with a fresh set of interned types
  test_tracing();
  test_types();
  test_features();
  test_ids();
  test_core();
  test_relooper();
  test_binaries();
  test_interpret();
  test_nonvalid();
  test_parsing();
  test_internals();
  test_for_each();
  test_expression_info();
}

main();
