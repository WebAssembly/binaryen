(module
  (func $__Z12serveroptionPc (result i32)
    (block $switch$0
      (return
        (i32.const 0)
      )
      (br $switch$0)
    )
    (return
      (i32.const 0)
    )
  )
  (func $drop-unreachable (param $var$0 f32) (param $var$1 f32) (result f32)
   (block $label$0 (result f32)
    (loop $label$2
     (drop
      (unreachable)
     )
     (unreachable)
    )
    (local.get $var$1)
   )
  )

 (func $set-unreachable (param $var$0 i64) (result i64)
  (local $var$1 i64)
  (local $var$2 i64)
  (block $label$0 (result i64)
   (block $label$1
    (loop $label$2
     (if
      (i64.eq
       (local.get $var$1)
       (i64.const 0)
      )
      (unreachable)
      (local.set $var$2
       (i64.mul
        (unreachable)
        (local.get $var$2)
       )
      )
     )
     (br $label$2)
    )
   )
   (local.get $var$2)
  )
 )
)

