(module
  (import "import" "import" (func $import))

  (memory 256 256)
  (data (i32.const 10) "_________________")

  (export "test1" $test1)
  (export "memory" (memory $0))

  (func $test1
    ;; A safe store, should alter memory
    (i32.store8 (i32.const 12) (i32.const 115))

    ;; Load the value we just saved, and return because of its value. (This way
    ;; we could not see the return must execute without ctor-eval. At least, not
    ;; without store-load forwarding.)
    (if
      (i32.load8_u
        (i32.const 12)
      )
      (return)
    )

    ;; This is unsafe to call, and would stop evalling here. But we exit due to
    ;; the return before anyhow, so it doesn't matter.
    (call $import)

    ;; A safe store that we never reach because of the return before us.
    (i32.store8 (i32.const 13) (i32.const 115))
  )
)
