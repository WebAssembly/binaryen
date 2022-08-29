(module
 (type $none_=>_none (func))
 (type $i32_i32_i32_=>_i32 (func (param i32 i32 i32) (result i32)))
 (type $none_=>_i32 (func (result i32)))
 (type $i32_i32_=>_i32 (func (param i32 i32) (result i32)))
 (import "env" "memory" (memory $mimport$0 1))
 (import "env" "__indirect_function_table" (table $timport$0 0 funcref))
 (import "env" "__stack_pointer" (global $__stack_pointer (mut i32)))
 (import "env" "__memory_base" (global $__memory_base i32))
 (import "env" "__table_base" (global $__table_base i32))
 (import "GOT.mem" "_ZN20__em_asm_sig_builderI19__em_asm_type_tupleIJEEE6bufferE" (global $__em_asm_sig_builder<__em_asm_type_tuple<>>::buffer (mut i32)))
 (import "GOT.mem" "_ZN20__em_asm_sig_builderI19__em_asm_type_tupleIJiiEEE6bufferE" (global $__em_asm_sig_builder<__em_asm_type_tuple<int\2c\20int>>::buffer (mut i32)))
 (import "GOT.mem" "_ZN20__em_asm_sig_builderI19__em_asm_type_tupleIJiEEE6bufferE" (global $__em_asm_sig_builder<__em_asm_type_tuple<int>>::buffer (mut i32)))
 (import "env" "emscripten_asm_const_int" (func $emscripten_asm_const_int (param i32 i32 i32) (result i32)))
 (global $global$0 i32 (i32.const 0))
 (global $global$1 i32 (i32.const 1))
 (global $global$2 i32 (i32.const 4))
 (global $global$3 i32 (i32.const 6))
 (global $global$4 i32 (i32.const 90))
 (data $.data (global.get $__memory_base) "\00ii\00i\00{ Module.print(\"Hello world\"); }\00{ return $0 + $1; }\00{ Module.print(\"Got \" + $0); }\00")
 (export "__wasm_call_ctors" (func $__wasm_call_ctors))
 (export "__wasm_apply_data_relocs" (func $__wasm_apply_data_relocs))
 (export "__original_main" (func $__original_main))
 (export "_ZN20__em_asm_sig_builderI19__em_asm_type_tupleIJEEE6bufferE" (global $global$0))
 (export "_ZN20__em_asm_sig_builderI19__em_asm_type_tupleIJiiEEE6bufferE" (global $global$1))
 (export "_ZN20__em_asm_sig_builderI19__em_asm_type_tupleIJiEEE6bufferE" (global $global$2))
 (export "main" (func $main))
 (export "__start_em_asm" (global $global$3))
 (export "__stop_em_asm" (global $global$4))
 (func $__wasm_call_ctors
 )
 (func $__wasm_apply_data_relocs
 )
 (func $__original_main (result i32)
  (local $0 i32)
  (local $1 i32)
  (global.set $__stack_pointer
   (local.tee $0
    (i32.sub
     (global.get $__stack_pointer)
     (i32.const 32)
    )
   )
  )
  (drop
   (call $emscripten_asm_const_int
    (i32.add
     (local.tee $1
      (global.get $__memory_base)
     )
     (i32.const 6)
    )
    (global.get $__em_asm_sig_builder<__em_asm_type_tuple<>>::buffer)
    (i32.const 0)
   )
  )
  (i64.store offset=16
   (local.get $0)
   (i64.const 115964117005)
  )
  (i32.store
   (local.get $0)
   (call $emscripten_asm_const_int
    (i32.add
     (local.get $1)
     (i32.const 39)
    )
    (global.get $__em_asm_sig_builder<__em_asm_type_tuple<int\2c\20int>>::buffer)
    (i32.add
     (local.get $0)
     (i32.const 16)
    )
   )
  )
  (drop
   (call $emscripten_asm_const_int
    (i32.add
     (local.get $1)
     (i32.const 59)
    )
    (global.get $__em_asm_sig_builder<__em_asm_type_tuple<int>>::buffer)
    (local.get $0)
   )
  )
  (global.set $__stack_pointer
   (i32.add
    (local.get $0)
    (i32.const 32)
   )
  )
  (i32.const 0)
 )
 (func $main (param $0 i32) (param $1 i32) (result i32)
  (call $__original_main)
 )
 ;; dylink section
 ;;   memorysize: 90
 ;;   memoryalignment: 0
 ;;   tablesize: 0
 ;;   tablealignment: 0
 ;; custom section "producers", size 112
 ;; features section: mutable-globals
)

