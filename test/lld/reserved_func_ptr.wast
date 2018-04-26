(module
 (type $0 (func))
 (type $1 (func (param i32)))
 (type $2 (func (param i32 i32) (result i32)))
 (type $3 (func (param f32 f32 i32) (result f32)))
 (type $4 (func (param f64 i32) (result f64)))
 (type $5 (func (param i32 i32 i32)))
 (type $6 (func (param i32) (result i32)))
 (import "env" "_Z4atoiPKc" (func $_Z4atoiPKc (param i32) (result i32)))
 (global $global$0 (mut i32) (i32.const 66112))
 (global $global$1 i32 (i32.const 66112))
 (global $global$2 i32 (i32.const 568))
 (table 3 3 anyfunc)
 (elem (i32.const 1) $_Z18address_taken_funciii $_Z19address_taken_func2iii)
 (memory $0 2)
 (export "memory" (memory $0))
 (export "__wasm_call_ctors" (func $__wasm_call_ctors))
 (export "main" (func $main))
 (export "__heap_base" (global $global$1))
 (export "__data_end" (global $global$2))
 (func $_Z18address_taken_funciii (; 1 ;) (type $5) (param $var$0 i32) (param $var$1 i32) (param $var$2 i32)
 )
 (func $_Z19address_taken_func2iii (; 2 ;) (type $5) (param $var$0 i32) (param $var$1 i32) (param $var$2 i32)
 )
 (func $main (; 3 ;) (type $2) (param $var$0 i32) (param $var$1 i32) (result i32)
  (local $var$2 i32)
  (local $var$3 i32)
  (local $var$4 i32)
  (local $var$5 i32)
  (set_local $var$2
   (call $_Z4atoiPKc
    (i32.load offset=4
     (get_local $var$1)
    )
   )
  )
  (set_local $var$3
   (call $_Z4atoiPKc
    (i32.load offset=8
     (get_local $var$1)
    )
   )
  )
  (set_local $var$4
   (call $_Z4atoiPKc
    (i32.load offset=12
     (get_local $var$1)
    )
   )
  )
  (set_local $var$5
   (call $_Z4atoiPKc
    (i32.load offset=16
     (get_local $var$1)
    )
   )
  )
  (set_local $var$1
   (call $_Z4atoiPKc
    (i32.load offset=20
     (get_local $var$1)
    )
   )
  )
  (call_indirect (type $0)
   (get_local $var$2)
  )
  (call_indirect (type $1)
   (i32.const 3)
   (get_local $var$3)
  )
  (drop
   (call_indirect (type $2)
    (i32.const 4)
    (i32.const 5)
    (get_local $var$4)
   )
  )
  (drop
   (call_indirect (type $3)
    (f32.const 3.0999999046325684)
    (f32.const 4.199999809265137)
    (i32.const 5)
    (get_local $var$5)
   )
  )
  (drop
   (call_indirect (type $4)
    (f64.const 4.2)
    (i32.const 5)
    (get_local $var$1)
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
     (get_local $var$0)
     (i32.const 3)
    )
   )
  )
  (i32.const 0)
 )
 (func $__wasm_call_ctors (; 4 ;) (type $0)
 )
 ;; custom section "linking", size 3
)

