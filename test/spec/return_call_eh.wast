;; Test the combination of 'return_call' with exception handling.

(module
  (tag $t)

  (func $test (export "test") (result i32)
    (block $catch
      (return
        (try_table (result i32) (catch_all $catch)
          (call $return-call-in-try_table)
        )
      )
    )
    ;; Catch the exception thrown from $return-callee.
    (i32.const 42)
  )

  (func $return-call-in-try_table (result i32)
    (block $catch
      (try_table (catch_all $catch)
        (return_call $return-callee)
      )
    )
    (unreachable)
  )

  (func $return-callee (result i32)
    (throw $t)
  )
)

(assert_return (invoke "test") (i32.const 42))
