(module
  ;; These are not quite valid usages of push/pop - they are not meant to be used
  ;; with each other. This just tests we can emit them/handle them in the optimizer.
  ;; Once we have proper places to use them, we can tighten up the validation and
  ;; replace this test with something correct.
  (func "ppi32" (result i32)
    (push (i32.const 1))
    (i32.pop)
  )
  (func "ppi64" (result i64)
    (push (i64.const 1))
    (i64.pop)
  )
  (func "ppf32" (result f32)
    (push (f32.const 1))
    (f32.pop)
  )
  (func "ppf64" (result f64)
    (push (f64.const 1))
    (f64.pop)
  )
  (func "ppanyref" (result anyref) (local $any anyref)
    (push (local.get $any))
    (anyref.pop)
  )
  (func "ppfuncref" (result funcref) (local $fn funcref)
    (push (local.get $fn))
    (funcref.pop)
  )
  (func "ppnullref"
    (push (ref.null))
    (drop (nullref.pop))
  )
  (func "ppexnref" (result exnref) (local $exn exnref)
    (push (local.get $exn))
    (exnref.pop)
  )
)

