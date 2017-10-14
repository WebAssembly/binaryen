(module
 (memory $0 (shared 1 1))
 (func $0 (result i32)
  (i32.atomic.store16
   (i32.const 0)
   (i32.const 0)
  )
  (i32.const 1)
 )
 (func $1 (result i64)
  (drop
   (call $0)
  )
  (i64.const 0)
 )
)
