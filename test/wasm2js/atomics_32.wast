(module
  (memory (shared 256 256))
  (func "atomic-cmpxchg"
    (local $x i32)
    (local.set $x (i32.atomic.rmw8.cmpxchg_u (i32.const 1024) (i32.const 1) (i32.const 2)))
    (local.set $x (i32.atomic.rmw16.cmpxchg_u (i32.const 1024) (i32.const 1) (i32.const 2)))
    (local.set $x (i32.atomic.rmw.cmpxchg (i32.const 1024) (i32.const 1) (i32.const 2)))
    (local.set $x (i32.atomic.load8_u (i32.const 1028)))
    (local.set $x (i32.atomic.load16_u (i32.const 1028)))
    (local.set $x (i32.atomic.load (i32.const 1028)))
    (i32.atomic.store (i32.const 100) (i32.const 200))
  )
)
