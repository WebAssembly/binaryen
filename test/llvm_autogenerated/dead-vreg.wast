(module
 (import "env" "memory" (memory $0 1))
 (table 0 funcref)
 (data (i32.const 4) "\10\04\00\00")
 (export "foo" (func $foo))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $foo (; 0 ;) (param $0 i32) (param $1 i32) (param $2 i32)
  (local $3 i32)
  (local $4 i32)
  (local $5 i32)
  (local $6 i32)
  (local $7 i32)
  (local $8 i32)
  (block $label$0
   (br_if $label$0
    (i32.lt_s
     (local.get $2)
     (i32.const 1)
    )
   )
   (local.set $3
    (i32.shl
     (local.get $1)
     (i32.const 2)
    )
   )
   (local.set $5
    (i32.const 0)
   )
   (local.set $4
    (i32.lt_s
     (local.get $1)
     (i32.const 1)
    )
   )
   (loop $label$1
    (block $label$2
     (br_if $label$2
      (local.get $4)
     )
     (local.set $6
      (i32.const 0)
     )
     (local.set $7
      (local.get $0)
     )
     (local.set $8
      (local.get $1)
     )
     (loop $label$3
      (i32.store
       (local.get $7)
       (local.get $6)
      )
      (local.set $6
       (i32.add
        (local.get $6)
        (local.get $5)
       )
      )
      (local.set $7
       (i32.add
        (local.get $7)
        (i32.const 4)
       )
      )
      (br_if $label$3
       (local.tee $8
        (i32.add
         (local.get $8)
         (i32.const -1)
        )
       )
      )
     )
    )
    (local.set $0
     (i32.add
      (local.get $0)
      (local.get $3)
     )
    )
    (br_if $label$1
     (i32.ne
      (local.tee $5
       (i32.add
        (local.get $5)
        (i32.const 1)
       )
      )
      (local.get $2)
     )
    )
   )
  )
 )
 (func $stackSave (; 1 ;) (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (; 2 ;) (param $0 i32) (result i32)
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
 (func $stackRestore (; 3 ;) (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (local.get $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [], "declares": [], "externs": [], "implementedFunctions": ["_foo","_stackSave","_stackAlloc","_stackRestore"], "exports": ["foo","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
