(module
  (type $FUNCSIG$vi (func (param i32)))
  (import "env" "exit" (func $exit (param i32)))
  (import "env" "memory" (memory $0 1))
  (table 0 anyfunc)
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
