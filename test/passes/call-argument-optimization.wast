(module
  (func $a (param $x i32)
  )
  (func $b
    (call $a (i32.const 1)) ;; best case scenario
  )
  (func $a1 (param $x i32)
    (unreachable)
  )
  (func $b1
    (call $a1 (i32.const 2)) ;; same value in both, so works
  )
  (func $b11
    (call $a1 (i32.const 2))
  )
  (func $a2 (param $x i32)
    (drop (get_local $x))
  )
  (func $b2
    (call $a2 (i32.const 3)) ;; different value!
  )
  (func $b22
    (call $a2 (i32.const 4))
  )
  (func $a3 (param $x i32)
    (drop (i32.const -1)) ;; diff value, but at least unused, so no need to send
  )
  (func $b3
    (call $a3 (i32.const 3))
  )
  (func $b33
    (call $a3 (i32.const 4))
  )
  (func $a4 (param $x i32) ;; diff value, but with effects
  )
  (func $b4
    (call $a4 (unreachable))
  )
  (func $b43
    (call $a4 (i32.const 4))
  )
)

