(module
 (export "stacky-help" (func $stacky-help))
 (func $stacky-help (param $x i32) (result i32)
  (local $temp i32)
  (i32.add
   (call $stacky-help (i32.const 0))
   (i32.eqz
    (block (result i32) ;; after we use the stack instead of the local, we can remove this block
     (local.set $temp (call $stacky-help (i32.const 1)))
     (drop (call $stacky-help (i32.const 2)))
     (local.get $temp)
    )
   )
  )
 )
)
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
)

