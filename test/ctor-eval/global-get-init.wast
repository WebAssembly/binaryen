(module
  (import "import" "global" (global $imported i32))
  (func $use-global (export "use-global") (result i32)
    (global.get $imported)
  )
  ;; The imported global isn't used in the ctor,
  ;; so we're free to remove it completely.
  (func $test1 (export "test1"))
)
