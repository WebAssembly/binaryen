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
;; don't remove a value with a side effect
(module
 (global $global$0 (mut i32) (i32.const 0))
 (global $global$1 (mut i32) (i32.const 0))
 (export "func_9" (func $0))
 (func $0 (result f64)
  (global.set $global$0
   (block $label$1 (result i32)
    (if
     (i32.eqz
      (global.get $global$1)
     )
     (unreachable)
    )
    (i32.const 2)
   )
  )
  (f64.const 1)
 )
)
