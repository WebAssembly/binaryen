;; Test that appending more build and run operations, as the ClusterFuzz run.py
;; does, works properly.

(module
  (import "fuzzing-support" "log-i32" (func $log (param i32)))
  (import "fuzzing-support" "call-export-catch" (func $call.export.catch (param i32) (result i32)))

  (global $errors (mut i32)
    (i32.const 0)
  )

  (func $errors (export "errors")
    ;; Log the number of errors we've seen.
    (call $log
      (global.get $errors)
    )
  )

  (func $do-call (param $x i32)
    ;; Given an index $x, call the export of that index, and note an error if
    ;; we see one.
    (if
      (call $call.export.catch
        (local.get $x)
      )
      (then
        ;; Log that we errored right now, and then increment the total.
        (call $log
          (i32.const -1)
        )
        (global.set $errors
          (i32.add
            (global.get $errors)
            (i32.const 1)
          )
        )
      )
    )
    ;; Log the total number of errors so far.
    (call $log
      (global.get $errors)
    )
  )

  (func $call-0 (export "call0")
    ;; This calls "errors".
    (call $do-call
      (i32.const 0)
    )
  )

  (func $call-3 (export "call3")
    ;; The first time we try this, there is no export at index 3, since we just
    ;; have ["errors", "call0", "call3"]. After we build the module a second
    ;; time, we will have "errors" from the second module there.
    (call $do-call
      (i32.const 3)
    )
  )
)

;; Run normally.
;;
;; RUN: wasm-opt %s -o %t.wasm -q
;; RUN: node %S/../../../scripts/fuzz_shell.js %t.wasm | filecheck %s
;;
;; "errors" reports we've seen no errors.
;; CHECK: [fuzz-exec] calling errors
;; CHECK: [LoggingExternalInterface logging 0]

;; "call0" calls "errors", which logs 0 twice.
;; CHECK: [fuzz-exec] calling call0
;; CHECK: [LoggingExternalInterface logging 0]
;; CHECK: [LoggingExternalInterface logging 0]

;; "call3" calls an invalid index, and logs -1 as an error, and 1 as the total
;; errors so far.
;; CHECK: [fuzz-exec] calling call3
;; CHECK: [LoggingExternalInterface logging -1]
;; CHECK: [LoggingExternalInterface logging 1]

;; Append another build + run.
;;
;; RUN: cp %S/../../../scripts/fuzz_shell.js %t.js
;; RUN: echo "build(binary);" >> %t.js
;; RUN: echo "callExports();" >> %t.js
;; RUN: node %t.js %t.wasm | filecheck %s --check-prefix=APPENDED
;;
;; The first part is unchanged from before.
;; APPENDED: [fuzz-exec] calling errors
;; APPENDED: [LoggingExternalInterface logging 0]
;; APPENDED: [fuzz-exec] calling call0
;; APPENDED: [LoggingExternalInterface logging 0]
;; APPENDED: [LoggingExternalInterface logging 0]
;; APPENDED: [fuzz-exec] calling call3
;; APPENDED: [LoggingExternalInterface logging -1]
;; APPENDED: [LoggingExternalInterface logging 1]

;; Next, we build the module again, append its exports, and call them all.

;; "errors" from the first module recalls that we errored before.
;; APPENDED: [fuzz-exec] calling errors
;; APPENDED: [LoggingExternalInterface logging 1]

;; "call0" calls "errors", and they both log 1.
;; APPENDED: [fuzz-exec] calling call0
;; APPENDED: [LoggingExternalInterface logging 1]
;; APPENDED: [LoggingExternalInterface logging 1]

;; "call3" does *not* error like before, as the later exports provide something
;; at index 3: the second module's "errors". That reports that the second module
;; has seen no errors, and then call3 from the first module reports that that
;; module has seen 1 error.
;; APPENDED: [fuzz-exec] calling call3
;; APPENDED: [LoggingExternalInterface logging 0]
;; APPENDED: [LoggingExternalInterface logging 1]

;; "errors" from the second module reports no errors.
;; APPENDED: [fuzz-exec] calling errors
;; APPENDED: [LoggingExternalInterface logging 0]

;; "call0" from the second module to the first makes the first module's "errors"
;; report 1, and then we report 0 from the second module.
;; APPENDED: [fuzz-exec] calling call0
;; APPENDED: [LoggingExternalInterface logging 1]
;; APPENDED: [LoggingExternalInterface logging 0]

;; "call3" from the second module calls "errors" in the second module, and they
;; both report 0 errors.
;; APPENDED: [fuzz-exec] calling call3
;; APPENDED: [LoggingExternalInterface logging 0]
;; APPENDED: [LoggingExternalInterface logging 0]

;; Overall, we have seen each module call the other, showing calls work both
;; ways.
