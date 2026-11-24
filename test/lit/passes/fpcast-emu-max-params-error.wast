;; RUN: foreach %s %t not wasm-opt --fpcast-emu --pass-arg=fpcast-emu-export-thunks --pass-arg=max-func-params@1 2>&1 | filecheck %s

;; Exported function with more parameters than max-func-params.
(module
  ;; CHECK: Fatal: max-func-params needs to be at least 2
  (export "too_many_params" (func $f))
  (func $f (param i32 i32))
)

;; Function in element segment with more parameters than max-func-params.
(module
  ;; CHECK: Fatal: max-func-params needs to be at least 2
  (table 1 funcref)
  (elem (i32.const 0) $f)
  (func $f (param i32 i32))
)
