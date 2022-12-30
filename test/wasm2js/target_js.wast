(module
  (func $func (export "func") (param $x i32) (result i32)
    ;; Do not turn xor into something that does not express well in JS
    ;; when optimizing.
    (i32.xor
      (i32.shl
        (i32.const 1)
        (local.get $x)
      )
      (i32.const -1)
    )
  )
)
