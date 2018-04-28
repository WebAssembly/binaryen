(module
 (func "one"
  (loop $label$2
   (br_if $label$2
    (block $label$3 (result i32)
     (drop
      (br_if $label$3
       (i32.const 0)
       (i32.load
        (i32.const 3060)
       )
      )
     )
     (i32.const 0)
    )
   )
  )
  (unreachable)
 )
)

