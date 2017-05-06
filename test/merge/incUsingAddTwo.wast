(module
 (type $FUNCSIG$iii (func (param i32 i32) (result i32)))
 (import "env" "addTwo" (func $addTwo (param i32 i32) (result i32)))
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (export "inc" (func $inc))
 (func $inc (param $0 i32) (result i32)
  (call $addTwo
   (get_local $0)
   (i32.const 1)
  )
 )
)
