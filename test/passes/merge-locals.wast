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
 (func $test-multiple (param $x $i32) (param $y i32) (result i32)
  (drop
   (if (result i32)
    (tee_local $x
     (get_local $y)
    )
    (i32.const 100)
    (get_local $x)
   )
  )
  (drop (get_local $y)) ;; turn this into $x
  (get_local $y) ;; turn this into $x
 )
 (func $test-just-some (param $x $i32) (param $y i32) (result i32)
  (drop
   (if (result i32)
    (tee_local $x
     (get_local $y)
    )
    (i32.const 100)
    (get_local $x)
   )
  )
  (drop (get_local $y)) ;; turn this into $x
  (set_local $y (i32.const 200))
  (get_local $y) ;; but not this one!
 )
 (func $test-just-some2 (param $x $i32) (param $y i32) (result i32)
  (drop
   (if (result i32)
    (tee_local $x
     (get_local $y)
    )
    (i32.const 100)
    (get_local $x)
   )
  )
  (if
   (i32.const 300)
   (set_local $y (i32.const 400))
   (drop (get_local $y)) ;; turn this into $x
  )
  (i32.const 500)
 )
 (func $test-just-some3 (param $x $i32) (param $y i32) (result i32)
  (drop
   (if (result i32)
    (tee_local $x
     (get_local $y)
    )
    (i32.const 100)
    (get_local $x)
   )
  )
  (if
   (i32.const 300)
   (set_local $y (i32.const 400))
   (drop (get_local $y)) ;; can turn this into $x, but another exists we can't, so do nothing
  )
  (get_local $y) ;; but not this one!
 )
 (func $silly-self (param $x $i32) (param $y i32) (result i32)
  (drop
   (if (result i32)
    (tee_local $x
     (get_local $x)
    )
    (i32.const 100)
    (get_local $x)
   )
  )
  (get_local $y) ;; turn this into $x
 )
)

