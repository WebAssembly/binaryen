(module
 (type $0 (func))
 (type $1 (func (param i32)))
 (type $2 (func (param i32 i32) (result i32)))
 (type $3 (func (param f32 f32 i32) (result f32)))
 (type $4 (func (param f64 i32) (result f64)))
 (type $5 (func (param i32 i32 i32)))
 (type $6 (func (param i32) (result i32)))
 (import "env" "_Z4atoiPKc" (func $atoi\28char\20const*\29 (param i32) (result i32)))
 (memory $0 2)
 (table $0 3 3 funcref)
 (elem (i32.const 1) $address_taken_func\28int\2c\20int\2c\20int\29 $address_taken_func2\28int\2c\20int\2c\20int\29)
 (global $global$0 (mut i32) (i32.const 66112))
 (global $global$1 i32 (i32.const 568))
 (export "memory" (memory $0))
 (export "__wasm_call_ctors" (func $__wasm_call_ctors))
 (export "main" (func $main))
 (export "__data_end" (global $global$1))
 (func $__wasm_call_ctors (; 1 ;) (type $0)
 )
 (func $address_taken_func\28int\2c\20int\2c\20int\29 (; 2 ;) (type $5) (param $0 i32) (param $1 i32) (param $2 i32)
 )
 (func $address_taken_func2\28int\2c\20int\2c\20int\29 (; 3 ;) (type $5) (param $0 i32) (param $1 i32) (param $2 i32)
 )
 (func $main (; 4 ;) (type $2) (param $0 i32) (param $1 i32) (result i32)
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
  (call_indirect (type $0)
   (local.get $2)
  )
  (call_indirect (type $1)
   (i32.const 3)
   (local.get $3)
  )
  (drop
   (call_indirect (type $2)
    (i32.const 4)
    (i32.const 5)
    (local.get $4)
   )
  )
  (drop
   (call_indirect (type $3)
    (f32.const 3.0999999046325684)
    (f32.const 4.199999809265137)
    (i32.const 5)
    (local.get $5)
   )
  )
  (drop
   (call_indirect (type $4)
    (f64.const 4.2)
    (i32.const 5)
    (local.get $1)
   )
  )
  (call_indirect (type $5)
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
 ;; custom section "producers", size 112
)

