(module
 (memory $0 1 1)
 (func $foo
  (drop (i32.atomic.rmw.cmpxchg
   (i32.const 0)
   (i32.const 0)
   (i32.const 0)
  ))
 )
)
