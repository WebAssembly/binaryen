(module
 (type $none_=>_none (func))
 (type $i32_=>_none (func (param i32)))
 (type $i32_=>_i32 (func (param i32) (result i32)))
 (memory $0 2)
 (table $0 1 1 funcref)
 (global $global$0 (mut i32) (i32.const 66112))
 (export "memory" (memory $0))
 (export "__wasm_call_ctors" (func $__wasm_call_ctors))
 (export "stackRestore" (func $stackRestore))
 (export "stackAlloc" (func $stackAlloc))
 (export "main" (func $main))
 (func $__wasm_call_ctors
 )
 (func $stackRestore (param $0 i32)
  (global.set $global$0
   (local.get $0)
  )
 )
 (func $stackAlloc (param $0 i32) (result i32)
  (local $1 i32)
  (local $2 i32)
  (global.set $global$0
   (local.tee $1
    (i32.and
     (i32.sub
      (global.get $global$0)
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

