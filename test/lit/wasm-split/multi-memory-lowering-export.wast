;; RUN: wasm-opt %s --enable-multi-memories --multi-memory-lowering --enable-bulk-memory --enable-extended-const --enable-simd --enable-threads -S -o - | filecheck %s

(module
  (memory $memory1 1)
  (memory $memory2 1 1)
  (export "mem" (memory $memory1))
)

;; CHECK: (export "mem" (memory $combined_memory))
