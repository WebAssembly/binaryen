(module
  (memory 0)
  (export "memory_size" $memory_size)
  (export "grow_memory" $grow_memory)
  (func $memory_size (result i64)
    (return
      (memory_size)
    )
  )
  (func $grow_memory (param $$0 i64)
    (memory_size)
    (return)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 4 }
