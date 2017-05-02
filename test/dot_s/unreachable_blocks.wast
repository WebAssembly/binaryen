(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (func $unreachable_block_void
  (block $label$0
  )
  (return
   (i32.const 1)
  )
  (block $label$1
  )
 )
 (func $unreachable_block_i32 (result i32)
  (return
   (i32.const 2)
  )
  (block $label$0 i32
   (unreachable)
  )
 )
 (func $unreachable_block_i64 (result i64)
  (return
   (i64.const 3)
  )
  (block $label$0 i64
   (unreachable)
  )
 )
 (func $unreachable_block_f32 (result f32)
  (return
   (f32.const 4.5)
  )
  (block $label$0 f32
   (unreachable)
  )
 )
 (func $unreachable_block_f64 (result f64)
  (return
   (f64.const 5.5)
  )
  (block $label$0 f64
   (unreachable)
  )
 )
 (func $unreachable_loop_void
  (loop $label$0
   (br $label$0)
  )
  (return
   (i32.const 6)
  )
  (loop $label$1
   (br $label$1)
  )
 )
 (func $unreachable_loop_i32 (result i32)
  (return
   (i32.const 7)
  )
  (loop $label$0 i32
   (br $label$0)
  )
 )
 (func $unreachable_loop_i64 (result i64)
  (return
   (i64.const 8)
  )
  (loop $label$0 i64
   (br $label$0)
  )
 )
 (func $unreachable_loop_f32 (result f32)
  (return
   (f32.const 9.5)
  )
  (loop $label$0 f32
   (br $label$0)
  )
 )
 (func $unreachable_loop_f64 (result f64)
  (return
   (f64.const 10.5)
  )
  (loop $label$0 f64
   (br $label$0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [] }
