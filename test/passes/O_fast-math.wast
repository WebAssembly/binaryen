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
 (func "neg_lhs_32_1" (param $fx f32) (result f32)
  ;; -x * 1  =>  x * -1
  (f32.mul
   (f32.neg (local.get $fx))
   (f32.const 1)
  )
 )
 (func "neg_lhs_32_2" (param $fx f32) (result f32)
  ;; -x / inf  =>  x / -inf
  (f32.div
   (f32.neg (local.get $fx))
   (f32.const inf)
  )
 )
 (func "neg_lhs_64_1" (param $fy f64) (result f64)
  ;; -x * -2.1  =>  x * 2.1
  (f64.mul
   (f64.neg (local.get $fy))
   (f64.const -2.1)
  )
 )
 (func "neg_lhs_64_2" (param $fy f64) (result f64)
  ;; 2 * -x  =>  x * -2
  (f64.mul
   (f64.const 2)
   (f64.neg (local.get $fy))
  )
 )
 (func "neg_lhs_64_3" (param $fy f64) (result f64)
  ;; -x / -0.0  =>  x / 0.0
  (f64.div
   (f64.neg (local.get $fy))
   (f64.const -0.0)
  )
 )
 (func "neg_lhs_64_4" (param $fy f64) (result f64)
  ;; -x / nan  =>  x / -nan
  (f64.div
   (f64.neg (local.get $fy))
   (f64.const nan)
  )
 )
 (func "neg_lhs_64_5" (param $fy f64) (result f64)
  ;; 5.0 / -x  =>  -5 / x
  (f64.div
   (f64.const 5)
   (f64.neg (local.get $fy))
  )
 )
)
