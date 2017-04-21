(module
  (memory 256 256)
  (data (i32.const 10) "waka waka waka waka waka")
  (export "test1" $test1)
  (export "test2" $test2)
  (export "test3" $test3)
  (func $test1
    (drop (i32.const 0)) ;; no work at all, really
    (call $safe-to-call) ;; safe to call
  )
  (func $test2
    (drop (i32.load (i32.const 12))) ;; a safe load
    (drop (i32.load16 (i32.const 12)))
    (drop (i32.load8 (i32.const 12)))
  )
  (func $test3
    (i32.store (i32.const 12) (i32.const 115)) ;; a safe store, should alter memory
    (i32.store16 (i32.const 20) (i32.const 31353))
    (i32.store8 (i32.const 23) (i32.const 120))
  )
  (func $safe-to-call
    (drop (i32.const 1))
  )
)
