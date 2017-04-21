(module
  (memory 256 256)
  (data (i32.const 10) "waka waka waka waka waka")
  (export "test1" $test1)
  (export "test2" $test2)
  (export "test3" $test3)
  (func $test1
    (drop (i32.const 0)) ;; no work at all, really
  )
  (func $test2
    (drop (i32.load (i32.const 12))) ;; a safe load
  )
  (func $test3
    (drop (i32.store (i32.const 12) (i32.const 115))) ;; a safe store, should alter memory
    (drop (i32.store16 (i32.const 20) (i32.const 31353)))
    (drop (i32.store8 (i32.const 23) (i32.const 120)))
  )
)
