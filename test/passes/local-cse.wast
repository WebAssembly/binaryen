(module
 (global $glob (mut i32) (i32.const 1))
 (func $i64-shifts (result i64)
  (local $temp i64)
  (local.set $temp
   (i64.add
    (i64.const 1)
    (i64.const 2)
   )
  )
  (local.set $temp
   (i64.const 9999)
  )
  (local.set $temp
   (i64.add
    (i64.const 1)
    (i64.const 2)
   )
  )
  (local.get $temp)
 )
 (func $global
  (local $x i32)
  (local $y i32)
  (local.set $x (global.get $glob))
  (local.set $y (global.get $glob))
  (local.set $y (global.get $glob))
 )
)
