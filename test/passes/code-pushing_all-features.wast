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

  (func $can-push-past-throw-within-try
    (local $x i32)
    (block $out
      ;; This local.set can be pushed down, because the 'throw' below is going
      ;; to be caught by the inner catch
      (local.set $x (i32.const 1))
      (try
        (do
          (throw $e (i32.const 0))
        )
        (catch
          (drop (pop exnref))
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
      ;; the inner catch
      (local.set $x (i32.const 1))
      (try
        (do
          (throw $e (i32.const 0))
        )
        (catch
          (rethrow (pop exnref))
        )
      )
      (drop (i32.const 1))
      (br_if $out (i32.const 2))
      (drop (local.get $x))
    )
  )

  (func $push-past-br-on-exn
    (local $x i32)
    (local $y exnref)
    (drop
      (block $out (result i32)
        (local.set $x (i32.const 1))
        (drop
          (br_on_exn $out $e (local.get $y))
        )
        (local.get $x)
      )
    )
  )
)
