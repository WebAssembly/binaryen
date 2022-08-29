(module
  (memory 1 1)
  (func $mystart
   ;; should not be modified because its the start function
   (i32.store (i32.load (i32.const 42)) (i32.const 43))
   (call $foo)
  )
  (func $foo
   ;; should not be modified because its reachable from start function
   (i32.store (i32.load (i32.const 1234)) (i32.const 5678))
   (call $foo2)
  )
  (func $foo2
   ;; should not be modified because its reachable from start function
   (i32.store (i32.load (i32.const 98)) (i32.const 99))
  )
  (func $bar
   (i32.store (i32.load (i32.const 1234)) (i32.const 5678))
  )
  (start $mystart)
)
