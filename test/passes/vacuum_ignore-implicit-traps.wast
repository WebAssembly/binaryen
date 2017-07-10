(module
  (func $load-would-normally-have-side-effects (result i32)
   (i64.ge_s
    (block (result i64)
     (drop
      (i64.eq
       (i64.load32_s
        (i32.const 678585719)
       )
       (i64.const 8097879367757079605)
      )
     )
     (i64.const 2912825531628789796)
    )
    (i64.const 0)
   )
  )
)

