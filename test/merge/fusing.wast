(module
  (import "env" "memoryBase" (global $memoryBase i32))
  (import "env" "tableBase" (global $tableBase i32))
  (import "env" "memory" (memory $0 256))
  (import "env" "table" (table 0 anyfunc))
  (export "foo" (func $foo-func))
  (func $foo-func
    (drop (i32.const 1337))
  )
)

