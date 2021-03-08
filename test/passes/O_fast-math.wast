;; with fast-math we can optimize some of these patterns
(module
 (func "div" (result f32)
  (f32.div
   (f32.const -nan:0x23017a)
   (f32.const 1)
  )
 )
 (func "mul1" (result f32)
  (f32.mul
   (f32.const -nan:0x34546d)
   (f32.const 1)
  )
 )
 (func "mul2" (result f32)
  (f32.mul
   (f32.const 1)
   (f32.const -nan:0x34546d)
  )
 )
 (func "add1" (result f32)
  (f32.add
   (f32.const -nan:0x34546d)
   (f32.const -0)
  )
 )
 (func "add2" (result f32)
  (f32.add
   (f32.const -0)
   (f32.const -nan:0x34546d)
  )
 )
 (func "add3" (result f32)
  (f32.add
   (f32.const -nan:0x34546d)
   (f32.const 0)
  )
 )
 (func "add4" (result f32)
  (f32.add
   (f32.const 0)
   (f32.const -nan:0x34546d)
  )
 )
 (func "sub1" (result f32)
  (f32.sub
   (f32.const -nan:0x34546d)
   (f32.const 0)
  )
 )
 (func "sub2" (result f32)
  (f32.sub
   (f32.const -nan:0x34546d)
   (f32.const -0)
  )
 )
 (func "mul_neg_one1" (param $x f32) (result f32)
  (f32.mul
   (local.get $x)
   (f32.const -1)
  )
 )
 (func "mul_neg_one2" (param $x f64) (result f64)
  (f64.mul
   (local.get $x)
   (f64.const -1)
  )
 )
 (func "abs_sub_zero1" (param $x f32) (result f32)
  ;; abs(0 - x)   ==>   abs(x)
  (f32.abs
   (f32.sub
    (f32.const 0)
    (local.get $x)
   )
  )
 )
 (func "abs_sub_zero2" (param $x f64) (result f64)
  ;; abs(0 - x)   ==>   abs(x)
  (f64.abs
   (f64.sub
    (f64.const 0)
    (local.get $x)
   )
  )
 )
)
