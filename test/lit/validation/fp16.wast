;; Test that fp16 operations require the fp16 feature.

;; RUN: not wasm-opt %s --enable-simd 2>&1 | filecheck %s --check-prefix NO-FP16
;; RUN: wasm-opt %s --enable-simd --enable-fp16 -o - -S | filecheck %s --check-prefix FP16

;; NO-FP16: FP16 operations require FP16 [--enable-fp16]
;; FP16: (type $0 (func (param v128 v128) (result v128)))

(module
  (func (export "f16x8.add") (param $0 v128) (param $1 v128) (result v128) (f16x8.add (local.get $0) (local.get $1)))
)
