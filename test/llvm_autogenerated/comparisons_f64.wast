(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "ord_f64" (func $ord_f64))
 (export "uno_f64" (func $uno_f64))
 (export "oeq_f64" (func $oeq_f64))
 (export "une_f64" (func $une_f64))
 (export "olt_f64" (func $olt_f64))
 (export "ole_f64" (func $ole_f64))
 (export "ogt_f64" (func $ogt_f64))
 (export "oge_f64" (func $oge_f64))
 (export "ueq_f64" (func $ueq_f64))
 (export "one_f64" (func $one_f64))
 (export "ult_f64" (func $ult_f64))
 (export "ule_f64" (func $ule_f64))
 (export "ugt_f64" (func $ugt_f64))
 (export "uge_f64" (func $uge_f64))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $ord_f64 (; 0 ;) (param $0 f64) (param $1 f64) (result i32)
  (return
   (i32.and
    (f64.eq
     (get_local $0)
     (get_local $0)
    )
    (f64.eq
     (get_local $1)
     (get_local $1)
    )
   )
  )
 )
 (func $uno_f64 (; 1 ;) (param $0 f64) (param $1 f64) (result i32)
  (return
   (i32.or
    (f64.ne
     (get_local $0)
     (get_local $0)
    )
    (f64.ne
     (get_local $1)
     (get_local $1)
    )
   )
  )
 )
 (func $oeq_f64 (; 2 ;) (param $0 f64) (param $1 f64) (result i32)
  (return
   (f64.eq
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $une_f64 (; 3 ;) (param $0 f64) (param $1 f64) (result i32)
  (return
   (f64.ne
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $olt_f64 (; 4 ;) (param $0 f64) (param $1 f64) (result i32)
  (return
   (f64.lt
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $ole_f64 (; 5 ;) (param $0 f64) (param $1 f64) (result i32)
  (return
   (f64.le
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $ogt_f64 (; 6 ;) (param $0 f64) (param $1 f64) (result i32)
  (return
   (f64.gt
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $oge_f64 (; 7 ;) (param $0 f64) (param $1 f64) (result i32)
  (return
   (f64.ge
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $ueq_f64 (; 8 ;) (param $0 f64) (param $1 f64) (result i32)
  (return
   (i32.or
    (f64.eq
     (get_local $0)
     (get_local $1)
    )
    (i32.or
     (f64.ne
      (get_local $0)
      (get_local $0)
     )
     (f64.ne
      (get_local $1)
      (get_local $1)
     )
    )
   )
  )
 )
 (func $one_f64 (; 9 ;) (param $0 f64) (param $1 f64) (result i32)
  (return
   (i32.and
    (f64.ne
     (get_local $0)
     (get_local $1)
    )
    (i32.and
     (f64.eq
      (get_local $0)
      (get_local $0)
     )
     (f64.eq
      (get_local $1)
      (get_local $1)
     )
    )
   )
  )
 )
 (func $ult_f64 (; 10 ;) (param $0 f64) (param $1 f64) (result i32)
  (return
   (i32.or
    (f64.lt
     (get_local $0)
     (get_local $1)
    )
    (i32.or
     (f64.ne
      (get_local $0)
      (get_local $0)
     )
     (f64.ne
      (get_local $1)
      (get_local $1)
     )
    )
   )
  )
 )
 (func $ule_f64 (; 11 ;) (param $0 f64) (param $1 f64) (result i32)
  (return
   (i32.or
    (f64.le
     (get_local $0)
     (get_local $1)
    )
    (i32.or
     (f64.ne
      (get_local $0)
      (get_local $0)
     )
     (f64.ne
      (get_local $1)
      (get_local $1)
     )
    )
   )
  )
 )
 (func $ugt_f64 (; 12 ;) (param $0 f64) (param $1 f64) (result i32)
  (return
   (i32.or
    (f64.gt
     (get_local $0)
     (get_local $1)
    )
    (i32.or
     (f64.ne
      (get_local $0)
      (get_local $0)
     )
     (f64.ne
      (get_local $1)
      (get_local $1)
     )
    )
   )
  )
 )
 (func $uge_f64 (; 13 ;) (param $0 f64) (param $1 f64) (result i32)
  (return
   (i32.or
    (f64.ge
     (get_local $0)
     (get_local $1)
    )
    (i32.or
     (f64.ne
      (get_local $0)
      (get_local $0)
     )
     (f64.ne
      (get_local $1)
      (get_local $1)
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
 (func $stackRestore (; 16 ;) (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [], "declares": [], "externs": [], "implementedFunctions": ["_ord_f64","_uno_f64","_oeq_f64","_une_f64","_olt_f64","_ole_f64","_ogt_f64","_oge_f64","_ueq_f64","_one_f64","_ult_f64","_ule_f64","_ugt_f64","_uge_f64","_stackSave","_stackAlloc","_stackRestore"], "exports": ["ord_f64","uno_f64","oeq_f64","une_f64","olt_f64","ole_f64","ogt_f64","oge_f64","ueq_f64","one_f64","ult_f64","ule_f64","ugt_f64","uge_f64","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
