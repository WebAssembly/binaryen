(module
  (memory 0 4294967295)
  (export "main" $main)
  (func $main (result i32)
    (local $$0 i32)
    (block
      (call_import $exit
        (i32.const 0)
      )
    )
  )
)
