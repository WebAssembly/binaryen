;; RUN: not wasm-opt %s --enable-multi-memories --multi-memory-lowering --enable-bulk-memory --enable-extended-const --enable-simd --enable-threads 2>&1 | filecheck %s

(module
  (memory $memory1 1)
  (memory $memory2 1 1)
  (export "mem" (memory $memory2))
)

;; CHECK: MultiMemoryLowering: only the first memory can be exported
