(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "eq_i64" (func $eq_i64))
 (export "ne_i64" (func $ne_i64))
 (export "slt_i64" (func $slt_i64))
 (export "sle_i64" (func $sle_i64))
 (export "ult_i64" (func $ult_i64))
 (export "ule_i64" (func $ule_i64))
 (export "sgt_i64" (func $sgt_i64))
 (export "sge_i64" (func $sge_i64))
 (export "ugt_i64" (func $ugt_i64))
 (export "uge_i64" (func $uge_i64))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $eq_i64 (; 0 ;) (param $0 i64) (param $1 i64) (result i32)
  (return
   (i64.eq
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $ne_i64 (; 1 ;) (param $0 i64) (param $1 i64) (result i32)
  (return
   (i64.ne
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $slt_i64 (; 2 ;) (param $0 i64) (param $1 i64) (result i32)
  (return
   (i64.lt_s
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $sle_i64 (; 3 ;) (param $0 i64) (param $1 i64) (result i32)
  (return
   (i64.le_s
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $ult_i64 (; 4 ;) (param $0 i64) (param $1 i64) (result i32)
  (return
   (i64.lt_u
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $ule_i64 (; 5 ;) (param $0 i64) (param $1 i64) (result i32)
  (return
   (i64.le_u
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $sgt_i64 (; 6 ;) (param $0 i64) (param $1 i64) (result i32)
  (return
   (i64.gt_s
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $sge_i64 (; 7 ;) (param $0 i64) (param $1 i64) (result i32)
  (return
   (i64.ge_s
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $ugt_i64 (; 8 ;) (param $0 i64) (param $1 i64) (result i32)
  (return
   (i64.gt_u
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $uge_i64 (; 9 ;) (param $0 i64) (param $1 i64) (result i32)
  (return
   (i64.ge_u
    (get_local $0)
    (get_local $1)
   )
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
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [], "declares": [], "externs": [], "implementedFunctions": ["_eq_i64","_ne_i64","_slt_i64","_sle_i64","_ult_i64","_ule_i64","_sgt_i64","_sge_i64","_ugt_i64","_uge_i64","_stackSave","_stackAlloc","_stackRestore"], "exports": ["eq_i64","ne_i64","slt_i64","sle_i64","ult_i64","ule_i64","sgt_i64","sge_i64","ugt_i64","uge_i64","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
