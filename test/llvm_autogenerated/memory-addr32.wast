(module
  (memory 0)
  (export "memory" memory)
  (export "memory_size" $memory_size)
  (export "grow_memory" $grow_memory)
  (func $memory_size (result i32)
    (return
      (memory_size)
    )
  )
  (func $grow_memory (param $$0 i32)
    (grow_memory
      (get_local $$0)
    )
    (return)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 4, "initializers": [] }
