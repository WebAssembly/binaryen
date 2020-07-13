(module
 (type $i32_=>_none (func (param i32)))
 (type $i32_i32_=>_none (func (param i32 i32)))
 (type $none_=>_i32 (func (result i32)))
 (type $none_=>_none (func))
 (type $i32_i32_i32_=>_none (func (param i32 i32 i32)))
 (type $i32_=>_i32 (func (param i32) (result i32)))
 (type $i32_i32_=>_i32 (func (param i32 i32) (result i32)))
 (type $i32_i32_i32_=>_i32 (func (param i32 i32 i32) (result i32)))
 (type $i32_i32_i32_i32_=>_i32 (func (param i32 i32 i32 i32) (result i32)))
 (import "env" "malloc" (func $fimport$0 (param i32) (result i32)))
 (import "env" "saveSetjmp" (func $fimport$1 (param i32 i32 i32 i32) (result i32)))
 (import "env" "getTempRet0" (func $fimport$2 (result i32)))
 (import "env" "emscripten_longjmp_jmpbuf" (func $fimport$3 (param i32 i32)))
 (import "env" "__invoke_void_i32_i32" (func $fimport$4 (param i32 i32 i32)))
 (import "env" "testSetjmp" (func $fimport$5 (param i32 i32 i32) (result i32)))
 (import "env" "setTempRet0" (func $fimport$6 (param i32)))
 (import "env" "free" (func $fimport$7 (param i32)))
 (import "env" "emscripten_longjmp" (func $fimport$8 (param i32 i32)))
 (memory $0 2)
 (table $0 2 2 funcref)
 (elem (i32.const 1) $fimport$3)
 (global $global$0 (mut i32) (i32.const 66112))
 (global $global$1 i32 (i32.const 576))
 (export "memory" (memory $0))
 (export "__wasm_call_ctors" (func $0))
 (export "main" (func $2))
 (export "__data_end" (global $global$1))
 (func $0
 )
 (func $1 (result i32)
  (local $0 i32)
  (local $1 i32)
  (local $2 i32)
  (local $3 i32)
  (i32.store
   (local.tee $0
    (call $fimport$0
     (i32.const 40)
    )
   )
   (i32.const 0)
  )
  (local.set $1
   (call $fimport$1
    (local.get $0)
    (i32.const 1)
    (local.get $0)
    (i32.const 4)
   )
  )
  (local.set $2
   (call $fimport$2)
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
     (call $fimport$4
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
        (call $fimport$5
         (i32.load
          (local.get $0)
         )
         (local.get $1)
         (local.get $2)
        )
       )
      )
      (call $fimport$6
       (local.get $3)
      )
     )
     (local.set $0
      (call $fimport$2)
     )
     (br $label$3)
    )
   )
   (call $fimport$7
    (local.get $1)
   )
   (return
    (i32.const 0)
   )
  )
  (call $fimport$8
   (local.get $0)
   (local.get $3)
  )
  (unreachable)
 )
 (func $2 (param $0 i32) (param $1 i32) (result i32)
  (call $1)
 )
 ;; custom section "producers", size 112
)

