(module
  ;; imports must not be used
  (import "env" "imported" (global $imported i32))

  (memory 256 256)

  (func $test1 (export "test1") (result i32)
    (local $temp i32)

    ;; this errors, and we never get to evalling the store after it
    (local.set $temp
      (global.get $imported)
    )

    (i32.store8
      (i32.const 13)
      (i32.const 115)
    )

    (local.get $temp)
  )

  (func $keepalive (export "keepalive") (result i32)
    (drop
      (i32.load
        (i32.const 13)
      )
    )
    (global.get $imported)
  )
)
