(module
  (table 0 anyfunc)
  (memory $0 1)
  (data (i32.const 4) "\10\04\00\00")
  (export "memory" (memory $0))
  (export "current_memory" (func $current_memory))
  (export "grow_memory" (func $grow_memory))
  (func $current_memory (result i32)
    (return
      (current_memory)
    )
  )
  (func $grow_memory (param $0 i32)
    (drop
      (grow_memory
        (get_local $0)
      )
    )
    (return)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
