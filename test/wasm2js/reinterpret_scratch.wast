(module
 (memory $0 1 1)
 (func "foo" (result i32)
  (local $0 f32)
  (i64.store align=4
   (i32.reinterpret_f32 ;; i32 0
    (local.get $0)      ;; f32 0
   )
   (i64.reinterpret_f64    ;; these two reinterprets must not interfere with
    (f64.const 0x12345678) ;; each other, even though both use scratch memory
   )
  )
  (i32.load
   (i32.const 0)
  )
 )
)
