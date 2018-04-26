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

