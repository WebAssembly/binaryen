(module
 (func $if-select
  (local $var$0 i32)
  (nop)
  (drop
   (if (result i32)
    (select
     (i32.const 65473)
     (i32.const 1)
     (get_local $var$0)
    )
    (i32.const -2405046)
    (i32.const 1)
   )
  )
 )
)

