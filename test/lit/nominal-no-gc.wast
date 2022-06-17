;; Write the module with --nominal but without GC
;; RUN: wasm-opt %s --nominal --disable-gc -g -o %t.wasm

;; We should not get any recursion groups even though we used --nominal
;; RUN: wasm-opt %t.wasm --hybrid -all -S -o - | filecheck %s

;; CHECK-NOT: rec

(module
  (type $foo (func))
  (type $bar (func))

  (func $f1 (type $foo))
  (func $f2 (type $bar))
)
