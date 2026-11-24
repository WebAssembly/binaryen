;; Test that validator errors when binary operations use features that are not
;; enabled.

;; RUN: not wasm-opt %s 2>&1 | filecheck %s --check-prefix NONE
;; RUN: not wasm-opt %s --enable-simd 2>&1 | filecheck %s --check-prefix SIMD
;; RUN: wasm-opt %s --enable-simd --enable-relaxed-simd -o - -S | filecheck %s --check-prefix ALL

;; NONE:      Binary operation requires additional features, on
;; NONE-NEXT: (i8x16.add
;; NONE-NEXT:  (unreachable)
;; NONE-NEXT:  (unreachable)
;; NONE-NEXT: )
;; NONE-NEXT: [--enable-simd]
;; NONE-NEXT: [wasm-validator error in function relaxed] unexpected false: Binary operation requires additional features, on
;; NONE-NEXT: (f32x4.relaxed_min
;; NONE-NEXT:  (unreachable)
;; NONE-NEXT:  (unreachable)
;; NONE-NEXT: )
;; NONE-NEXT: [--enable-simd --enable-relaxed-simd]
;; NONE-NEXT: Fatal: error validating input

;; SIMD:      [wasm-validator error in function relaxed] unexpected false: Binary operation requires additional features, on
;; SIMD-NEXT: (f32x4.relaxed_min
;; SIMD-NEXT:  (unreachable)
;; SIMD-NEXT:  (unreachable)
;; SIMD-NEXT: )
;; SIMD-NEXT: [--enable-relaxed-simd]
;; SIMD-NEXT: Fatal: error validating input

;; ALL: (i8x16.add
;; ALL: (f32x4.relaxed_min
;; ALL: (i32.add

(module
  (func $simd
    (drop
      (i8x16.add (unreachable) (unreachable))
    )
  )
  (func $relaxed
    (drop
      (f32x4.relaxed_min (unreachable) (unreachable))
    )
  )
  (func $mvp (result i32)
    (i32.add (i32.const 1) (i32.const 2))
  )
)
