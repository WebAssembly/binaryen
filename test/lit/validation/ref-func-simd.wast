;; A function type that uses a SIMD type requires the SIMD feature.
;; RUN: not wasm-opt --enable-reference-types %s 2>&1 | filecheck %s

;; CHECK: all used types should be allowed

(module
  (type $simd-user (func (param v128)))

  (global $g (ref null $simd-user) (ref.null func))
)

;; But it passes with the feature enabled.
;; RUN: wasm-opt --enable-reference-types --enable-simd %s
