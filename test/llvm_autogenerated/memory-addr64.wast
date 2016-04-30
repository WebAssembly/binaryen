(module
  (memory 1
    (segment 4 "\10\04\00\00")
  )
  (export "memory" memory)
  (export "current_memory" $current_memory)
  (export "grow_memory" $grow_memory)
  (func $current_memory (result i64)
    (return
      (current_memory)
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
