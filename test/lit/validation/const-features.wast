;; Test that validator errors when constants require features that are not
;; enabled.

;; RUN: not wasm-opt %s 2>&1 | filecheck %s --check-prefix NO-SIMD
;; RUN: wasm-opt %s --enable-simd -o - -S | filecheck %s --check-prefix SIMD

;; NO-SIMD:      Const type requires additional features, on
;; NO-SIMD-NEXT: (v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000)
;; NO-SIMD-NEXT: [--enable-simd]
;; NO-SIMD-NEXT: Fatal: error validating input

;; SIMD: (v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000)
;; SIMD: (i32.const 0)

(module
  (func $v128
    (drop
      (v128.const i32x4 0 0 0 0)
    )
  )
  (func $i32
    (drop
      (i32.const 0)
    )
  )
)
