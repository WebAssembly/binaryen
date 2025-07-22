(module
  (import "env" "_abort" (func $_abort))
  (type $v (func))
  (memory $m 256 256)
  (data (i32.const 10) "waka waka waka waka waka")
  (table 2 2 funcref)
  (elem (i32.const 0) $_abort $call-indirect)
  (export "test1" (func $test1))
  (export "memory" (memory $m)) ;; export memory so we can see the updated data
  (func $test1
    (call_indirect (type $v) (i32.const 1)) ;; safe to call
    (i32.store8 (i32.const 20) (i32.const 120))
  )
  (func $call-indirect
    (i32.store8 (i32.const 40) (i32.const 67))
  )
)
