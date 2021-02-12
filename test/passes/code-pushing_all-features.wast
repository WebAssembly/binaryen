(module
  (event $e (attr 0) (param i32))

  (func $cant-push-past-call
    (local $x i32)
    (block $out
      ;; This local.set cannot be pushed down, because the call below can throw
      (local.set $x (i32.const 1))
      (call $cant-push-past-call)
      (drop (i32.const 1))
      (br_if $out (i32.const 2))
      (drop (local.get $x))
    )
  )

  (func $cant-push-past-throw
    (local $x i32)
    (block $out
      ;; This local.set cannot be pushed down, because there is 'throw' below
      (local.set $x (i32.const 1))
      (throw $e (i32.const 0))
      (drop (i32.const 1))
      (br_if $out (i32.const 2))
      (drop (local.get $x))
    )
  )

  (func $can-push-past-try
    (local $x i32)
    (block $out
      ;; This local.set can be pushed down, because the 'throw' below is going
      ;; to be caught by the inner catch_all
      (local.set $x (i32.const 1))
      (try
        (do
          (throw $e (i32.const 0))
        )
        (catch_all
          (drop (pop i32))
        )
      )
      (drop (i32.const 1))
      (br_if $out (i32.const 2))
      (drop (local.get $x))
    )
  )

  (func $foo)
  (func $cant-push-past-try
    (local $x i32)
    (block $out
      ;; This local.set cannot be pushed down, because the exception thrown by
      ;; 'call $foo' below may not be caught by 'catch $e'
      (local.set $x (i32.const 1))
      (try
        (do
          (call $foo)
        )
        (catch $e
          (drop (pop i32))
        )
      )
      (drop (i32.const 1))
      (br_if $out (i32.const 2))
      (drop (local.get $x))
    )
  )

  (func $cant-push-past-rethrow-within-catch
    (local $x i32)
    (block $out
      ;; This local.set cannot be pushed down, because there is 'rethrow' within
      ;; the inner catch_all
      (local.set $x (i32.const 1))
      (try $l0
        (do
          (throw $e (i32.const 0))
        )
        (catch_all
          (rethrow $l0)
        )
      )
      (drop (i32.const 1))
      (br_if $out (i32.const 2))
      (drop (local.get $x))
    )
  )
)
