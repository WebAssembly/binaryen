;; RUN: not wasm-as %s -o /dev/null 2>&1 | filecheck %s
;; RUN: not wasm-opt %s -o /dev/null 2>&1 | filecheck %s

;; CHECK: popping from empty stack

(module (func (block (unreachable)) (drop)))
