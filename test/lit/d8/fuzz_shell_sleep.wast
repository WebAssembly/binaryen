(module
  (import "fuzzing-support" "sleep" (func $sleep (param i32 i32) (result i32)))

  (func $func1 (export "func1") (result i32)
    (call $sleep
      (i32.const 0) ;; ms (d8 always sleeps 0 anyhow)
      (i32.const 1) ;; id
    )
  )

  (func $func2 (export "func2") (result i32)
    (call $sleep
      (i32.const 0)
      (i32.const 2)
    )
  )

  (func $func3 (export "func3") (result i32)
    (call $sleep
      (i32.const 0)
      (i32.const 3)
    )
  )

  (func $func4 (export "func4") (result i32)
    (call $sleep
      (i32.const 0)
      (i32.const 4)
    )
  )

  (func $func5 (export "func5") (result i32)
    (call $sleep
      (i32.const 0)
      (i32.const 5)
    )
  )
)

;; See fuzz_shell_jspi.wast for how the following works.
;; RUN: echo "JSPI = 1;" > %t.0.js
;; RUN: cat %S/../../../scripts/fuzz_shell.js | node -e "process.stdout.write(require('fs').readFileSync(0, 'utf-8').replace(/[/][*] async [*][/]/g, 'async').replace(/[/][*] await [*][/]/g, 'await'))" >> %t.0.js

;; Replace the callExports() at the end with a call that has a random seed.
;; RUN: cat %t.0.js | node -e "process.stdout.write(require('fs').readFileSync(0, 'utf-8').replace('callExports()', 'callExports(66)'))" > %t.js

;; Run that JS shell with our wasm.
;; RUN: wasm-opt %s -o %t.wasm -q
;; RUN: v8 --wasm-staging %t.js -- %t.wasm | filecheck %s
;;
;; We should see a few cases that avoid sleeping: func2, func3, and func4 all
;; return a result immediately, showing they do not sleep. (Note though that
;; func2 is more because we do not have a toplevel await, see comment in
;; fuzz_shell_jspi.wast.)
;;
;; CHECK: [fuzz-exec] calling func2
;; CHECK: [fuzz-exec] note result: func2 => 2
;; CHECK: [fuzz-exec] calling func1
;; CHECK: (jspi: defer func1)
;; CHECK: [fuzz-exec] calling func3
;; CHECK: [fuzz-exec] note result: func3 => 3
;; CHECK: [fuzz-exec] calling func1 (after defer)
;; CHECK: (jspi: finish func1)
;; CHECK: [fuzz-exec] note result: func1 => 1
;; CHECK: [fuzz-exec] calling func5
;; CHECK: (jspi: defer func5)
;; CHECK: [fuzz-exec] calling func4
;; CHECK: [fuzz-exec] note result: func4 => 4
;; CHECK: [fuzz-exec] calling func5 (after defer)
;; CHECK: (jspi: finish func5)
;; CHECK: [fuzz-exec] note result: func5 => 5

