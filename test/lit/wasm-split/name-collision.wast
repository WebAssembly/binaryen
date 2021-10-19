;; Regression test for a bug in which colliding internal names between
;; non-function exports would result in the wrong import names being used in the
;; secondary module.

;; RUN: wasm-split %s -o1 %t.1.wasm -o2 %t.2.wasm
;; RUN: wasm-dis %t.2.wasm | filecheck %s

;; CHECK-NOT: (import "primary" "memory" (table
;; CHECK: (import "primary" "table" (table

(module
 (table $collide 1 funcref)
 (memory $collide 1 1)
 (export "table" (table $collide))
 (export "memory" (memory $collide))
)
