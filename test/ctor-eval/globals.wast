(module
  (global $g1 (mut i32) (i32.const 10))
  (global $g2 (mut i32) (i32.const 20))
  (func $test1 (export "test1")
    (global.set $g1 (i32.const 30))
    (global.set $g2 (i32.const 40))
    (global.set $g1 (i32.const 50)) ;; this overrides the previous 30
  )
  (func $keepalive (export "keepalive") (result i32)
    ;; Keep the globals alive so we can see their values.
    (i32.add
      (global.get $g1)
      (global.get $g2)
    )
  )
)
