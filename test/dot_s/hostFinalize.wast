(module
  (memory $0 1)
  (export "memory" (memory $0))
  (func $_main
    (drop
      (grow_memory
        (i32.add
          (current_memory)
          (i32.const 1)
        )
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [] }
