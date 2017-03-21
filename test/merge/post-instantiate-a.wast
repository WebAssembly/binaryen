(module
  (import "env" "memoryBase" (global $memoryBase i32))
  (import "env" "tableBase" (global $tableBase i32))
  (export "__post_instantiate" (func $0))
  (func $0
    (drop (i32.const 1000))
  )
)

