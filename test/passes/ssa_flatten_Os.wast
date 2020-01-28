(module
 (export "need-ssa-to-break-local-deps" (func $need-ssa-to-break-local-deps))
 (func $need-ssa-to-break-local-deps (param $0 i32) (result i32)
  (local $1 i32)
  (set_local $0
   (i32.add
    (tee_local $1
     (i32.add
      (get_local $0)
      (i32.const -47)
     )
    )
    (i32.const 8)
   )
  )
  (i32.store
   (i32.sub
    (get_local $1)
    (get_local $0)
   )
   (i32.const 27)
  )
  (i32.const 0)
 )
)

