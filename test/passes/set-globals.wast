(module
 ;; an imported i32
 (import "env" "in" (global $foo i32))

 ;; a defined i64
 (global $bar i64 (i64.const 1234))
)
