(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (export "sext_i8_i32" (func $sext_i8_i32))
 (export "zext_i8_i32" (func $zext_i8_i32))
 (export "sext_i16_i32" (func $sext_i16_i32))
 (export "zext_i16_i32" (func $zext_i16_i32))
 (export "sext_i8_i64" (func $sext_i8_i64))
 (export "zext_i8_i64" (func $zext_i8_i64))
 (export "sext_i16_i64" (func $sext_i16_i64))
 (export "zext_i16_i64" (func $zext_i16_i64))
 (export "sext_i32_i64" (func $sext_i32_i64))
 (export "zext_i32_i64" (func $zext_i32_i64))
 (func $sext_i8_i32 (param $0 i32) (result i32)
  (return
   (i32.load8_s
    (get_local $0)
   )
  )
 )
 (func $zext_i8_i32 (param $0 i32) (result i32)
  (return
   (i32.load8_u
    (get_local $0)
   )
  )
 )
 (func $sext_i16_i32 (param $0 i32) (result i32)
  (return
   (i32.load16_s
    (get_local $0)
   )
  )
 )
 (func $zext_i16_i32 (param $0 i32) (result i32)
  (return
   (i32.load16_u
    (get_local $0)
   )
  )
 )
 (func $sext_i8_i64 (param $0 i32) (result i64)
  (return
   (i64.load8_s
    (get_local $0)
   )
  )
 )
 (func $zext_i8_i64 (param $0 i32) (result i64)
  (return
   (i64.load8_u
    (get_local $0)
   )
  )
 )
 (func $sext_i16_i64 (param $0 i32) (result i64)
  (return
   (i64.load16_s
    (get_local $0)
   )
  )
 )
 (func $zext_i16_i64 (param $0 i32) (result i64)
  (return
   (i64.load16_u
    (get_local $0)
   )
  )
 )
 (func $sext_i32_i64 (param $0 i32) (result i64)
  (return
   (i64.load32_s
    (get_local $0)
   )
  )
 )
 (func $zext_i32_i64 (param $0 i32) (result i64)
  (return
   (i64.load32_u
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
