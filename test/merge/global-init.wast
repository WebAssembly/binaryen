(module
  (import "env" "memoryBase" (global $memoryBase i32))
  (import "env" "tableBase" (global $tableBase i32))
  (import "env" "memory" (memory $0 256))
  (import "env" "table" (table 0 anyfunc))
  (import "env" "globally" (global $i-collide i32))
  (global $a i32 (get_global $i-collide))
  (global $a-mut (mut i32) (get_global $i-collide))
  (global $g-collide i32 (get_global $i-collide))
  (global $g-collide-mut (mut i32) (get_global $i-collide))
)

