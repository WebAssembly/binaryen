(module
  (start $start)

  (func $start
    (drop
      (i32.const 1)
    )
  )

  (func $user
    ;; These calls must go to the function $start here (with body "1") and not
    ;; to the modified start that has the third module's content merged in.
    (call $start)
    (call $start)
  )
)
