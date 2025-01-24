(module
  (import "fuzzing-support" "sleep" (func $sleep (param i32 i32) (result i32)))

  (func $a (export "a") (result i32)
    (call $sleep
      (i32.const 0)  ;; ms (d8 always sleeps 0 anyhow)
      (i32.const 10) ;; id
    )
  )

  (func $b (export "b") (result i32)
    (call $sleep
      (i32.const 0)
      (i32.const 20)
    )
  )

  (func $c (export "c") (result i32)
    (call $sleep
      (i32.const 0)
      (i32.const 30)
    )
  )

  (func $d (export "d") (result i32)
    (call $sleep
      (i32.const 0)
      (i32.const 40)
    )
  )

  (func $e (export "e") (result i32)
    (call $sleep
      (i32.const 0)
      (i32.const 50)
    )
  )
)

;; See fuzz_shell_jspi.wast for how the following works.
;; RUN: echo "JSPI = 1;" > %t.js
;; RUN: cat %S/../../../scripts/fuzz_shell.js | node -e "process.stdout.write(require('fs').readFileSync(0, 'utf-8').replace(/[/][*] async [*][/]/g, 'async').replace(/[/][*] await [*][/]/g, 'await'))" >> %t.js
;; RUN: echo "callExports(42);" >> %t.js

;; Run that JS shell with our wasm.
;; RUN: wasm-opt %s -o %t.wasm -q
;; RUN: v8 --wasm-staging %t.js -- %t.wasm | filecheck %s
;;
;; We should see a few cases of "avoid sleeping", but otherwise the majority of
;; executions should sleep, and therefore have "sleep" and "resolve" messages.
;;
;; CHECK: [fuzz-exec] calling a
;; CHECK: (jspi: sleep #10)
;; CHECK: [fuzz-exec] calling b
;; CHECK: (jspi: sleep #20)
;; CHECK: (jspi: resolve #10)
;; CHECK: [fuzz-exec] note result: a => 10
;; CHECK: [fuzz-exec] calling b
;; CHECK: (jspi: sleep #20)
;; CHECK: (jspi: resolve #20)
;; CHECK: [fuzz-exec] note result: b => 20
;; CHECK: [fuzz-exec] calling c
;; CHECK: (jspi: sleep #30)
;; CHECK: (jspi: defer c)
;; CHECK: [fuzz-exec] calling c
;; CHECK: (jspi: finish c)
;; CHECK: (jspi: resolve #20)
;; CHECK: [fuzz-exec] note result: b => 20
;; CHECK: [fuzz-exec] calling c
;; CHECK: (jspi: sleep #30)
;; CHECK: (jspi: resolve #30)
;; CHECK: [fuzz-exec] note result: c => 30
;; CHECK: [fuzz-exec] calling e
;; CHECK: (jspi: avoid sleeping #50)
;; CHECK: [fuzz-exec] note result: e => 50
;; CHECK: [fuzz-exec] calling d
;; CHECK: (jspi: avoid sleeping #40)
;; CHECK: (jspi: defer d)
;; CHECK: [fuzz-exec] calling d
;; CHECK: (jspi: finish d)
;; CHECK: [fuzz-exec] note result: d => 40
;; CHECK: [fuzz-exec] calling a
;; CHECK: (jspi: avoid sleeping #10)
;; CHECK: [fuzz-exec] note result: a => 10
;; CHECK: (jspi: resolve #30)
;; CHECK: [fuzz-exec] note result: c => 30
;; CHECK: [fuzz-exec] calling d
;; CHECK: (jspi: sleep #40)
;; CHECK: (jspi: resolve #40)
;; CHECK: [fuzz-exec] note result: d => 40
;; CHECK: [fuzz-exec] calling e
;; CHECK: (jspi: sleep #50)
;; CHECK: (jspi: resolve #50)
;; CHECK: [fuzz-exec] note result: e => 50

