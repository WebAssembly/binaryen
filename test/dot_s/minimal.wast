(module
  (memory 0 4294967295)
  (func $0 (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.const 5)
        )
      )
    )
  )
)
