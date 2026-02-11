;; The llvm-memory-copy-fill-lowering pass should Fatal() when a module
;; contains table.copy, since it does not support bulk table operations.

;; RUN: not wasm-opt --enable-bulk-memory %s --llvm-memory-copy-fill-lowering 2>&1 | filecheck %s
;; CHECK: table.copy instruction found

(module
 (memory 0)
 (table $t 1 funcref)
 (func $test
  (memory.copy (i32.const 0) (i32.const 0) (i32.const 0))
  (table.copy $t $t (i32.const 0) (i32.const 0) (i32.const 0))
 )
)
