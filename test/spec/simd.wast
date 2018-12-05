(module
 (memory 1)
 (data (i32.const 128) "WASMSIMDGOESFAST")
 (func (export "v128.load") (param $0 i32) (result v128)(v128.load (get_local $0)))
 (func (export "v128.store") (param $0 i32) (param $1 v128) (result v128)
   (v128.store offset=0 align=16 (get_local $0) (get_local $1))
   (v128.load (get_local $0))
 )
 (func (export "v128.const") (result v128) (v128.const i32 1 2 3 4))
 (func (export "v128.shuffle_interleave_bytes") (param $0 v128) (param $1 v128) (result v128)
   (v8x16.shuffle 0 17 2 19 4 21 6 23 8 25 10 27 12 29 14 31 (get_local $0) (get_local $1))
 )
 (func (export "v128.shuffle_reverse_i32s") (param $0 v128) (result v128)
   (v8x16.shuffle 12 13 14 15 8 9 10 11 4 5 6 7 0 1 2 3 (get_local $0) (get_local $0))
 )
 (func (export "i8x16.splat") (param $0 i32) (result v128) (i8x16.splat (get_local $0)))
 (func (export "i8x16.extract_lane_s_first") (param $0 v128) (result i32) (i8x16.extract_lane_s 0 (get_local $0)))
 (func (export "i8x16.extract_lane_s_last") (param $0 v128) (result i32) (i8x16.extract_lane_s 15 (get_local $0)))
 (func (export "i8x16.extract_lane_u_first") (param $0 v128) (result i32) (i8x16.extract_lane_u 0 (get_local $0)))
 (func (export "i8x16.extract_lane_u_last") (param $0 v128) (result i32) (i8x16.extract_lane_u 15 (get_local $0)))
 (func (export "i8x16.replace_lane_first") (param $0 v128) (param $1 i32) (result v128) (i8x16.replace_lane 0 (get_local $0) (get_local $1)))
 (func (export "i8x16.replace_lane_last") (param $0 v128) (param $1 i32) (result v128) (i8x16.replace_lane 15 (get_local $0) (get_local $1)))
 (func (export "i16x8.splat") (param $0 i32) (result v128) (i16x8.splat (get_local $0)))
 (func (export "i16x8.extract_lane_s_first") (param $0 v128) (result i32) (i16x8.extract_lane_s 0 (get_local $0)))
 (func (export "i16x8.extract_lane_s_last") (param $0 v128) (result i32) (i16x8.extract_lane_s 7 (get_local $0)))
 (func (export "i16x8.extract_lane_u_first") (param $0 v128) (result i32) (i16x8.extract_lane_u 0 (get_local $0)))
 (func (export "i16x8.extract_lane_u_last") (param $0 v128) (result i32) (i16x8.extract_lane_u 7 (get_local $0)))
 (func (export "i16x8.replace_lane_first") (param $0 v128) (param $1 i32) (result v128) (i16x8.replace_lane 0 (get_local $0) (get_local $1)))
 (func (export "i16x8.replace_lane_last") (param $0 v128) (param $1 i32) (result v128) (i16x8.replace_lane 7 (get_local $0) (get_local $1)))
 (func (export "i32x4.splat") (param $0 i32) (result v128) (i32x4.splat (get_local $0)))
 (func (export "i32x4.extract_lane_first") (param $0 v128) (result i32) (i32x4.extract_lane 0 (get_local $0)))
 (func (export "i32x4.extract_lane_last") (param $0 v128) (result i32) (i32x4.extract_lane 3 (get_local $0)))
 (func (export "i32x4.replace_lane_first") (param $0 v128) (param $1 i32) (result v128) (i32x4.replace_lane 0 (get_local $0) (get_local $1)))
 (func (export "i32x4.replace_lane_last") (param $0 v128) (param $1 i32) (result v128) (i32x4.replace_lane 3 (get_local $0) (get_local $1)))
 (func (export "i64x2.splat") (param $0 i64) (result v128) (i64x2.splat (get_local $0)))
 (func (export "i64x2.extract_lane_first") (param $0 v128) (result i64) (i64x2.extract_lane 0 (get_local $0)))
 (func (export "i64x2.extract_lane_last") (param $0 v128) (result i64) (i64x2.extract_lane 1 (get_local $0)))
 (func (export "i64x2.replace_lane_first") (param $0 v128) (param $1 i64) (result v128) (i64x2.replace_lane 0 (get_local $0) (get_local $1)))
 (func (export "i64x2.replace_lane_last") (param $0 v128) (param $1 i64) (result v128) (i64x2.replace_lane 1 (get_local $0) (get_local $1)))
 (func (export "f32x4.splat") (param $0 f32) (result v128) (f32x4.splat (get_local $0)))
 (func (export "f32x4.extract_lane_first") (param $0 v128) (result f32) (f32x4.extract_lane 0 (get_local $0)))
 (func (export "f32x4.extract_lane_last") (param $0 v128) (result f32) (f32x4.extract_lane 3 (get_local $0)))
 (func (export "f32x4.replace_lane_first") (param $0 v128) (param $1 f32) (result v128) (f32x4.replace_lane 0 (get_local $0) (get_local $1)))
 (func (export "f32x4.replace_lane_last") (param $0 v128) (param $1 f32) (result v128) (f32x4.replace_lane 3 (get_local $0) (get_local $1)))
 (func (export "f64x2.splat") (param $0 f64) (result v128) (f64x2.splat (get_local $0)))
 (func (export "f64x2.extract_lane_first") (param $0 v128) (result f64) (f64x2.extract_lane 0 (get_local $0)))
 (func (export "f64x2.extract_lane_last") (param $0 v128) (result f64) (f64x2.extract_lane 1 (get_local $0)))
 (func (export "f64x2.replace_lane_first") (param $0 v128) (param $1 f64) (result v128) (f64x2.replace_lane 0 (get_local $0) (get_local $1)))
 (func (export "f64x2.replace_lane_last") (param $0 v128) (param $1 f64) (result v128) (f64x2.replace_lane 1 (get_local $0) (get_local $1)))
 (func (export "i8x16.eq") (param $0 v128) (param $1 v128) (result v128) (i8x16.eq (get_local $0) (get_local $1)))
 (func (export "i8x16.ne") (param $0 v128) (param $1 v128) (result v128) (i8x16.ne (get_local $0) (get_local $1)))
 (func (export "i8x16.lt_s") (param $0 v128) (param $1 v128) (result v128) (i8x16.lt_s (get_local $0) (get_local $1)))
 (func (export "i8x16.lt_u") (param $0 v128) (param $1 v128) (result v128) (i8x16.lt_u (get_local $0) (get_local $1)))
 (func (export "i8x16.gt_s") (param $0 v128) (param $1 v128) (result v128) (i8x16.gt_s (get_local $0) (get_local $1)))
 (func (export "i8x16.gt_u") (param $0 v128) (param $1 v128) (result v128) (i8x16.gt_u (get_local $0) (get_local $1)))
 (func (export "i8x16.le_s") (param $0 v128) (param $1 v128) (result v128) (i8x16.le_s (get_local $0) (get_local $1)))
 (func (export "i8x16.le_u") (param $0 v128) (param $1 v128) (result v128) (i8x16.le_u (get_local $0) (get_local $1)))
 (func (export "i8x16.ge_s") (param $0 v128) (param $1 v128) (result v128) (i8x16.ge_s (get_local $0) (get_local $1)))
 (func (export "i8x16.ge_u") (param $0 v128) (param $1 v128) (result v128) (i8x16.ge_u (get_local $0) (get_local $1)))
 (func (export "i16x8.eq") (param $0 v128) (param $1 v128) (result v128) (i16x8.eq (get_local $0) (get_local $1)))
 (func (export "i16x8.ne") (param $0 v128) (param $1 v128) (result v128) (i16x8.ne (get_local $0) (get_local $1)))
 (func (export "i16x8.lt_s") (param $0 v128) (param $1 v128) (result v128) (i16x8.lt_s (get_local $0) (get_local $1)))
 (func (export "i16x8.lt_u") (param $0 v128) (param $1 v128) (result v128) (i16x8.lt_u (get_local $0) (get_local $1)))
 (func (export "i16x8.gt_s") (param $0 v128) (param $1 v128) (result v128) (i16x8.gt_s (get_local $0) (get_local $1)))
 (func (export "i16x8.gt_u") (param $0 v128) (param $1 v128) (result v128) (i16x8.gt_u (get_local $0) (get_local $1)))
 (func (export "i16x8.le_s") (param $0 v128) (param $1 v128) (result v128) (i16x8.le_s (get_local $0) (get_local $1)))
 (func (export "i16x8.le_u") (param $0 v128) (param $1 v128) (result v128) (i16x8.le_u (get_local $0) (get_local $1)))
 (func (export "i16x8.ge_s") (param $0 v128) (param $1 v128) (result v128) (i16x8.ge_s (get_local $0) (get_local $1)))
 (func (export "i16x8.ge_u") (param $0 v128) (param $1 v128) (result v128) (i16x8.ge_u (get_local $0) (get_local $1)))
 (func (export "i32x4.eq") (param $0 v128) (param $1 v128) (result v128) (i32x4.eq (get_local $0) (get_local $1)))
 (func (export "i32x4.ne") (param $0 v128) (param $1 v128) (result v128) (i32x4.ne (get_local $0) (get_local $1)))
 (func (export "i32x4.lt_s") (param $0 v128) (param $1 v128) (result v128) (i32x4.lt_s (get_local $0) (get_local $1)))
 (func (export "i32x4.lt_u") (param $0 v128) (param $1 v128) (result v128) (i32x4.lt_u (get_local $0) (get_local $1)))
 (func (export "i32x4.gt_s") (param $0 v128) (param $1 v128) (result v128) (i32x4.gt_s (get_local $0) (get_local $1)))
 (func (export "i32x4.gt_u") (param $0 v128) (param $1 v128) (result v128) (i32x4.gt_u (get_local $0) (get_local $1)))
 (func (export "i32x4.le_s") (param $0 v128) (param $1 v128) (result v128) (i32x4.le_s (get_local $0) (get_local $1)))
 (func (export "i32x4.le_u") (param $0 v128) (param $1 v128) (result v128) (i32x4.le_u (get_local $0) (get_local $1)))
 (func (export "i32x4.ge_s") (param $0 v128) (param $1 v128) (result v128) (i32x4.ge_s (get_local $0) (get_local $1)))
 (func (export "i32x4.ge_u") (param $0 v128) (param $1 v128) (result v128) (i32x4.ge_u (get_local $0) (get_local $1)))
 (func (export "f32x4.eq") (param $0 v128) (param $1 v128) (result v128) (f32x4.eq (get_local $0) (get_local $1)))
 (func (export "f32x4.ne") (param $0 v128) (param $1 v128) (result v128) (f32x4.ne (get_local $0) (get_local $1)))
 (func (export "f32x4.lt") (param $0 v128) (param $1 v128) (result v128) (f32x4.lt (get_local $0) (get_local $1)))
 (func (export "f32x4.gt") (param $0 v128) (param $1 v128) (result v128) (f32x4.gt (get_local $0) (get_local $1)))
 (func (export "f32x4.le") (param $0 v128) (param $1 v128) (result v128) (f32x4.le (get_local $0) (get_local $1)))
 (func (export "f32x4.ge") (param $0 v128) (param $1 v128) (result v128) (f32x4.ge (get_local $0) (get_local $1)))
 (func (export "f64x2.eq") (param $0 v128) (param $1 v128) (result v128) (f64x2.eq (get_local $0) (get_local $1)))
 (func (export "f64x2.ne") (param $0 v128) (param $1 v128) (result v128) (f64x2.ne (get_local $0) (get_local $1)))
 (func (export "f64x2.lt") (param $0 v128) (param $1 v128) (result v128) (f64x2.lt (get_local $0) (get_local $1)))
 (func (export "f64x2.gt") (param $0 v128) (param $1 v128) (result v128) (f64x2.gt (get_local $0) (get_local $1)))
 (func (export "f64x2.le") (param $0 v128) (param $1 v128) (result v128) (f64x2.le (get_local $0) (get_local $1)))
 (func (export "f64x2.ge") (param $0 v128) (param $1 v128) (result v128) (f64x2.ge (get_local $0) (get_local $1)))
 (func (export "v128.not") (param $0 v128) (result v128) (v128.not (get_local $0)))
 (func (export "v128.and") (param $0 v128) (param $1 v128) (result v128) (v128.and (get_local $0) (get_local $1)))
 (func (export "v128.or") (param $0 v128) (param $1 v128) (result v128) (v128.or (get_local $0) (get_local $1)))
 (func (export "v128.xor") (param $0 v128) (param $1 v128) (result v128) (v128.xor (get_local $0) (get_local $1)))
 (func (export "v128.bitselect") (param $0 v128) (param $1 v128) (param $2 v128) (result v128)
   (v128.bitselect (get_local $0) (get_local $1) (get_local $2))
 )
 (func (export "i8x16.neg") (param $0 v128) (result v128) (i8x16.neg (get_local $0)))
 (func (export "i8x16.any_true") (param $0 v128) (result i32) (i8x16.any_true (get_local $0)))
 (func (export "i8x16.all_true") (param $0 v128) (result i32) (i8x16.all_true (get_local $0)))
 (func (export "i8x16.shl") (param $0 v128) (param $1 i32) (result v128) (i8x16.shl (get_local $0) (get_local $1)))
 (func (export "i8x16.shr_s") (param $0 v128) (param $1 i32) (result v128) (i8x16.shr_s (get_local $0) (get_local $1)))
 (func (export "i8x16.shr_u") (param $0 v128) (param $1 i32) (result v128) (i8x16.shr_u (get_local $0) (get_local $1)))
 (func (export "i8x16.add") (param $0 v128) (param $1 v128) (result v128) (i8x16.add (get_local $0) (get_local $1)))
 (func (export "i8x16.add_saturate_s") (param $0 v128) (param $1 v128) (result v128) (i8x16.add_saturate_s (get_local $0) (get_local $1)))
 (func (export "i8x16.add_saturate_u") (param $0 v128) (param $1 v128) (result v128) (i8x16.add_saturate_u (get_local $0) (get_local $1)))
 (func (export "i8x16.sub") (param $0 v128) (param $1 v128) (result v128) (i8x16.sub (get_local $0) (get_local $1)))
 (func (export "i8x16.sub_saturate_s") (param $0 v128) (param $1 v128) (result v128) (i8x16.sub_saturate_s (get_local $0) (get_local $1)))
 (func (export "i8x16.sub_saturate_u") (param $0 v128) (param $1 v128) (result v128) (i8x16.sub_saturate_u (get_local $0) (get_local $1)))
 (func (export "i8x16.mul") (param $0 v128) (param $1 v128) (result v128) (i8x16.mul (get_local $0) (get_local $1)))
 (func (export "i16x8.neg") (param $0 v128) (result v128) (i16x8.neg (get_local $0)))
 (func (export "i16x8.any_true") (param $0 v128) (result i32) (i16x8.any_true (get_local $0)))
 (func (export "i16x8.all_true") (param $0 v128) (result i32) (i16x8.all_true (get_local $0)))
 (func (export "i16x8.shl") (param $0 v128) (param $1 i32) (result v128) (i16x8.shl (get_local $0) (get_local $1)))
 (func (export "i16x8.shr_s") (param $0 v128) (param $1 i32) (result v128) (i16x8.shr_s (get_local $0) (get_local $1)))
 (func (export "i16x8.shr_u") (param $0 v128) (param $1 i32) (result v128) (i16x8.shr_u (get_local $0) (get_local $1)))
 (func (export "i16x8.add") (param $0 v128) (param $1 v128) (result v128) (i16x8.add (get_local $0) (get_local $1)))
 (func (export "i16x8.add_saturate_s") (param $0 v128) (param $1 v128) (result v128) (i16x8.add_saturate_s (get_local $0) (get_local $1)))
 (func (export "i16x8.add_saturate_u") (param $0 v128) (param $1 v128) (result v128) (i16x8.add_saturate_u (get_local $0) (get_local $1)))
 (func (export "i16x8.sub") (param $0 v128) (param $1 v128) (result v128) (i16x8.sub (get_local $0) (get_local $1)))
 (func (export "i16x8.sub_saturate_s") (param $0 v128) (param $1 v128) (result v128) (i16x8.sub_saturate_s (get_local $0) (get_local $1)))
 (func (export "i16x8.sub_saturate_u") (param $0 v128) (param $1 v128) (result v128) (i16x8.sub_saturate_u (get_local $0) (get_local $1)))
 (func (export "i16x8.mul") (param $0 v128) (param $1 v128) (result v128) (i16x8.mul (get_local $0) (get_local $1)))
 (func (export "i32x4.neg") (param $0 v128) (result v128) (i32x4.neg (get_local $0)))
 (func (export "i32x4.any_true") (param $0 v128) (result i32) (i32x4.any_true (get_local $0)))
 (func (export "i32x4.all_true") (param $0 v128) (result i32) (i32x4.all_true (get_local $0)))
 (func (export "i32x4.shl") (param $0 v128) (param $1 i32) (result v128) (i32x4.shl (get_local $0) (get_local $1)))
 (func (export "i32x4.shr_s") (param $0 v128) (param $1 i32) (result v128) (i32x4.shr_s (get_local $0) (get_local $1)))
 (func (export "i32x4.shr_u") (param $0 v128) (param $1 i32) (result v128) (i32x4.shr_u (get_local $0) (get_local $1)))
 (func (export "i32x4.add") (param $0 v128) (param $1 v128) (result v128) (i32x4.add (get_local $0) (get_local $1)))
 (func (export "i32x4.sub") (param $0 v128) (param $1 v128) (result v128) (i32x4.sub (get_local $0) (get_local $1)))
 (func (export "i32x4.mul") (param $0 v128) (param $1 v128) (result v128) (i32x4.mul (get_local $0) (get_local $1)))
 (func (export "i64x2.neg") (param $0 v128) (result v128) (i64x2.neg (get_local $0)))
 (func (export "i64x2.any_true") (param $0 v128) (result i32) (i64x2.any_true (get_local $0)))
 (func (export "i64x2.all_true") (param $0 v128) (result i32) (i64x2.all_true (get_local $0)))
 (func (export "i64x2.shl") (param $0 v128) (param $1 i32) (result v128) (i64x2.shl (get_local $0) (get_local $1)))
 (func (export "i64x2.shr_s") (param $0 v128) (param $1 i32) (result v128) (i64x2.shr_s (get_local $0) (get_local $1)))
 (func (export "i64x2.shr_u") (param $0 v128) (param $1 i32) (result v128) (i64x2.shr_u (get_local $0) (get_local $1)))
 (func (export "i64x2.add") (param $0 v128) (param $1 v128) (result v128) (i64x2.add (get_local $0) (get_local $1)))
 (func (export "i64x2.sub") (param $0 v128) (param $1 v128) (result v128) (i64x2.sub (get_local $0) (get_local $1)))
 (func (export "f32x4.add") (param $0 v128) (param $1 v128) (result v128) (f32x4.add (get_local $0) (get_local $1)))
 (func (export "f32x4.sub") (param $0 v128) (param $1 v128) (result v128) (f32x4.sub (get_local $0) (get_local $1)))
 (func (export "f32x4.mul") (param $0 v128) (param $1 v128) (result v128) (f32x4.mul (get_local $0) (get_local $1)))
 (func (export "f32x4.div") (param $0 v128) (param $1 v128) (result v128) (f32x4.div (get_local $0) (get_local $1)))
 (func (export "f32x4.min") (param $0 v128) (param $1 v128) (result v128) (f32x4.min (get_local $0) (get_local $1)))
 (func (export "f32x4.max") (param $0 v128) (param $1 v128) (result v128) (f32x4.max (get_local $0) (get_local $1)))
 (func (export "f32x4.abs") (param $0 v128) (result v128) (f32x4.abs (get_local $0)))
 (func (export "f32x4.neg") (param $0 v128) (result v128) (f32x4.neg (get_local $0)))
 (func (export "f32x4.sqrt") (param $0 v128) (result v128) (f32x4.sqrt (get_local $0)))
 (func (export "f64x2.add") (param $0 v128) (param $1 v128) (result v128) (f64x2.add (get_local $0) (get_local $1)))
 (func (export "f64x2.sub") (param $0 v128) (param $1 v128) (result v128) (f64x2.sub (get_local $0) (get_local $1)))
 (func (export "f64x2.mul") (param $0 v128) (param $1 v128) (result v128) (f64x2.mul (get_local $0) (get_local $1)))
 (func (export "f64x2.div") (param $0 v128) (param $1 v128) (result v128) (f64x2.div (get_local $0) (get_local $1)))
 (func (export "f64x2.min") (param $0 v128) (param $1 v128) (result v128) (f64x2.min (get_local $0) (get_local $1)))
 (func (export "f64x2.max") (param $0 v128) (param $1 v128) (result v128) (f64x2.max (get_local $0) (get_local $1)))
 (func (export "f64x2.abs") (param $0 v128) (result v128) (f64x2.abs (get_local $0)))
 (func (export "f64x2.neg") (param $0 v128) (result v128) (f64x2.neg (get_local $0)))
 (func (export "f64x2.sqrt") (param $0 v128) (result v128) (f64x2.sqrt (get_local $0)))
 (func (export "i32x4.trunc_s/f32x4:sat") (param $0 v128) (result v128) (i32x4.trunc_s/f32x4:sat (get_local $0)))
 (func (export "i32x4.trunc_u/f32x4:sat") (param $0 v128) (result v128) (i32x4.trunc_u/f32x4:sat (get_local $0)))
 (func (export "i64x2.trunc_s/f64x2:sat") (param $0 v128) (result v128) (i64x2.trunc_s/f64x2:sat (get_local $0)))
 (func (export "i64x2.trunc_u/f64x2:sat") (param $0 v128) (result v128) (i64x2.trunc_u/f64x2:sat (get_local $0)))
 (func (export "f32x4.convert_s/i32x4") (param $0 v128) (result v128) (f32x4.convert_s/i32x4 (get_local $0)))
 (func (export "f32x4.convert_u/i32x4") (param $0 v128) (result v128) (f32x4.convert_u/i32x4 (get_local $0)))
 (func (export "f64x2.convert_s/i64x2") (param $0 v128) (result v128) (f64x2.convert_s/i64x2 (get_local $0)))
 (func (export "f64x2.convert_u/i64x2") (param $0 v128) (result v128) (f64x2.convert_u/i64x2 (get_local $0)))
)

