(module
 (type $0 (func (param i32) (result i32)))
 (type $1 (func (result i32)))
 (memory $0 1)
 (export "memory" (memory $0))
 (export "f1" (func $0))
 (export "f2" (func $1))

 (func $0 (result i32)
  (block
    (i32.store (i32.const 0) (grow_memory (i32.const 1)))
    (i32.load (i32.const 0))
  )
 )

 (func $1 (result i32)
  (block
    (i32.store (i32.const 0) (call $grow))
    (i32.load (i32.const 0))
  )
 )

 (func $grow (result i32)
  (grow_memory (i32.const 1))
 )
)


(assert_return (invoke "f1") (i32.const 1))
(assert_return (invoke "f2") (i32.const 2))
