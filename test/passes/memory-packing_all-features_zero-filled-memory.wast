(module
 ;; we can optimize on an imported memory with zeroFilledMemory being set.
 (import "env" "memory" (memory $0 1 1))
 (data (i32.const 1024) "x")
 (data (i32.const 1023) "\00")
)
