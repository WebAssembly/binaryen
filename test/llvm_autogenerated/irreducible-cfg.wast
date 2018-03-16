(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
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
     (get_local $2)
    )
    (set_local $2
     (i32.const 0)
    )
    (set_local $5
     (i32.const 1)
    )
    (br $label$0)
   )
   (set_local $4
    (f64.load align=4
     (i32.add
      (get_local $0)
      (i32.shl
       (get_local $3)
       (i32.const 3)
      )
     )
    )
   )
   (set_local $5
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
          (get_local $5)
         )
        )
        (br_if $label$3
         (i32.ge_s
          (get_local $2)
          (get_local $1)
         )
        )
        (set_local $5
         (i32.const 3)
        )
        (br $label$2)
       )
       (f64.store align=4
        (tee_local $3
         (i32.add
          (get_local $0)
          (i32.shl
           (get_local $2)
           (i32.const 3)
          )
         )
        )
        (tee_local $4
         (f64.mul
          (f64.load align=4
           (get_local $3)
          )
          (f64.const 2.3)
         )
        )
       )
       (set_local $5
        (i32.const 0)
       )
       (br $label$2)
      )
      (f64.store align=4
       (i32.add
        (get_local $0)
        (i32.shl
         (get_local $2)
         (i32.const 3)
        )
       )
       (f64.add
        (get_local $4)
        (f64.const 1.3)
       )
      )
      (set_local $2
       (i32.add
        (get_local $2)
        (i32.const 1)
       )
      )
      (br $label$4)
     )
     (return)
    )
    (set_local $5
     (i32.const 1)
    )
    (br $label$2)
   )
   (set_local $5
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
     (get_local $2)
    )
    (set_local $3
     (i32.const 0)
    )
    (set_local $5
     (i32.const 1)
    )
    (br $label$0)
   )
   (set_local $4
    (f64.load align=4
     (i32.add
      (get_local $0)
      (i32.shl
       (get_local $3)
       (i32.const 3)
      )
     )
    )
   )
   (set_local $5
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
            (get_local $5)
           )
          )
          (br_if $label$3
           (i32.ge_s
            (get_local $3)
            (get_local $1)
           )
          )
          (set_local $5
           (i32.const 3)
          )
          (br $label$2)
         )
         (f64.store align=4
          (tee_local $2
           (i32.add
            (get_local $0)
            (i32.shl
             (get_local $3)
             (i32.const 3)
            )
           )
          )
          (tee_local $4
           (f64.mul
            (f64.load align=4
             (get_local $2)
            )
            (f64.const 2.3)
           )
          )
         )
         (set_local $2
          (i32.const 0)
         )
         (set_local $5
          (i32.const 4)
         )
         (br $label$2)
        )
        (br_if $label$4
         (i32.lt_s
          (tee_local $2
           (i32.add
            (get_local $2)
            (i32.const 1)
           )
          )
          (i32.const 256)
         )
        )
        (set_local $5
         (i32.const 0)
        )
        (br $label$2)
       )
       (f64.store align=4
        (i32.add
         (get_local $0)
         (i32.shl
          (get_local $3)
          (i32.const 3)
         )
        )
        (f64.add
         (get_local $4)
         (f64.const 1.3)
        )
       )
       (set_local $3
        (i32.add
         (get_local $3)
         (i32.const 1)
        )
       )
       (br $label$5)
      )
      (return)
     )
     (set_local $5
      (i32.const 1)
     )
     (br $label$2)
    )
    (set_local $5
     (i32.const 4)
    )
    (br $label$2)
   )
   (set_local $5
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
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [], "declares": [], "externs": [], "implementedFunctions": ["_test0","_test1","_stackSave","_stackAlloc","_stackRestore"], "exports": ["test0","test1","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
