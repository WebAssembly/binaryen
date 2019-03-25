(module
 (memory $0 1 1)
 (global $global$0 (mut i32) (i32.const 10))
 (func "foo" (result i32)
  (i32.load offset=4 align=1
   (i32.and
    (block $label$1 (result i32)
     (global.set $global$0
      (i32.const 0)
     )
     (i32.const -64)
    )
    (i32.const 15)
   )
  )
 )
)


