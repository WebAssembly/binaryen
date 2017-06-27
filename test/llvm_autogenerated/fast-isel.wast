(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (export "immediate_f32" (func $immediate_f32))
 (export "immediate_f64" (func $immediate_f64))
 (export "bitcast_i32_f32" (func $bitcast_i32_f32))
 (export "bitcast_f32_i32" (func $bitcast_f32_i32))
 (export "bitcast_i64_f64" (func $bitcast_i64_f64))
 (export "bitcast_f64_i64" (func $bitcast_f64_i64))
 (func $immediate_f32 (result f32)
  (f32.const 2.5)
 )
 (func $immediate_f64 (result f64)
  (f64.const 2.5)
 )
 (func $bitcast_i32_f32 (param $0 f32) (result i32)
  (i32.reinterpret/f32
   (get_local $0)
  )
 )
 (func $bitcast_f32_i32 (param $0 i32) (result f32)
  (f32.reinterpret/i32
   (get_local $0)
  )
 )
 (func $bitcast_i64_f64 (param $0 f64) (result i64)
  (i64.reinterpret/f64
   (get_local $0)
  )
 )
 (func $bitcast_f64_i64 (param $0 i64) (result f64)
  (f64.reinterpret/i64
   (get_local $0)
  )
 )
 (func $stackSave (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (param $0 i32) (result i32)
  (local $1 i32)
  (set_local $1
   (i32.load offset=4
    (i32.const 0)
   )
  )
  (i32.store offset=4
   (i32.const 0)
   (i32.and
    (i32.add
     (i32.add
      (get_local $1)
      (get_local $0)
     )
     (i32.const 15)
    )
    (i32.const -16)
   )
  )
  (get_local $1)
 )
 (func $stackRestore (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
