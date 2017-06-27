(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
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
 (func $ord_f64 (param $0 f64) (param $1 f64) (result i32)
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
 (func $uno_f64 (param $0 f64) (param $1 f64) (result i32)
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
 (func $oeq_f64 (param $0 f64) (param $1 f64) (result i32)
  (return
   (f64.eq
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $une_f64 (param $0 f64) (param $1 f64) (result i32)
  (return
   (f64.ne
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $olt_f64 (param $0 f64) (param $1 f64) (result i32)
  (return
   (f64.lt
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $ole_f64 (param $0 f64) (param $1 f64) (result i32)
  (return
   (f64.le
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $ogt_f64 (param $0 f64) (param $1 f64) (result i32)
  (return
   (f64.gt
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $oge_f64 (param $0 f64) (param $1 f64) (result i32)
  (return
   (f64.ge
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $ueq_f64 (param $0 f64) (param $1 f64) (result i32)
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
 (func $one_f64 (param $0 f64) (param $1 f64) (result i32)
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
 (func $ult_f64 (param $0 f64) (param $1 f64) (result i32)
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
 (func $ule_f64 (param $0 f64) (param $1 f64) (result i32)
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
 (func $ugt_f64 (param $0 f64) (param $1 f64) (result i32)
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
 (func $uge_f64 (param $0 f64) (param $1 f64) (result i32)
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
