(module
  (memory 1
    (segment 0 "\10\04\00\00")
  )
  (export "memory" memory)
  (type $FUNCSIG$i (func (result i32)))
  (import $return_something "env" "return_something" (result i32))
  (export "unused_first" $unused_first)
  (export "unused_second" $unused_second)
  (export "call_something" $call_something)
  (func $unused_first (param $$0 i32) (param $$1 i32) (result i32)
    (return
      (get_local $$1)
    )
  )
  (func $unused_second (param $$0 i32) (param $$1 i32) (result i32)
    (return
      (get_local $$0)
    )
  )
  (func $call_something
    (call_import $return_something)
    (return)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
