(module
  (import "import" "import" (func $import))

  (memory 256 256)
  (data (i32.const 10) "_________________")

  (export "test1" $test1)
  (export "memory" (memory $0))

  (func $test1 (result i32)
    ;; A safe store, should alter memory
    (i32.store8 (i32.const 12) (i32.const 115))

    ;; A load which is the result of the function, which will be computed.
    (i32.load8_u
      (i32.const 12)
    )
  )
)
