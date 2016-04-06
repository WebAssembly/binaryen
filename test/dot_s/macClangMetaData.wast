(module
  (memory 1
    (segment 16 "Hello, World!\00")
  )
  (export "memory" memory)
  (type $FUNCSIG$ii (func (param i32) (result i32)))
  (import $puts "env" "puts" (param i32) (result i32))
  (export "main" $main)
  (func $main (param $$0 i32) (param $$1 i32) (result i32)
    (call_import $puts
      (i32.const 16)
    )
    (return
      (i32.const 0)
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 30, "initializers": [] }
