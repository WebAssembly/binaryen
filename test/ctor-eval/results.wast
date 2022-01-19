(module
  (import "import" "import" (func $import))

  (global $global1 (mut i32) (i32.const 1))
  (global $global2 (mut i32) (i32.const 2))
  (global $global3 (mut i32) (i32.const 3))
  (global $global4 (mut i32) (i32.const 4))
  (global $global5 (mut i32) (i32.const 5))

  (func $test1 (export "test1")
    ;; This function can be evalled. But in this test we keep this export,
    ;; so we should still see an export, but the export should do nothing since
    ;; the code has already run.
    ;;
    ;; In comparison, test3 below, with a result, will still contain a
    ;; (constant) result in the remaining export once we can handle results.

    (global.set $global1
      (i32.const 11)
    )
  )

  (func $test2 (export "test2")
    ;; As the above function, but the export is *not* kept.
    (global.set $global2
      (i32.const 12)
    )
  )

  (func $test3 (export "test3") (result i32)
    ;; The global.set can be evalled. We must then keep returning the 42.
    (global.set $global3
      (i32.const 13)
    )
    (i32.const 42)
  )

  (func $test4 (export "test4") (result i32)
    ;; Similar to the above, but not in a toplevel block format that we can
    ;; eval one item at a time. We will eval this entire function at once, and
    ;; we should succeed. After that we should keep returning the constant 55
    (if (result i32)
      (i32.const 1)
      (block (result i32)
        (global.set $global4
          (i32.const 14)
        )
        (i32.const 55)
      )
      (i32.const 99)
    )
  )

  (func $test5 (export "test5") (result i32)
    ;; Tests partial evalling with a return value at the end. We never reach
    ;; that return value, but we should eval the global.set.
    (global.set $global5
      (i32.const 15)
    )

    (call $import)

    (i32.const 100)
  )

  (func "keepalive" (result i32)
    ;; Keep everything alive to see the changes.

    ;; These should call the original $test1, not the one that is nopped out
    ;; after evalling.
    (call $test1)
    (call $test2)

    (drop
      (call $test3)
    )
    (drop
      (call $test4)
    )
    (drop
      (call $test5)
    )

    ;; Keeping these alive should show the changes to the globals (that should
    ;; contain 11, 12, and 3).
    (i32.add
      (i32.add
        (global.get $global1)
        (global.get $global2)
      )
      (i32.add
        (global.get $global3)
        (i32.add
          (global.get $global4)
          (global.get $global5)
        )
      )
    )
  )
)
