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
 (func $get-first (result i32)
  (tuple.extract 0
   (call $triple)
  )
 )
 (func $get-second (result i64)
  (tuple.extract 1
   (call $triple)
  )
 )
 (func $get-third (result f32)
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
 (func $unreachable (result i64)
  (tuple.extract 1
   (tuple.make
    (i32.const 42)
    (i64.const 7)
    (unreachable)
   )
  )
 )

 ;; Test lowering of multivalue drops
 (func $drop-call
  (drop
   (call $pair)
  )
 )
 (func $drop-tuple-make
  (drop
   (tuple.make
    (i32.const 42)
    (i64.const 42)
   )
  )
 )
 (func $drop-block
  (drop
   (block (result i32 i64)
    (tuple.make
     (i32.const 42)
     (i64.const 42)
    )
   )
  )
 )

 ;; Test multivalue control structures
 (func $mv-return (result i32 i64)
  (return
   (tuple.make
    (i32.const 42)
    (i64.const 42)
   )
  )
 )
 (func $mv-return-in-block (result i32 i64)
  (block (result i32 i64)
   (return
    (tuple.make
     (i32.const 42)
     (i64.const 42)
    )
   )
  )
 )
 (func $mv-block-break (result i32 i64)
  (block $l (result i32 i64)
   (br $l
    (tuple.make
     (i32.const 42)
     (i64.const 42)
    )
   )
  )
 )
 (func $mv-block-br-if (result i32 i64)
  (block $l (result i32 i64)
   (br_if $l
    (tuple.make
     (i32.const 42)
     (i64.const 42)
    )
    (i32.const 1)
   )
  )
 )
 (func $mv-if (result i32 i64 anyref)
  (if (result i32 i64 nullref)
   (i32.const 1)
   (tuple.make
    (i32.const 42)
    (i64.const 42)
    (ref.null)
   )
   (tuple.make
    (i32.const 42)
    (i64.const 42)
    (ref.null)
   )
  )
 )
 (func $mv-loop (result i32 i64)
  (loop (result i32 i64)
   (tuple.make
    (i32.const 42)
    (i64.const 42)
   )
  )
 )
 (func $mv-switch (result i32 i64)
  (block $a (result i32 i64)
   (block $b (result i32 i64)
    (br_table $a $b
     (tuple.make
      (i32.const 42)
      (i64.const 42)
     )
     (i32.const 0)
    )
   )
  )
 )
)