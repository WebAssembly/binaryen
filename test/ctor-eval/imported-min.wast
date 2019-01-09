(module
  (memory 256 256)
  (data (i32.const 10) "waka waka waka waka waka")
  ;; stack imports are special
  (import "env" "STACKTOP" (global $STACKTOP$asm2wasm$import i32))
  (import "env" "STACK_MAX" (global $STACK_MAX$asm2wasm$import i32))
  (import "env" "tempDoublePtr" (global $tempDoublePtr i32))
  (global $tempDoublePtrMut (mut i32) (global.get $tempDoublePtr))
  (export "test1" $test1)
  (export "test2" $test2)
  (export "test3" $test3)
  ;; ok to modify a global, if we keep it the same value
  (global $mine (mut i32) (i32.const 1))
  ;; stack imports are ok to use. their uses are the same as other
  ;; globals - must keep the same value (which means, unwind the stack)
  ;; here the global names are "minified"
  (global $global0 (mut i32) (global.get $STACKTOP$asm2wasm$import))
  (global $global1 (mut i32) (global.get $STACK_MAX$asm2wasm$import))
  ;; a global initialized by an import, so bad, but ok if not used
  (global $do-not-use (mut i32) (global.get $tempDoublePtr))
  (func $test1
    (local $temp i32)
    (global.set $mine (i32.const 1))
    (local.set $temp (global.get $global0))
    (global.set $global0 (i32.const 1337)) ;; bad
    (global.set $global0 (local.get $temp)) ;; save us
    (global.set $global1 (i32.const 913370)) ;; bad
    (global.set $global1 (local.get $temp)) ;; save us
    ;; use the stack memory
    (i32.store (local.get $temp) (i32.const 1337))
    (if
      (i32.ne
        (i32.load (local.get $temp))
        (i32.const 1337)
      )
      (unreachable) ;; they should be equal, never get here
    )
    ;; finally, do a valid store
    (i32.store8 (i32.const 12) (i32.const 115))
  )
  (func $test2
    (i32.store8 (i32.const 13) (i32.const 115))
  )
  (func $test3
    (i32.store8 (i32.const 14) (i32.const 115))
  )
)
