(module
  (import "import" "global" (global $imported i32))
  (func $test1 (export "test1")
    ;; This should be safe to eval in theory, but the imported global stops us,
    ;; so this function will not be optimized out.
    ;; TODO: perhaps if we never use that global that is ok?
  )
)
