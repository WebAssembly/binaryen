(module
 (type $0 (func))
 (memory $0 (shared 23 256))
 (func $atomic-loadstore (type $0)
  (local $0 i32)
  (local $1 i64)
  (drop
   (i32.atomic.load8_u offset=4
    (get_local $0)
   )
  )
  (drop
   (i32.atomic.load16_u offset=4
    (get_local $0)
   )
  )
  (drop
   (i32.atomic.load offset=4
    (get_local $0)
   )
  )
  (drop
   (i64.atomic.load8_u
    (get_local $0)
   )
  )
  (drop
   (i64.atomic.load16_u
    (get_local $0)
   )
  )
  (drop
   (i64.atomic.load32_u
    (get_local $0)
   )
  )
  (drop
   (i64.atomic.load
    (get_local $0)
   )
  )
  (i32.atomic.store offset=4 align=4
   (get_local $0)
   (get_local $0)
  )
  (i32.atomic.store8 offset=4 align=1
   (get_local $0)
   (get_local $0)
  )
  (i32.atomic.store16 offset=4
   (get_local $0)
   (get_local $0)
  )
  (i64.atomic.store offset=4
   (get_local $0)
   (get_local $1)
  )
  (i64.atomic.store8 offset=4
   (get_local $0)
   (get_local $1)
  )
  (i64.atomic.store16 offset=4
   (get_local $0)
   (get_local $1)
  )
  (i64.atomic.store32 offset=4
   (get_local $0)
   (get_local $1)
  )
 )
 (func $atomic-rmw (type $0)
  (local $0 i32)
  (local $1 i64)
  (drop
   (i32.atomic.rmw.add offset=4
    (get_local $0)
    (get_local $0)
   )
  )
  (drop
   (i32.atomic.rmw8_u.add offset=4
    (get_local $0)
    (get_local $0)
   )
  )
  (drop
   (i32.atomic.rmw16_u.and align=2
    (get_local $0)
    (get_local $0)
   )
  )
  (drop
   (i64.atomic.rmw32_u.or
    (get_local $0)
    (get_local $1)
   )
  )
  (drop
   (i32.atomic.rmw8_u.xchg align=1
    (get_local $0)
    (get_local $0)
   )
  )
 )
 (func $atomic-cmpxchg (type $0)
  (local $0 i32)
  (local $1 i64)
  (drop
   (i32.atomic.rmw.cmpxchg offset=4
    (get_local $0)
    (get_local $0)
    (get_local $0)
   )
  )
  (drop
   (i32.atomic.rmw8_u.cmpxchg
    (get_local $0)
    (get_local $0)
    (get_local $0)
   )
  )
  (drop
   (i64.atomic.rmw.cmpxchg offset=4
    (get_local $0)
    (get_local $1)
    (get_local $1)
   )
  )
  (drop
   (i64.atomic.rmw32_u.cmpxchg align=4
    (get_local $0)
    (get_local $1)
    (get_local $1)
   )
  )
 )
 (func $atomic-wait-wake (type $0)
  (local $0 i32)
  (local $1 i64)
  (drop
   (i32.wait
    (get_local $0)
    (get_local $0)
    (get_local $1)
   )
  )
  (drop
   (wake
    (get_local $0)
    (get_local $0)
   )
  )
  (drop
   (i64.wait
    (get_local $0)
    (get_local $1)
    (get_local $1)
   )
  )
 )
)
