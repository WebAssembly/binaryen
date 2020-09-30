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
)
