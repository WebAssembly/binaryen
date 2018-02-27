(module
 (type $FUNCSIG$ddd (func (param f64 f64) (result f64)))
 (type $FUNCSIG$fff (func (param f32 f32) (result f32)))
 (import "env" "fmod" (func $fmod (param f64 f64) (result f64)))
 (import "env" "fmodf" (func $fmodf (param f32 f32) (result f32)))
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "frem32" (func $frem32))
 (export "frem64" (func $frem64))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $frem32 (; 2 ;) (param $0 f32) (param $1 f32) (result f32)
  (return
   (call $fmodf
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $frem64 (; 3 ;) (param $0 f64) (param $1 f64) (result f64)
  (return
   (call $fmod
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
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [], "declares": ["fmod","fmodf"], "externs": [], "implementedFunctions": ["_frem32","_frem64","_stackSave","_stackAlloc","_stackRestore"], "exports": ["frem32","frem64","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
