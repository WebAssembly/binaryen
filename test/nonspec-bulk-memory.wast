(module
 (memory 1024 1024
  (segment 0 "hello, world")
 )
 (func $memory.init
  (memory.init 0
   (i32.const 512)
   (i32.const 0)
   (i32.const 12)
  )
 )
 (func $data.drop
  (data.drop 0)
 )
 (func $memory.copy
  (memory.copy
   (i32.const 512)
   (i32.const 0)
   (i32.const 12)
  )
 )
 (func $memory.fill
  (memory.fill
   (i32.const 0)
   (i32.const 42)
   (i32.const 1024)
  )
 )
)
