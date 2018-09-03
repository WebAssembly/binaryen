(module
  (memory 256 256)
  (data (i32.const 10) "waka waka waka waka waka")
  (export "test1" $test1)
  (func $test1
    (call $unsafe-to-call) ;; unsafe to call
    (i32.store (i32.const 12) (i32.const 115)) ;; a safe store, should alter memory
    (i32.store16 (i32.const 20) (i32.const 31353))
    (i32.store8 (i32.const 23) (i32.const 120))
  )
  (func $unsafe-to-call
    (unreachable)
  )
)
