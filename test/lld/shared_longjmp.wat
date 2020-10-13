(module
 (type $none_=>_none (func))
 (type $i32_=>_none (func (param i32)))
 (type $i32_i32_=>_none (func (param i32 i32)))
 (type $i32_i32_i32_=>_none (func (param i32 i32 i32)))
 (type $none_=>_i32 (func (result i32)))
 (type $i32_=>_i32 (func (param i32) (result i32)))
 (type $i32_i32_i32_=>_i32 (func (param i32 i32 i32) (result i32)))
 (type $i32_i32_i32_i32_=>_i32 (func (param i32 i32 i32 i32) (result i32)))
 (import "env" "memory" (memory $mimport$0 0))
 (data (global.get $gimport$2) "\00\00\00\00\00\00\00\00")
 (import "env" "__indirect_function_table" (table $timport$1 0 funcref))
 (import "env" "__memory_base" (global $gimport$2 i32))
 (import "env" "__table_base" (global $gimport$3 i32))
 (import "GOT.mem" "__THREW__" (global $gimport$12 (mut i32)))
 (import "GOT.func" "emscripten_longjmp" (global $gimport$13 (mut i32)))
 (import "GOT.mem" "__threwValue" (global $gimport$14 (mut i32)))
 (import "env" "malloc" (func $fimport$4 (param i32) (result i32)))
 (import "env" "saveSetjmp" (func $fimport$5 (param i32 i32 i32 i32) (result i32)))
 (import "env" "getTempRet0" (func $fimport$6 (result i32)))
 (import "env" "emscripten_longjmp" (func $fimport$7 (param i32 i32)))
 (import "env" "invoke_vii" (func $fimport$8 (param i32 i32 i32)))
 (import "env" "testSetjmp" (func $fimport$9 (param i32 i32 i32) (result i32)))
 (import "env" "setTempRet0" (func $fimport$10 (param i32)))
 (import "env" "free" (func $fimport$11 (param i32)))
 (global $global$0 i32 (i32.const 0))
 (global $global$1 i32 (i32.const 4))
 (export "__wasm_call_ctors" (func $0))
 (export "_start" (func $2))
 (export "__THREW__" (global $global$0))
 (export "__threwValue" (global $global$1))
 (func $0
  (call $1)
 )
 (func $1
 )
 (func $2
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
       (global.get $gimport$12)
      )
      (i32.const 0)
     )
     (call $fimport$8
      (global.get $gimport$13)
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
      (global.get $gimport$14)
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
  (call $fimport$7
   (local.get $3)
   (local.get $0)
  )
  (unreachable)
 )
 ;; dylink section
 ;;   memorysize: 8
 ;;   memoryalignment: 2
 ;;   tablesize: 0
 ;;   tablealignment: 0
 ;; custom section "producers", size 112
)

