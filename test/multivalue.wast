(module
 (import "env" "pair" (func $pair (result i32 i64)))
 ;; Test basic lowering of tuple.make, tuple.extract, and tuple locals

 (func $triple (result i32 i64 f32)
  (tuple.make
   (i32.const 42)
   (i64.const 7)
   (f32.const 13)
  )
 )

 (func $get_first (result i32)
  (tuple.extract 0
   (call $triple)
  )
 )

 (func $get_second (result i64)
  (tuple.extract 1
   (call $triple)
  )
 )

 (func $get_third (result f32)
  (tuple.extract 2
   (call $triple)
  )
 )

 (func $reverse (result f32 i64 i32)
  (local $x (i32 i64 f32))
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

 ;; Test lowering of multivalue drops
 (func $drop_call
  (drop
   (call $pair)
  )
 )

 (func $drop_tuple_make
  (drop
   (tuple.make
    (i32.const 42)
    (i64.const 42)
   )
  )
 )

 (func $drop_block
  (drop
   (block (result i32 i64)
    (tuple.make
     (i32.const 42)
     (i64.const 42)
    )
   )
  )
 )
)
