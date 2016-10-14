(module
  (import "env" "memory" (memory $0 1))
  (table 0 anyfunc)
  (data (i32.const 12) "\00\00\00\00")
  (data (i32.const 416) "`\00\00\00")
)
;; METADATA: { "asmConsts": {},"staticBump": 420, "initializers": [] }
