
;; RUN: wasm-opt %s -all --fuzz-exec-before --fuzz-exec-second=%s.second.wast -q -o /dev/null 2>&1 | filecheck %s

(module
  (func $first (export "first") (result i32)
    (i32.const 42)
  )
)

;; Test that the fuzz_shell.js file will run a second wasm file that is
;; provided, and call its exports as well as the first module's.

;; CHECK:      [fuzz-exec] calling first
;; CHECK-NEXT: [fuzz-exec] note result: first => 42
;; CHECK:      [fuzz-exec] calling second
;; CHECK-NEXT: [fuzz-exec] note result: second => 1337

