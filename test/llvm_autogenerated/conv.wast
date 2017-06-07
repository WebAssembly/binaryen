(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (export "i32_wrap_i64" (func $i32_wrap_i64))
 (export "i64_extend_s_i32" (func $i64_extend_s_i32))
 (export "i64_extend_u_i32" (func $i64_extend_u_i32))
 (export "i32_trunc_s_f32" (func $i32_trunc_s_f32))
 (export "i32_trunc_u_f32" (func $i32_trunc_u_f32))
 (export "i32_trunc_s_f64" (func $i32_trunc_s_f64))
 (export "i32_trunc_u_f64" (func $i32_trunc_u_f64))
 (export "i64_trunc_s_f32" (func $i64_trunc_s_f32))
 (export "i64_trunc_u_f32" (func $i64_trunc_u_f32))
 (export "i64_trunc_s_f64" (func $i64_trunc_s_f64))
 (export "i64_trunc_u_f64" (func $i64_trunc_u_f64))
 (export "f32_convert_s_i32" (func $f32_convert_s_i32))
 (export "f32_convert_u_i32" (func $f32_convert_u_i32))
 (export "f64_convert_s_i32" (func $f64_convert_s_i32))
 (export "f64_convert_u_i32" (func $f64_convert_u_i32))
 (export "f32_convert_s_i64" (func $f32_convert_s_i64))
 (export "f32_convert_u_i64" (func $f32_convert_u_i64))
 (export "f64_convert_s_i64" (func $f64_convert_s_i64))
 (export "f64_convert_u_i64" (func $f64_convert_u_i64))
 (export "f64_promote_f32" (func $f64_promote_f32))
 (export "f32_demote_f64" (func $f32_demote_f64))
 (export "anyext" (func $anyext))
 (export "bitcast_i32_to_float" (func $bitcast_i32_to_float))
 (export "bitcast_float_to_i32" (func $bitcast_float_to_i32))
 (export "bitcast_i64_to_double" (func $bitcast_i64_to_double))
 (export "bitcast_double_to_i64" (func $bitcast_double_to_i64))
 (func $i32_wrap_i64 (param $0 i64) (result i32)
  (return
   (i32.wrap/i64
    (get_local $0)
   )
  )
 )
 (func $i64_extend_s_i32 (param $0 i32) (result i64)
  (return
   (i64.extend_s/i32
    (get_local $0)
   )
  )
 )
 (func $i64_extend_u_i32 (param $0 i32) (result i64)
  (return
   (i64.extend_u/i32
    (get_local $0)
   )
  )
 )
 (func $i32_trunc_s_f32 (param $0 f32) (result i32)
  (return
   (i32.trunc_s/f32
    (get_local $0)
   )
  )
 )
 (func $i32_trunc_u_f32 (param $0 f32) (result i32)
  (return
   (i32.trunc_u/f32
    (get_local $0)
   )
  )
 )
 (func $i32_trunc_s_f64 (param $0 f64) (result i32)
  (return
   (i32.trunc_s/f64
    (get_local $0)
   )
  )
 )
 (func $i32_trunc_u_f64 (param $0 f64) (result i32)
  (return
   (i32.trunc_u/f64
    (get_local $0)
   )
  )
 )
 (func $i64_trunc_s_f32 (param $0 f32) (result i64)
  (return
   (i64.trunc_s/f32
    (get_local $0)
   )
  )
 )
 (func $i64_trunc_u_f32 (param $0 f32) (result i64)
  (return
   (i64.trunc_u/f32
    (get_local $0)
   )
  )
 )
 (func $i64_trunc_s_f64 (param $0 f64) (result i64)
  (return
   (i64.trunc_s/f64
    (get_local $0)
   )
  )
 )
 (func $i64_trunc_u_f64 (param $0 f64) (result i64)
  (return
   (i64.trunc_u/f64
    (get_local $0)
   )
  )
 )
 (func $f32_convert_s_i32 (param $0 i32) (result f32)
  (return
   (f32.convert_s/i32
    (get_local $0)
   )
  )
 )
 (func $f32_convert_u_i32 (param $0 i32) (result f32)
  (return
   (f32.convert_u/i32
    (get_local $0)
   )
  )
 )
 (func $f64_convert_s_i32 (param $0 i32) (result f64)
  (return
   (f64.convert_s/i32
    (get_local $0)
   )
  )
 )
 (func $f64_convert_u_i32 (param $0 i32) (result f64)
  (return
   (f64.convert_u/i32
    (get_local $0)
   )
  )
 )
 (func $f32_convert_s_i64 (param $0 i64) (result f32)
  (return
   (f32.convert_s/i64
    (get_local $0)
   )
  )
 )
 (func $f32_convert_u_i64 (param $0 i64) (result f32)
  (return
   (f32.convert_u/i64
    (get_local $0)
   )
  )
 )
 (func $f64_convert_s_i64 (param $0 i64) (result f64)
  (return
   (f64.convert_s/i64
    (get_local $0)
   )
  )
 )
 (func $f64_convert_u_i64 (param $0 i64) (result f64)
  (return
   (f64.convert_u/i64
    (get_local $0)
   )
  )
 )
 (func $f64_promote_f32 (param $0 f32) (result f64)
  (return
   (f64.promote/f32
    (get_local $0)
   )
  )
 )
 (func $f32_demote_f64 (param $0 f64) (result f32)
  (return
   (f32.demote/f64
    (get_local $0)
   )
  )
 )
 (func $anyext (param $0 i32) (result i64)
  (return
   (i64.shl
    (i64.extend_u/i32
     (get_local $0)
    )
    (i64.const 32)
   )
  )
 )
 (func $bitcast_i32_to_float (param $0 i32) (result f32)
  (return
   (f32.reinterpret/i32
    (get_local $0)
   )
  )
 )
 (func $bitcast_float_to_i32 (param $0 f32) (result i32)
  (return
   (i32.reinterpret/f32
    (get_local $0)
   )
  )
 )
 (func $bitcast_i64_to_double (param $0 i64) (result f64)
  (return
   (f64.reinterpret/i64
    (get_local $0)
   )
  )
 )
 (func $bitcast_double_to_i64 (param $0 f64) (result i64)
  (return
   (i64.reinterpret/f64
    (get_local $0)
   )
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
