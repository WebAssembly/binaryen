(module
 (type $FUNCSIG$vi (func (param i32)))
 (type $FUNCSIG$iiii (func (param i32 i32 i32) (result i32)))
 (import "env" "big_byval_callee" (func $big_byval_callee (param i32)))
 (import "env" "ext_byval_func" (func $ext_byval_func (param i32)))
 (import "env" "ext_byval_func_align8" (func $ext_byval_func_align8 (param i32)))
 (import "env" "ext_byval_func_alignedstruct" (func $ext_byval_func_alignedstruct (param i32)))
 (import "env" "ext_byval_func_empty" (func $ext_byval_func_empty (param i32)))
 (import "env" "ext_func" (func $ext_func (param i32)))
 (import "env" "ext_func_empty" (func $ext_func_empty (param i32)))
 (import "env" "memcpy" (func $memcpy (param i32 i32 i32) (result i32)))
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (export "byval_arg" (func $byval_arg))
 (export "byval_arg_align8" (func $byval_arg_align8))
 (export "byval_arg_double" (func $byval_arg_double))
 (export "byval_param" (func $byval_param))
 (export "byval_empty_caller" (func $byval_empty_caller))
 (export "byval_empty_callee" (func $byval_empty_callee))
 (export "big_byval" (func $big_byval))
 (func $byval_arg (param $0 i32)
  (local $1 i32)
  (i32.store offset=4
   (i32.const 0)
   (tee_local $1
    (i32.sub
     (i32.load offset=4
      (i32.const 0)
     )
     (i32.const 16)
    )
   )
  )
  (i32.store offset=12
   (get_local $1)
   (i32.load
    (get_local $0)
   )
  )
  (call $ext_byval_func
   (i32.add
    (get_local $1)
    (i32.const 12)
   )
  )
  (i32.store offset=4
   (i32.const 0)
   (i32.add
    (get_local $1)
    (i32.const 16)
   )
  )
  (return)
 )
 (func $byval_arg_align8 (param $0 i32)
  (local $1 i32)
  (i32.store offset=4
   (i32.const 0)
   (tee_local $1
    (i32.sub
     (i32.load offset=4
      (i32.const 0)
     )
     (i32.const 16)
    )
   )
  )
  (i32.store offset=8
   (get_local $1)
   (i32.load
    (get_local $0)
   )
  )
  (call $ext_byval_func_align8
   (i32.add
    (get_local $1)
    (i32.const 8)
   )
  )
  (i32.store offset=4
   (i32.const 0)
   (i32.add
    (get_local $1)
    (i32.const 16)
   )
  )
  (return)
 )
 (func $byval_arg_double (param $0 i32)
  (local $1 i32)
  (i32.store offset=4
   (i32.const 0)
   (tee_local $1
    (i32.sub
     (i32.load offset=4
      (i32.const 0)
     )
     (i32.const 16)
    )
   )
  )
  (i64.store
   (i32.add
    (get_local $1)
    (i32.const 8)
   )
   (i64.load
    (i32.add
     (get_local $0)
     (i32.const 8)
    )
   )
  )
  (i64.store
   (get_local $1)
   (i64.load
    (get_local $0)
   )
  )
  (call $ext_byval_func_alignedstruct
   (get_local $1)
  )
  (i32.store offset=4
   (i32.const 0)
   (i32.add
    (get_local $1)
    (i32.const 16)
   )
  )
  (return)
 )
 (func $byval_param (param $0 i32)
  (call $ext_func
   (get_local $0)
  )
  (return)
 )
 (func $byval_empty_caller (param $0 i32)
  (call $ext_byval_func_empty
   (get_local $0)
  )
  (return)
 )
 (func $byval_empty_callee (param $0 i32)
  (call $ext_func_empty
   (get_local $0)
  )
  (return)
 )
 (func $big_byval (param $0 i32)
  (local $1 i32)
  (i32.store offset=4
   (i32.const 0)
   (tee_local $1
    (i32.sub
     (i32.load offset=4
      (i32.const 0)
     )
     (i32.const 131072)
    )
   )
  )
  (call $big_byval_callee
   (tee_local $0
    (call $memcpy
     (get_local $1)
     (get_local $0)
     (i32.const 131072)
    )
   )
  )
  (i32.store offset=4
   (i32.const 0)
   (i32.add
    (get_local $0)
    (i32.const 131072)
   )
  )
  (return)
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
