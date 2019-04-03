(module
 (import "env" "memory" (memory $0 1))
 (table 0 funcref)
 (data (i32.const 4) "\10\04\00\00")
 (export "test0" (func $test0))
 (export "test1" (func $test1))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $test0 (; 0 ;) (param $0 i32) (result i32)
  (block $label$0
   (br_if $label$0
    (i32.gt_s
     (local.get $0)
     (i32.const -1)
    )
   )
   (local.set $0
    (i32.div_s
     (local.get $0)
     (i32.const 3)
    )
   )
  )
  (return
   (local.get $0)
  )
 )
 (func $test1 (; 1 ;) (param $0 i32) (result i32)
  (local $1 i32)
  (local $2 i32)
  (local $3 i32)
  (local $4 i32)
  (local.set $2
   (i32.const 0)
  )
  (local.set $3
   (i32.const 1)
  )
  (local.set $4
   (i32.const 0)
  )
  (loop $label$0
   (local.set $1
    (local.get $2)
   )
   (local.set $2
    (local.get $3)
   )
   (local.set $3
    (local.get $1)
   )
   (br_if $label$0
    (i32.lt_s
     (local.tee $4
      (i32.add
       (local.get $4)
       (i32.const 1)
      )
     )
     (local.get $0)
    )
   )
  )
  (return
   (local.get $1)
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
   (local.tee $1
    (i32.and
     (i32.sub
      (i32.load offset=4
       (i32.const 0)
      )
      (local.get $0)
     )
     (i32.const -16)
    )
   )
  )
  (local.get $1)
 )
 (func $stackRestore (; 4 ;) (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (local.get $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [], "declares": [], "externs": [], "implementedFunctions": ["_test0","_test1","_stackSave","_stackAlloc","_stackRestore"], "exports": ["test0","test1","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
