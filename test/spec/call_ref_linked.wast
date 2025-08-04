;; Test that we can create a function in one module and call it using call_ref
;; from another.

(module
  (type $func-i32 (func (result i32)))

  (func $inner (result i32)
    (i32.const 42)
  )
  (func $func-i32 (result i32)
    (call $inner)
  )
  (func (export "get-func-i32") (result (ref $func-i32))
    (return (ref.func $func-i32))
  )
)

(register "first")

(module
  (type $func-i32 (func (result i32)))

  (import "first" "get-func-i32" (func $imported (result (ref $func-i32))))

  (func (export "run") (result i32)
    (call_ref $func-i32
      (call $imported)
    )
  )
)

(assert_return (invoke "run" (i64.const 42)))

