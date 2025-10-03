(module
  (import "primary" "first" (func $first-func (result i32)))

  (func $second (export "second") (result i32)
    ;; Test we can call the first module, linked as "primary."
    (i32.add
      (call $first-func)
      (i32.const 1295)
    )
  )
)

