(module
  (import "env" "memory" (memory $0 1))
  (table 0 anyfunc)
  (data (i32.const 20) "\10\00\00\00")
)
;; METADATA: { "asmConsts": {},"staticBump": 24, "initializers": [] }
