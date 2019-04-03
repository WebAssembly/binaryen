(module
 (import "env" "memory" (memory $0 1))
 (table 0 funcref)
 (data (i32.const 4) "\10\04\00\00")
 (export "eq_i32" (func $eq_i32))
 (export "ne_i32" (func $ne_i32))
 (export "slt_i32" (func $slt_i32))
 (export "sle_i32" (func $sle_i32))
 (export "ult_i32" (func $ult_i32))
 (export "ule_i32" (func $ule_i32))
 (export "sgt_i32" (func $sgt_i32))
 (export "sge_i32" (func $sge_i32))
 (export "ugt_i32" (func $ugt_i32))
 (export "uge_i32" (func $uge_i32))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $eq_i32 (; 0 ;) (param $0 i32) (param $1 i32) (result i32)
  (return
   (i32.eq
    (local.get $0)
    (local.get $1)
   )
  )
 )
 (func $ne_i32 (; 1 ;) (param $0 i32) (param $1 i32) (result i32)
  (return
   (i32.ne
    (local.get $0)
    (local.get $1)
   )
  )
 )
 (func $slt_i32 (; 2 ;) (param $0 i32) (param $1 i32) (result i32)
  (return
   (i32.lt_s
    (local.get $0)
    (local.get $1)
   )
  )
 )
 (func $sle_i32 (; 3 ;) (param $0 i32) (param $1 i32) (result i32)
  (return
   (i32.le_s
    (local.get $0)
    (local.get $1)
   )
  )
 )
 (func $ult_i32 (; 4 ;) (param $0 i32) (param $1 i32) (result i32)
  (return
   (i32.lt_u
    (local.get $0)
    (local.get $1)
   )
  )
 )
 (func $ule_i32 (; 5 ;) (param $0 i32) (param $1 i32) (result i32)
  (return
   (i32.le_u
    (local.get $0)
    (local.get $1)
   )
  )
 )
 (func $sgt_i32 (; 6 ;) (param $0 i32) (param $1 i32) (result i32)
  (return
   (i32.gt_s
    (local.get $0)
    (local.get $1)
   )
  )
 )
 (func $sge_i32 (; 7 ;) (param $0 i32) (param $1 i32) (result i32)
  (return
   (i32.ge_s
    (local.get $0)
    (local.get $1)
   )
  )
 )
 (func $ugt_i32 (; 8 ;) (param $0 i32) (param $1 i32) (result i32)
  (return
   (i32.gt_u
    (local.get $0)
    (local.get $1)
   )
  )
 )
 (func $uge_i32 (; 9 ;) (param $0 i32) (param $1 i32) (result i32)
  (return
   (i32.ge_u
    (local.get $0)
    (local.get $1)
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
   (local.tee $1
    (i32.and
     (i32.sub
      (i32.load offset=4
       (i32.const 0)
      )
      (local.get $0)
     )
     (i32.const -16)
    )
   )
  )
  (local.get $1)
 )
 (func $stackRestore (; 12 ;) (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (local.get $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [], "declares": [], "externs": [], "implementedFunctions": ["_eq_i32","_ne_i32","_slt_i32","_sle_i32","_ult_i32","_ule_i32","_sgt_i32","_sge_i32","_ugt_i32","_uge_i32","_stackSave","_stackAlloc","_stackRestore"], "exports": ["eq_i32","ne_i32","slt_i32","sle_i32","ult_i32","ule_i32","sgt_i32","sge_i32","ugt_i32","uge_i32","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
