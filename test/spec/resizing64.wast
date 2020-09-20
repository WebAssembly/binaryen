(module
    (memory i64 0)

    (func (export "load_at_zero") (result i32) (i32.load (i64.const 0)))
    (func (export "store_at_zero") (i32.store (i64.const 0) (i32.const 2)))

    (func (export "load_at_page_size") (result i32) (i32.load (i64.const 0x10000)))
    (func (export "store_at_page_size") (i32.store (i64.const 0x10000) (i32.const 3)))

    (func (export "grow") (param $sz i64) (result i64) (memory.grow (local.get $sz)))
    (func (export "size") (result i64) (memory.size))
)

(assert_return (invoke "size") (i64.const 0))
(assert_trap (invoke "store_at_zero") "out of bounds memory access")
(assert_trap (invoke "load_at_zero") "out of bounds memory access")
(assert_trap (invoke "store_at_page_size") "out of bounds memory access")
(assert_trap (invoke "load_at_page_size") "out of bounds memory access")
(assert_return (invoke "grow" (i64.const 1)) (i64.const 0))
(assert_return (invoke "size") (i64.const 1))
(assert_return (invoke "load_at_zero") (i32.const 0))
(assert_return (invoke "store_at_zero"))
(assert_return (invoke "load_at_zero") (i32.const 2))
(assert_trap (invoke "store_at_page_size") "out of bounds memory access")
(assert_trap (invoke "load_at_page_size") "out of bounds memory access")
(assert_return (invoke "grow" (i64.const 4)) (i64.const 1))
(assert_return (invoke "size") (i64.const 5))
(assert_return (invoke "load_at_zero") (i32.const 2))
(assert_return (invoke "store_at_zero"))
(assert_return (invoke "load_at_zero") (i32.const 2))
(assert_return (invoke "load_at_page_size") (i32.const 0))
(assert_return (invoke "store_at_page_size"))
(assert_return (invoke "load_at_page_size") (i32.const 3))


(module
  (memory i64 0)
  (func (export "grow") (param i64) (result i64) (memory.grow (local.get 0)))
)

(assert_return (invoke "grow" (i64.const 0)) (i64.const 0))
(assert_return (invoke "grow" (i64.const 1)) (i64.const 0))
(assert_return (invoke "grow" (i64.const 0)) (i64.const 1))
(assert_return (invoke "grow" (i64.const 2)) (i64.const 1))
(assert_return (invoke "grow" (i64.const 10000)) (i64.const 3))

(module
  (memory i64 0 10)
  (func (export "grow") (param i64) (result i64) (memory.grow (local.get 0)))
)

(assert_return (invoke "grow" (i64.const 0)) (i64.const 0))
(assert_return (invoke "grow" (i64.const 1)) (i64.const 0))
(assert_return (invoke "grow" (i64.const 1)) (i64.const 1))
(assert_return (invoke "grow" (i64.const 2)) (i64.const 2))
(assert_return (invoke "grow" (i64.const 6)) (i64.const 4))
(assert_return (invoke "grow" (i64.const 0)) (i64.const 10))
(assert_return (invoke "grow" (i64.const 1)) (i64.const -1))
