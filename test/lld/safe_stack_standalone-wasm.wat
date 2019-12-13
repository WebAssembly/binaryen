(module
 (type $0 (func (param i32 i32) (result i32)))
 (type $1 (func))
 (type $2 (func (result i32)))
 (import "env" "printf" (func $printf (param i32 i32) (result i32)))
 (memory $0 2)
 (data (i32.const 568) "%d:%d\n\00Result: %d\n\00")
 (table $0 1 1 funcref)
 (global $global$0 (mut i32) (i32.const 66128))
 (global $global$1 i32 (i32.const 66128))
 (global $global$2 i32 (i32.const 587))
 (export "memory" (memory $0))
 (export "__wasm_call_ctors" (func $__wasm_call_ctors))
 (export "__heap_base" (global $global$1))
 (export "__data_end" (global $global$2))
 (export "main" (func $main))
 (func $__wasm_call_ctors (; 1 ;) (type $1)
 )
 (func $foo (; 2 ;) (type $0) (param $0 i32) (param $1 i32) (result i32)
  (local $2 i32)
  (global.set $global$0
   (local.tee $2
    (i32.sub
     (global.get $global$0)
     (i32.const 16)
    )
   )
  )
  (i32.store offset=4
   (local.get $2)
   (local.get $1)
  )
  (i32.store
   (local.get $2)
   (local.get $0)
  )
  (drop
   (call $printf
    (i32.const 568)
    (local.get $2)
   )
  )
  (global.set $global$0
   (i32.add
    (local.get $2)
    (i32.const 16)
   )
  )
  (i32.add
   (local.get $1)
   (local.get $0)
  )
 )
 (func $__original_main (; 3 ;) (type $2) (result i32)
  (local $0 i32)
  (global.set $global$0
   (local.tee $0
    (i32.sub
     (global.get $global$0)
     (i32.const 16)
    )
   )
  )
  (i32.store
   (local.get $0)
   (call $foo
    (i32.const 1)
    (i32.const 2)
   )
  )
  (drop
   (call $printf
    (i32.const 575)
    (local.get $0)
   )
  )
  (global.set $global$0
   (i32.add
    (local.get $0)
    (i32.const 16)
   )
  )
  (i32.const 0)
 )
 (func $main (; 4 ;) (type $0) (param $0 i32) (param $1 i32) (result i32)
  (call $__original_main)
 )
)

