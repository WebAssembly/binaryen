;; --dupliate-function-elimination should not remove functions used in ref.func.
(module
  (func $0 (result i32)
    (i32.const 0)
  )
  (func $1 (result i32)
    (i32.const 0)
  )
  (func $test (result funcref)
    (ref.func $1)
  )
)
