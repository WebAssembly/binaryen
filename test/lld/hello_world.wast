(module
 (type $0 (func (result i32)))
 (type $1 (func (param i32) (result i32)))
 (import "env" "puts" (func $import$0 (param i32) (result i32)))
 (global $global$0 (mut i32) (i32.const 66576))
 (table 1 1 anyfunc)
 (memory $0 2)
 (data (i32.const 1024) "Hello, world\00")
 (export "memory" (memory $0))
 (export "main" (func $main))
 (func $main (; 1 ;) (type $0) (result i32)
  (drop
   (call $import$0
    (i32.const 1024)
   )
  )
  (i32.const 0)
 )
 ;; custom section "linking", size 3
)

