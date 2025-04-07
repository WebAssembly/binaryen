;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: wasm-opt %s --precompute -all -S -o - | filecheck %s

(module
  ;; CHECK:      (type $0 (func (result v128)))

  ;; CHECK:      (func $relaxed-madd (type $0) (result v128)
  ;; CHECK-NEXT:  (f32x4.relaxed_madd
  ;; CHECK-NEXT:   (v128.const i32x4 0x3f800000 0x40000000 0x40400000 0x40800000)
  ;; CHECK-NEXT:   (v128.const i32x4 0x40a00000 0x40c00000 0x40e00000 0x41000000)
  ;; CHECK-NEXT:   (v128.const i32x4 0x41100000 0x40400000 0x3f800000 0x00000000)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $relaxed-madd (result v128)
    ;; Though this is all constant and precomputable, we do not optimize
    ;; relaxed SIMD operations.
    ;; TODO if we optimize some cases of relaxed operations (ones without
    ;;      nondeterminism) we should pick proper nondeterministic values here.
    (f32x4.relaxed_madd
      (v128.const f32x4 1 2 3 4)
      (v128.const f32x4 5 6 7 8)
      (v128.const f32x4 9 3 1 0)
    )
  )

  ;; CHECK:      (func $normal-add (type $0) (result v128)
  ;; CHECK-NEXT:  (v128.const i32x4 0x41600000 0x41100000 0x41000000 0x41000000)
  ;; CHECK-NEXT: )
  (func $normal-add (result v128)
    ;; For comparison, we do optimize non-relaxed SIMD.
    (f32x4.add
      (v128.const f32x4 5 6 7 8)
      (v128.const f32x4 9 3 1 0)
    )
  )
)
