(module
 (type $FUNCSIG$v (func))
 (type $FUNCSIG$i (func (result i32)))
 (type $FUNCSIG$ii (func (param i32) (result i32)))
 (type $FUNCSIG$vii (func (param i32 i32)))
 (type $FUNCSIG$vi (func (param i32)))
 (import "env" "__cxa_begin_catch" (func $__cxa_begin_catch (param i32) (result i32)))
 (import "env" "__cxa_end_catch" (func $__cxa_end_catch))
 (import "env" "__cxa_find_matching_catch_3" (func $__cxa_find_matching_catch_3 (param i32) (result i32)))
 (import "env" "invoke_v" (func $invoke_v (param i32)))
 (import "env" "longjmp" (func $longjmp (param i32 i32)))
 (import "env" "setjmp" (func $setjmp (param i32) (result i32)))
 (import "env" "memory" (memory $0 1))
 (import "env" "foo" (func $foo))
 (table 2 2 anyfunc)
 (elem (i32.const 0) $__wasm_nullptr $__importThunk_foo)
 (data (i32.const 4) " \04\00\00")
 (data (i32.const 12) "\00\00\00\00")
 (data (i32.const 16) "\00\00\00\00")
 (data (i32.const 20) "\00\00\00\00")
 (export "exception" (func $exception))
 (export "setjmp_longjmp" (func $setjmp_longjmp))
 (export "setThrew" (func $setThrew))
 (export "setTempRet0" (func $setTempRet0))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (export "dynCall_v" (func $dynCall_v))
 (func $exception (; 7 ;)
  (local $0 i32)
  (i32.store offset=12
   (i32.const 0)
   (i32.const 0)
  )
  (call $invoke_v
   (i32.const 1)
  )
  (set_local $0
   (i32.load offset=12
    (i32.const 0)
   )
  )
  (i32.store offset=12
   (i32.const 0)
   (i32.const 0)
  )
  (block $label$0
   (br_if $label$0
    (i32.ne
     (get_local $0)
     (i32.const 1)
    )
   )
   (drop
    (call $__cxa_begin_catch
     (call $__cxa_find_matching_catch_3
      (i32.const 0)
     )
    )
   )
   (call $__cxa_end_catch)
  )
 )
 (func $setjmp_longjmp (; 8 ;)
  (local $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (tee_local $0
    (i32.sub
     (i32.load offset=4
      (i32.const 0)
     )
     (i32.const 160)
    )
   )
  )
  (drop
   (call $setjmp
    (get_local $0)
   )
  )
  (call $longjmp
   (get_local $0)
   (i32.const 1)
  )
  (unreachable)
 )
 (func $setThrew (; 9 ;) (param $0 i32) (param $1 i32)
  (block $label$0
   (br_if $label$0
    (i32.load offset=12
     (i32.const 0)
    )
   )
   (i32.store offset=16
    (i32.const 0)
    (get_local $1)
   )
   (i32.store offset=12
    (i32.const 0)
    (get_local $0)
   )
  )
 )
 (func $setTempRet0 (; 10 ;) (param $0 i32)
  (i32.store offset=20
   (i32.const 0)
   (get_local $0)
  )
 )
 (func $__wasm_nullptr (; 11 ;) (type $FUNCSIG$v)
  (unreachable)
 )
 (func $__importThunk_foo (; 12 ;) (type $FUNCSIG$v)
  (call $foo)
 )
 (func $stackSave (; 13 ;) (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (; 14 ;) (param $0 i32) (result i32)
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
 (func $stackRestore (; 15 ;) (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
 (func $dynCall_v (; 16 ;) (param $fptr i32)
  (call_indirect (type $FUNCSIG$v)
   (get_local $fptr)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1056, "initializers": [], "declares": ["__cxa_begin_catch","__cxa_end_catch","__cxa_find_matching_catch_3","longjmp","setjmp","foo"], "externs": [], "implementedFunctions": ["_exception","_setjmp_longjmp","_setThrew","_setTempRet0","_stackSave","_stackAlloc","_stackRestore","_dynCall_v"], "exports": ["exception","setjmp_longjmp","setThrew","setTempRet0","stackSave","stackAlloc","stackRestore","dynCall_v"], "invokeFuncs": ["invoke_v"] }
