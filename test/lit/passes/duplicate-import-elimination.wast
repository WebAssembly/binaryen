;; RUN: foreach %s %t wasm-opt --duplicate-import-elimination -S -o - | filecheck %s

;; Merge imports with matching signatures and update calls, elements, and start.
;; The import with a different signature must remain distinct.

(module
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (type $1 (func (param i32)))
  ;; CHECK-NOT:  (import "env" "waka" (func $bar

  ;; CHECK:      (import "env" "waka" (func $foo))
  ;; CHECK-NOT:  (import "env" "waka" (func $bar
  (import "env" "waka" (func $foo))
  (import "env" "waka" (func $bar))
  ;; CHECK:      (import "env" "waka" (func $wrong (param i32)))
  ;; CHECK-NOT:  (import "env" "waka" (func $bar
  (import "env" "waka" (func $wrong (param i32)))
  (table 2 2 funcref)
  (elem (i32.const 0) $foo $bar)
  (start $bar)
  ;; CHECK:      (table $0 2 2 funcref)

  ;; CHECK:      (elem $0 (i32.const 0) $foo $foo)

  ;; CHECK:      (export "baz" (func $baz))

  ;; CHECK:      (start $foo)

  ;; CHECK:      (func $baz
  ;; CHECK-NEXT:  (call $foo)
  ;; CHECK-NEXT:  (call $foo)
  ;; CHECK-NEXT:  (call $wrong
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $baz (export "baz")
    (call $foo)
    (call $bar)
    (call $wrong (i32.const 1))
  )
)
