(module
 (type $0 (func (param i32 i32 i32) (result i32)))
 (type $1 (func))
 (type $2 (func (result i32)))
 (type $3 (func (param i32 i32) (result i32)))
 (import "env" "memory" (memory $0 0))
 (data (global.get $gimport$3) "")
 (import "env" "__indirect_function_table" (table $timport$1 0 funcref))
 (import "env" "__stack_pointer" (global $gimport$2 (mut i32)))
 (import "env" "__memory_base" (global $gimport$3 i32))
 (import "env" "__table_base" (global $gimport$4 i32))
 (import "GOT.mem" "_ZN20__tester_sig_builderI19__tester_type_tupleIJEEE6bufferE" (global $gimport$6 (mut i32)))
 (import "GOT.mem" "_ZN20__tester_sig_builderI19__tester_type_tupleIJiiEEE6bufferE" (global $gimport$7 (mut i32)))
 (import "GOT.mem" "_ZN20__tester_sig_builderI19__tester_type_tupleIJiEEE6bufferE" (global $gimport$8 (mut i32)))
 (import "env" "emscripten_asm_const_int" (func $emscripten_asm_const_int (param i32 i32 i32) (result i32)))
 (global $global$1 i32 (i32.const 54))
 (global $global$2 i32 (i32.const 0))
 (export "__wasm_call_ctors" (func $__wasm_call_ctors))
 (export "__original_main" (func $__original_main))
 (export "_ZN20__tester_sig_builderI19__tester_type_tupleIJiiEEE6bufferE" (global $global$1))
 (export "main" (func $main))
 (export "__data_end" (global $global$2))
 (func $__wasm_call_ctors (; 1 ;) (type $1)
  (call $__wasm_apply_relocs)
 )
 (func $__wasm_apply_relocs (; 2 ;) (type $1)
 )
 (func $__original_main (; 3 ;) (type $2) (result i32)
  (i32.const 0)
 )
 (func $main (; 4 ;) (type $3) (param $0 i32) (param $1 i32) (result i32)
  (call $__original_main)
 )
 ;; custom section "dylink", size 5
 ;; custom section "producers", size 112
)

