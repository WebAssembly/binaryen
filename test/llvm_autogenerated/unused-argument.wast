(module
  (type $FUNCSIG$i (func (result i32)))
  (import "env" "return_something" (func $return_something (result i32)))
  (import "env" "memory" (memory $0 1))
  (table 0 anyfunc)
  (data (i32.const 4) "\10\04\00\00")
  (export "unused_first" (func $unused_first))
  (export "unused_second" (func $unused_second))
  (export "call_something" (func $call_something))
  (func $unused_first (param $0 i32) (param $1 i32) (result i32)
    (return
      (get_local $1)
    )
  )
  (func $unused_second (param $0 i32) (param $1 i32) (result i32)
    (return
      (get_local $0)
    )
  )
  (func $call_something
    (drop
      (call $return_something)
    )
    (return)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
