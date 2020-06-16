(module
  (memory (shared 256 256))
  (func "atomic-cmpxchg"
    (local $x i32)
    (local.set $x (i32.atomic.rmw.cmpxchg (i32.const 1024) (i32.const 1) (i32.const 2)))
    ;; (drop (i32.atomic.load (i32.const 1028)))
    (drop (local.get $x))
  )
)
