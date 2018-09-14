(module
  (import "env" "imported" (func $imported (result i64)))
  (export "func" (func $func))
  (export "imported" (func $imported))
  (export "imported_again" (func $imported))
  (func $func (result i64)
    (drop (call $imported))
    (unreachable)
  )
)
(module)

