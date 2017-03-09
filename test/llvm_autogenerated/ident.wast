(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
