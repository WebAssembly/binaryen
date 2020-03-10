(module
 (func (export "pair") (result i32 i64)
  (tuple.make
   (i32.const 42)
   (i64.const 7)
  )
 )
)

(assert_return (invoke "pair") (tuple.make (i32.const 42) (i64.const 7)))