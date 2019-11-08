(module
 (type $0 (func (param i64 f64) (result i64)))
 (memory $0 1 1)
 (func $0 (; 0 ;) (type $0) (param $0 i64) (param $1 f64) (result i64)
  (local $2 f32)
  (if (result i64)
   (loop $label$1 (result i32)
    (br_if $label$1
     (i32.const 1)
    )
    (i32.const 0)
   )
   (loop $label$3
    (block $label$4
     (f32.store offset=22 align=2
      (i32.const 0)
      (local.get $2)
     )
     (drop
      (local.tee $2
       (if (result f32)
        (i32.const -19666)
        (local.get $2)
        (unreachable)
       )
      )
     )
    )
    (br $label$3)
   )
   (i64.const 1)
  )
 )
)

