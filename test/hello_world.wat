(module
 (type $0 (func (param i32 i32) (result i32)))
 (memory $0 256 256)
 (export "add" (func $add))
 (func $add (; 0 ;) (type $0) (param $x i32) (param $y i32) (result i32)
  (i32.add
   (local.get $x)
   (local.get $y)
  )
 )
)
