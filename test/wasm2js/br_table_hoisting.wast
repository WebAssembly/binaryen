(module
 (func $zed (param i32)
  (call $zed (local.get 0))
 )
 (func "foo1" (param $x i32)
  (block $a
   (block $b
    (block $c
     (block $d
      (block $e
       (br_table $a $b $c $d $e (local.get $x))
      )
      (call $zed (i32.const -1))
      (call $zed (i32.const -2))
      ;; implicit fallthrough - can be done in the switch too
     )
     (call $zed (i32.const -3))
     (call $zed (i32.const -4))
     (br $c) ;; branch which is identical to a fallthrough
    )
    (call $zed (i32.const -5))
    (call $zed (i32.const -6))
    (br $a) ;; skip some blocks - can't do this in a switch!
   )
   (call $zed (i32.const -7))
   (call $zed (i32.const -8))
   (br $a)
  )
  (call $zed (i32.const -9))
  (call $zed (i32.const -10))
 )
 (func "foo2" (param $x i32)
  (block $a
   (block $b
    (block $c
     (block $d
      (block $e
       (br_table $a $b $c $d $e (local.get $x))
      )
      (call $zed (i32.const -1))
      (call $zed (i32.const -2))
      (br $c) ;; skip some blocks - can't do this in a switch!
     )
     (call $zed (i32.const -3))
     (call $zed (i32.const -4))
     (br $c) ;; branch which is identical to a fallthrough
    )
    (call $zed (i32.const -5))
    (call $zed (i32.const -6))
    (br $a) ;; skip some blocks - can't do this in a switch!
   )
   (call $zed (i32.const -7))
   (call $zed (i32.const -8))
   (br $a)
  )
  (call $zed (i32.const -9))
  (call $zed (i32.const -10))
 )
 (func "foo3" (param $x i32)
  (block $a
   (block $b
    (block $c
     (block $d
      (block $e
       (br_table $a $b $c $d $e (local.get $x))
      )
      (br_if $c (local.get $x))
      (call $zed (i32.const -1))
      (call $zed (i32.const -2))
     )
     (call $zed (i32.const -3))
     (call $zed (i32.const -4))
     (br $c) ;; branch which is identical to a fallthrough
    )
    (call $zed (i32.const -5))
    (call $zed (i32.const -6))
    (br $a) ;; skip some blocks - can't do this in a switch!
   )
   (call $zed (i32.const -7))
   (call $zed (i32.const -8))
   (br $a)
  )
  (call $zed (i32.const -9))
  (call $zed (i32.const -10))
 )
 (func "foo4" (param $x i32)
  (block $a
   (block $b
    (block $c
     (block $d
      (br_if $c (local.get $x))
      (block $e
       (br_table $a $b $c $d $e (local.get $x))
      )
      (br_if $c (local.get $x))
      (call $zed (i32.const -1))
      (call $zed (i32.const -2))
     )
     (call $zed (i32.const -3))
     (call $zed (i32.const -4))
     (br $c) ;; branch which is identical to a fallthrough
    )
    (call $zed (i32.const -5))
    (call $zed (i32.const -6))
    (br $a) ;; skip some blocks - can't do this in a switch!
   )
   (call $zed (i32.const -7))
   (call $zed (i32.const -8))
   (br $a)
  )
  (call $zed (i32.const -9))
  (call $zed (i32.const -10))
 )
)

