;; Test that shared memory requires atomics

;; RUN: not wasm-opt -all --disable-extended-const %s 2>&1 | filecheck %s --check-prefix NO-EXTENDED
;; RUN: wasm-opt %s -all -o - -S | filecheck %s --check-prefix EXTENDED

;; NO-EXTENDED: unexpected false: global init must be constant
;; NO-EXTENDED: unexpected false: memory segment offset should be constant

;; EXTENDED: (import "env" "global" (global $gimport$0 i32))
;; EXTENDED: (global $1 i32 (i32.add
;; EXTENDED:  (global.get $gimport$0)
;; EXTENDED:  (i32.const 42)
;; EXTENDED: ))
;; EXTENDED: (data $0 (i32.sub
;; EXTENDED:  (global.get $gimport$0)
;; EXTENDED:  (i32.const 10)
;; EXTENDED: ) "hello world")

(module
  (import "env" "global" (global i32))
  (memory 1 1)
  (global i32 (i32.add (global.get 0) (i32.const 42)))
  (data (offset (i32.sub (global.get 0) (i32.const 10))) "hello world")
)
