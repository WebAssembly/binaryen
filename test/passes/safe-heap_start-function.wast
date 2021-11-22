(module
  (memory 1 1)
  (func $foo
   ;; should not be modified because its the start function
   (i32.store (i32.load (i32.const 1234)) (i32.const 5678))
  )
  (func $bar
   (i32.store (i32.load (i32.const 1234)) (i32.const 5678))
  )
  (start $foo)
)
