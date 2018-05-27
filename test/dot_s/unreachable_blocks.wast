(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $unreachable_block_void (; 0 ;) (result i32)
  (block $label$0
  )
  (return
   (i32.const 1)
  )
  (block $label$1
   (unreachable)
  )
 )
 (func $unreachable_block_i32 (; 1 ;) (result i32)
  (return
   (i32.const 2)
  )
  (block $label$0
   (unreachable)
  )
 )
 (func $unreachable_block_i64 (; 2 ;) (result i64)
  (return
   (i64.const 3)
  )
  (block $label$0
   (unreachable)
  )
 )
 (func $unreachable_block_f32 (; 3 ;) (result f32)
  (return
   (f32.const 4.5)
  )
  (block $label$0
   (unreachable)
  )
 )
 (func $unreachable_block_f64 (; 4 ;) (result f64)
  (return
   (f64.const 5.5)
  )
  (block $label$0
   (unreachable)
  )
 )
 (func $unreachable_loop_void (; 5 ;) (result i32)
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
 (func $unreachable_loop_i32 (; 6 ;) (result i32)
  (return
   (i32.const 7)
  )
  (loop $label$0 (result i32)
   (br $label$0)
  )
 )
 (func $unreachable_loop_i64 (; 7 ;) (result i64)
  (return
   (i64.const 8)
  )
  (loop $label$0 (result i64)
   (br $label$0)
  )
 )
 (func $unreachable_loop_f32 (; 8 ;) (result f32)
  (return
   (f32.const 9.5)
  )
  (loop $label$0 (result f32)
   (br $label$0)
  )
 )
 (func $unreachable_loop_f64 (; 9 ;) (result f64)
  (return
   (f64.const 10.5)
  )
  (loop $label$0 (result f64)
   (br $label$0)
  )
 )
 (func $stackSave (; 10 ;) (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (; 11 ;) (param $0 i32) (result i32)
  (local $1 i32)
  (i32.store offset=4
   (i32.const 0)
   (tee_local $1
    (i32.and
     (i32.sub
      (i32.load offset=4
       (i32.const 0)
      )
      (get_local $0)
     )
     (i32.const -16)
    )
   )
  )
  (get_local $1)
 )
 (func $stackRestore (; 12 ;) (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [], "declares": [], "externs": [], "implementedFunctions": ["_stackSave","_stackAlloc","_stackRestore"], "exports": ["stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
