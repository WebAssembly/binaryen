(module
  (memory 256 256)
  (data (i32.const 10) "waka waka waka waka waka")
  ;; stack imports are special-cased
  (import "env" "STACKTOP" (global $STACKTOP i32))
  (import "env" "STACK_MAX" (global $STACK_MAX i32))
  ;; other imports must not be touched!
  (import "env" "tempDoublePtr" (global $tempDoublePtr i32))
  (export "test1" $test1)
  (export "test2" $test2)
  (export "test3" $test3)
  ;; ok to modify a global, if we keep it the same value
  (global $mine (mut i32) (i32.const 1))
  (func $test1
    (set_global $mine (i32.const 2))
    (set_global $mine (i32.const 1)) ;; restore!
    (i32.store8 (i32.const 12) (i32.const 115))
  )
  (func $test2
    (set_global $mine (i32.const 2)) ;; embadden
    (i32.store8 (i32.const 13) (i32.const 115))
  )
  (func $test3
    (i32.store8 (i32.const 14) (i32.const 115))
  )
)
