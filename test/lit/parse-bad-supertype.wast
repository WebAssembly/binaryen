;; Test that an invalid supertype results in a useful error message

;; RUN: not wasm-opt %s -all --nominal 2>&1 | filecheck %s

;; CHECK: Fatal: Invalid type: Heap type has an invalid supertype at type $sub
(module
  (type $super (struct_subtype i32 data))
  (type $sub (struct_subtype i64 $super))
)