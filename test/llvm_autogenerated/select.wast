(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
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
 (func $select_i32_bool (param $0 i32) (param $1 i32) (param $2 i32) (result i32) ;; 0
  (return
   (select
    (get_local $1)
    (get_local $2)
    (get_local $0)
   )
  )
 )
 (func $select_i32_eq (param $0 i32) (param $1 i32) (param $2 i32) (result i32) ;; 1
  (return
   (select
    (get_local $2)
    (get_local $1)
    (get_local $0)
   )
  )
 )
 (func $select_i32_ne (param $0 i32) (param $1 i32) (param $2 i32) (result i32) ;; 2
  (return
   (select
    (get_local $1)
    (get_local $2)
    (get_local $0)
   )
  )
 )
 (func $select_i64_bool (param $0 i32) (param $1 i64) (param $2 i64) (result i64) ;; 3
  (return
   (select
    (get_local $1)
    (get_local $2)
    (get_local $0)
   )
  )
 )
 (func $select_i64_eq (param $0 i32) (param $1 i64) (param $2 i64) (result i64) ;; 4
  (return
   (select
    (get_local $2)
    (get_local $1)
    (get_local $0)
   )
  )
 )
 (func $select_i64_ne (param $0 i32) (param $1 i64) (param $2 i64) (result i64) ;; 5
  (return
   (select
    (get_local $1)
    (get_local $2)
    (get_local $0)
   )
  )
 )
 (func $select_f32_bool (param $0 i32) (param $1 f32) (param $2 f32) (result f32) ;; 6
  (return
   (select
    (get_local $1)
    (get_local $2)
    (get_local $0)
   )
  )
 )
 (func $select_f32_eq (param $0 i32) (param $1 f32) (param $2 f32) (result f32) ;; 7
  (return
   (select
    (get_local $2)
    (get_local $1)
    (get_local $0)
   )
  )
 )
 (func $select_f32_ne (param $0 i32) (param $1 f32) (param $2 f32) (result f32) ;; 8
  (return
   (select
    (get_local $1)
    (get_local $2)
    (get_local $0)
   )
  )
 )
 (func $select_f64_bool (param $0 i32) (param $1 f64) (param $2 f64) (result f64) ;; 9
  (return
   (select
    (get_local $1)
    (get_local $2)
    (get_local $0)
   )
  )
 )
 (func $select_f64_eq (param $0 i32) (param $1 f64) (param $2 f64) (result f64) ;; 10
  (return
   (select
    (get_local $2)
    (get_local $1)
    (get_local $0)
   )
  )
 )
 (func $select_f64_ne (param $0 i32) (param $1 f64) (param $2 f64) (result f64) ;; 11
  (return
   (select
    (get_local $1)
    (get_local $2)
    (get_local $0)
   )
  )
 )
 (func $stackSave (result i32) ;; 12
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (param $0 i32) (result i32) ;; 13
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
 (func $stackRestore (param $0 i32) ;; 14
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
