(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "load_u_i1_i32" (func $load_u_i1_i32))
 (export "load_s_i1_i32" (func $load_s_i1_i32))
 (export "load_u_i1_i64" (func $load_u_i1_i64))
 (export "load_s_i1_i64" (func $load_s_i1_i64))
 (export "store_i32_i1" (func $store_i32_i1))
 (export "store_i64_i1" (func $store_i64_i1))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $load_u_i1_i32 (; 0 ;) (param $0 i32) (result i32)
  (return
   (i32.load8_u
    (get_local $0)
   )
  )
 )
 (func $load_s_i1_i32 (; 1 ;) (param $0 i32) (result i32)
  (return
   (i32.sub
    (i32.const 0)
    (i32.and
     (i32.load8_u
      (get_local $0)
     )
     (i32.const 1)
    )
   )
  )
 )
 (func $load_u_i1_i64 (; 2 ;) (param $0 i32) (result i64)
  (return
   (i64.load8_u
    (get_local $0)
   )
  )
 )
 (func $load_s_i1_i64 (; 3 ;) (param $0 i32) (result i64)
  (return
   (i64.sub
    (i64.const 0)
    (i64.and
     (i64.load8_u
      (get_local $0)
     )
     (i64.const 1)
    )
   )
  )
 )
 (func $store_i32_i1 (; 4 ;) (param $0 i32) (param $1 i32)
  (i32.store8
   (get_local $0)
   (i32.and
    (get_local $1)
    (i32.const 1)
   )
  )
  (return)
 )
 (func $store_i64_i1 (; 5 ;) (param $0 i32) (param $1 i64)
  (i64.store8
   (get_local $0)
   (i64.and
    (get_local $1)
    (i64.const 1)
   )
  )
  (return)
 )
 (func $stackSave (; 6 ;) (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (; 7 ;) (param $0 i32) (result i32)
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
 (func $stackRestore (; 8 ;) (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [], "declares": [], "externs": [], "implementedFunctions": ["_load_u_i1_i32","_load_s_i1_i32","_load_u_i1_i64","_load_s_i1_i64","_store_i32_i1","_store_i64_i1","_stackSave","_stackAlloc","_stackRestore"], "exports": ["load_u_i1_i32","load_s_i1_i32","load_u_i1_i64","load_s_i1_i64","store_i32_i1","store_i64_i1","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
