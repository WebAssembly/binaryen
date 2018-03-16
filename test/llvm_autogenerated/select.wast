(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "select_i32_bool" (func $select_i32_bool))
 (export "select_i32_eq" (func $select_i32_eq))
 (export "select_i32_ne" (func $select_i32_ne))
 (export "select_i64_bool" (func $select_i64_bool))
 (export "select_i64_eq" (func $select_i64_eq))
 (export "select_i64_ne" (func $select_i64_ne))
 (export "select_f32_bool" (func $select_f32_bool))
 (export "select_f32_eq" (func $select_f32_eq))
 (export "select_f32_ne" (func $select_f32_ne))
 (export "select_f64_bool" (func $select_f64_bool))
 (export "select_f64_eq" (func $select_f64_eq))
 (export "select_f64_ne" (func $select_f64_ne))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $select_i32_bool (; 0 ;) (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
  (return
   (select
    (get_local $1)
    (get_local $2)
    (get_local $0)
   )
  )
 )
 (func $select_i32_eq (; 1 ;) (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
  (return
   (select
    (get_local $2)
    (get_local $1)
    (get_local $0)
   )
  )
 )
 (func $select_i32_ne (; 2 ;) (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
  (return
   (select
    (get_local $1)
    (get_local $2)
    (get_local $0)
   )
  )
 )
 (func $select_i64_bool (; 3 ;) (param $0 i32) (param $1 i64) (param $2 i64) (result i64)
  (return
   (select
    (get_local $1)
    (get_local $2)
    (get_local $0)
   )
  )
 )
 (func $select_i64_eq (; 4 ;) (param $0 i32) (param $1 i64) (param $2 i64) (result i64)
  (return
   (select
    (get_local $2)
    (get_local $1)
    (get_local $0)
   )
  )
 )
 (func $select_i64_ne (; 5 ;) (param $0 i32) (param $1 i64) (param $2 i64) (result i64)
  (return
   (select
    (get_local $1)
    (get_local $2)
    (get_local $0)
   )
  )
 )
 (func $select_f32_bool (; 6 ;) (param $0 i32) (param $1 f32) (param $2 f32) (result f32)
  (return
   (select
    (get_local $1)
    (get_local $2)
    (get_local $0)
   )
  )
 )
 (func $select_f32_eq (; 7 ;) (param $0 i32) (param $1 f32) (param $2 f32) (result f32)
  (return
   (select
    (get_local $2)
    (get_local $1)
    (get_local $0)
   )
  )
 )
 (func $select_f32_ne (; 8 ;) (param $0 i32) (param $1 f32) (param $2 f32) (result f32)
  (return
   (select
    (get_local $1)
    (get_local $2)
    (get_local $0)
   )
  )
 )
 (func $select_f64_bool (; 9 ;) (param $0 i32) (param $1 f64) (param $2 f64) (result f64)
  (return
   (select
    (get_local $1)
    (get_local $2)
    (get_local $0)
   )
  )
 )
 (func $select_f64_eq (; 10 ;) (param $0 i32) (param $1 f64) (param $2 f64) (result f64)
  (return
   (select
    (get_local $2)
    (get_local $1)
    (get_local $0)
   )
  )
 )
 (func $select_f64_ne (; 11 ;) (param $0 i32) (param $1 f64) (param $2 f64) (result f64)
  (return
   (select
    (get_local $1)
    (get_local $2)
    (get_local $0)
   )
  )
 )
 (func $stackSave (; 12 ;) (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (; 13 ;) (param $0 i32) (result i32)
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
 (func $stackRestore (; 14 ;) (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [], "declares": [], "externs": [], "implementedFunctions": ["_select_i32_bool","_select_i32_eq","_select_i32_ne","_select_i64_bool","_select_i64_eq","_select_i64_ne","_select_f32_bool","_select_f32_eq","_select_f32_ne","_select_f64_bool","_select_f64_eq","_select_f64_ne","_stackSave","_stackAlloc","_stackRestore"], "exports": ["select_i32_bool","select_i32_eq","select_i32_ne","select_i64_bool","select_i64_eq","select_i64_ne","select_f32_bool","select_f32_eq","select_f32_ne","select_f64_bool","select_f64_eq","select_f64_ne","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
