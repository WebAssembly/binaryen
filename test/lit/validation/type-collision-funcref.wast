;; RUN: not wasm-opt %s -all --disable-gc 2>&1 | filecheck %s

;; CHECK: error: invalid type: distinct rec groups would be identical after binary writing

(module
  (type $foo (func))
  (type $A (func (param (ref null $foo))))
  (type $B (func (param funcref)))
)