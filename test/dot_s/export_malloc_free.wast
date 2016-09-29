(module
  (memory $0 1)
  (export "memory" (memory $0))
  (export "main" (func $main))
  (export "malloc" (func $malloc))
  (export "free" (func $free))
  (export "realloc" (func $realloc))
  (func $main (result i32)
    (i32.const 0)
  )
  (func $malloc (param $0 i32) (result i32)
    (i32.const 0)
  )
  (func $free (param $0 i32)
  )
  (func $realloc (param $0 i32) (param $1 i32) (result i32)
    (i32.const 0)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [] }
