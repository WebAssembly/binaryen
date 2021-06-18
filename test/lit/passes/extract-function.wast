;; RUN: foreach %s %t wasm-opt --extract-function=foo -S -o - | filecheck %s
;; RUN: foreach %s %t wasm-opt --extract-function --pass-arg=extract-function@foo -S -o - | filecheck %s
;; RUN: foreach %s %t wasm-opt --extract-function-index=0 -S -o - | filecheck %s
;; RUN: foreach %s %t wasm-opt --extract-function-index --pass-arg=extract-function-index@0 -S -o - | filecheck %s

;; CHECK:      (module
;; CHECK-NEXT:  (type $none_=>_none (func))
;; CHECK-NEXT:  (import "env" "bar" (func $bar))
;; CHECK-NEXT:  (export "foo" (func $foo))
;; CHECK-NEXT:  (func $foo
;; CHECK-NEXT:   (call $bar)
;; CHECK-NEXT:  )
;; CHECK-NEXT: )
(module
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

;; CHECK:      (module
;; CHECK-NEXT:  (type $none_=>_none (func))
;; CHECK-NEXT:  (import "env" "other" (func $other))
;; CHECK-NEXT:  (export "foo" (func $foo))
;; CHECK-NEXT:  (func $foo
;; CHECK-NEXT:   (nop)
;; CHECK-NEXT:  )
;; CHECK-NEXT: )
(module
  ;; Use another function in the table, but the table is not used in the
  ;; extracted function
  (table $t 10 funcref)
  (elem $0 (table $t) (i32.const 0) func $other)
  (func $foo
    (nop)
  )
  (func $other
    (drop (i32.const 1))
  )
)

;; CHECK:      (module
;; CHECK-NEXT:  (type $none (func))
;; CHECK-NEXT:  (import "env" "other" (func $other))
;; CHECK-NEXT:  (table $t 10 funcref)
;; CHECK-NEXT:  (elem $0 (i32.const 0) $other)
;; CHECK-NEXT:  (export "foo" (func $foo))
;; CHECK-NEXT:  (func $foo
;; CHECK-NEXT:   (call_indirect (type $none)
;; CHECK-NEXT:    (i32.const 10)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT: )
(module
  ;; Use another function in the table, and the table *is* used. As a result,
  ;; the table and its elements will remain. The called function, $other, will
  ;; remain as an import that is placed in the table.
  (type $none (func))
  (table $t 10 funcref)
  (elem $0 (table $t) (i32.const 0) func $other)
  (func $foo
   (call_indirect (type $none) (i32.const 10))
  )
  (func $other
    (drop (i32.const 1))
  )
)
