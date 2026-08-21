;; RUN: wasm-as %s -all --no-validation -o /dev/null
;; RUN: wasm-opt %s -all --no-validation -o /dev/null

;; Void unreachable try with return_call is valid Binaryen IR for inlining
;; tests but not valid Wasm at function end; parse with --no-validation.

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
