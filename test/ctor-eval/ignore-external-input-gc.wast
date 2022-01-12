(module
  (global $global1 (mut i32) (i32.const 10))
  (global $global2 (mut i32) (i32.const 20))

  (func "test1" (param $any (ref null any))
    ;; This is ok to call: when ignoring external input we assume 0 for the
    ;; parameters, and this parameter is nullable.
    (drop
      (local.get $any)
    )
    (global.set $global1
      (i32.const 11)
    )
  )

  (func "test2" (param $any (ref any))
    ;; This is *not* ok to call: when ignoring external input we assume 0 for
    ;; the parameters, and this parameter is not nullable.
    (drop
      (local.get $any)
    )
    (global.set $global2
      (i32.const 22)
    )
  )

  (func "keepalive" (result i32)
    (i32.add
      (global.get $global1)
      (global.get $global2)
    )
  )
)
