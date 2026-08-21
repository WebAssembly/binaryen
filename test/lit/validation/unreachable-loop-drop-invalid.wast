;; RUN: not wasm-opt %s -all -o /dev/null 2>&1 | filecheck %s
;; RUN: not wasm-as %s -all -o /dev/null 2>&1 | filecheck %s
;; RUN: wasm-opt %s -all --no-validation -o /dev/null
;; RUN: wasm-as %s -all --no-validation -o /dev/null

;; CHECK: popping from empty stack

(module (func (loop (unreachable)) (drop)))
