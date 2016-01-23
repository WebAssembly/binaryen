(module
  (memory 0 4294967295)
  (export "memory_size" $memory_size)
  (export "grow_memory" $grow_memory)
  (func $memory_size (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (memory_size)
        )
      )
    )
  )
  (func $grow_memory (param $$0 i64)
    (block $fake_return_waka123
      (block
        (memory_size)
        (br $fake_return_waka123)
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 4 }
