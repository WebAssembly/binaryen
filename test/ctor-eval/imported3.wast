(module
  (memory 256 256)
  (data (i32.const 10) "waka waka waka waka waka")
  ;; imports must not be used
  (import "env" "tempDoublePtr" (global $tempDoublePtr i32))
  (export "test1" $test1)
  (export "test2" $test2)
  (export "test3" $test3)
  ;; ok to modify a global, if we keep it the same value
  (global $mine (mut i32) (get_global $tempDoublePtr)) ;; BAD!
  (func $test1
    (i32.store8 (i32.const 12) (i32.const 115)) ;; we never get here.
  )
)
