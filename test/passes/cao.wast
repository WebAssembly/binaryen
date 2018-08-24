(module
  (export "a8" (func $a8))
  (table 1 1 anyfunc)
  (elem (i32.const 0) $a9)
  (func $a (param $x i32))
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
  (func $a5 (param $x i32) (param $y f64) ;; optimize two
    (drop (get_local $x))
    (drop (get_local $y))
  )
  (func $b5
    (call $a5 (i32.const 1) (f64.const 3.14159))
  )
  (func $a6 (param $x i32) (param $y f64) ;; optimize just one
    (drop (get_local $x))
    (drop (get_local $y))
  )
  (func $b6
    (call $a6 (unreachable) (f64.const 3.14159))
  )
  (func $a7 (param $x i32) (param $y f64) ;; optimize just the other one
    (drop (get_local $x))
    (drop (get_local $y))
  )
  (func $b7
    (call $a7 (i32.const 1) (unreachable))
  )
  (func $a8 (param $x i32)) ;; exported, do not optimize
  (func $b8
    (call $a8 (i32.const 1))
  )
  (func $a9 (param $x i32)) ;; tabled, do not optimize
  (func $b9
    (call $a9 (i32.const 1))
  )
  (func $a10 (param $x i32) ;; recursion
    (call $a10 (i32.const 1))
    (call $a10 (i32.const 1))
  )
  (func $a11 (param $x i32) ;; partially successful recursion
    (call $a11 (i32.const 1))
    (call $a11 (i32.const 2))
  )
  (func $a12 (param $x i32) ;; unsuccessful recursion
    (drop (get_local $x))
    (call $a12 (i32.const 1))
    (call $a12 (i32.const 2))
  )
)

