(module
  (type $v (func))
  (memory 256 256)
  (data (i32.const 10) "waka waka waka waka waka")
  (table 1 1 anyfunc)
  (elem (i32.const 0) $call-indirect)
  (export "test1" $test1)
  (func $test1
    (call_indirect (type $v) (i32.const 1)) ;; unsafe to call, out of range
    (i32.store8 (i32.const 20) (i32.const 120))
  )
  (func $call-indirect
    (i32.store8 (i32.const 40) (i32.const 67))
  )
)
