(module
 (export "foo" (func $foo (param i32) (result i32)))
 (func $foo (param $0 i32) (result i32)
  (i32.add
   (i32.div_u
    (local.get $0)
    (i32.const 100)
   )
   (i32.div_s
    (local.get $0)
    (i32.const -100)
   )
  )
 )
)