;; RUN: not wasm-opt %s -all --nominal -S -o - 2>&1 | filecheck %s

;; CHECK: [wasm-validator error in function make-super-struct] function body type must match
;; CHECK: [wasm-validator error in function make-super-array] function body type must match

(module

  (type $sub-struct (struct i32 i64))
  (type $super-struct (struct i32))

  (type $sub-array (array (ref $sub-struct)))
  (type $super-array (array (ref $super-struct)))

  (func $make-sub-struct (result (ref $sub-struct))
    (unreachable)
  )

  (func $make-super-struct (result (ref $super-struct))
    (call $make-sub-struct)
  )

  (func $make-sub-array (result (ref $sub-array))
    (unreachable)
  )

  (func $make-super-array (result (ref $super-array))
    (call $make-sub-array)
  )
)
