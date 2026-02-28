;; RUN: not wasm-opt --enable-simd %s 2>&1 | filecheck %s

;; CHECK: SIMD ternary operation requires additional features, on
;; CHECK: [--enable-relaxed-simd --enable-fp16]

(module
  (func $fp16 (param v128 v128 v128)
    (f16x8.relaxed_madd (local.get 0) (local.get 1) (local.get 2))
  )
)
