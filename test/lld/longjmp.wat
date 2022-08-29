(module
 (type $none_=>_i32 (func (result i32)))
 (type $i32_=>_none (func (param i32)))
 (type $i32_=>_i32 (func (param i32) (result i32)))
 (type $i32_i32_i32_i32_=>_i32 (func (param i32 i32 i32 i32) (result i32)))
 (type $i32_i32_=>_none (func (param i32 i32)))
 (type $i32_i32_i32_=>_none (func (param i32 i32 i32)))
 (type $i32_i32_i32_=>_i32 (func (param i32 i32 i32) (result i32)))
 (type $none_=>_none (func))
 (type $i32_i32_=>_i32 (func (param i32 i32) (result i32)))
 (import "env" "malloc" (func $malloc (param i32) (result i32)))
 (import "env" "saveSetjmp" (func $saveSetjmp (param i32 i32 i32 i32) (result i32)))
 (import "env" "getTempRet0" (func $getTempRet0 (result i32)))
 (import "env" "emscripten_longjmp" (func $emscripten_longjmp (param i32 i32)))
 (import "env" "invoke_vii" (func $invoke_vii (param i32 i32 i32)))
 (import "env" "testSetjmp" (func $testSetjmp (param i32 i32 i32) (result i32)))
 (import "env" "setTempRet0" (func $setTempRet0 (param i32)))
 (import "env" "free" (func $free (param i32)))
 (global $__stack_pointer (mut i32) (i32.const 66112))
 (memory $0 2)
 (table $0 2 2 funcref)
 (elem (i32.const 1) $emscripten_longjmp)
 (export "memory" (memory $0))
 (export "__wasm_call_ctors" (func $__wasm_call_ctors))
 (export "main" (func $main))
 (func $__wasm_call_ctors
 )
 (func $__original_main (result i32)
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
     (i32.store offset=568
      (i32.const 0)
      (i32.const 0)
     )
     (call $invoke_vii
      (i32.const 1)
      (local.get $0)
      (i32.const 1)
     )
     (local.set $0
      (i32.load offset=568
       (i32.const 0)
      )
     )
     (i32.store offset=568
      (i32.const 0)
      (i32.const 0)
     )
     (block $label$4
      (br_if $label$4
       (i32.eqz
        (local.get $0)
       )
      )
      (br_if $label$4
       (i32.eqz
        (local.tee $3
         (i32.load offset=572
          (i32.const 0)
         )
        )
       )
      )
      (br_if $label$1
       (i32.eqz
        (call $testSetjmp
         (i32.load
          (local.get $0)
         )
         (local.get $1)
         (local.get $2)
        )
       )
      )
      (call $setTempRet0
       (local.get $3)
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
   (return
    (i32.const 0)
   )
  )
  (call $free
   (local.get $1)
  )
  (call $emscripten_longjmp
   (local.get $0)
   (local.get $3)
  )
  (unreachable)
 )
 (func $main (param $0 i32) (param $1 i32) (result i32)
  (call $__original_main)
 )
 ;; custom section "producers", size 112
)

