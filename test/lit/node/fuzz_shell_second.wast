;; Test that the fuzz_shell.js file will run a second wasm file that is
;; provided, and call its exports as well as the first module's.

(module
  (func $first (export "first") (result i32)
    (i32.const 42)
  )
)

;; Build both files to binary.
;;
;; RUN: wasm-opt %s -o %t.wasm -q
;; RUN: wasm-opt %s.second -o %t.second.wasm -q

;; Run in node.
;;
;; RUN: node %S/../../../scripts/fuzz_shell.js %t.wasm %t.second.wasm | filecheck %s
;;
;; CHECK: [fuzz-exec] calling first
;; CHECK: [fuzz-exec] note result: first => 42
;; CHECK: [fuzz-exec] calling second
;; CHECK: [fuzz-exec] note result: second => 1337

;; Run in reverse order, flipping the order in the output.
;;
;; RUN: node %S/../../../scripts/fuzz_shell.js %t.second.wasm %t.wasm | filecheck %s --check-prefix=REVERSE
;;
;; REVERSE: [fuzz-exec] calling second
;; REVERSE: [fuzz-exec] note result: second => 1337
;; REVERSE: [fuzz-exec] calling first
;; REVERSE: [fuzz-exec] note result: first => 42

