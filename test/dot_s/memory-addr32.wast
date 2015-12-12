(module
  (memory 0 4294967295)
  (func $memory_size (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (memory_size)
        )
      )
    )
  )
  (func $grow_memory (param $$0 i32)
    (block $fake_return_waka123
      (block
        (memory_size)
        (br $fake_return_waka123)
      )
    )
  )
)
