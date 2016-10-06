(module
  (memory $0 1)
  (data (i32.const 4) "\90\04\00\00")
  (export "memory" (memory $0))
  (export "main" (func $main))
  (table 0 anyfunc)
  
  (func $main (result i32)
    (local $0 i32)
    (set_local $0
      (i32.const -128)
    )
    (loop $label$0
      (i32.store
        (i32.add
          (get_local $0)
          (i32.const 144)
        )
        (i32.const 1)
      )
      (br_if $label$0
        (tee_local $0
          (i32.add
            (get_local $0)
            (i32.const 4)
          )
        )
      )
    )
    (return
      (i32.const 0)
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1168, "initializers": [] }
