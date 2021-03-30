(module
 (memory 1 1)
 ;; this can be removed destructively
 (data "some-data")
 (func "foo" (result i32)
  ;; this can be removed destructively
  (memory.init 0
   (i32.const 3)
   (i32.const 3)
   (i32.const 3))
  (i32.atomic.store8
   (i32.const 0)
   ;; an add that can be optimized
   (i32.add
    (i32.const 97)
    (i32.const 2)
   )
  )
  ;; add some nops and blocks for reduction to remove
  (nop)
  (block (result i32)
   (i32.atomic.load8_u
    (i32.const 0)
   )
  )
 )
)
