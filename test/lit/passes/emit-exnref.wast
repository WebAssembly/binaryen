;; When given alone, --emit-exnref just runs --translate-to-exnref
;; RUN: wasm-opt %s -all --translate-to-exnref -S -o %t1.wasm
;; RUN: wasm-opt %s -all --emit-exnref -S -o %t2.wasm
;; RUN: diff %t1.wasm %t2.wasm

;; When given with other flags, --emit-exnref runs the translator after running
;; other passes. If --optimize-level >=3, --experimenal-new-eh also runs StackIR
;; (+ local2stack) optimization. So running '-O --emit-exnref' should be the
;; same as running all these passes separately.
;; RUN: wasm-opt %s -all -O --translate-to-exnref --optimize-level=3 --generate-stack-ir --optimize-stack-ir -o %t1.wasm
;; RUN: wasm-opt %s -all -O --emit-exnref -o %t2.wasm
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
