;; Test that appending more build and run operations, as the ClusterFuzz run.py
;; does, works properly. g a wasm file in fuzz_shell.js.

(module
  (import "fuzzing-support" "call-export" (func $call.export (param i32)))

  (func $number (export "number") (result i32)
    (i32.const 42)
  )

  (func $call (export "call") (result i32)
    ;; Call export #2. There is no such export initially, just
    ;;
    ;;  0: $number
    ;;  1: $call
    ;;
    ;; but after we append commands to build the wasm again, its exports
    ;; accumulate, so we have
    ;;
    ;;  0: $number
    ;;  1: $call
    ;;  2: $number
    ;;  3: $call
    ;;
    ;; and then the call will succeed (by calling $number and returning 42).
    (call $call.export
      (i32.const 2)
    )
  )
)

;; Running normally executes the first export ok, and the second traps.
;;
;; RUN: wasm-opt %s -o %t.wasm
;; RUN: node %S/../../../scripts/fuzz_shell.js %t.wasm | filecheck %s
;;
;; CHECK: [fuzz-exec] calling number
;; CHECK: [fuzz-exec] note result: number => 42
;; CHECK: [fuzz-exec] calling call
;; CHECK: [fuzz-exec] TRAP

;; Append another build + run. We now have 4 exports, and the second and fourth
;; do not trap.
;;
;; RUN: cp %S/../../../scripts/fuzz_shell.js %t.js
;; RUN: echo "build(binary);" >> %t.js
;; RUN: echo "callExports();" >> %t.js
;; RUN: node %t.js %t.wasm | filecheck %s
;;
;; CHECK: [fuzz-exec] calling number
;; CHECK: [fuzz-exec] note result: number => 42
;; CHECK: [fuzz-exec] calling call
;; CHECK: [fuzz-exec] note result: number => 42
;; CHECK: [fuzz-exec] calling number
;; CHECK: [fuzz-exec] note result: number => 42
;; CHECK: [fuzz-exec] calling call
;; CHECK: [fuzz-exec] note result: number => 42

