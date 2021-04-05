(module
  (import "env" "imported" (func $imported (result i64)))
  (import "env" "other" (func $other (param i32) (param i64) (param i64)))
  (import "env" "ref-func-arg" (func $ref-func-arg (result i64)))
  (export "func" (func $func))
  (export "ref-func-test" (func $ref-func-test))
  (export "imported" (func $imported))
  (export "imported_again" (func $imported))
  (export "other" (func $other))
  (func $func (result i64)
    (drop (call $imported))
    (call $other
      (i32.const 0)
      (i64.const 0)
      (i64.const 0)
    )
    (unreachable)
  )

  ;; ref.func must also be updated.
  (func $ref-func-test
    (drop
      (call $ref-func-arg)
    )
    (drop
      (ref.func $ref-func-arg)
    )
  )
)
(module)
