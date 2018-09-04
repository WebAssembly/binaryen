(module
  (type $T (func (result i32)))
  (table 4 anyfunc)
  (elem (i32.const 1) $t1 $t2 $t3)

  (func $t1 (type $T) (i32.const 1))
  (func $t2 (type $T) (i32.const 2))
  (func $t3 (type $T) (i32.const 3))

  (func (export "call") (param i32) (result i32)
    (call_indirect (type $T) (get_local $0))
  )
)

(assert_return (invoke "call" (i32.const 1)) (i32.const 1))
(assert_return (invoke "call" (i32.const 2)) (i32.const 2))
(assert_return (invoke "call" (i32.const 3)) (i32.const 3))
