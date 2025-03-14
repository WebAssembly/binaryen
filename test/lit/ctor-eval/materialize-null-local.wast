;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: wasm-ctor-eval %s -all --ctors=test --kept-exports=test --ignore-external-input -S -o - \
;; RUN:     | filecheck %s

;; Check that materializing a non-data null local, which at time of writing uses
;; Builder::makeConstantExpression, does not trigger an assertion failure.

(module
 (func $test (export "test") (param $0 externref)
  (local $3 anyref)
  (local.set $3
   (any.convert_extern
    (local.get $0)
   )
  )
 )
)
;; CHECK:      (type $0 (func (param externref)))

;; CHECK:      (export "test" (func $test_1))

;; CHECK:      (func $test_1 (type $0) (param $0 externref)
;; CHECK-NEXT:  (local $3 anyref)
;; CHECK-NEXT:  (nop)
;; CHECK-NEXT: )
