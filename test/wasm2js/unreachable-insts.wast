(module
 (type $0 (func (param f64 f64 f32)))
 (memory $0 1 1)
 (func $0 (; 0 ;) (type $0) (param $0 f64) (param $1 f64) (param $2 f32)
  (f64.store offset=22 align=1
   (block $label$1 (result i32)
    (unreachable)
   )
   (f64.const 1)
  )
 )
)

