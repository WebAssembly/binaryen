;; Test that the --initial-table flag works as expected when the secondary
;; module uses the table.

;; RUN: wasm-split %s --instrument --initial-table=1234 -S | filecheck %s

;; RUN: wasm-split %s -g -o1 %t.1.wasm -o2 %t.2.wasm --split-funcs=use-table --initial-table=1234
;; RUN: wasm-dis %t.1.wasm | filecheck %s
;; RUN: wasm-dis %t.2.wasm | filecheck %s

;; CHECK: (table $table 1234 funcref)

(module
 (table $table 3 funcref)
 (func $use-table
  (call_indirect
   (i32.const 0)
  )
 )
 (func $use-use-table
  (call $use-table)
 )
)
