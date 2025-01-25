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
;; RUN: cat %t.0.js | node -e "process.stdout.write(require('fs').readFileSync(0, 'utf-8').replace('callExports()', 'callExports(42)'))" > %t.js

;; Run that JS shell with our wasm.
;; RUN: wasm-opt %s -o %t.wasm -q
;; RUN: v8 --wasm-staging %t.js -- %t.wasm | filecheck %s
;;
;; We should see a few cases of "avoid sleeping", but otherwise the majority of
;; executions should sleep, and therefore have "sleep" and "wake" messages.
;;

