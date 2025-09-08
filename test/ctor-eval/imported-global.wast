(module
  (import "env" "tempDoublePtr" (global $tempDoublePtr i32))
  (memory 256 256)
  (data (i32.const 10) "waka waka waka waka waka")
  ;; imports must not be used
  (export "test1" (func $test1))
  (global $mine (mut i32) (global.get $tempDoublePtr)) ;; BAD, if used
  (func $test1
    (i32.store8 (i32.const 13) (i32.const 115)) ;; we never get here.
  )
)
