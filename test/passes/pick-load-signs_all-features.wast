(module
 (memory $0 (shared 16 16))
 (func $atomics-are-always-unsigned (result i32)
  (local $0 i32)
  (drop
   (block (result i32)
    (local.set $0
     (i32.atomic.load16_u ;; an atomic load cannot become signed
      (i32.const 27)
     )
    )
    (i32.shr_s
     (i32.shl
      (local.get $0)
      (i32.const 16)
     )
     (i32.const 16)
    )
   )
  )
  (i32.const -65)
 )
)
