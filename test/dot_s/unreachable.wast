(module
  (memory 0 4294967295)
  (func $f1 (result i32)
    (block
      (call $abort)
      (unreachable)
    )
  )
  (func $f2
    (block $fake_return_waka123
      (block
        (unreachable)
        (br $fake_return_waka123)
      )
    )
  )
  (func $f3
    (block $fake_return_waka123
      (block
        (unreachable)
        (br $fake_return_waka123)
      )
    )
  )
)
