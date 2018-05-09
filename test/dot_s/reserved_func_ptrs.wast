(module
 (type $FUNCSIG$v (func))
 (type $FUNCSIG$vi (func (param i32)))
 (type $FUNCSIG$iii (func (param i32 i32) (result i32)))
 (type $FUNCSIG$fffi (func (param f32 f32 i32) (result f32)))
 (type $FUNCSIG$ddi (func (param f64 i32) (result f64)))
 (type $FUNCSIG$viii (func (param i32 i32 i32)))
 (type $FUNCSIG$ii (func (param i32) (result i32)))
 (import "env" "atoi" (func $atoi (param i32) (result i32)))
 (import "env" "memory" (memory $0 1))
 (table 3 3 anyfunc)
 (elem (i32.const 0) $__wasm_nullptr $_Z18address_taken_funciii $_Z19address_taken_func2iii)
 (export "main" (func $main))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (export "dynCall_viii" (func $dynCall_viii))
 (func $_Z18address_taken_funciii (; 1 ;) (type $FUNCSIG$viii) (param $0 i32) (param $1 i32) (param $2 i32)
 )
 (func $_Z19address_taken_func2iii (; 2 ;) (type $FUNCSIG$viii) (param $0 i32) (param $1 i32) (param $2 i32)
 )
 (func $main (; 3 ;) (param $0 i32) (param $1 i32) (result i32)
  (local $2 i32)
  (local $3 i32)
  (local $4 i32)
  (local $5 i32)
  (set_local $2
   (call $atoi
    (i32.load offset=4
     (get_local $1)
    )
   )
  )
  (set_local $3
   (call $atoi
    (i32.load offset=8
     (get_local $1)
    )
   )
  )
  (set_local $4
   (call $atoi
    (i32.load offset=12
     (get_local $1)
    )
   )
  )
  (set_local $5
   (call $atoi
    (i32.load offset=16
     (get_local $1)
    )
   )
  )
  (set_local $1
   (call $atoi
    (i32.load offset=20
     (get_local $1)
    )
   )
  )
  (call_indirect (type $FUNCSIG$v)
   (get_local $2)
  )
  (call_indirect (type $FUNCSIG$vi)
   (i32.const 3)
   (get_local $3)
  )
  (drop
   (call_indirect (type $FUNCSIG$iii)
    (i32.const 4)
    (i32.const 5)
    (get_local $4)
   )
  )
  (drop
   (call_indirect (type $FUNCSIG$fffi)
    (f32.const 3.0999999046325684)
    (f32.const 4.199999809265137)
    (i32.const 5)
    (get_local $5)
   )
  )
  (drop
   (call_indirect (type $FUNCSIG$ddi)
    (f64.const 4.2)
    (i32.const 5)
    (get_local $1)
   )
  )
  (call_indirect (type $FUNCSIG$viii)
   (i32.const 1)
   (i32.const 2)
   (i32.const 3)
   (select
    (i32.const 1)
    (i32.const 2)
    (i32.gt_s
     (get_local $0)
     (i32.const 3)
    )
   )
  )
  (i32.const 0)
 )
 (func $__wasm_nullptr (; 4 ;) (type $FUNCSIG$v)
  (unreachable)
 )
 (func $stackSave (; 5 ;) (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (; 6 ;) (param $0 i32) (result i32)
  (local $1 i32)
  (i32.store offset=4
   (i32.const 0)
   (tee_local $1
    (i32.and
     (i32.sub
      (i32.load offset=4
       (i32.const 0)
      )
      (get_local $0)
     )
     (i32.const -16)
    )
   )
  )
  (get_local $1)
 )
 (func $stackRestore (; 7 ;) (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
 (func $dynCall_viii (; 8 ;) (param $fptr i32) (param $0 i32) (param $1 i32) (param $2 i32)
  (call_indirect (type $FUNCSIG$viii)
   (get_local $0)
   (get_local $1)
   (get_local $2)
   (get_local $fptr)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [], "declares": ["atoi"], "externs": [], "implementedFunctions": ["_main","_stackSave","_stackAlloc","_stackRestore","_dynCall_viii"], "exports": ["main","stackSave","stackAlloc","stackRestore","dynCall_viii"], "invokeFuncs": [] }
