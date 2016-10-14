(module
  (import "env" "memory" (memory $0 1))
  (table 0 anyfunc)
  (data (i32.const 12) "\01\00\00\00\00\00\00\00\00\00\00\00")
  (export "f" (func $f))
  (func $f (param $0 i32) (param $1 i32)
    (i32.store offset=16
      (get_local $0)
      (get_local $1)
    )
    (return)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 24, "initializers": [] }
