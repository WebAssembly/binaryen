(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (export "fib" (func $fib))
 (func $fib (param $0 i32) (result i32)
  (local $1 i32)
  (local $2 i32)
  (local $3 i32)
  (local $4 i32)
  (set_local $3
   (i32.const 0)
  )
  (set_local $2
   (i32.const -1)
  )
  (set_local $4
   (i32.const 1)
  )
  (block $label$0
   (loop $label$1
    ;;@ fib.c:3:17
    (set_local $2
     (i32.add
      (get_local $2)
      (i32.const 1)
     )
    )
    ;;@ fib.c:3:3
    (br_if $label$0
     (i32.ge_s
      (get_local $2)
      (get_local $0)
     )
    )
    ;;@ fib.c:4:11
    (set_local $1
     (i32.add
      (get_local $4)
      (get_local $3)
     )
    )
    (set_local $3
     (get_local $4)
    )
    (set_local $4
     (get_local $1)
    )
    (br $label$1)
   )
  )
  ;;@ fib.c:6:3
  (return
   (get_local $4)
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
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [] }
