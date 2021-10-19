(module
 (type $0 (func))
 (memory $0 (shared i64 23 256))
 (func $atomic-loadstore (type $0)
  (local $0 i64)
  (local $1 i64)
  (local $2 i32)
  (drop
   (i32.atomic.load8_u offset=4
    (local.get $0)
   )
  )
  (drop
   (i32.atomic.load16_u offset=4
    (local.get $0)
   )
  )
  (drop
   (i32.atomic.load offset=4
    (local.get $0)
   )
  )
  (drop
   (i64.atomic.load8_u
    (local.get $0)
   )
  )
  (drop
   (i64.atomic.load16_u
    (local.get $0)
   )
  )
  (drop
   (i64.atomic.load32_u
    (local.get $0)
   )
  )
  (drop
   (i64.atomic.load
    (local.get $0)
   )
  )
  (i32.atomic.store offset=4 align=4
   (local.get $0)
   (local.get $2)
  )
  (i32.atomic.store8 offset=4 align=1
   (local.get $0)
   (local.get $2)
  )
  (i32.atomic.store16 offset=4
   (local.get $0)
   (local.get $2)
  )
  (i64.atomic.store offset=4
   (local.get $0)
   (local.get $1)
  )
  (i64.atomic.store8 offset=4
   (local.get $0)
   (local.get $1)
  )
  (i64.atomic.store16 offset=4
   (local.get $0)
   (local.get $1)
  )
  (i64.atomic.store32 offset=4
   (local.get $0)
   (local.get $1)
  )
 )
 (func $atomic-rmw (type $0)
  (local $0 i64)
  (local $1 i64)
  (local $2 i32)
  (drop
   (i32.atomic.rmw.add offset=4
    (local.get $0)
    (local.get $2)
   )
  )
  (drop
   (i32.atomic.rmw8.add_u offset=4
    (local.get $0)
    (local.get $2)
   )
  )
  (drop
   (i32.atomic.rmw16.and_u align=2
    (local.get $0)
    (local.get $2)
   )
  )
  (drop
   (i64.atomic.rmw32.or_u
    (local.get $0)
    (local.get $1)
   )
  )
  (drop
   (i32.atomic.rmw8.xchg_u align=1
    (local.get $0)
    (local.get $2)
   )
  )
 )
 (func $atomic-cmpxchg (type $0)
  (local $0 i64)
  (local $1 i64)
  (local $2 i32)
  (drop
   (i32.atomic.rmw.cmpxchg offset=4
    (local.get $0)
    (local.get $2)
    (local.get $2)
   )
  )
  (drop
   (i32.atomic.rmw8.cmpxchg_u
    (local.get $0)
    (local.get $2)
    (local.get $2)
   )
  )
  (drop
   (i64.atomic.rmw.cmpxchg offset=4
    (local.get $0)
    (local.get $1)
    (local.get $1)
   )
  )
  (drop
   (i64.atomic.rmw32.cmpxchg_u align=4
    (local.get $0)
    (local.get $1)
    (local.get $1)
   )
  )
 )
 (func $atomic-wait-notify (type $0)
  (local $0 i64)
  (local $1 i64)
  (local $2 i32)
  (drop
   (memory.atomic.wait32
    (local.get $0)
    (local.get $2)
    (local.get $1)
   )
  )
  (drop
   (memory.atomic.wait32 offset=4 align=4
    (local.get $0)
    (local.get $2)
    (local.get $1)
   )
  )
  (drop
   (memory.atomic.notify
    (local.get $0)
    (local.get $2)
   )
  )
  (drop
   (memory.atomic.notify offset=24 align=4
    (local.get $0)
    (local.get $2)
   )
  )
  (drop
   (memory.atomic.wait64
    (local.get $0)
    (local.get $1)
    (local.get $1)
   )
  )
  (drop
   (memory.atomic.wait64 align=8 offset=16
    (local.get $0)
    (local.get $1)
    (local.get $1)
   )
  )
 )
 (func $atomic-fence (type $0)
  (atomic.fence)
 )
)
