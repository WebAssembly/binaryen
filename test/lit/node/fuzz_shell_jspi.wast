(module
  (import "fuzzing-support" "log-i32" (func $log (param i32)))

  (func $a (export "a") (result i32)
    (i32.const 10)
  )

  (func $b (export "b") (result i32)
    (i32.const 20)
  )

  (func $c (export "c") (result i32)
    (i32.const 30)
  )

  (func $d (export "d") (result i32)
    (i32.const 40)
  )

  (func $e (export "e") (result i32)
    (i32.const 50)
  )
)

;; Apply JSPI: prepend JSPI = 1 and remove comments around async and await.
;; RUN: echo "JSPI = 1;" > %t.js
;; RUN: node -e "process.stdout.write(require('fs').readFileSync(process.stdin.fd, 'utf-8').replaceAll('/* async */', 'async').replaceAll('/* await */', 'await'))"

;; Append another run with a random seed, so we reorder and delay execution.
;; RUN: echo "callExports(42);" >> %t.js
;; RUN: node %t.js %t.wasm | filecheck %s
;;
;; The first part is unchanged from before.
;; CHECK: [fuzz-exec] calling errors
;; CHECK: [LoggingExternalInterface logging 0]
;; CHECK: [fuzz-exec] calling call0
;; CHECK: [LoggingExternalInterface logging 0]
;; CHECK: [LoggingExternalInterface logging 0]
;; CHECK: [fuzz-exec] calling call3
;; CHECK: [LoggingExternalInterface logging -1]
;; CHECK: [LoggingExternalInterface logging 1]

