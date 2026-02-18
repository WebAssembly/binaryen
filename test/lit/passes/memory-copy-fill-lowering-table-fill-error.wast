;; The llvm-memory-copy-fill-lowering pass should Fatal() when a module
;; contains table.fill, since it does not support bulk table operations.

;; RUN: not wasm-opt --enable-bulk-memory --enable-reference-types %s --llvm-memory-copy-fill-lowering 2>&1 | filecheck %s
;; CHECK: table.fill instruction found

(module
 (memory 0)
 (table $t 1 funcref)
 (func $test
  (memory.copy (i32.const 0) (i32.const 0) (i32.const 0))
  (table.fill $t (i32.const 0) (ref.null func) (i32.const 0))
 )
)
