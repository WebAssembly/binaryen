;; RUN: wasm-opt %s --enable-multi-memories --multi-memory-lowering --enable-bulk-memory --enable-extended-const --enable-simd --enable-threads -S -o - | filecheck %s

(module
  (import "env" "mem" (memory $memory1 1 1))
  (memory $memory2 1 1)
)

;; CHECK: (import "env" "mem" (memory $combined_memory 2 2))
