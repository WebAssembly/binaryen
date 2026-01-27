;; RUN: wasm-split %s -g -o1 %t.1.wasm -o2 %t.2.wasm --keep-funcs=foo -all
;; RUN: wasm-dis %t.1.wasm | filecheck %s

;; Check if only the module elements that are used in the secondary module are
;; exported from the primary module.

;; CHECK:      (export "memory" (memory $used-mem))
;; CHECK-NOT:  (export "{{.*}}" (memory $unused-mem))
;; CHECK:      (export "table" (table $used-table))
;; CHECK-NOT:  (export "{{.*}}" (table $unused-table))
;; CHECK:      (export "global" (global $used-global))
;; CHECK-NOT:  (export "{{.*}}" (global $unused-global))
;; CHECK:      (export "tag" (tag $used-tag))
;; CHECK-NOT:  (export "{{.*}}" (tag $unused-tag))

(module
 (memory $used-mem 1 1)
 (memory $unused-mem 1 1)
 (global $used-global i32 (i32.const 10))
 (global $unused-global i32 (i32.const 20))
 (table $used-table 1 1 funcref)
 (table $unused-table 1 1 funcref)
 (tag $used-tag (param i32))
 (tag $unused-tag (param i32))

 (elem (table $used-table) (i32.const 0) func $foo)

 (func $foo (param i32) (result i32)
  (call $bar (i32.const 0))
  ;; call_indirect requires a table, ensuring at least one table exists
 )

 (func $bar (param i32) (result i32)
  (call $foo (i32.const 1))
  ;; Uses $used-mem
  (drop
   (i32.load
    (i32.const 24)
   )
  )
  ;; Uses $used-table
  (drop
   (call_indirect (param i32) (result i32)
    (i32.const 0)
    (i32.const 0)
   )
  )
  ;; Uses $used-global
  (drop
   (global.get $used-global)
  )
  ;; Uses $used-tag
  (throw $used-tag
   (i32.const 0)
  )
 )
)
