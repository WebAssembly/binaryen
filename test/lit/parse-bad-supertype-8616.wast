;; RUN: not wasm-opt %s 2>&1 | filecheck %s

;; CHECK: Fatal: {{.*}}:9:2: error: invalid type: Heap type has an undeclared supertype

;; Regression test for a parser bug that caused an assertion failure in this case.
(module
 (rec
  (type $A (sub (struct (field i32))))
  (type $B (sub $B (struct (field i32) (field i32))))
 )
)