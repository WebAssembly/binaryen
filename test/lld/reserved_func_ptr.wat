(module $reserved_func_ptr.wasm
 (type $0 (func (param i32 i32 i32)))
 (type $1 (func))
 (type $2 (func (param i32 i32) (result i32)))
 (type $3 (func (param i32) (result i32)))
 (type $4 (func (param i32)))
 (type $5 (func (param f32 f32 i32) (result f32)))
 (type $6 (func (param f64 i32) (result f64)))
 (import "env" "_Z4atoiPKc" (func $atoi\28char\20const*\29 (param i32) (result i32)))
 (global $__stack_pointer (mut i32) (i32.const 66112))
 (memory $0 2)
 (table $0 3 3 funcref)
 (elem $0 (i32.const 1) $address_taken_func\28int\2c\20int\2c\20int\29 $address_taken_func2\28int\2c\20int\2c\20int\29)
 (export "memory" (memory $0))
 (export "__wasm_call_ctors" (func $__wasm_call_ctors))
 (export "__main_argc_argv" (func $main))
 (func $__wasm_call_ctors
 )
 (func $address_taken_func\28int\2c\20int\2c\20int\29 (param $0 i32) (param $1 i32) (param $2 i32)
 )
 (func $address_taken_func2\28int\2c\20int\2c\20int\29 (param $0 i32) (param $1 i32) (param $2 i32)
 )
 (func $main (param $0 i32) (param $1 i32) (result i32)
  (local $2 i32)
  (local $3 i32)
  (local $4 i32)
  (local $5 i32)
  (local.set $2
   (call $atoi\28char\20const*\29
    (i32.load offset=4
     (local.get $1)
    )
   )
  )
  (local.set $3
   (call $atoi\28char\20const*\29
    (i32.load offset=8
     (local.get $1)
    )
   )
  )
  (local.set $4
   (call $atoi\28char\20const*\29
    (i32.load offset=12
     (local.get $1)
    )
   )
  )
  (local.set $5
   (call $atoi\28char\20const*\29
    (i32.load offset=16
     (local.get $1)
    )
   )
  )
  (local.set $1
   (call $atoi\28char\20const*\29
    (i32.load offset=20
     (local.get $1)
    )
   )
  )
  (call_indirect $0 (type $1)
   (local.get $2)
  )
  (call_indirect $0 (type $4)
   (i32.const 3)
   (local.get $3)
  )
  (drop
   (call_indirect $0 (type $2)
    (i32.const 4)
    (i32.const 5)
    (local.get $4)
   )
  )
  (drop
   (call_indirect $0 (type $5)
    (f32.const 3.0999999046325684)
    (f32.const 4.199999809265137)
    (i32.const 5)
    (local.get $5)
   )
  )
  (drop
   (call_indirect $0 (type $6)
    (f64.const 4.2)
    (i32.const 5)
    (local.get $1)
   )
  )
  (call_indirect $0 (type $0)
   (i32.const 1)
   (i32.const 2)
   (i32.const 3)
   (select
    (i32.const 1)
    (i32.const 2)
    (i32.gt_s
     (local.get $0)
     (i32.const 3)
    )
   )
  )
  (i32.const 0)
 )
 ;; custom section "producers", size 115
 ;; features section: mutable-globals, nontrapping-float-to-int, bulk-memory, sign-ext, reference-types, multivalue, bulk-memory-opt, call-indirect-overlong
)

