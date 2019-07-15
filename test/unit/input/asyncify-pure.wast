(module
  (memory 1 1)
  (import "spectest" "print" (func $print (param i32)))
  (import "asyncify" "start_unwind" (func $asyncify_start_unwind (param i32)))
  (import "asyncify" "stop_unwind" (func $asyncify_stop_unwind))
  (import "asyncify" "start_rewind" (func $asyncify_start_rewind (param i32)))
  (import "asyncify" "stop_rewind" (func $asyncify_stop_rewind))
  (global $sleeping (mut i32) (i32.const 0))
  (start $runtime)
  (func $main
    (call $print (i32.const 10))
    (call $before)
    (call $print (i32.const 20))
    (call $sleep)
    (call $print (i32.const 30))
    (call $after)
    (call $print (i32.const 40))
  )
  (func $before
    (call $print (i32.const 1))
  )
  (func $sleep
    (call $print (i32.const 1000))
    (if
      (i32.eqz (global.get $sleeping))
      (block
        (call $print (i32.const 2000))
        (global.set $sleeping (i32.const 1))
        (i32.store (i32.const 16) (i32.const 24))
        (i32.store (i32.const 20) (i32.const 1024))
        (call $asyncify_start_unwind (i32.const 16))
      )
      (block
        (call $print (i32.const 3000))
        (call $asyncify_stop_rewind)
        (global.set $sleeping (i32.const 0))
      )
    )
    (call $print (i32.const 4000))
  )
  (func $after
    (call $print (i32.const 2))
  )
  (func $runtime
    (call $print (i32.const 100))
    ;; call main the first time, let the stack unwind
    (call $main)
    (call $print (i32.const 200))
    (call $asyncify_stop_unwind)
    (call $print (i32.const 300))
    ;; ...can do some async stuff around here...
    ;; set the rewind in motion
    (call $asyncify_start_rewind (i32.const 16))
    (call $print (i32.const 400))
    (call $main)
    (call $print (i32.const 500))
  )
)

