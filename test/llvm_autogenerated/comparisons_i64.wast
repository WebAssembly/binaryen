(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
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
 (func $eq_i64 (param $0 i64) (param $1 i64) (result i32)
  (return
   (i64.eq
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $ne_i64 (param $0 i64) (param $1 i64) (result i32)
  (return
   (i64.ne
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $slt_i64 (param $0 i64) (param $1 i64) (result i32)
  (return
   (i64.lt_s
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $sle_i64 (param $0 i64) (param $1 i64) (result i32)
  (return
   (i64.le_s
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $ult_i64 (param $0 i64) (param $1 i64) (result i32)
  (return
   (i64.lt_u
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $ule_i64 (param $0 i64) (param $1 i64) (result i32)
  (return
   (i64.le_u
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $sgt_i64 (param $0 i64) (param $1 i64) (result i32)
  (return
   (i64.gt_s
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $sge_i64 (param $0 i64) (param $1 i64) (result i32)
  (return
   (i64.ge_s
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $ugt_i64 (param $0 i64) (param $1 i64) (result i32)
  (return
   (i64.gt_u
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $uge_i64 (param $0 i64) (param $1 i64) (result i32)
  (return
   (i64.ge_u
    (get_local $0)
    (get_local $1)
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
