(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (export "test0" (func $test0))
 (export "test1" (func $test1))
 (func $test0 (param $0 i32) (result i32)
  (block $label$0
   (br_if $label$0
    (i32.gt_s
     (get_local $0)
     (i32.const -1)
    )
   )
   (set_local $0
    (i32.div_s
     (get_local $0)
     (i32.const 3)
    )
   )
  )
  (return
   (get_local $0)
  )
 )
 (func $test1 (param $0 i32) (result i32)
  (local $1 i32)
  (local $2 i32)
  (local $3 i32)
  (local $4 i32)
  (set_local $2
   (i32.const 0)
  )
  (set_local $3
   (i32.const 1)
  )
  (set_local $4
   (i32.const 0)
  )
  (loop $label$0
   (set_local $1
    (get_local $2)
   )
   (set_local $2
    (get_local $3)
   )
   (set_local $3
    (get_local $1)
   )
   (br_if $label$0
    (i32.lt_s
     (tee_local $4
      (i32.add
       (get_local $4)
       (i32.const 1)
      )
     )
     (get_local $0)
    )
   )
  )
  (return
   (get_local $1)
  )
 )
 (func $stackSave (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (param $0 i32) (result i32)
  (local $1 i32)
  (set_local $1
   (i32.load offset=4
    (i32.const 0)
   )
  )
  (i32.store offset=4
   (i32.const 0)
   (i32.and
    (i32.add
     (i32.add
      (get_local $1)
      (get_local $0)
     )
     (i32.const 15)
    )
    (i32.const -16)
   )
  )
  (get_local $1)
 )
 (func $stackRestore (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
