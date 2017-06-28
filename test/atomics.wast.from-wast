(module
 (type $0 (func))
 (memory $0 23 256 shared)
 (func $atomics (type $0)
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
  (i32.atomic.store offset=4
   (get_local $0)
   (get_local $0)
  )
  (i32.atomic.store8 offset=4
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
)
