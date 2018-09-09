(module
  (import "env" "memoryBase" (global $memoryBase i32))
  (import "env" "tableBase" (global $tableBase i32))
  (import "env" "memory" (memory $0 256))
  (import "env" "table" (table 0 anyfunc))
  (export "foo" (func $foo-func))
  (import "env" "bar" (func $bar-func))
  (global $a-global i32 (i32.const 0))
  (export "aglobal" (global $a-global))
  (import "env" "bglobal" (global $b-global f64))
  (func $foo-func
    (drop (i32.const 1337))
    (call $bar-func)
    (drop (get_global $a-global))
    (drop (get_global $b-global))
  )
)

