(module
  (memory 256 256)
  (data (i32.const 10) "waka waka waka waka waka")
  ;; imports must not be used
  (import "env" "tempDoublePtr" (global $tempDoublePtr i32))
  (export "test1" $test1)
  (global $mine (mut i32) (global.get $tempDoublePtr)) ;; BAD, if used
  (func $test1
    (drop (global.get $mine))
    (i32.store8 (i32.const 13) (i32.const 115)) ;; we never get here.
  )
)
