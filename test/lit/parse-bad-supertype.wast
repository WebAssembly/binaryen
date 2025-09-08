;; Test that an invalid supertype results in a useful error message

;; RUN: not wasm-opt %s -all 2>&1 | filecheck %s

;; CHECK: Fatal: {{.*}}:8:2: error: invalid type: Heap type has an invalid supertype
(module
  (type $super (sub (struct i32)))
  (type $sub (sub $super (struct i64)))
)