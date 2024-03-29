;; Test the combination of 'return_call' with exception handling

(module
  (tag $t)

  (func $test (export "test") (result i32)
    (try (result i32)
      (do
        (call $return-call-in-try)
      )
      (catch_all
        ;; Catch the exception thrown from $return-callee
        (i32.const 42)
      )
    )

  )

  (func $return-call-in-try (result i32)
    (try (result i32)
      (do
        (return_call $return-callee)
      )
      (catch_all
        (unreachable)
      )
    )
  )

  (func $return-callee (result i32)
   (throw $t)
  )
)

(assert_return (invoke "test") (i32.const 42))
