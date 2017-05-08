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
   (block $label$0 f32
    (loop $label$2
     (drop
      (unreachable)
     )
     (unreachable)
    )
    (get_local $var$1)
   )
  )
)

