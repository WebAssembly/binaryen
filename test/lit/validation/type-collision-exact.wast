;; RUN: not wasm-opt %s -all --disable-custom-descriptors 2>&1 | filecheck %s

;; CHECK: error: invalid type: distinct rec groups would be identical after binary writing

(module
  (type $foo (struct))
  (type $A (struct (field (ref $foo))))
  (type $B (struct (field (ref (exact $foo)))))
)
