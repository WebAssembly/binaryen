(module
  (import "env" "memory" (memory $0 1))
  (table 0 anyfunc)
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
