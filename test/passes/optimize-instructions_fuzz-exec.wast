(module
 (import "fuzzing-support" "log-f32" (func $logf32 (param f32)))
 (import "fuzzing-support" "log-f64" (func $logf64 (param f64)))
 (func "test32"
  (call $logf32
   (f32.add
    (f32.const -nan:0xffff82)
    (f32.neg
     (f32.const -nan:0xfff622)
    )
   )
  )
  (call $logf32
   (f32.sub
    (f32.const -nan:0xffff82)
    (f32.neg
     (f32.const -nan:0xfff622)
    )
   )
  )
  (call $logf32
   (f32.mul
    (f32.const -nan:0xffff82)
    (f32.neg
     (f32.const -nan:0xfff622)
    )
   )
  )
  (call $logf32
   (f32.div
    (f32.const -nan:0xffff82)
    (f32.neg
     (f32.const -nan:0xfff622)
    )
   )
  )
  (call $logf32
   (f32.copysign
    (f32.const -nan:0xffff82)
    (f32.neg
     (f32.const -nan:0xfff622)
    )
   )
  )
  (call $logf32
   (f32.min
    (f32.const -nan:0xffff82)
    (f32.neg
     (f32.const -nan:0xfff622)
    )
   )
  )
  (call $logf32
   (f32.max
    (f32.const -nan:0xffff82)
    (f32.neg
     (f32.const -nan:0xfff622)
    )
   )
  )
 )
 (func "test64"
  (call $logf64
   (f64.add
    (f64.const -nan:0xfffffffffff82)
    (f64.neg
     (f64.const -nan:0xfffffffffa622)
    )
   )
  )
  (call $logf64
   (f64.sub
    (f64.const -nan:0xfffffffffff82)
    (f64.neg
     (f64.const -nan:0xfffffffffa622)
    )
   )
  )
  (call $logf64
   (f64.mul
    (f64.const -nan:0xfffffffffff82)
    (f64.neg
     (f64.const -nan:0xfffffffffa622)
    )
   )
  )
  (call $logf64
   (f64.div
    (f64.const -nan:0xfffffffffff82)
    (f64.neg
     (f64.const -nan:0xfffffffffa622)
    )
   )
  )
  (call $logf64
   (f64.copysign
    (f64.const -nan:0xfffffffffff82)
    (f64.neg
     (f64.const -nan:0xfffffffffa622)
    )
   )
  )
  (call $logf64
   (f64.min
    (f64.const -nan:0xfffffffffff82)
    (f64.neg
     (f64.const -nan:0xfffffffffa622)
    )
   )
  )
  (call $logf64
   (f64.max
    (f64.const -nan:0xfffffffffff82)
    (f64.neg
     (f64.const -nan:0xfffffffffa622)
    )
   )
  )
 )
 (func "ignore"
  ;; none of these are nan inputs, so the interpreter must not change the sign
  (call $logf32
   (f32.div
    (f32.const 0)
    (f32.neg
     (f32.const 0)
    )
   )
  )
  (call $logf32
   (f32.div
    (f32.const -0)
    (f32.neg
     (f32.const 0)
    )
   )
  )
  (call $logf32
   (f32.div
    (f32.const 0)
    (f32.neg
     (f32.const -0)
    )
   )
  )
  (call $logf32
   (f32.div
    (f32.const -0)
    (f32.neg
     (f32.const -0)
    )
   )
  )
 )
)

