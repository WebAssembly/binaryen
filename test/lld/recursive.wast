(module
 (type $0 (func (param i32 i32) (result i32)))
 (type $1 (func (result i32)))
 (type $2 (func))
 (import "env" "printf" (func $printf (param i32 i32) (result i32)))
 (global $global$0 (mut i32) (i32.const 66128))
 (global $global$1 i32 (i32.const 66128))
 (global $global$2 i32 (i32.const 587))
 (table 1 1 funcref)
 (memory $0 2)
 (data (i32.const 568) "%d:%d\n\00Result: %d\n\00")
 (export "memory" (memory $0))
 (export "__wasm_call_ctors" (func $__wasm_call_ctors))
 (export "main" (func $main))
 (export "__heap_base" (global $global$1))
 (export "__data_end" (global $global$2))
 (func $foo (; 1 ;) (type $0) (param $var$0 i32) (param $var$1 i32) (result i32)
  (local $var$2 i32)
  (global.set $global$0
   (local.tee $var$2
    (i32.sub
     (global.get $global$0)
     (i32.const 16)
    )
   )
  )
  (i32.store offset=4
   (local.get $var$2)
   (local.get $var$1)
  )
  (i32.store
   (local.get $var$2)
   (local.get $var$0)
  )
  (drop
   (call $printf
    (i32.const 568)
    (local.get $var$2)
   )
  )
  (global.set $global$0
   (i32.add
    (local.get $var$2)
    (i32.const 16)
   )
  )
  (i32.add
   (local.get $var$1)
   (local.get $var$0)
  )
 )
 (func $main (; 2 ;) (type $1) (result i32)
  (local $var$0 i32)
  (global.set $global$0
   (local.tee $var$0
    (i32.sub
     (global.get $global$0)
     (i32.const 16)
    )
   )
  )
  (i32.store
   (local.get $var$0)
   (call $foo
    (i32.const 1)
    (i32.const 2)
   )
  )
  (drop
   (call $printf
    (i32.const 575)
    (local.get $var$0)
   )
  )
  (global.set $global$0
   (i32.add
    (local.get $var$0)
    (i32.const 16)
   )
  )
  (i32.const 0)
 )
 (func $__wasm_call_ctors (; 3 ;) (type $2)
 )
 ;; custom section "linking", size 3
)

