(module
 (import "import" "memory" (memory $memory 1 1))
 (global $global (export "g") (mut i32) (i32.const 0))

 (func $foo
  ;; Loading from an imported memory stops further optimization
  (drop (i32.load $memory (i32.const 0)))
  (nop)
  (global.set $global (i32.const 1))
 )
 (export "foo" (func $foo))
) 
