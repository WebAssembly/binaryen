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
  (global $g3 (mut i32) (global.get $g2))
  (global $g4 (mut i32) (global.get $g3))
  (func $foo
   (drop (global.get $g1))
   (drop (global.get $g2))
   (drop (global.get $g3))
   (drop (global.get $g4))
  )
)
(module
  (import "env" "global-1" (global $g1 (mut i32)))
  (global $g2 (mut i32) (global.get $g1))
)
(module
  (import "env" "global-1" (global $g1 i32))
  (global $g2 (mut i32) (global.get $g1))
  (func $foo
   (global.set $g2 (unreachable))
  )
)
(module
  (import "env" "global-1" (global $g1 (mut i32)))
  (global $g2 (mut i32) (global.get $g1))
  (export "global-2" (global $g2))
)

