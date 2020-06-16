(module
  (memory (shared 256 256))
  (func "atomic-cmpxchg"
    (local $x i32)
    (local $y f32)
    (local $z f64)
    (local.set $x (i32.atomic.rmw8.cmpxchg_u (i32.const 1024) (i32.const 1) (i32.const 2)))
    (local.set $x (i32.atomic.rmw16.cmpxchg_u (i32.const 1024) (i32.const 1) (i32.const 2)))
    (local.set $x (i32.atomic.rmw.cmpxchg (i32.const 1024) (i32.const 1) (i32.const 2)))
    (local.set $x (i32.atomic.load (i32.const 1028)))
  )
)
