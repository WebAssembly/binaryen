(module
 (memory $0 1 2)
 (export "memory" (memory $0))
 (export "grow" (func $grow))
 (export "size" (func $size))

 (func $grow (param i32) (result i32)
  (memory.grow (local.get 0))
 )

 (func $size (result i32)
  (memory.size)
 )
)

;; The initial size is 1 page, max is 2 pages.
;; Growing by 1 should succeed (1+1=2 <= max).
(assert_return (invoke "size") (i32.const 1))
(assert_return (invoke "grow" (i32.const 1)) (i32.const 1))
(assert_return (invoke "size") (i32.const 2))
;; Growing by 1 more should fail (2+1=3 > max).
;; The size should remain at 2.
;; FIXME: Failing to grow should actually return -1, not the old size.
(assert_return (invoke "grow" (i32.const 1)) (i32.const 2))
(assert_return (invoke "size") (i32.const 2))
