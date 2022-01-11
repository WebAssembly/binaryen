(module
  (global $global1 (mut i32) (i32.const 0))
  (global $global2 (mut i32) (i32.const 1))

  (func "test1"
    ;; This function can be evalled. But in this test we keep this export,
    ;; so we should still see an export, but the export should do nothing since
    ;; the code has already run.
    ;;
    ;; In comparison, test3 below, with a result, will still contain a
    ;; (constant) result in the remaining export once we can handle results.

    (global.set $global1
      (i32.const 2)
    )
  )

  (func "test2"
    ;; As the above function, but the export is *not* kept.
    (global.set $global2
      (i32.const 3)
    )
  )

  (func "test3" (result i32)
    ;; The presence of a result stops us from evalling this function (at least
    ;; for now).
    (i32.const 42)
  )

  (func "keepalive" (result i32)
    (i32.add
      (global.get $global1)
      (global.get $global2)
    )
  )
)
