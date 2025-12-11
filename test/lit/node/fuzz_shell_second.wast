;; Test that the fuzz_shell.js file will run a second wasm file that is
;; provided, and call its exports as well as the first module's.

(module
  (func $first (export "first") (result i32)
    (i32.const 42)
  )

  (func $split (export "__fuzz_split_func") (result i32)
    (i32.const 999)
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
;; CHECK: [fuzz-exec] calling __fuzz_split_func
;; CHECK: [fuzz-exec] note result: __fuzz_split_func => 999
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
;; REVERSE: [fuzz-exec] calling __fuzz_split_func
;; REVERSE: [fuzz-exec] note result: __fuzz_split_func => 999

;; Run with --fuzz-split, which does not run exports from the second one,
;; and also ignores exports starting with "__fuzz_split_"
;;
;; RUN: node %S/../../../scripts/fuzz_shell.js %t.wasm %t.second.wasm --fuzz-split | filecheck %s --check-prefix=WASM_SPLIT
;;
;; WASM_SPLIT: [fuzz-exec] calling first
;; WASM_SPLIT: [fuzz-exec] note result: first => 42
;; WASM_SPLIT-NOT: [fuzz-exec] calling second
;; WASM_SPLIT-NOT: [fuzz-exec] calling __fuzz_split_func

