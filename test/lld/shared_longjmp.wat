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
 (import "env" "malloc" (func $fimport$4 (param i32) (result i32)))
 (import "env" "saveSetjmp" (func $fimport$5 (param i32 i32 i32 i32) (result i32)))
 (import "env" "getTempRet0" (func $fimport$6 (result i32)))
 (import "env" "emscripten_longjmp_jmpbuf" (func $fimport$7 (param i32 i32)))
 (import "env" "__invoke_void_i32_i32" (func $fimport$8 (param i32 i32 i32)))
 (import "env" "testSetjmp" (func $fimport$9 (param i32 i32 i32) (result i32)))
 (import "env" "setTempRet0" (func $fimport$10 (param i32)))
 (import "env" "free" (func $fimport$11 (param i32)))
 (import "env" "emscripten_longjmp" (func $fimport$12 (param i32 i32)))
 (global $global$0 i32 (i32.const 0))
 (global $global$1 i32 (i32.const 4))
 (export "__wasm_call_ctors" (func $0))
 (export "_start" (func $2))
 (export "__THREW__" (global $global$0))
 (export "__threwValue" (global $global$1))
 (func $0 (; 9 ;) (type $7)
  (call $1)
 )
 (func $1 (; 10 ;) (type $7)
 )
 (func $2 (; 11 ;) (type $7)
  (local $0 i32)
  (local $1 i32)
  (local $2 i32)
  (local $3 i32)
  (i32.store
   (local.tee $0
    (call $fimport$4
     (i32.const 40)
    )
   )
   (i32.const 0)
  )
  (local.set $1
   (call $fimport$5
    (local.get $0)
    (i32.const 1)
    (local.get $0)
    (i32.const 4)
   )
  )
  (local.set $2
   (call $fimport$6)
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
     (call $fimport$8
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
        (call $fimport$9
         (i32.load
          (local.get $3)
         )
         (local.get $1)
         (local.get $2)
        )
       )
      )
      (call $fimport$10
       (local.get $0)
      )
     )
     (local.set $0
      (call $fimport$6)
     )
     (br $label$3)
    )
   )
   (call $fimport$11
    (local.get $1)
   )
   (return)
  )
  (call $fimport$12
   (local.get $3)
   (local.get $0)
  )
  (unreachable)
 )
 ;; custom section "dylink", size 5
 ;; custom section "producers", size 112
)

