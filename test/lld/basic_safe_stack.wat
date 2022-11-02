(module
 (type $none_=>_none (func))
 (type $i32_=>_none (func (param i32)))
 (type $i32_=>_i32 (func (param i32) (result i32)))
 (global $__stack_pointer (mut i32) (i32.const 66112))
 (memory $0 2)
 (export "memory" (memory $0))
 (export "__wasm_call_ctors" (func $__wasm_call_ctors))
 (export "stackRestore" (func $stackRestore))
 (export "stackAlloc" (func $stackAlloc))
 (export "main" (func $main))
 (func $__wasm_call_ctors
 )
 (func $stackRestore (param $0 i32)
  (global.set $__stack_pointer
   (local.get $0)
  )
 )
 (func $stackAlloc (param $0 i32) (result i32)
  (local $1 i32)
  (local $2 i32)
  (global.set $__stack_pointer
   (local.tee $1
    (i32.and
     (i32.sub
      (global.get $__stack_pointer)
      (local.get $0)
     )
     (i32.const -16)
    )
   )
  )
  (local.get $1)
 )
 (func $main
 )
)

