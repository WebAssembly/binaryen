(module
  (import "env" "global-1" (global $g1 i32))
  (global $g2 (mut i32) (global.get $g1))
  (func $foo
   (drop (global.get $g1))
   (drop (global.get $g2))
  )
)
(module
  (import "env" "global-1" (global $g1 i32))
  (global $g2 (mut i32) (global.get $g1))
  (func $foo
   (global.set $g2 (unreachable))
  )
)
(module
  (global $g1 (mut i32) (i32.const 1))
  (global $g2 (mut i32) (i32.const 1))
  (func $f (param $x i32) (result i32)
    (global.set $g1 (i32.const 100))
    (global.set $g2 (local.get $x))
    (if (local.get $x) (return (i32.const 0)))
    (local.set $x
      (i32.add
        (global.get $g1)
        (global.get $g2)
      )
    )
    (if (local.get $x) (return (i32.const 1)))
    (global.set $g1 (i32.const 200))
    (global.set $g2 (local.get $x))
    (local.set $x
      (i32.add
        (global.get $g1)
        (global.get $g2)
      )
    )
    (local.get $x)
  )
)
(module
  (global $g1 (mut i32) (i32.const 1))
  (global $g2 (mut i32) (i32.const 1))
  (func $f (param $x i32) (result i32)
    (global.set $g1 (i32.const 100))
    (global.set $g2 (local.get $x))
    (local.set $x
      (i32.add
        (i32.add
          (global.get $g1)
          (global.get $g1)
        )
        (global.get $g2)
      )
    )
    (local.get $x)
  )
)
(module
  (global $g1 (mut i32) (i32.const 1))
  (global $g2 (mut i32) (i32.const 1))
  (func $no (param $x i32) (result i32)
    (global.set $g1 (i32.const 100))
    (drop (call $no (i32.const 200))) ;; invalidate
    (global.get $g1)
  )
  (func $no2 (param $x i32) (result i32)
    (global.set $g1 (i32.const 100))
    (global.set $g1 (local.get $x)) ;; invalidate
    (global.get $g1)
  )
  (func $yes (param $x i32) (result i32)
    (global.set $g1 (i32.const 100))
    (global.set $g2 (local.get $x)) ;; almost invalidate
    (global.get $g1)
  )
)
;; Reference type tests
(module
  (import "env" "global-1" (global $g1 externref))
  (global $g2 (mut externref) (global.get $g1))
  (global $g3 externref (ref.null extern))
  (func $test1
    (drop (global.get $g1))
    (drop (global.get $g2))
  )
  (func $test2
    (drop (global.get $g3))
  )
)
;; Global is used by `set` but never `get` can be eliminated.
(module
  (global $write-only (mut i32) (i32.const 1))
  (func $foo
    (global.set $write-only (i32.const 2))
  )
)
