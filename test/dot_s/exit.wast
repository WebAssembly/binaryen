(module
  (type $FUNCSIG$vi (func (param i32)))
  (import "env" "exit" (func $exit (param i32)))
  (table 0 anyfunc)
  (memory $0 1)
  (export "memory" (memory $0))
  (export "main" (func $main))
  (func $main (result i32)
    (local $0 i32)
    (call $exit
      (i32.const 0)
    )
    (unreachable)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [] }
