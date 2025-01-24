(module
  (import "fuzzing-support" "sleep" (func $log (param i32 i32) (result i32)))

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
;; The output here looks a little out of order, in particular because we do not
;; |await| the toplevel callExports() calls. That |await| is only valid if we
;; pass --module, which we do not fuzz with. As a result, the first await
;; operation in the first callExports() leaves that function and continues to
;; the next, but we do get around to executing all the things we need. In
;; particular, the output here should contain two "node result" lines for each
;; of the 5 functions (one from each callExports()). The important thing is that
;; we get a random-like ordering, which includes some defers (each of which has
;; a later finish), showing that we interleave stacks.
;;
;; waka

