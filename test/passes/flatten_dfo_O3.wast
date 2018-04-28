(module
 (func "look-at-the-8's" (result i32)
  (local $var$0 i32)
  (i32.store
   (i32.const 4)
   (tee_local $var$0
    (i32.load
     (i32.const 4)
    )
   )
  )
  (i32.store
   (block $label$1 (result i32)
    (drop
     (br_if $label$1
      (i32.add
       (get_local $var$0)
       (i32.const 8)
      )
      (i32.load
       (i32.const 5072)
      )
     )
    )
    (i32.add
     (get_local $var$0)
     (i32.const 8)
    )
   )
   (i32.const 0)
  )
  (unreachable)
 )
)

