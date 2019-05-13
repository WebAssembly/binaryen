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
  console.log("BinaryenTypeNone: " + Binaryen.none);
  console.log("BinaryenTypeInt32: " + Binaryen.i32);
  console.log("BinaryenTypeInt64: " + Binaryen.i64);
  console.log("BinaryenTypeFloat32: " + Binaryen.f32);
  console.log("BinaryenTypeFloat64: " + Binaryen.f64);
  console.log("BinaryenTypeVec128: " + Binaryen.v128);
  console.log("BinaryenTypeExceptRef: " + Binaryen.except_ref);
  console.log("BinaryenTypeUnreachable: " + Binaryen.unreachable);
  console.log("BinaryenTypeAuto: " + Binaryen.auto);
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
  console.log("BinaryenGetLocalId: " + Binaryen.GetLocalId);
  console.log("BinaryenSetLocalId: " + Binaryen.SetLocalId);
  console.log("BinaryenGetGlobalId: " + Binaryen.GetGlobalId);
  console.log("BinaryenSetGlobalId: " + Binaryen.SetGlobalId);
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
  console.log("BinaryenSIMDBitselectId: " + Binaryen.SIMDBitselectId);
  console.log("BinaryenSIMDShiftId: " + Binaryen.SIMDShiftId);
  console.log("MemoryInitId: " + Binaryen.MemoryInitId);
  console.log("DataDropId: " + Binaryen.DataDropId);
  console.log("MemoryCopyId: " + Binaryen.MemoryCopyId);
  console.log("MemoryFillId: " + Binaryen.MemoryFillId);
}

