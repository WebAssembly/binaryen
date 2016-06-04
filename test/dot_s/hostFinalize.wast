(module
  (memory 1)
  (export "memory" memory)
  (func $_main
    (grow_memory
      (i32.add
        (current_memory)
        (i32.const 1)
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [] }
