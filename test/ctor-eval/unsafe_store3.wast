(module
  (memory 256 256)
  (data (i32.const 10) "waka waka waka waka waka")
  (export "test1" $test1)
  (export "test2" $test2)
  (export "test3" $test3)
  (func $test1
    (i32.store16 (i32.const 33) (i32.const 109)) ;; UNsafe store due to size of type
    (i32.store (i32.const 12) (i32.const 115)) ;; a safe store, should alter memory
  )
)
