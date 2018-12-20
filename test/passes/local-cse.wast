(module
 (global $glob (mut i32) (i32.const 1))
 (func $i64-shifts (result i64)
  (local $temp i64)
  (set_local $temp
   (i64.add
    (i64.const 1)
    (i64.const 2)
   )
  )
  (set_local $temp
   (i64.const 9999)
  )
  (set_local $temp
   (i64.add
    (i64.const 1)
    (i64.const 2)
   )
  )
  (get_local $temp)
 )
 (func $global
  (local $x i32)
  (local $y i32)
  (set_local $x (get_global $glob))
  (set_local $y (get_global $glob))
  (set_local $y (get_global $glob))
 )
)
