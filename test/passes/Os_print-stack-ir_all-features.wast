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
  ;; These are not valid usages of pops - they are not meant to be
  ;; used alone. This just tests we can emit them/handle them in the
  ;; optimizer.
  (func "ppi32" (result i32)
    (pop i32)
  )
  (func "ppi64" (result i64)
    (pop i64)
  )
  (func "ppf32" (result f32)
    (pop f32)
  )
  (func "ppf64" (result f64)
    (pop f64)
  )
  (func "pair" (result i32 f64)
    (pop i32 f64)
  )
)
