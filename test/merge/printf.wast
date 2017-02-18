(module
  (import "env" "memoryBase" (global $memoryBase i32))
  (import "env" "tableBase" (global $tableBase i32))
  (import "env" "memory" (memory $0 256))
  (import "env" "table" (table 0 anyfunc))
  (import "env" "globally" (global $i-collide i32))
  (import "env" "foobar" (func $import$8 (param i32 i32) (result i32)))
  (export "_printf" (func $625))
  (func $625 (param $var$0 i32) (param $var$1 i32) (result i32)
    (i32.const 102030)
  )
)

