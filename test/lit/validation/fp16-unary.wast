;; RUN: foreach %s %t not wasm-opt --enable-simd 2>&1 | filecheck %s
;; RUN: foreach %s %t wasm-opt --enable-simd --enable-fp16 -o /dev/null

;; CHECK: FP16 operations require FP16 [--enable-fp16]
(module (func (param v128) (result v128)
  (f32x4.promote_low_f16x8 (local.get 0))))

;; CHECK: FP16 operations require FP16 [--enable-fp16]
(module (func (param v128) (result v128)
  (f16x8.demote_f32x4_zero (local.get 0))))

;; CHECK: FP16 operations require FP16 [--enable-fp16]
(module (func (param v128) (result v128)
  (f16x8.demote_f64x2_zero (local.get 0))))

;; CHECK: FP16 operations require FP16 [--enable-fp16]
(module (func (param v128) (result v128)
  (i16x8.trunc_sat_f16x8_s (local.get 0))))

;; CHECK: FP16 operations require FP16 [--enable-fp16]
(module (func (param v128) (result v128)
  (i16x8.trunc_sat_f16x8_u (local.get 0))))

;; CHECK: FP16 operations require FP16 [--enable-fp16]
(module (func (param v128) (result v128)
  (f16x8.convert_i16x8_s (local.get 0))))

;; CHECK: FP16 operations require FP16 [--enable-fp16]
(module (func (param v128) (result v128)
  (f16x8.convert_i16x8_u (local.get 0))))
