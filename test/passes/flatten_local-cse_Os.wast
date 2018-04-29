(module
 ;; testcase from AssemblyScript
 (func "div16_internal" (param $0 i32) (param $1 i32) (result i32)
  (i32.add
   (i32.xor
    (i32.shr_s
     (i32.shl
      (get_local $0)
      (i32.const 16)
     )
     (i32.const 16)
    )
    (i32.shr_s
     (i32.shl
      (get_local $1)
      (i32.const 16)
     )
     (i32.const 16)
    )
   )
   (i32.xor
    (i32.shr_s
     (i32.shl
      (get_local $0)
      (i32.const 16)
     )
     (i32.const 16)
    )
    (i32.shr_s
     (i32.shl
      (get_local $1)
      (i32.const 16)
     )
     (i32.const 16)
    )
   )
  )
 )
)
