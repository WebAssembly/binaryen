(module
 (func $0 (result f64)
  (if
   (i32.const 0)
   (loop $label$2
    (unreachable)
   )
  )
  (f64.const -nan:0xfffffd63e4e5a)
 )
)
(module
 (func $0 (result i32)
  (block $label$8
   (block $label$9
    (block $label$16
     (block $label$18
      (block $label$19
       (br_table $label$18 $label$16 $label$19
        (i32.const 0)
       )
      )
      (br_table $label$9 $label$8
       (i32.const 1)
      )
     )
     (unreachable)
    )
    (unreachable)
   )
   (unreachable)
  )
  (i32.const 2)
 )
)

