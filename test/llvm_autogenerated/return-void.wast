(module
  (memory 1
    (segment 4 "\10\04\00\00")
  )
  (export "memory" memory)
  (export "return_void" $return_void)
  (export "return_void_twice" $return_void_twice)
  (func $return_void
  )
  (func $return_void_twice (param $0 i32)
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
      (return)
    )
    (i32.store
      (i32.const 0)
      (i32.const 1)
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
