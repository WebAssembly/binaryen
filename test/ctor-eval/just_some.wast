(module
  (memory 256 256)
  (data (i32.const 10) "waka waka waka waka waka")
  (export "test1" $test1)
  (export "test2" $test2)
  (export "test3" $test3)
  (func $test1
    (i32.store8 (i32.const 12) (i32.const 115)) ;; a safe store, should alter memory
  )
  (func $test2
    (unreachable)
    (i32.store8 (i32.const 13) (i32.const 114)) ;; a safe store, should alter memory, but we trapped already
  )
  (func $test3
    (i32.store8 (i32.const 13) (i32.const 113)) ;; a safe store, should alter memory, but we trapped already
  )
)
