;; Test that we can run GC types through the optimizer
(module
  (type $struct.A (struct i32))

  (func "foo" (param $x (ref null $struct.A))
    ;; get a struct reference
    (drop
      (local.get $x)
    )
    ;; get a struct field value
    ;; (note that since this is a nullable reference, it may trap)
    (drop
      (struct.get $struct.A 0 (local.get $x))
    )
  )
)
