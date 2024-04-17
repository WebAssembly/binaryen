;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.

;; Test that we roundtrip br_if with a reference value properly if GC is not
;; enabled. We emit a ref.cast in such cases when GC is used, but if only
;; reference types are enabled then we can only use a ref.as_non_null (to fix up
;; the type difference between Binaryen IR and the wasm spec, on the typing of
;; br_if).

;; RUN: wasm-opt %s --enable-reference-types --roundtrip -S -o - | filecheck %s

(module
  ;; CHECK:      (func $test (param $x i32) (result funcref)
  ;; CHECK-NEXT:  (block $label$1 (result funcref)
  ;; CHECK-NEXT:   (br_if $label$1
  ;; CHECK-NEXT:    (ref.func $test)
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test (param $x i32) (result funcref)
    (block $out (result funcref)
      (br_if $out
        ;; This has non-nullable type, which is more refined than the block, so
        ;; it looks like we need to emit a cast after the br_if.
        (ref.func $test)
        (local.get $x)
      )
    )
  )
)