(module
 (func $sink-from-inside (result i32)
  (local $0 i32)
  (local $1 i32)
  (local $2 i32)
  (local.set $2
   (block (result i32)
    (local.set $0
     (i32.const 1)
    )
    (drop
     (local.get $0)
    )
    (local.set $1 ;; after we sink this, must be careful about sinking the parent, to not reorder other things badly
     (select
      (i32.const 0)
      (i32.const 1)
      (local.get $0)
     )
    )
    (i32.const 1)
   )
  )
  (i32.and
   (local.get $1)
   (local.get $2)
  )
 )
)
