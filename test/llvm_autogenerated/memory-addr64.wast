(module
  (memory 1
    (segment 0 "\10\04\00\00")
  )
  (export "memory" memory)
  (export "memory_size" $memory_size)
  (export "grow_memory" $grow_memory)
  (func $memory_size (result i64)
    (return
      (memory_size)
    )
  )
  (func $grow_memory (param $$0 i64)
    (grow_memory
      (get_local $$0)
    )
    (return)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
