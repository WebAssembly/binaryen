(module
 (type $FUNCSIG$ddd (func (param f64 f64) (result f64)))
 (type $FUNCSIG$fff (func (param f32 f32) (result f32)))
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "fold_promote" (func $fold_promote))
 (export "fold_demote" (func $fold_demote))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $fold_promote (; 0 ;) (param $0 f64) (param $1 f32) (result f64)
  (f64.copysign
   (get_local $0)
   (f64.promote/f32
    (get_local $1)
   )
  )
 )
 (func $fold_demote (; 1 ;) (param $0 f32) (param $1 f64) (result f32)
  (f32.copysign
   (get_local $0)
   (f32.demote/f64
    (get_local $1)
   )
  )
 )
 (func $stackSave (; 2 ;) (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (; 3 ;) (param $0 i32) (result i32)
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
 (func $stackRestore (; 4 ;) (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [], "declares": [], "externs": [], "implementedFunctions": ["_fold_promote","_fold_demote","_stackSave","_stackAlloc","_stackRestore"], "exports": ["fold_promote","fold_demote","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
