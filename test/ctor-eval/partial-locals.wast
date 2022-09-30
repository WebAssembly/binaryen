(module
  (import "import" "import" (func $import))

  (memory 256 256)
  (data (i32.const 10) "_________________")

  (export "test1" $test1)

  (global $sp (mut i32) (i32.const 100))

  (func $test1
    (local $temp-sp i32)

    ;; Save and bump the stack pointer.
    (local.set $temp-sp
      (global.get $sp)
    )
    (global.set $sp
      (i32.add
        (global.get $sp)
        (i32.const 4)
      )
    )

    ;; A safe store, should alter memory
    (i32.store8 (i32.const 12) (i32.const 115))

    ;; A call to an import, which prevents evalling. We will stop here. After
    ;; optimization we'll serialize the value of $temp-sp so that when the
    ;; code is run later it runs properly.
    ;;
    ;; (Also, the global $sp will contain 104, the value after the bump.)
    (call $import)

    ;; A safe store that we never reach
    (i32.store8 (i32.const 13) (i32.const 115))

    ;; Restore the stack pointer.
    (global.set $sp
      (local.get $temp-sp)
    )
  )
)
