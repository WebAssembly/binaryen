(module
 (import "env" "memory" (memory $0 1))
 (table 0 funcref)
 (data (i32.const 4) "\10\04\00\00")
 (export "ord_f32" (func $ord_f32))
 (export "uno_f32" (func $uno_f32))
 (export "oeq_f32" (func $oeq_f32))
 (export "une_f32" (func $une_f32))
 (export "olt_f32" (func $olt_f32))
 (export "ole_f32" (func $ole_f32))
 (export "ogt_f32" (func $ogt_f32))
 (export "oge_f32" (func $oge_f32))
 (export "ueq_f32" (func $ueq_f32))
 (export "one_f32" (func $one_f32))
 (export "ult_f32" (func $ult_f32))
 (export "ule_f32" (func $ule_f32))
 (export "ugt_f32" (func $ugt_f32))
 (export "uge_f32" (func $uge_f32))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $ord_f32 (; 0 ;) (param $0 f32) (param $1 f32) (result i32)
  (return
   (i32.and
    (f32.eq
     (local.get $0)
     (local.get $0)
    )
    (f32.eq
     (local.get $1)
     (local.get $1)
    )
   )
  )
 )
 (func $uno_f32 (; 1 ;) (param $0 f32) (param $1 f32) (result i32)
  (return
   (i32.or
    (f32.ne
     (local.get $0)
     (local.get $0)
    )
    (f32.ne
     (local.get $1)
     (local.get $1)
    )
   )
  )
 )
 (func $oeq_f32 (; 2 ;) (param $0 f32) (param $1 f32) (result i32)
  (return
   (f32.eq
    (local.get $0)
    (local.get $1)
   )
  )
 )
 (func $une_f32 (; 3 ;) (param $0 f32) (param $1 f32) (result i32)
  (return
   (f32.ne
    (local.get $0)
    (local.get $1)
   )
  )
 )
 (func $olt_f32 (; 4 ;) (param $0 f32) (param $1 f32) (result i32)
  (return
   (f32.lt
    (local.get $0)
    (local.get $1)
   )
  )
 )
 (func $ole_f32 (; 5 ;) (param $0 f32) (param $1 f32) (result i32)
  (return
   (f32.le
    (local.get $0)
    (local.get $1)
   )
  )
 )
 (func $ogt_f32 (; 6 ;) (param $0 f32) (param $1 f32) (result i32)
  (return
   (f32.gt
    (local.get $0)
    (local.get $1)
   )
  )
 )
 (func $oge_f32 (; 7 ;) (param $0 f32) (param $1 f32) (result i32)
  (return
   (f32.ge
    (local.get $0)
    (local.get $1)
   )
  )
 )
 (func $ueq_f32 (; 8 ;) (param $0 f32) (param $1 f32) (result i32)
  (return
   (i32.or
    (f32.eq
     (local.get $0)
     (local.get $1)
    )
    (i32.or
     (f32.ne
      (local.get $0)
      (local.get $0)
     )
     (f32.ne
      (local.get $1)
      (local.get $1)
     )
    )
   )
  )
 )
 (func $one_f32 (; 9 ;) (param $0 f32) (param $1 f32) (result i32)
  (return
   (i32.and
    (f32.ne
     (local.get $0)
     (local.get $1)
    )
    (i32.and
     (f32.eq
      (local.get $0)
      (local.get $0)
     )
     (f32.eq
      (local.get $1)
      (local.get $1)
     )
    )
   )
  )
 )
 (func $ult_f32 (; 10 ;) (param $0 f32) (param $1 f32) (result i32)
  (return
   (i32.or
    (f32.lt
     (local.get $0)
     (local.get $1)
    )
    (i32.or
     (f32.ne
      (local.get $0)
      (local.get $0)
     )
     (f32.ne
      (local.get $1)
      (local.get $1)
     )
    )
   )
  )
 )
 (func $ule_f32 (; 11 ;) (param $0 f32) (param $1 f32) (result i32)
  (return
   (i32.or
    (f32.le
     (local.get $0)
     (local.get $1)
    )
    (i32.or
     (f32.ne
      (local.get $0)
      (local.get $0)
     )
     (f32.ne
      (local.get $1)
      (local.get $1)
     )
    )
   )
  )
 )
 (func $ugt_f32 (; 12 ;) (param $0 f32) (param $1 f32) (result i32)
  (return
   (i32.or
    (f32.gt
     (local.get $0)
     (local.get $1)
    )
    (i32.or
     (f32.ne
      (local.get $0)
      (local.get $0)
     )
     (f32.ne
      (local.get $1)
      (local.get $1)
     )
    )
   )
  )
 )
 (func $uge_f32 (; 13 ;) (param $0 f32) (param $1 f32) (result i32)
  (return
   (i32.or
    (f32.ge
     (local.get $0)
     (local.get $1)
    )
    (i32.or
     (f32.ne
      (local.get $0)
      (local.get $0)
     )
     (f32.ne
      (local.get $1)
      (local.get $1)
     )
    )
   )
  )
 )
 (func $stackSave (; 14 ;) (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (; 15 ;) (param $0 i32) (result i32)
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
 (func $stackRestore (; 16 ;) (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (local.get $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [], "declares": [], "externs": [], "implementedFunctions": ["_ord_f32","_uno_f32","_oeq_f32","_une_f32","_olt_f32","_ole_f32","_ogt_f32","_oge_f32","_ueq_f32","_one_f32","_ult_f32","_ule_f32","_ugt_f32","_uge_f32","_stackSave","_stackAlloc","_stackRestore"], "exports": ["ord_f32","uno_f32","oeq_f32","une_f32","olt_f32","ole_f32","ogt_f32","oge_f32","ueq_f32","one_f32","ult_f32","ule_f32","ugt_f32","uge_f32","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
