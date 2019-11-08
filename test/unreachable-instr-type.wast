(module
  (memory (shared 1 1))
  (func $test
    (f32.load (unreachable))

    (f32.store
      (unreachable)
      (f32.const 0)
    )

    (i64.atomic.rmw.add
      (unreachable)
      (i64.const 0)
    )

    (i64.atomic.rmw.cmpxchg
      (unreachable)
      (i64.const 0)
      (i64.const 1)
    )

    (i64.atomic.wait
      (unreachable)
      (i64.const 0)
      (i64.const 0)
    )
  )
)
