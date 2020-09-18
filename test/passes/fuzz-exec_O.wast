(module
 (memory $0 1 1)
 (export "func_0" (func $func_0))
 (export "func_1" (func $func_1))
 (func $func_0 (result i64)
  (block $label$0 (result i64)
   (loop $label$1 (result i64)
    (br_if $label$0
     (i64.const 1234)
     (i32.load16_s offset=22 align=1
      (i32.const -1)
     )
    )
   )
  )
 )
 (func $func_1 (result i32)
  (i32.load16_s offset=22 align=1
   (i32.const -1)
  )
 )
)
(module
 (func "div" (result f32)
  (f32.div                   ;; div by 1 can be removed, leaving this nan
   (f32.const -nan:0x23017a) ;; as it is. wasm semantics allow nan bits to
   (f32.const 1)             ;; change, but the interpreter should not do so,
  )                          ;; so that it does not fail on that opt.
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
   (f32.const 0)
  )
 )
 (func "add2" (result f32)
  (f32.add
   (f32.const 0)
   (f32.const -nan:0x34546d)
  )
 )
 (func "sub" (result f32)
  (f32.sub
   (f32.const -nan:0x34546d)
   (f32.const 0)
  )
 )
)
