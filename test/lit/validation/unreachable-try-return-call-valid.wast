;; RUN: wasm-as %s -all -o /dev/null
;; RUN: wasm-opt %s -all -o /dev/null

;; Void unreachable try with return_call must remain parseable in functions
;; with concrete result types (see inlining-unreachable.wast module 2).

(module
  (import "env" "imported" (func $imported (param i32) (result i32)))
  (func $callee-2 (result i32)
    (try
      (do
        (return_call $imported
          (unreachable)
        )
      )
    )
  )
)
