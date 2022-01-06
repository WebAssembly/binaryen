(module
  (import "import" "global" (global $imported i32))
  (func $test1 (export "test1")
    ;; This should be safe to eval in theory, but the imported global stops us.
    ;; TODO: perhaps if we never use it that is ok?
  )
)
