(module
 (export "a" (func $a))
 (export "b" (func $b))
 (export "c" (func $c))
 (export "d" (func $d))
 (export "e" (func $e))
 (func $a (result i32)
  (i32.extend8_s
   (i32.const 187)
  )
 )
 (func $b (result i32)
  (i32.extend16_s
   (i32.const 33768)
  )
 )
 (func $c (result i64)
  (i64.extend8_s
   (i64.const 187)
  )
 )
 (func $d (result i64)
  (i64.extend16_s
   (i64.const 33768)
  )
 )
 (func $e (result i64)
  (i64.extend32_s
   (i64.const 2148318184)
  )
 )
)

