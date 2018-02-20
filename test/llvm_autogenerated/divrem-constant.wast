(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "test_udiv_2" (func $test_udiv_2))
 (export "test_udiv_5" (func $test_udiv_5))
 (export "test_sdiv_2" (func $test_sdiv_2))
 (export "test_sdiv_5" (func $test_sdiv_5))
 (export "test_urem_2" (func $test_urem_2))
 (export "test_urem_5" (func $test_urem_5))
 (export "test_srem_2" (func $test_srem_2))
 (export "test_srem_5" (func $test_srem_5))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $test_udiv_2 (; 0 ;) (param $0 i32) (result i32)
  (i32.shr_u
   (get_local $0)
   (i32.const 1)
  )
 )
 (func $test_udiv_5 (; 1 ;) (param $0 i32) (result i32)
  (i32.div_u
   (get_local $0)
   (i32.const 5)
  )
 )
 (func $test_sdiv_2 (; 2 ;) (param $0 i32) (result i32)
  (i32.div_s
   (get_local $0)
   (i32.const 2)
  )
 )
 (func $test_sdiv_5 (; 3 ;) (param $0 i32) (result i32)
  (i32.div_s
   (get_local $0)
   (i32.const 5)
  )
 )
 (func $test_urem_2 (; 4 ;) (param $0 i32) (result i32)
  (i32.and
   (get_local $0)
   (i32.const 1)
  )
 )
 (func $test_urem_5 (; 5 ;) (param $0 i32) (result i32)
  (i32.rem_u
   (get_local $0)
   (i32.const 5)
  )
 )
 (func $test_srem_2 (; 6 ;) (param $0 i32) (result i32)
  (i32.rem_s
   (get_local $0)
   (i32.const 2)
  )
 )
 (func $test_srem_5 (; 7 ;) (param $0 i32) (result i32)
  (i32.rem_s
   (get_local $0)
   (i32.const 5)
  )
 )
 (func $stackSave (; 8 ;) (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (; 9 ;) (param $0 i32) (result i32)
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
 (func $stackRestore (; 10 ;) (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [], "declares": [], "externs": [] }
