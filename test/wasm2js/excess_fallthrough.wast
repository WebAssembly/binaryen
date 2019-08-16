(module
 (export "foo" (func $foo))
 (func $bar)
 (func $foo (param $0 i32)
  (loop $label$4
   (block $label$5
    (call $bar)
    (block
     (block $label$7
      (br_table $label$7 $label$5
       (i32.const 123)
      )
     )
     (call $bar)
    )
    (return)
   )
   (unreachable)
  )
 )
)
