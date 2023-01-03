;; RUN: not wasm-opt %s --multi-memory-lowering -all 2>&1 | filecheck %s

(module
  (memory $memory1 1)
  (memory $memory2 1 1)
  (export "mem" (memory $memory2))
)

;; CHECK: MultiMemoryLowering: only the first memory can be exported
