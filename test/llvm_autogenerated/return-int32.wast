(module
  (import "env" "memory" (memory $0 1))
  (table 0 anyfunc)
  (data (i32.const 4) "\10\04\00\00")
  (export "return_i32" (func $return_i32))
  (export "return_i32_twice" (func $return_i32_twice))
  (func $return_i32 (param $0 i32) (result i32)
    (get_local $0)
  )
  (func $return_i32_twice (param $0 i32) (result i32)
    (block $label$0
      (br_if $label$0
        (i32.eqz
          (get_local $0)
        )
      )
      (i32.store
        (i32.const 0)
        (i32.const 0)
      )
      (return
        (i32.const 1)
      )
    )
    (i32.store
      (i32.const 0)
      (i32.const 2)
    )
    (i32.const 3)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
