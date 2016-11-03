(module
  (import "env" "memory" (memory $0 2048 2048))
  (import "env" "memoryBase" (global $memoryBase i32))
  (data (get_global $memoryBase) "waka this cannot be optimized\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00we don't know where it will go")
  (data (i32.const 1024) "waka this CAN be optimized\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00we DO know where it will go")
  (data (i32.const 2000) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00zeros before")
  (data (i32.const 3000) "zeros after\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00")
  (data (i32.const 4000) "zeros\00in\00the\00middle\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00nice skip here\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00another\00but no")
)
(module
  (import "env" "memory" (memory $0 2048 2048))
  (import "env" "memoryBase" (global $memoryBase i32))
  ;; nothing
)
(module
  (import "env" "memory" (memory $0 2048 2048))
  (import "env" "memoryBase" (global $memoryBase i32))
  (data (i32.const 4066) "") ;; empty
)

