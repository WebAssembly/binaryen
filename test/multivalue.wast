(module
 (func $triple (result i32 i32 i32)
  (tuple.make
   (i32.const 42)
   (i32.const 7)
   (i32.const 13)
  )
 )
 (func $get_first (result i32)
  (tuple.extract 0
   (call $triple)
  )
 )
 (func $get_second (result i32)
  (tuple.extract 1
   (call $triple)
  )
 )
 (func $get_third (result i32)
  (tuple.extract 2
   (call $triple)
  )
 )
 (func $reverse (result i32 i32 i32)
  (local $x (i32 i32 i32))
  (local.set $x
   (call $triple)
  )
  (tuple.make
   (tuple.extract 2
    (local.get $x)
   )
   (tuple.extract 1
    (local.get $x)
   )
   (tuple.extract 0
    (local.get $x)
   )
  )
 )
)