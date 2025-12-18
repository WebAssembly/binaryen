;; RUN: not wasm-opt %s -all --disable-gc 2>&1 | filecheck %s

;; CHECK: error: invalid type: distinct rec groups would be identical after binary writing

(module
  (type $A (func (param externref)))
  (type $B (func (param (ref noextern))))
)