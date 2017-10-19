(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (export "test_udiv_2" (func $test_udiv_2))
 (export "test_udiv_5" (func $test_udiv_5))
 (export "test_sdiv_2" (func $test_sdiv_2))
 (export "test_sdiv_5" (func $test_sdiv_5))
 (export "test_urem_2" (func $test_urem_2))
 (export "test_urem_5" (func $test_urem_5))
 (export "test_srem_2" (func $test_srem_2))
 (export "test_srem_5" (func $test_srem_5))
 (func $test_udiv_2 (param $0 i32) (result i32) ;; 0
  (i32.shr_u
   (get_local $0)
   (i32.const 1)
  )
 )
 (func $test_udiv_5 (param $0 i32) (result i32) ;; 1
  (i32.div_u
   (get_local $0)
   (i32.const 5)
  )
 )
 (func $test_sdiv_2 (param $0 i32) (result i32) ;; 2
  (i32.div_s
   (get_local $0)
   (i32.const 2)
  )
 )
 (func $test_sdiv_5 (param $0 i32) (result i32) ;; 3
  (i32.div_s
   (get_local $0)
   (i32.const 5)
  )
 )
 (func $test_urem_2 (param $0 i32) (result i32) ;; 4
  (i32.and
   (get_local $0)
   (i32.const 1)
  )
 )
 (func $test_urem_5 (param $0 i32) (result i32) ;; 5
  (i32.rem_u
   (get_local $0)
   (i32.const 5)
  )
 )
 (func $test_srem_2 (param $0 i32) (result i32) ;; 6
  (i32.rem_s
   (get_local $0)
   (i32.const 2)
  )
 )
 (func $test_srem_5 (param $0 i32) (result i32) ;; 7
  (i32.rem_s
   (get_local $0)
   (i32.const 5)
  )
 )
 (func $stackSave (result i32) ;; 8
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (param $0 i32) (result i32) ;; 9
  (local $1 i32)
  (set_local $1
   (i32.load offset=4
    (i32.const 0)
   )
  )
  (i32.store offset=4
   (i32.const 0)
   (i32.and
    (i32.sub
     (get_local $1)
     (get_local $0)
    )
    (i32.const -16)
   )
  )
  (get_local $1)
 )
 (func $stackRestore (param $0 i32) ;; 10
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
