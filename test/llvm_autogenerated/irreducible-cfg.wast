(module
 (import "env" "memory" (memory $0 1))
 (table 0 funcref)
 (data (i32.const 4) "\10\04\00\00")
 (export "test0" (func $test0))
 (export "test1" (func $test1))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $test0 (; 0 ;) (param $0 i32) (param $1 i32) (param $2 i32) (param $3 i32)
  (local $4 f64)
  (local $5 i32)
  (block $label$0
   (block $label$1
    (br_if $label$1
     (local.get $2)
    )
    (local.set $2
     (i32.const 0)
    )
    (local.set $5
     (i32.const 1)
    )
    (br $label$0)
   )
   (local.set $4
    (f64.load align=4
     (i32.add
      (local.get $0)
      (i32.shl
       (local.get $3)
       (i32.const 3)
      )
     )
    )
   )
   (local.set $5
    (i32.const 0)
   )
  )
  (loop $label$2
   (block $label$3
    (block $label$4
     (block $label$5
      (block $label$6
       (block $label$7
        (block $label$8
         (br_table $label$6 $label$8 $label$5 $label$7 $label$7
          (local.get $5)
         )
        )
        (br_if $label$3
         (i32.ge_s
          (local.get $2)
          (local.get $1)
         )
        )
        (local.set $5
         (i32.const 3)
        )
        (br $label$2)
       )
       (f64.store align=4
        (local.tee $3
         (i32.add
          (local.get $0)
          (i32.shl
           (local.get $2)
           (i32.const 3)
          )
         )
        )
        (local.tee $4
         (f64.mul
          (f64.load align=4
           (local.get $3)
          )
          (f64.const 2.3)
         )
        )
       )
       (local.set $5
        (i32.const 0)
       )
       (br $label$2)
      )
      (f64.store align=4
       (i32.add
        (local.get $0)
        (i32.shl
         (local.get $2)
         (i32.const 3)
        )
       )
       (f64.add
        (local.get $4)
        (f64.const 1.3)
       )
      )
      (local.set $2
       (i32.add
        (local.get $2)
        (i32.const 1)
       )
      )
      (br $label$4)
     )
     (return)
    )
    (local.set $5
     (i32.const 1)
    )
    (br $label$2)
   )
   (local.set $5
    (i32.const 2)
   )
   (br $label$2)
  )
 )
 (func $test1 (; 1 ;) (param $0 i32) (param $1 i32) (param $2 i32) (param $3 i32)
  (local $4 f64)
  (local $5 i32)
  (block $label$0
   (block $label$1
    (br_if $label$1
     (local.get $2)
    )
    (local.set $3
     (i32.const 0)
    )
    (local.set $5
     (i32.const 1)
    )
    (br $label$0)
   )
   (local.set $4
    (f64.load align=4
     (i32.add
      (local.get $0)
      (i32.shl
       (local.get $3)
       (i32.const 3)
      )
     )
    )
   )
   (local.set $5
    (i32.const 0)
   )
  )
  (loop $label$2
   (block $label$3
    (block $label$4
     (block $label$5
      (block $label$6
       (block $label$7
        (block $label$8
         (block $label$9
          (block $label$10
           (br_table $label$7 $label$10 $label$6 $label$9 $label$8 $label$8
            (local.get $5)
           )
          )
          (br_if $label$3
           (i32.ge_s
            (local.get $3)
            (local.get $1)
           )
          )
          (local.set $5
           (i32.const 3)
          )
          (br $label$2)
         )
         (f64.store align=4
          (local.tee $2
           (i32.add
            (local.get $0)
            (i32.shl
             (local.get $3)
             (i32.const 3)
            )
           )
          )
          (local.tee $4
           (f64.mul
            (f64.load align=4
             (local.get $2)
            )
            (f64.const 2.3)
           )
          )
         )
         (local.set $2
          (i32.const 0)
         )
         (local.set $5
          (i32.const 4)
         )
         (br $label$2)
        )
        (br_if $label$4
         (i32.lt_s
          (local.tee $2
           (i32.add
            (local.get $2)
            (i32.const 1)
           )
          )
          (i32.const 256)
         )
        )
        (local.set $5
         (i32.const 0)
        )
        (br $label$2)
       )
       (f64.store align=4
        (i32.add
         (local.get $0)
         (i32.shl
          (local.get $3)
          (i32.const 3)
         )
        )
        (f64.add
         (local.get $4)
         (f64.const 1.3)
        )
       )
       (local.set $3
        (i32.add
         (local.get $3)
         (i32.const 1)
        )
       )
       (br $label$5)
      )
      (return)
     )
     (local.set $5
      (i32.const 1)
     )
     (br $label$2)
    )
    (local.set $5
     (i32.const 4)
    )
    (br $label$2)
   )
   (local.set $5
    (i32.const 2)
   )
   (br $label$2)
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