;; Basic v128 manipulation
(assert_return (invoke "v128.load" (i32.const 128)) (v128.const i32 87 65 83 77 83 73 77 68 71 79 69 83 70 65 83 84))
(assert_return (invoke "v128.store" (i32.const 16) (v128.const i32 1 2 3 4)) (v128.const i32 1 2 3 4))
(assert_return (invoke "v128.const") (v128.const i32 01 00 00 00 02 00 00 00 03 00 00 00 04 00 00 00))
(assert_return
  (invoke "v128.shuffle_interleave_bytes"
    (v128.const i32 1 0 3 0 5 0 7 0 9 0 11 0 13 0 15 0)
    (v128.const i32 0 2 0 4 0 6 0 8 0 10 0 12 0 14 0 16)
  )
  (v128.const i32 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16)
)
(assert_return (invoke "v128.shuffle_reverse_i32s" (v128.const i32 1 2 3 4)) (v128.const i32 4 3 2 1))

;; i8x16 lane accesses
(assert_return (invoke "i8x16.splat" (i32.const 5)) (v128.const i32 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5))
(assert_return (invoke "i8x16.splat" (i32.const 257)) (v128.const i32 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1))
(assert_return (invoke "i8x16.extract_lane_s_first" (v128.const i32 255 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)) (i32.const -1))
(assert_return (invoke "i8x16.extract_lane_s_last" (v128.const i32 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 255)) (i32.const -1))
(assert_return (invoke "i8x16.extract_lane_u_first" (v128.const i32 255 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)) (i32.const 255))
(assert_return (invoke "i8x16.extract_lane_u_last" (v128.const i32 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 255)) (i32.const 255))
(assert_return (invoke "i8x16.replace_lane_first" (v128.const i64 0 0) (i32.const 7)) (v128.const i32 7 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
(assert_return (invoke "i8x16.replace_lane_last" (v128.const i64 0 0) (i32.const 7)) (v128.const i32 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 7))

;; i16x8 lane accesses
(assert_return (invoke "i16x8.splat" (i32.const 5)) (v128.const i32 5 5 5 5 5 5 5 5))
(assert_return (invoke "i16x8.splat" (i32.const 65537)) (v128.const i32 1 1 1 1 1 1 1 1))
(assert_return (invoke "i16x8.extract_lane_s_first" (v128.const i32 65535 0 0 0 0 0 0 0)) (i32.const -1))
(assert_return (invoke "i16x8.extract_lane_s_last" (v128.const i32 0 0 0 0 0 0 0 65535)) (i32.const -1))
(assert_return (invoke "i16x8.extract_lane_u_first" (v128.const i32 65535 0 0 0 0 0 0 0)) (i32.const 65535))
(assert_return (invoke "i16x8.extract_lane_u_last" (v128.const i32 0 0 0 0 0 0 0 65535)) (i32.const 65535))
(assert_return (invoke "i16x8.replace_lane_first" (v128.const i64 0 0) (i32.const 7)) (v128.const i32 7 0 0 0 0 0 0 0))
(assert_return (invoke "i16x8.replace_lane_last" (v128.const i64 0 0) (i32.const 7)) (v128.const i32 0 0 0 0 0 0 0 7))

;; i32x4 lane accesses
(assert_return (invoke "i32x4.splat" (i32.const -5)) (v128.const i32 -5 -5 -5 -5))
(assert_return (invoke "i32x4.extract_lane_first" (v128.const i32 -5 0 0 0)) (i32.const -5))
(assert_return (invoke "i32x4.extract_lane_last" (v128.const i32 0 0 0 -5)) (i32.const -5))
(assert_return (invoke "i32x4.replace_lane_first" (v128.const i64 0 0) (i32.const 53)) (v128.const i32 53 0 0 0))
(assert_return (invoke "i32x4.replace_lane_last" (v128.const i64 0 0) (i32.const 53)) (v128.const i32 0 0 0 53))

;; i64x2 lane accesses
(assert_return (invoke "i64x2.splat" (i64.const -5)) (v128.const i64 -5 -5))
(assert_return (invoke "i64x2.extract_lane_first" (v128.const i64 -5 0)) (i64.const -5))
(assert_return (invoke "i64x2.extract_lane_last" (v128.const i64 0 -5)) (i64.const -5))
(assert_return (invoke "i64x2.replace_lane_first" (v128.const i64 0 0) (i64.const 53)) (v128.const i64 53 0))
(assert_return (invoke "i64x2.replace_lane_last" (v128.const i64 0 0) (i64.const 53)) (v128.const i64 0 53))

;; f32x4 lane accesses
(assert_return (invoke "f32x4.splat" (f32.const -5)) (v128.const f32 -5 -5 -5 -5))
(assert_return (invoke "f32x4.extract_lane_first" (v128.const f32 -5 0 0 0)) (f32.const -5))
(assert_return (invoke "f32x4.extract_lane_last" (v128.const f32 0 0 0 -5)) (f32.const -5))
(assert_return (invoke "f32x4.replace_lane_first" (v128.const i64 0 0) (f32.const 53)) (v128.const f32 53 0 0 0))
(assert_return (invoke "f32x4.replace_lane_last" (v128.const i64 0 0) (f32.const 53)) (v128.const f32 0 0 0 53))

;; f64x2 lane accesses
(assert_return (invoke "f64x2.splat" (f64.const -5)) (v128.const f64 -5 -5))
(assert_return (invoke "f64x2.extract_lane_first" (v128.const f64 -5 0)) (f64.const -5))
(assert_return (invoke "f64x2.extract_lane_last" (v128.const f64 0 -5)) (f64.const -5))
(assert_return (invoke "f64x2.replace_lane_first" (v128.const f64 0 0) (f64.const 53)) (v128.const f64 53 0))
(assert_return (invoke "f64x2.replace_lane_last" (v128.const f64 0 0) (f64.const 53)) (v128.const f64 0 53))

;; i8x16 comparisons
(assert_return
  (invoke "i8x16.eq"
    (v128.const i32 0 127 13 128 1   13  129 42  0 127 255 42  1   13  129 42)
    (v128.const i32 0 255 13 42  129 127 0   128 0 255 13  42  129 127 0   128)
  )
  (v128.const i32 -1 0 -1 0 0 0 0 0 -1 0 0 -1 0 0 0 0)
)
(assert_return
  (invoke "i8x16.ne"
    (v128.const i32 0 127 13 128 1   13  129 42  0 127 255 42  1   13  129 42)
    (v128.const i32 0 255 13 42  129 127 0   128 0 255 13  42  129 127 0   128)
  )
  (v128.const i32 0 -1 0 -1 -1 -1 -1 -1 0 -1 -1 0 -1 -1 -1 -1)
)
(assert_return
  (invoke "i8x16.lt_s"
    (v128.const i32 0 127 13 128 1   13  129 42  0 127 255 42  1   13  129 42)
    (v128.const i32 0 255 13 42  129 127 0   128 0 255 13  42  129 127 0   128)
  )
  (v128.const i32 0 0 0 -1 0 -1 -1 0 0 0 -1 0 0 -1 -1 0)
)
(assert_return
  (invoke "i8x16.lt_u"
    (v128.const i32 0 127 13 128 1   13  129 42  0 127 255 42  1   13  129 42)
    (v128.const i32 0 255 13 42  129 127 0   128 0 255 13  42  129 127 0   128)
  )
  (v128.const i32 0 -1 0 0 -1 -1 0 -1 0 -1 0 0 -1 -1 0 -1)
)
(assert_return
  (invoke "i8x16.gt_s"
    (v128.const i32 0 127 13 128 1   13  129 42  0 127 255 42  1   13  129 42)
    (v128.const i32 0 255 13 42  129 127 0   128 0 255 13  42  129 127 0   128)
  )
  (v128.const i32 0 -1 0 0 -1 0 0 -1 0 -1 0 0 -1 0 0 -1)
)
(assert_return
  (invoke "i8x16.gt_u"
    (v128.const i32 0 127 13 128 1   13  129 42  0 127 255 42  1   13  129 42)
    (v128.const i32 0 255 13 42  129 127 0   128 0 255 13  42  129 127 0   128)
  )
  (v128.const i32 0 0 0 -1 0 0 -1 0 0 0 -1 0 0 0 -1 0)
)
(assert_return
  (invoke "i8x16.le_s"
    (v128.const i32 0 127 13 128 1   13  129 42  0 127 255 42  1   13  129 42)
    (v128.const i32 0 255 13 42  129 127 0   128 0 255 13  42  129 127 0   128)
  )
  (v128.const i32 -1 0 -1 -1 0 -1 -1 0 -1 0 -1 -1 0 -1 -1 0)
)
(assert_return
  (invoke "i8x16.le_u"
    (v128.const i32 0 127 13 128 1   13  129 42  0 127 255 42  1   13  129 42)
    (v128.const i32 0 255 13 42  129 127 0   128 0 255 13  42  129 127 0   128)
  )
  (v128.const i32 -1 -1 -1 0 -1 -1 0 -1 -1 -1 0 -1 -1 -1 0 -1)
)
(assert_return
  (invoke "i8x16.ge_s"
    (v128.const i32 0 127 13 128 1   13  129 42  0 127 255 42  1   13  129 42)
    (v128.const i32 0 255 13 42  129 127 0   128 0 255 13  42  129 127 0   128)
  )
  (v128.const i32 -1 -1 -1 0 -1 0 0 -1 -1 -1 0 -1 -1 0 0 -1)
)
(assert_return
  (invoke "i8x16.ge_u"
    (v128.const i32 0 127 13 128 1   13  129 42  0 127 255 42  1   13  129 42)
    (v128.const i32 0 255 13 42  129 127 0   128 0 255 13  42  129 127 0   128)
  )
  (v128.const i32 -1 0 -1 -1 0 0 -1 0 -1 0 -1 -1 0 0 -1 0)
)

;; i16x8 comparisons
(assert_return (invoke "i16x8.eq"
    (v128.const i32 0 32767 13 32768 1     32769 42    40000)
    (v128.const i32 0 13    1  32767 32769 42    40000 32767)
  )
  (v128.const i32 -1 0 0 0 0 0 0 0)
)
(assert_return
  (invoke "i16x8.ne"
    (v128.const i32 0 32767 13 32768 1     32769 42    40000)
    (v128.const i32 0 13    1  32767 32769 42    40000 32767)
  )
  (v128.const i32 0 -1 -1 -1 -1 -1 -1 -1)
)
(assert_return
  (invoke "i16x8.lt_s"
    (v128.const i32 0 32767 13 32768 1     32769 42    40000)
    (v128.const i32 0 13    1  32767 32769 42    40000 32767)
  )
  (v128.const i32 0 0 0 -1 0 -1 0 -1)
)
(assert_return
  (invoke "i16x8.lt_u"
    (v128.const i32 0 32767 13 32768 1     32769 42    40000)
    (v128.const i32 0 13    1  32767 32769 42    40000 32767)
  )
  (v128.const i32 0 0 0 0 -1 0 -1 0)
)
(assert_return
  (invoke "i16x8.gt_s"
    (v128.const i32 0 32767 13 32768 1     32769 42    40000)
    (v128.const i32 0 13    1  32767 32769 42    40000 32767)
  )
  (v128.const i32 0 -1 -1 0 -1 0 -1 0)
)
(assert_return
  (invoke "i16x8.gt_u"
    (v128.const i32 0 32767 13 32768 1     32769 42    40000)
    (v128.const i32 0 13    1  32767 32769 42    40000 32767)
  )
  (v128.const i32 0 -1 -1 -1 0 -1 0 -1)
)
(assert_return
  (invoke "i16x8.le_s"
    (v128.const i32 0 32767 13 32768 1     32769 42    40000)
    (v128.const i32 0 13    1  32767 32769 42    40000 32767)
  )
  (v128.const i32 -1 0 0 -1 0 -1 0 -1)
)
(assert_return
  (invoke "i16x8.le_u"
    (v128.const i32 0 32767 13 32768 1     32769 42    40000)
    (v128.const i32 0 13    1  32767 32769 42    40000 32767)
  )
  (v128.const i32 -1 0 0 0 -1 0 -1 0)
)
(assert_return
  (invoke "i16x8.ge_s"
    (v128.const i32 0 32767 13 32768 1     32769 42    40000)
    (v128.const i32 0 13    1  32767 32769 42    40000 32767)
  )
  (v128.const i32 -1 -1 -1 0 -1 0 -1 0)
)
(assert_return
  (invoke "i16x8.ge_u"
    (v128.const i32 0 32767 13 32768 1     32769 42    40000)
    (v128.const i32 0 13    1  32767 32769 42    40000 32767)
  )
  (v128.const i32 -1 -1 -1 -1 0 -1 0 -1)
)

;; i32x4 comparisons
(assert_return (invoke "i32x4.eq" (v128.const i32 0 -1 53 -7) (v128.const i32 0 53 -7 -1)) (v128.const i32 -1 0 0 0))
(assert_return (invoke "i32x4.ne" (v128.const i32 0 -1 53 -7) (v128.const i32 0 53 -7 -1)) (v128.const i32 0 -1 -1 -1))
(assert_return (invoke "i32x4.lt_s" (v128.const i32 0 -1 53 -7) (v128.const i32 0 53 -7 -1)) (v128.const i32 0 -1 0 -1))
(assert_return (invoke "i32x4.lt_u" (v128.const i32 0 -1 53 -7) (v128.const i32 0 53 -7 -1)) (v128.const i32 0 0 -1 -1))
(assert_return (invoke "i32x4.gt_s" (v128.const i32 0 -1 53 -7) (v128.const i32 0 53 -7 -1)) (v128.const i32 0 0 -1 0))
(assert_return (invoke "i32x4.gt_u" (v128.const i32 0 -1 53 -7) (v128.const i32 0 53 -7 -1)) (v128.const i32 0 -1 0 0))
(assert_return (invoke "i32x4.le_s" (v128.const i32 0 -1 53 -7) (v128.const i32 0 53 -7 -1)) (v128.const i32 -1 -1 0 -1))
(assert_return (invoke "i32x4.le_u" (v128.const i32 0 -1 53 -7) (v128.const i32 0 53 -7 -1)) (v128.const i32 -1 0 -1 -1))
(assert_return (invoke "i32x4.ge_s" (v128.const i32 0 -1 53 -7) (v128.const i32 0 53 -7 -1)) (v128.const i32 -1 0 -1 0))
(assert_return (invoke "i32x4.ge_u" (v128.const i32 0 -1 53 -7) (v128.const i32 0 53 -7 -1)) (v128.const i32 -1 -1 0 0))

;; f32x4 comparisons
(assert_return (invoke "f32x4.eq" (v128.const f32 0 -1 1 0) (v128.const f32 0 0 -1 1)) (v128.const i32 -1 0 0 0))
(assert_return (invoke "f32x4.ne" (v128.const f32 0 -1 1 0) (v128.const f32 0 0 -1 1)) (v128.const i32 0 -1 -1 -1))
(assert_return (invoke "f32x4.lt" (v128.const f32 0 -1 1 0) (v128.const f32 0 0 -1 1)) (v128.const i32 0 -1 0 -1))
(assert_return (invoke "f32x4.gt" (v128.const f32 0 -1 1 0) (v128.const f32 0 0 -1 1)) (v128.const i32 0 0 -1 0))
(assert_return (invoke "f32x4.le" (v128.const f32 0 -1 1 0) (v128.const f32 0 0 -1 1)) (v128.const i32 -1 -1 0 -1))
(assert_return (invoke "f32x4.ge" (v128.const f32 0 -1 1 0) (v128.const f32 0 0 -1 1)) (v128.const i32 -1 0 -1 0))
(assert_return (invoke "f32x4.eq" (v128.const f32 nan 0 nan infinity) (v128.const f32 0 nan nan infinity)) (v128.const i32 0 0 0 -1))
(assert_return (invoke "f32x4.ne" (v128.const f32 nan 0 nan infinity) (v128.const f32 0 nan nan infinity)) (v128.const i32 -1 -1 -1 0))
(assert_return (invoke "f32x4.lt" (v128.const f32 nan 0 nan infinity) (v128.const f32 0 nan nan infinity)) (v128.const i32 0 0 0 0))
(assert_return (invoke "f32x4.gt" (v128.const f32 nan 0 nan infinity) (v128.const f32 0 nan nan infinity)) (v128.const i32 0 0 0 0))
(assert_return (invoke "f32x4.le" (v128.const f32 nan 0 nan infinity) (v128.const f32 0 nan nan infinity)) (v128.const i32 0 0 0 -1))
(assert_return (invoke "f32x4.ge" (v128.const f32 nan 0 nan infinity) (v128.const f32 0 nan nan infinity)) (v128.const i32 0 0 0 -1))
(assert_return (invoke "f32x4.eq" (v128.const f32 -infinity 0 nan -infinity) (v128.const f32 0 infinity infinity nan)) (v128.const i32 0 0 0 0))
(assert_return (invoke "f32x4.ne" (v128.const f32 -infinity 0 nan -infinity) (v128.const f32 0 infinity infinity nan)) (v128.const i32 -1 -1 -1 -1))
(assert_return (invoke "f32x4.lt" (v128.const f32 -infinity 0 nan -infinity) (v128.const f32 0 infinity infinity nan)) (v128.const i32 -1 -1 0 0))
(assert_return (invoke "f32x4.gt" (v128.const f32 -infinity 0 nan -infinity) (v128.const f32 0 infinity infinity nan)) (v128.const i32 0 0 0 0))
(assert_return (invoke "f32x4.le" (v128.const f32 -infinity 0 nan -infinity) (v128.const f32 0 infinity infinity nan)) (v128.const i32 -1 -1 0 0))
(assert_return (invoke "f32x4.ge" (v128.const f32 -infinity 0 nan -infinity) (v128.const f32 0 infinity infinity nan)) (v128.const i32 0 0 0 0))

;; f64x2 comparisons
(assert_return (invoke "f64x2.eq" (v128.const f64 0 1) (v128.const f64 0 0)) (v128.const i64 -1 0))
(assert_return (invoke "f64x2.ne" (v128.const f64 0 1) (v128.const f64 0 0)) (v128.const i64 0 -1))
(assert_return (invoke "f64x2.lt" (v128.const f64 0 1) (v128.const f64 0 0)) (v128.const i64 0 0))
(assert_return (invoke "f64x2.gt" (v128.const f64 0 1) (v128.const f64 0 0)) (v128.const i64 0 -1))
(assert_return (invoke "f64x2.le" (v128.const f64 0 1) (v128.const f64 0 0)) (v128.const i64 -1 0))
(assert_return (invoke "f64x2.ge" (v128.const f64 0 1) (v128.const f64 0 0)) (v128.const i64 -1 -1))
(assert_return (invoke "f64x2.eq" (v128.const f64 nan 0) (v128.const f64 infinity infinity)) (v128.const i64 0 0))
(assert_return (invoke "f64x2.ne" (v128.const f64 nan 0) (v128.const f64 infinity infinity)) (v128.const i64 -1 -1))
(assert_return (invoke "f64x2.lt" (v128.const f64 nan 0) (v128.const f64 infinity infinity)) (v128.const i64 0 -1))
(assert_return (invoke "f64x2.gt" (v128.const f64 nan 0) (v128.const f64 infinity infinity)) (v128.const i64 0 0))
(assert_return (invoke "f64x2.le" (v128.const f64 nan 0) (v128.const f64 infinity infinity)) (v128.const i64 0 -1))
(assert_return (invoke "f64x2.ge" (v128.const f64 nan 0) (v128.const f64 infinity infinity)) (v128.const i64 0 0))

;; bitwise operations
(assert_return (invoke "v128.not" (v128.const i32 0 -1 0 -1)) (v128.const i32 -1 0 -1 0))
(assert_return (invoke "v128.and" (v128.const i32 0 0 -1 -1) (v128.const i32 0 -1 0 -1)) (v128.const i32 0 0 0 -1))
(assert_return (invoke "v128.or" (v128.const i32 0 0 -1 -1) (v128.const i32 0 -1 0 -1)) (v128.const i32 0 -1 -1 -1))
(assert_return (invoke "v128.xor" (v128.const i32 0 0 -1 -1) (v128.const i32 0 -1 0 -1)) (v128.const i32 0 -1 -1 0))
(assert_return (invoke "v128.bitselect"
    (v128.const i32 0xAAAAAAAA 0xAAAAAAAA 0xAAAAAAAA 0xAAAAAAAA)
    (v128.const i32 0xBBBBBBBB 0xBBBBBBBB 0xBBBBBBBB 0xBBBBBBBB)
    (v128.const i32 0xF0F0F0F0 0xFFFFFFFF 0x00000000 0xFF00FF00)
  )
  (v128.const i32 0xABABABAB 0xAAAAAAAA 0xBBBBBBBB 0xAABBAABB)
)
