(module
  (memory i64 1)
  (func $simple
    (drop (f32.reinterpret_i32 (i32.load (i64.const 1024))))
    (drop (i32.reinterpret_f32 (f32.load (i64.const 1024))))
    (drop (f64.reinterpret_i64 (i64.load (i64.const 1024))))
    (drop (i64.reinterpret_f64 (f64.load (i64.const 1024))))
  )
  (func $one
    (local $x i32)
    (local.set $x (i32.load (i64.const 1024)))
    (drop (f32.reinterpret_i32 (local.get $x)))
  )
  (func $one-b
    (local $x f32)
    (local.set $x (f32.load (i64.const 1024)))
    (drop (i32.reinterpret_f32 (local.get $x)))
  )
  (func $both
    (local $x i32)
    (local.set $x (i32.load (i64.const 1024)))
    (drop (f32.reinterpret_i32 (local.get $x)))
    (drop (f32.reinterpret_i32 (local.get $x)))
  )
  (func $half
    (local $x i32)
    (local.set $x (i32.load (i64.const 1024)))
    (drop (local.get $x))
    (drop (f32.reinterpret_i32 (local.get $x)))
  )
  (func $copy
    (local $x i32)
    (local $y i32)
    (local.set $x (i32.load (i64.const 1024)))
    (local.set $y (local.get $x))
    (drop (f32.reinterpret_i32 (local.get $y)))
  )
  (func $partial1 (result f32)
   (f32.reinterpret_i32
    (i32.load16_u
     (i64.const 3)
    )
   )
  )
  (func $partial2 (result f32)
   (f32.reinterpret_i32
    (i32.load8_u
     (i64.const 3)
    )
   )
  )
  (func $nofallthrough
    (local $x i32)
    (local.set $x
     (i32.load
      (i64.const 1024)
     )
    )
    (drop
     (f32.reinterpret_i32
      (block (result i32)
       (nop) ;; this would be removed by other opts, but in general, we can't
             ;; just look at the fallthrough, as we can't just remove code here
       (local.get $x)
      )
     )
    )
  )
)
