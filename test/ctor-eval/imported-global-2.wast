(module
  (memory 256 256)

  ;; imports must not be used
  (import "env" "imported" (global $imported i32))

  (func "test1"
    ;; this errors, and we never get to evalling the store after it
    (drop (global.get $imported))

    (i32.store8
      (i32.const 13)
      (i32.const 115)
    )
  )

  (func "keepalive"
    (drop
      (i32.load
        (i32.const 13)
      )
    )
  )
)
