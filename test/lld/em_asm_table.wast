(module
 (type $0 (func (param i32 i32)))
 (type $1 (func (param i32 i32 i32) (result i32)))
 (import "env" "memory" (memory $2 8192))
 (import "env" "emscripten_log" (func $fimport$0 (param i32 i32)))
 (import "env" "emscripten_asm_const_int" (func $fimport$1 (param i32 i32 i32) (result i32)))
 (import "env" "__invoke_i32_i8*_i8*_..." (func $__invoke_i32_i8*_i8*_... (param i32 i32 i32 i32) (result i32)))
 (data (i32.const 1024) "{ console.log(\"hello world\"); }\00")
 (table $0 159609 funcref)
 (elem (i32.const 1) $fimport$0 $fimport$1)
 (global $global$0 (mut i32) (i32.const 1024))
 (global $global$1 i32 (i32.const 1048))
 (export "__data_end" (global $global$1))
 (export "main" (func $main))
 (func $main
  (drop
   (call $__invoke_i32_i8*_i8*_... (i32.const 2) (i32.const 1024) (i32.const 13) (i32.const 27))
  )
 )
)

