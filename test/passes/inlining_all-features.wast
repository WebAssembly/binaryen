(module
  (export "test" (func $test))
  ;; $foo should not be removed after being inlined, because there is 'ref.func'
  ;; instruction that refers to it
  (func $foo)
  (func $test (result funcref)
    (call $foo)
    (ref.func $foo)
  )
)
