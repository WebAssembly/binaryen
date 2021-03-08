(module
 (memory $0 1 1)
 (func $test
  (drop (i32.load         (i32.const 4)))
  (drop (i32.load align=1 (i32.const 8)))
  (drop (i32.load align=2 (i32.const 12)))
  (i32.store         (i32.const 16) (i32.const 28))
  (i32.store align=1 (i32.const 20) (i32.const 32))
  (i32.store align=2 (i32.const 24) (i32.const 36))
 )
)
