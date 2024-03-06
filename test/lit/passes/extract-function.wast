;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; RUN: foreach %s %t wasm-opt --extract-function=foo -S -o - | filecheck %s
;; RUN: foreach %s %t wasm-opt --extract-function --pass-arg=extract-function@foo -S -o - | filecheck %s
;; RUN: foreach %s %t wasm-opt --extract-function-index=0 -S -o - | filecheck %s
;; RUN: foreach %s %t wasm-opt --extract-function-index --pass-arg=extract-function-index@0 -S -o - | filecheck %s

(module
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (import "env" "bar" (func $bar))

  ;; CHECK:      (export "foo" (func $foo))

  ;; CHECK:      (func $foo
  ;; CHECK-NEXT:  (call $bar)
  ;; CHECK-NEXT: )
  (func $foo
    (call $bar)
  )

  (func $bar
    (call $foo)
  )

  (func $other
    (drop (i32.const 1))
  )
)

(module
  ;; Use another function in the table, but the table is not used in the
  ;; extracted function
  (table $t 10 funcref)

  (elem $0 (table $t) (i32.const 0) func $other)

  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (import "env" "other" (func $other))

  ;; CHECK:      (export "foo" (func $foo))

  ;; CHECK:      (func $foo
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $foo
    (nop)
  )

  (func $other
    (drop (i32.const 1))
  )
)

(module
  ;; Use another function in the table, and the table *is* used. As a result,
  ;; the table and its elements will remain. The called function, $other, will
  ;; remain as an import that is placed in the table.

  ;; CHECK:      (type $none (func))
  (type $none (func))

  ;; CHECK:      (import "env" "other" (func $other))

  ;; CHECK:      (table $t 10 funcref)
  (table $t 10 funcref)

  ;; CHECK:      (elem $0 (offset (i32.const 0)) $other)
  (elem $0 (table $t) (i32.const 0) func $other)

  ;; Test that an existing export does not cause us to crash.
  ;; CHECK:      (export "foo" (func $foo))
  (export "foo" (func $foo))

  ;; CHECK:      (func $foo
  ;; CHECK-NEXT:  (call_indirect (type $none)
  ;; CHECK-NEXT:   (i32.const 10)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $foo
   (call_indirect (type $none) (i32.const 10))
  )

  (func $other
    (drop (i32.const 1))
  )
)
