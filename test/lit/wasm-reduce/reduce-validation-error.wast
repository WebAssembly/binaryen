;; This is a regression test for a crash in wasm-reduce where in-place mutation
;; of a Call node during replaceWithIdenticalType caused the replacement block
;; type to be set incorrectly to nullref instead of the original type, leading
;; to a validation error.

;; RUN: wasm-reduce %s -t %t.t.wast -w %t.w.wast \
;; RUN:   --command='wasm-opt %t.t.wast -all --fuzz-exec'

(module
  (func $to_remove (result anyref)
    (ref.null none)
  )

  (func $main (export "main") (result anyref)
    ;; This will be replaced with a nullref. This should not cause validation
    ;; failures and cause wasm-reduce to crash.
    (call $to_remove)
  )
)
