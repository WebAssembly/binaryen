(module
 (type $0 (func (param i32) (result i32)))
 (type $1 (func (result i32)))
 (memory $0 1)
 (export "memory" (memory $0))
 (export "grow" (func $0))
 (export "current" (func $1))
 (func $0 (; 0 ;) (type $0) (param $var$0 i32) (result i32)
  (grow_memory
   (get_local $var$0)
  )
 )
 (func $1 (; 1 ;) (type $1) (result i32)
  (current_memory)
 )
)

