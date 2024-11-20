;; Test that appending more build and run operations, as the ClusterFuzz run.py
;; does, works properly. g a wasm file in fuzz_shell.js.

(module
  (import "fuzzing-support" "log-i32" (func $log (param i32)))
  (import "fuzzing-support" "call-export-catch" (func $call.export.catch (param i32) (result i32)))

  (func $number (export "number")
    (call $log
      (i32.const 42)
    )
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
    (call $call.export.catch
      (i32.const 2)
    )
  )
)

;; Running normally executes the first export ok, and the second traps (so it
;; returns 1).
;;
;; RUN: wasm-opt %s -o %t.wasm -q
;; RUN: node %S/../../../scripts/fuzz_shell.js %t.wasm | filecheck %s
;;
;; CHECK: [fuzz-exec] calling number
;; CHECK: [LoggingExternalInterface logging 42]
;; CHECK: [fuzz-exec] calling call
;; CHECK: [fuzz-exec] note result: call => 1

;; Append another build + run. We repeat the exact output from before, and then
;; call the final 4 exports, and the second and fourth of them do not trap (so
;; they return 0, and they log out 42).
;;
;; RUN: cp %S/../../../scripts/fuzz_shell.js %t.js
;; RUN: echo "build(binary);" >> %t.js
;; RUN: echo "callExports();" >> %t.js
;; RUN: node %t.js %t.wasm | filecheck %s --check-prefix=CHECK-APPENDED
;;
;; CHECK-APPENDED: [fuzz-exec] calling number
;; CHECK-APPENDED: [LoggingExternalInterface logging 42]
;; CHECK-APPENDED: [fuzz-exec] calling call
;; CHECK-APPENDED: [fuzz-exec] note result: call => 1
;; CHECK-APPENDED: [fuzz-exec] calling number
;; CHECK-APPENDED: [LoggingExternalInterface logging 42]
;; CHECK-APPENDED: [fuzz-exec] calling call
;; CHECK-APPENDED: [LoggingExternalInterface logging 42]
;; CHECK-APPENDED: [fuzz-exec] note result: call => 0
;; CHECK-APPENDED: [fuzz-exec] calling number
;; CHECK-APPENDED: [LoggingExternalInterface logging 42]
;; CHECK-APPENDED: [fuzz-exec] calling call
;; CHECK-APPENDED: [LoggingExternalInterface logging 42]
;; CHECK-APPENDED: [fuzz-exec] note result: call => 0