function test_core() {

  // Module creation

  module = new Binaryen.Module();

  // Literals and consts

  var constI32 = module.i32.const(1),
      constI64 = module.i64.const(2),
      constF32 = module.f32.const(3.14),
      constF64 = module.f64.const(2.1828),
      constF32Bits = module.f32.const_bits(0xffff1234),
      constF64Bits = module.f64.const_bits(0x5678abcd, 0xffff1234);

  var iiIfF = module.addFunctionType("iiIfF", Binaryen.i32, [ Binaryen.i32, Binaryen.i64, Binaryen.f32, Binaryen.f64 ]);

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
    module.i32x4['trunc_s/f32x4:sat'](module.v128.const(v128_bytes)),
    module.i32x4['trunc_u/f32x4:sat'](module.v128.const(v128_bytes)),
    module.i64x2['trunc_s/f64x2:sat'](module.v128.const(v128_bytes)),
    module.i64x2['trunc_u/f64x2:sat'](module.v128.const(v128_bytes)),
    module.f32x4['convert_s/i32x4'](module.v128.const(v128_bytes)),
    module.f32x4['convert_u/i32x4'](module.v128.const(v128_bytes)),
    module.f64x2['convert_s/i64x2'](module.v128.const(v128_bytes)),
    module.f64x2['convert_u/i64x2'](module.v128.const(v128_bytes)),
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
    module.i8x16.add(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i8x16.add_saturate_s(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i8x16.add_saturate_u(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i8x16.sub(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i8x16.sub_saturate_s(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i8x16.sub_saturate_u(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i8x16.mul(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i16x8.add(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i16x8.add_saturate_s(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i16x8.add_saturate_u(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i16x8.sub(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i16x8.sub_saturate_s(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i16x8.sub_saturate_u(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i16x8.mul(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i32x4.add(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i32x4.sub(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
    module.i32x4.mul(module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
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
    // // SIMD shift
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
    // Other SIMD
    module.v8x16.shuffle(module.v128.const(v128_bytes), module.v128.const(v128_bytes), v128_bytes),
    module.v128.bitselect(module.v128.const(v128_bytes), module.v128.const(v128_bytes), module.v128.const(v128_bytes)),
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
      module.callIndirect(makeInt32(2449), [ makeInt32(13), makeInt64(37, 0), makeFloat32(1.3), makeFloat64(3.7) ], "iiIfF")
    ),
    module.drop(module.getLocal(0, Binaryen.i32)),
    module.setLocal(0, makeInt32(101)),
    module.drop(module.teeLocal(0, makeInt32(102))),
    module.i32.load(0, 0, makeInt32(1)),
    module.i64.load16_s(2, 1, makeInt32(8)),
    module.f32.load(0, 0, makeInt32(2)),
    module.f64.load(2, 8, makeInt32(9)),
    module.i32.store(0, 0, temp13, temp14),
    module.i64.store(2, 4, temp15, temp16),
    module.select(temp10, temp11, temp12),
    module.return(makeInt32(1337)),
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
  var sinker = module.addFunction("kitchen()sinker", iiIfF, [ Binaryen.i32 ], body);

  // Create a global
  var initExpr = module.i32.const(1);
  var global = module.addGlobal("a-global", Binaryen.i32, false, initExpr)

  // Imports

  var fiF = module.addFunctionType("fiF", Binaryen.f32, [ Binaryen.i32, Binaryen.f64 ]);
  module.addFunctionImport("an-imported", "module", "base", fiF);
  module.addGlobalImport("a-global-imp", "module", "base", Binaryen.i32);

  // Exports

  module.addFunctionExport("kitchen()sinker", "kitchen_sinker");
  module.addGlobalExport("a-global", "a-global-exp");

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
  ]);

  // Start function. One per module

  var v = module.addFunctionType("v", Binaryen.None, []);
  var starter = module.addFunction("starter", v, [], module.nop());
  module.setStart(starter);

  // Unnamed function type

  var noname = module.addFunctionType(null, Binaryen.None, []);

  // A bunch of our code needs drop, auto-add it
  module.autoDrop();

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
  var v = module.addFunctionType("v", Binaryen.None, []);
  var localTypes = [ Binaryen.i32 ];

  {
    var vi = module.addFunctionType("vi", Binaryen.None, [ Binaryen.i32 ]);
    module.addFunctionImport("check", "module", "check", vi);
  }

  { // trivial: just one block
    var relooper = new Binaryen.Relooper(module);
    var block = relooper.addBlock(makeCallCheck(1337));
    var body = relooper.renderAndDispose(block, 0, module);
    module.addFunction("just-one-block", v, localTypes, body);
  }
  { // two blocks
    var relooper = new Binaryen.Relooper(module);
    var block0 = relooper.addBlock(makeCallCheck(0));
    var block1 = relooper.addBlock(makeCallCheck(1));
    relooper.addBranch(block0, block1); // no condition, no code on branch
    var body = relooper.renderAndDispose(block0, 0, module);
    module.addFunction("two-blocks", v, localTypes, body);
  }
  { // two blocks with code between them
    var relooper = new Binaryen.Relooper(module);
    var block0 = relooper.addBlock(makeCallCheck(0));
    var block1 = relooper.addBlock(makeCallCheck(1));
    relooper.addBranch(block0, block1, null, makeDroppedInt32(77)); // code on branch
    var body = relooper.renderAndDispose(block0, 0, module);
    module.addFunction("two-blocks-plus-code", v, localTypes, body);
  }
  { // two blocks in a loop
    var relooper = new Binaryen.Relooper(module);
    var block0 = relooper.addBlock(makeCallCheck(0));
    var block1 = relooper.addBlock(makeCallCheck(1));
    relooper.addBranch(block0, block1, null, null);
    relooper.addBranch(block1, block0, null, null);
    var body = relooper.renderAndDispose(block0, 0, module);
    module.addFunction("loop", v, localTypes, body);
  }
  { // two blocks in a loop with codes
    var relooper = new Binaryen.Relooper(module);
    var block0 = relooper.addBlock(makeCallCheck(0));
    var block1 = relooper.addBlock(makeCallCheck(1));
    relooper.addBranch(block0, block1, null, makeDroppedInt32(33));
    relooper.addBranch(block1, block0, null, makeDroppedInt32(-66));
    var body = relooper.renderAndDispose(block0, 0, module);
    module.addFunction("loop-plus-code", v, localTypes, body);
  }
  { // split
    var relooper = new Binaryen.Relooper(module);
    var block0 = relooper.addBlock(makeCallCheck(0));
    var block1 = relooper.addBlock(makeCallCheck(1));
    var block2 = relooper.addBlock(makeCallCheck(2));
    relooper.addBranch(block0, block1, makeInt32(55), null);
    relooper.addBranch(block0, block2, null, null);
    var body = relooper.renderAndDispose(block0, 0, module);
    module.addFunction("split", v, localTypes, body);
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
    module.addFunction("split-plus-code", v, localTypes, body);
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
    module.addFunction("if", v, localTypes, body);
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
    module.addFunction("if-plus-code", v, localTypes, body);
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
    module.addFunction("if-else", v, localTypes, body);
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
    module.addFunction("loop-tail", v, localTypes, body);
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
    module.addFunction("nontrivial-loop-plus-phi-to-head", v, localTypes, body);
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
    module.addFunction("switch", v, localTypes, body);
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
    module.addFunction("duffs-device", v, [ Binaryen.i32, Binaryen.i32, Binaryen.i64, Binaryen.i32, Binaryen.f32, Binaryen.f64, Binaryen.i32 ], body);
  }

  var i = module.addFunctionType("i", Binaryen.i32, []);

  { // return in a block
    var relooper = new Binaryen.Relooper(module);
    var list = module.block("the-list", [ makeCallCheck(42), module.return(makeInt32(1337)) ]);
    var block = relooper.addBlock(list);
    var body = relooper.renderAndDispose(block, 0, module);
    module.addFunction("return", i, localTypes, body);
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
    var iii = module.addFunctionType("iii", Binaryen.i32, [ Binaryen.i32, Binaryen.i32 ]);
    var x = module.getLocal(0, Binaryen.i32),
        y = module.getLocal(1, Binaryen.i32);
    var add = module.i32.add(x, y);
    var adder = module.addFunction("adder", iii, [], add);
    var initExpr = module.i32.const(3);
    var global = module.addGlobal("a-global", Binaryen.i32, false, initExpr)
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

  // validate, print, and free
  assert(module.validate());
  console.log("module loaded from binary form:");
  console.log(module.emitText());
  module.dispose();
}

function test_interpret() {
  // create a simple module with a start method that prints a number, and interpret it, printing that number.
  module = new Binaryen.Module();

  var vi = module.addFunctionType("vi", Binaryen.None, [ Binaryen.i32 ]);
  module.addFunctionImport("print-i32", "spectest", "print", vi);

  var v = module.addFunctionType("v", Binaryen.None, []);
  call = module.call("print-i32", [ makeInt32(1234) ], Binaryen.None);
  var starter = module.addFunction("starter", v, [], call);
  module.setStart(starter);

  console.log(module.emitText());
  assert(module.validate());
  module.interpret();
  module.dispose();
}

function test_nonvalid() {
  // create a module that fails to validate
  module = new Binaryen.Module();

  var v = module.addFunctionType("v", Binaryen.None, []);
  var func = module.addFunction("func", v, [ Binaryen.i32 ],
    module.setLocal(0, makeInt64(1234, 0)) // wrong type!
  );

  console.log(module.emitText());
  console.log("validation: " + module.validate());

  module.dispose();
}

function test_tracing() {
  Binaryen.setAPITracing(1);
  test_core();
  test_relooper();
  Binaryen.setAPITracing(0);
}

function test_parsing() {
  var text;

  // create a module and write it to text
  module = new Binaryen.Module();
  var iii = module.addFunctionType("iii", Binaryen.i32, [ Binaryen.i32, Binaryen.i32 ]);
  var x = module.getLocal(0, Binaryen.i32),
      y = module.getLocal(1, Binaryen.i32);
  var add = module.i32.add(x, y);
  var adder = module.addFunction("adder", iii, [], add);
  var initExpr = module.i32.const(3);
  var global = module.addGlobal("a-global", Binaryen.i32, false, initExpr)
  text = module.emitText();
  module.dispose();
  module = null;
  console.log('test_parsing text:\n' + text);

  text = text.replace('adder', 'ADD_ER');

  var module2 = Binaryen.parseText(text);
  assert(module2.validate());
  console.log("module loaded from text form:");
  console.log(module2.emitText());
  module2.dispose();
}

function test_internals() {
  console.log('sizeof Literal: ' + Binaryen['_BinaryenSizeofLiteral']());
}

function main() {
  test_types();
  test_ids();
  test_core();
  test_relooper();
  test_binaries();
  test_interpret();
  test_nonvalid();
  test_tracing();
  test_parsing();
  test_internals();
}

main();
