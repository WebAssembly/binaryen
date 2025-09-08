(module
 (global $g (mut i32) (i32.const 0))

 (func $test (export "test")
  ;; Loops without labels. We should not emit anything invalid here (like a
  ;; null name, which would end up identical between the two, which is wrong).
  (loop
   (loop
    ;; Some content, so the loop is not trivial.
    (global.set $g
     (i32.const 0)
    )
    (unreachable)
   )
   (unreachable)
  )
 )
)
