(module
 (type $none_=>_none (func))
 (type $i32_=>_none (func (param i32)))
 (type $i32_=>_i32 (func (param i32) (result i32)))
 (type $i32_i32_i32_i32_=>_i32 (func (param i32 i32 i32 i32) (result i32)))
 (type $none_=>_i32 (func (result i32)))
 (type $i32_i32_=>_none (func (param i32 i32)))
 (type $i32_i32_i32_=>_none (func (param i32 i32 i32)))
 (type $i32_i32_i32_=>_i32 (func (param i32 i32 i32) (result i32)))
 (import "env" "memory" (memory $mimport$0 1))
 (import "env" "__indirect_function_table" (table $timport$0 0 funcref))
 (import "env" "__memory_base" (global $__memory_base i32))
 (import "env" "__table_base" (global $__table_base i32))
 (import "GOT.mem" "__THREW__" (global $__THREW__ (mut i32)))
 (import "GOT.func" "emscripten_longjmp" (global $emscripten_longjmp (mut i32)))
 (import "GOT.mem" "__threwValue" (global $__threwValue (mut i32)))
 (import "env" "malloc" (func $malloc (param i32) (result i32)))
 (import "env" "saveSetjmp" (func $saveSetjmp (param i32 i32 i32 i32) (result i32)))
 (import "env" "getTempRet0" (func $getTempRet0 (result i32)))
 (import "env" "emscripten_longjmp" (func $emscripten_longjmp (param i32 i32)))
 (import "env" "invoke_vii" (func $invoke_vii (param i32 i32 i32)))
 (import "env" "testSetjmp" (func $testSetjmp (param i32 i32 i32) (result i32)))
 (import "env" "setTempRet0" (func $setTempRet0 (param i32)))
 (import "env" "free" (func $free (param i32)))
 (global $global$0 i32 (i32.const 0))
 (global $global$1 i32 (i32.const 4))
 (data $.bss (global.get $__memory_base) "\00\00\00\00\00\00\00\00")
 (export "__wasm_call_ctors" (func $__wasm_call_ctors))
 (export "__wasm_apply_data_relocs" (func $__wasm_apply_data_relocs))
 (export "_start" (func $_start))
 (export "__THREW__" (global $global$0))
 (export "__threwValue" (global $global$1))
 (func $__wasm_call_ctors
 )
 (func $__wasm_apply_data_relocs
 )
 (func $_start
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
       (global.get $__THREW__)
      )
      (i32.const 0)
     )
     (call $invoke_vii
      (global.get $emscripten_longjmp)
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
      (global.get $__threwValue)
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
  (call $free
   (local.get $1)
  )
  (call $emscripten_longjmp
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
 ;; features section: mutable-globals
)

