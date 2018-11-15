(module
 (type $0 (func (param i32 i32)))
 (type $1 (func (param i32 i32 i32) (result i32)))
 (import "env" "memory" (memory $2 8192))
 (import "env" "emscripten_log" (func $fimport$0 (param i32 i32)))
 (import "env" "emscripten_asm_const_int" (func $fimport$1 (param i32 i32 i32) (result i32)))
 (table $0 159609 anyfunc)
 (elem (i32.const 1) $fimport$0 $fimport$1)
 (global $global$0 (mut i32) (i32.const 1024))
 (global $global$1 i32 (i32.const 1048))
 (export "__data_end" (global $global$1))
)

