(module
 (type $0 (func (param i32) (result i32)))
 (type $1 (func (param i32 i32 i32 i32) (result i32)))
 (type $2 (func (result i32)))
 (type $3 (func (param i32 i32)))
 (type $4 (func (param i32 i32 i32)))
 (type $5 (func (param i32 i32 i32) (result i32)))
 (type $6 (func (param i32)))
 (type $7 (func))
 (import "env" "memory" (memory $0 0))
 (data (global.get $gimport$2) "\00\00\00\00\00\00\00\00")
 (import "env" "__indirect_function_table" (table $timport$1 0 funcref))
 (import "env" "__memory_base" (global $gimport$2 i32))
 (import "env" "__table_base" (global $gimport$3 i32))
 (import "GOT.mem" "__THREW__" (global $gimport$13 (mut i32)))
 (import "GOT.func" "emscripten_longjmp_jmpbuf" (global $gimport$14 (mut i32)))
 (import "GOT.mem" "__threwValue" (global $gimport$15 (mut i32)))
 (import "env" "malloc" (func $malloc (param i32) (result i32)))
 (import "env" "saveSetjmp" (func $saveSetjmp (param i32 i32 i32 i32) (result i32)))
 (import "env" "getTempRet0" (func $getTempRet0 (result i32)))
 (import "env" "emscripten_longjmp_jmpbuf" (func $emscripten_longjmp_jmpbuf (param i32 i32)))
 (import "env" "__invoke_void_i32_i32" (func $__invoke_void_i32_i32 (param i32 i32 i32)))
 (import "env" "testSetjmp" (func $testSetjmp (param i32 i32 i32) (result i32)))
 (import "env" "setTempRet0" (func $setTempRet0 (param i32)))
 (import "env" "free" (func $free (param i32)))
 (import "env" "emscripten_longjmp" (func $emscripten_longjmp (param i32 i32)))
 (global $global$0 i32 (i32.const 0))
 (global $global$1 i32 (i32.const 4))
 (export "__wasm_call_ctors" (func $__wasm_call_ctors))
 (export "_start" (func $_start))
 (export "__THREW__" (global $global$0))
 (export "__threwValue" (global $global$1))
 (func $__wasm_call_ctors (; 9 ;) (type $7)
  (call $__wasm_apply_relocs)
 )
 (func $__wasm_apply_relocs (; 10 ;) (type $7)
 )
 (func $_start (; 11 ;) (type $7)
  (local $0 i32)
  (local $1 i32)
  (local $2 i32)
  (local $3 i32)
  (i32.store
   (local.tee $0
    (call $malloc
     (i32.const 40)
    )
   )
   (i32.const 0)
  )
  (local.set $1
   (call $saveSetjmp
    (local.get $0)
    (i32.const 1)
    (local.get $0)
    (i32.const 4)
   )
  )
  (local.set $2
   (call $getTempRet0)
  )
  (local.set $0
   (i32.const 0)
  )
  (block $label$1
   (block $label$2
    (loop $label$3
     (br_if $label$2
      (local.get $0)
     )
     (i32.store
      (local.tee $0
       (global.get $gimport$13)
      )
      (i32.const 0)
     )
     (call $__invoke_void_i32_i32
      (global.get $gimport$14)
      (local.get $0)
      (i32.const 1)
     )
     (local.set $3
      (i32.load
       (local.get $0)
      )
     )
     (i32.store
      (local.get $0)
      (i32.const 0)
     )
     (local.set $0
      (global.get $gimport$15)
     )
     (block $label$4
      (br_if $label$4
       (i32.eqz
        (local.get $3)
       )
      )
      (br_if $label$4
       (i32.eqz
        (local.tee $0
         (i32.load
          (local.get $0)
         )
        )
       )
      )
      (br_if $label$1
       (i32.eqz
        (call $testSetjmp
         (i32.load
          (local.get $3)
         )
         (local.get $1)
         (local.get $2)
        )
       )
      )
      (call $setTempRet0
       (local.get $0)
      )
     )
     (local.set $0
      (call $getTempRet0)
     )
     (br $label$3)
    )
   )
   (call $free
    (local.get $1)
   )
   (return)
  )
  (call $emscripten_longjmp
   (local.get $3)
   (local.get $0)
  )
  (unreachable)
 )
 ;; custom section "dylink", size 5
 ;; custom section "producers", size 112
)

