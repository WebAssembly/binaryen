(module
 (type $FUNCSIG$id (func (param f64) (result i32)))
 (import "asm2wasm" "f64-to-int" (func $f64-to-int (param f64) (result i32)))
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (export "test_traps" (func $test_traps))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $test_traps (; 1 ;) (param $0 f32) (param $1 f64) (result i32)
  (call $i32u-div
   (call $f64-to-int
    (f64.promote/f32
     (get_local $0)
    )
   )
   (call $f64-to-int
    (get_local $1)
   )
  )
 )
 (func $i32u-div (; 2 ;) (param $0 i32) (param $1 i32) (result i32)
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
 (func $stackSave (; 3 ;) (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (; 4 ;) (param $0 i32) (result i32)
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
 (func $stackRestore (; 5 ;) (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [], "declares": ["f64-to-int"], "externs": [], "implementedFunctions": ["_test_traps","_stackSave","_stackAlloc","_stackRestore"], "exports": ["test_traps","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
