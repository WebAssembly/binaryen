(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (export "test_traps" (func $test_traps))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $test_traps (; 0 ;) (param $0 f32) (param $1 f64) (result i32)
  (call $i32u-div
   (call $f32-to-int
    (get_local $0)
   )
   (call $f64-to-uint
    (get_local $1)
   )
  )
 )
 (func $f32-to-int (; 1 ;) (param $0 f32) (result i32)
  (if (result i32)
   (f32.ne
    (get_local $0)
    (get_local $0)
   )
   (i32.const -2147483648)
   (if (result i32)
    (f32.ge
     (get_local $0)
     (f32.const 2147483648)
    )
    (i32.const -2147483648)
    (if (result i32)
     (f32.le
      (get_local $0)
      (f32.const -2147483648)
     )
     (i32.const -2147483648)
     (i32.trunc_s/f32
      (get_local $0)
     )
    )
   )
  )
 )
 (func $f64-to-uint (; 2 ;) (param $0 f64) (result i32)
  (if (result i32)
   (f64.ne
    (get_local $0)
    (get_local $0)
   )
   (i32.const 0)
   (if (result i32)
    (f64.ge
     (get_local $0)
     (f64.const 4294967296)
    )
    (i32.const 0)
    (if (result i32)
     (f64.le
      (get_local $0)
      (f64.const -1)
     )
     (i32.const 0)
     (i32.trunc_u/f64
      (get_local $0)
     )
    )
   )
  )
 )
 (func $i32u-div (; 3 ;) (param $0 i32) (param $1 i32) (result i32)
  (if (result i32)
   (i32.eqz
    (get_local $1)
   )
   (i32.const 0)
   (i32.div_u
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $stackSave (; 4 ;) (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (; 5 ;) (param $0 i32) (result i32)
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
 (func $stackRestore (; 6 ;) (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [], "declares": [], "externs": [], "implementedFunctions": ["_test_traps","_stackSave","_stackAlloc","_stackRestore"], "exports": ["test_traps","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
