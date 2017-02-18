(module
  (import "env" "memoryBase" (global $memoryBase i32))
  (import "env" "tableBase" (global $tableBase i32))
  (import "env" "memory" (memory $0 256))
  (import "env" "table" (table 0 anyfunc))
  (data (get_global $memoryBase) "hello, A!\n")
  (func $only-a
    (drop (i32.const 100))
    (call $only-a)
  )
  (func $willCollide
    (drop (i32.const 200))
    (call $willCollide)
  )
)

