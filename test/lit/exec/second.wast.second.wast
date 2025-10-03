(module
  (import "primary" "first" (func $first-func (result i32)))

  (func $second (export "second") (result i32)
    (i32.add
      (call $first-func)
      (i32.const 1295)
    )
  )
)

