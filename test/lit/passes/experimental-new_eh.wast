;; When given alone, --experimental-new-eh just runs --translate-to-new-eh
;; RUN: wasm-opt %s -all --translate-to-new-eh -S -o %t1.wasm
;; RUN: wasm-opt %s -all --experimental-new-eh -S -o %t2.wasm
;; RUN: diff %t1.wasm %t2.wasm

;; When given with other flags, --experimental-new-eh runs the translator after
;; running other passes. If --optimize-level >=3, --experimenal-new-eh also runs
;; StackIR (+ local2stack) optimization. So running '-O --experimental-new-eh'
;; should be the same as running all these passes separately.
;; RUN: wasm-opt %s -all -O --translate-to-new-eh --optimize-level=3 --generate-stack-ir --optimize-stack-ir -o %t1.wasm
;; RUN: wasm-opt %s -all -O --experimental-new-eh -o %t2.wasm
;; RUN: diff %t1.wasm %t2.wasm

(module
  (import "env" "foo" (func $foo))
  (start $test)
  (func $test
    (try $l
      (do
        (call $foo)
      )
      (catch_all
        (call $foo)
        (rethrow $l)
      )
    )
  )
)
