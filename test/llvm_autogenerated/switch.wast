(module
 (type $FUNCSIG$v (func))
 (import "env" "foo0" (func $foo0))
 (import "env" "foo1" (func $foo1))
 (import "env" "foo2" (func $foo2))
 (import "env" "foo3" (func $foo3))
 (import "env" "foo4" (func $foo4))
 (import "env" "foo5" (func $foo5))
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "bar32" (func $bar32))
 (export "bar64" (func $bar64))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $bar32 (; 6 ;) (param $0 i32)
  (block $label$0
   (br_if $label$0
    (i32.gt_u
     (get_local $0)
     (i32.const 23)
    )
   )
   (block $label$1
    (block $label$2
     (block $label$3
      (block $label$4
       (block $label$5
        (block $label$6
         (br_table $label$6 $label$6 $label$6 $label$6 $label$6 $label$6 $label$6 $label$5 $label$5 $label$5 $label$5 $label$5 $label$5 $label$5 $label$5 $label$4 $label$4 $label$4 $label$4 $label$4 $label$4 $label$3 $label$2 $label$1 $label$6
          (get_local $0)
         )
        )
        (call $foo0)
        (return)
       )
       (call $foo1)
       (return)
      )
      (call $foo2)
      (return)
     )
     (call $foo3)
     (return)
    )
    (call $foo4)
    (return)
   )
   (call $foo5)
  )
  (return)
 )
 (func $bar64 (; 7 ;) (param $0 i64)
  (block $label$0
   (br_if $label$0
    (i64.gt_u
     (get_local $0)
     (i64.const 23)
    )
   )
   (block $label$1
    (block $label$2
     (block $label$3
      (block $label$4
       (block $label$5
        (block $label$6
         (br_table $label$6 $label$6 $label$6 $label$6 $label$6 $label$6 $label$6 $label$5 $label$5 $label$5 $label$5 $label$5 $label$5 $label$5 $label$5 $label$4 $label$4 $label$4 $label$4 $label$4 $label$4 $label$3 $label$2 $label$1 $label$6
          (i32.wrap/i64
           (get_local $0)
          )
         )
        )
        (call $foo0)
        (return)
       )
       (call $foo1)
       (return)
      )
      (call $foo2)
      (return)
     )
     (call $foo3)
     (return)
    )
    (call $foo4)
    (return)
   )
   (call $foo5)
  )
  (return)
 )
 (func $stackSave (; 8 ;) (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (; 9 ;) (param $0 i32) (result i32)
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
 (func $stackRestore (; 10 ;) (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [], "declares": ["foo0","foo1","foo2","foo3","foo4","foo5"], "externs": [], "implementedFunctions": ["_bar32","_bar64","_stackSave","_stackAlloc","_stackRestore"], "exports": ["bar32","bar64","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
