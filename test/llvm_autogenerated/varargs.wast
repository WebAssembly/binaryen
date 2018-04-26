(module
 (type $FUNCSIG$v (func))
 (type $FUNCSIG$vi (func (param i32)))
 (import "env" "callee" (func $callee (param i32)))
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "start" (func $start))
 (export "end" (func $end))
 (export "copy" (func $copy))
 (export "arg_i8" (func $arg_i8))
 (export "arg_i32" (func $arg_i32))
 (export "arg_i128" (func $arg_i128))
 (export "caller_none" (func $caller_none))
 (export "caller_some" (func $caller_some))
 (export "startbb" (func $startbb))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $start (; 1 ;) (param $0 i32) (param $1 i32)
  (i32.store
   (get_local $0)
   (get_local $1)
  )
  (return)
 )
 (func $end (; 2 ;) (param $0 i32)
  (return)
 )
 (func $copy (; 3 ;) (param $0 i32) (param $1 i32)
  (i32.store
   (get_local $0)
   (i32.load
    (get_local $1)
   )
  )
  (return)
 )
 (func $arg_i8 (; 4 ;) (param $0 i32) (result i32)
  (local $1 i32)
  (i32.store
   (get_local $0)
   (i32.add
    (tee_local $1
     (i32.load
      (get_local $0)
     )
    )
    (i32.const 4)
   )
  )
  (return
   (i32.load
    (get_local $1)
   )
  )
 )
 (func $arg_i32 (; 5 ;) (param $0 i32) (result i32)
  (local $1 i32)
  (i32.store
   (get_local $0)
   (i32.add
    (tee_local $1
     (i32.and
      (i32.add
       (i32.load
        (get_local $0)
       )
       (i32.const 3)
      )
      (i32.const -4)
     )
    )
    (i32.const 4)
   )
  )
  (return
   (i32.load
    (get_local $1)
   )
  )
 )
 (func $arg_i128 (; 6 ;) (param $0 i32) (param $1 i32)
  (local $2 i32)
  (local $3 i32)
  (local $4 i64)
  (i32.store
   (get_local $1)
   (tee_local $3
    (i32.add
     (tee_local $2
      (i32.and
       (i32.add
        (i32.load
         (get_local $1)
        )
        (i32.const 7)
       )
       (i32.const -8)
      )
     )
     (i32.const 8)
    )
   )
  )
  (set_local $4
   (i64.load
    (get_local $2)
   )
  )
  (i32.store
   (get_local $1)
   (i32.add
    (get_local $2)
    (i32.const 16)
   )
  )
  (i64.store
   (i32.add
    (get_local $0)
    (i32.const 8)
   )
   (i64.load
    (get_local $3)
   )
  )
  (i64.store
   (get_local $0)
   (get_local $4)
  )
  (return)
 )
 (func $caller_none (; 7 ;)
  (call $callee
   (i32.const 0)
  )
  (return)
 )
 (func $caller_some (; 8 ;)
  (local $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (tee_local $0
    (i32.sub
     (i32.load offset=4
      (i32.const 0)
     )
     (i32.const 16)
    )
   )
  )
  (i64.store offset=8
   (get_local $0)
   (i64.const 4611686018427387904)
  )
  (i32.store
   (get_local $0)
   (i32.const 0)
  )
  (call $callee
   (get_local $0)
  )
  (i32.store offset=4
   (i32.const 0)
   (i32.add
    (get_local $0)
    (i32.const 16)
   )
  )
  (return)
 )
 (func $startbb (; 9 ;) (param $0 i32) (param $1 i32) (param $2 i32)
  (block $label$0
   (br_if $label$0
    (i32.eqz
     (i32.and
      (get_local $0)
      (i32.const 1)
     )
    )
   )
   (return)
  )
  (i32.store
   (get_local $1)
   (get_local $2)
  )
  (return)
 )
 (func $stackSave (; 10 ;) (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (; 11 ;) (param $0 i32) (result i32)
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
 (func $stackRestore (; 12 ;) (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [], "declares": ["callee"], "externs": [], "implementedFunctions": ["_start","_end","_copy","_arg_i8","_arg_i32","_arg_i128","_caller_none","_caller_some","_startbb","_stackSave","_stackAlloc","_stackRestore"], "exports": ["start","end","copy","arg_i8","arg_i32","arg_i128","caller_none","caller_some","startbb","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
