;; RUN: not wasm-opt %s --enable-multi-memories --multi-memory-lowering --enable-bulk-memory --enable-extended-const --enable-simd --enable-threads 2>&1 | filecheck %s

(module
  (memory $memory1 1)
  (import "env" "mem" (memory $memory2 1 1))
)

;; CHECK: MultiMemoryLowering: only the first memory can be imported
