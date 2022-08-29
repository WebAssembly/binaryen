(module
  (memory 256 256)
  (data (i32.const 10) "waka waka waka waka waka")
  (export "test1" $test1)
  (func $test1
    (i32.store8 (i32.const 34) (i32.const 109)) ;; after last segment
  )
)
