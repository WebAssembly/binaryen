(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (export "addTwo" (func $addTwo))
 (func $addTwo (param $0 i32) (param $1 i32) (result i32)
  (i32.add
   (get_local $1)
   (get_local $0)
  )
 )
)
