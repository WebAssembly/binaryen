;; Test running a wasm file in fuzz_shell.js.

;; This fails on windows-ARM on CI for unclear reasons. v8 is somehow not
;; properly installed.
;; REQUIRES: linux

(module
  (func $test (export "test") (result i32)
    (i32.const 42)
  )
)

;; Build to a binary wasm.
;;
;; RUN: wasm-opt %s -o %t.wasm -q

;; Run in d8.
;;
;; RUN: v8 %S/../../../scripts/fuzz_shell.js -- %t.wasm | filecheck %s
;;
;; CHECK: [fuzz-exec] export test
;; CHECK: [fuzz-exec] note result: test => 42

