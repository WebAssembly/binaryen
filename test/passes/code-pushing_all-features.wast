(module
  (func $cant-push-past-stuff
    (local $x i32)
    (block $out
      ;; This local.set cannot be pushed down, because the call below can throw
      (local.set $x (i32.const 1))
      (call $cant-push-past-stuff)
      (drop (i32.const 1))
      (br_if $out (i32.const 2))
      (drop (local.get $x))
    )
  )
)
