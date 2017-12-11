(module
 (func $test (param $x $i32) (param $y i32) (result i32)
  (drop
   (if (result i32)
    (tee_local $x
     (get_local $y)
    )
    (i32.const 100)
    (get_local $x)
   )
  )
  (get_local $y) ;; turn this into $x
 )
 (func $test2 (param $x $i32) (param $y i32) (result i32)
  (drop
   (if (result i32)
    (tee_local $x
     (get_local $y)
    )
    (i32.const 100)
    (get_local $x)
   )
  )
  (get_local $x)
 )
)

