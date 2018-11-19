(module
  (type $v (func))
  (memory 256 256)
  ;; test flattening of multiple segments
  (data (i32.const 10) "waka ")
  (data (i32.const 15) "waka") ;; skip a byte here
  (data (i32.const 20) "waka waka waka")
  (table 1 1 anyfunc)
  (elem (i32.const 0) $call-indirect)
  (export "test1" $test1)
  (export "test2" $test2)
  (export "test3" $test3)
  (func $test1
    (drop (i32.const 0)) ;; no work at all, really
    (call $safe-to-call) ;; safe to call
    (call_indirect (type $v) (i32.const 0)) ;; safe to call
  )
  (func $test2
    (drop (i32.load (i32.const 12))) ;; a safe load
    (drop (i32.load16_s (i32.const 12)))
    (drop (i32.load8_s (i32.const 12)))
    (drop (i32.load16_u (i32.const 12)))
    (drop (i32.load8_u (i32.const 12)))
  )
  (func $test3
    (i32.store (i32.const 12) (i32.const 115)) ;; a safe store, should alter memory
    (i32.store16 (i32.const 20) (i32.const 31353))
    (i32.store8 (i32.const 23) (i32.const 120))
  )
  (func $safe-to-call
    (drop (i32.const 1))
    (i32.store8 (i32.const 10) (i32.const 110)) ;; safe write too (lowest possible)
    (i32.store8 (i32.const 33) (i32.const 109)) ;; safe write too (highest possible)
  )
  (func $call-indirect
    (i32.store8 (i32.const 40) (i32.const 67))
  )
)
