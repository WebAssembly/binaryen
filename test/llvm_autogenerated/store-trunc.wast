(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (export "trunc_i8_i32" (func $trunc_i8_i32))
 (export "trunc_i16_i32" (func $trunc_i16_i32))
 (export "trunc_i8_i64" (func $trunc_i8_i64))
 (export "trunc_i16_i64" (func $trunc_i16_i64))
 (export "trunc_i32_i64" (func $trunc_i32_i64))
 (func $trunc_i8_i32 (param $0 i32) (param $1 i32)
  (i32.store8
   (get_local $0)
   (get_local $1)
  )
 )
 (func $trunc_i16_i32 (param $0 i32) (param $1 i32)
  (i32.store16
   (get_local $0)
   (get_local $1)
  )
 )
 (func $trunc_i8_i64 (param $0 i32) (param $1 i64)
  (i64.store8
   (get_local $0)
   (get_local $1)
  )
 )
 (func $trunc_i16_i64 (param $0 i32) (param $1 i64)
  (i64.store16
   (get_local $0)
   (get_local $1)
  )
 )
 (func $trunc_i32_i64 (param $0 i32) (param $1 i64)
  (i64.store32
   (get_local $0)
   (get_local $1)
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
