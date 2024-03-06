;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: wasm-opt %s --memory-packing -all --zero-filled-memory -S -o - | filecheck %s

(module
 ;; we can optimize on an imported memory with zeroFilledMemory being set.
 ;; CHECK:      (import "env" "memory" (memory $0 1 1))
 (import "env" "memory" (memory $0 1 1))

 (data (i32.const 1024) "x")
 (data (i32.const 1023) "\00")
)
;; CHECK:      (data $0 (offset (i32.const 1024)) "x")
