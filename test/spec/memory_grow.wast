(module
    (memory 0)

    (func (export "load_at_zero") (result i32) (i32.load (i32.const 0)))
    (func (export "store_at_zero") (i32.store (i32.const 0) (i32.const 2)))

    (func (export "load_at_page_size") (result i32) (i32.load (i32.const 0x10000)))
    (func (export "store_at_page_size") (i32.store (i32.const 0x10000) (i32.const 3)))

    (func (export "grow") (param $sz i32) (result i32) (memory.grow (get_local $sz)))
    (func (export "size") (result i32) (memory.size))
)

(assert_return (invoke "size") (i32.const 0))
(assert_trap (invoke "store_at_zero") "out of bounds memory access")
(assert_trap (invoke "load_at_zero") "out of bounds memory access")
(assert_trap (invoke "store_at_page_size") "out of bounds memory access")
(assert_trap (invoke "load_at_page_size") "out of bounds memory access")
(assert_return (invoke "grow" (i32.const 1)) (i32.const 0))
(assert_return (invoke "size") (i32.const 1))
(assert_return (invoke "load_at_zero") (i32.const 0))
(assert_return (invoke "store_at_zero"))
(assert_return (invoke "load_at_zero") (i32.const 2))
(assert_trap (invoke "store_at_page_size") "out of bounds memory access")
(assert_trap (invoke "load_at_page_size") "out of bounds memory access")
(assert_return (invoke "grow" (i32.const 4)) (i32.const 1))
(assert_return (invoke "size") (i32.const 5))
(assert_return (invoke "load_at_zero") (i32.const 2))
(assert_return (invoke "store_at_zero"))
(assert_return (invoke "load_at_zero") (i32.const 2))
(assert_return (invoke "load_at_page_size") (i32.const 0))
(assert_return (invoke "store_at_page_size"))
(assert_return (invoke "load_at_page_size") (i32.const 3))


(module
  (memory 0)
  (func (export "grow") (param i32) (result i32) (memory.grow (get_local 0)))
)

(assert_return (invoke "grow" (i32.const 0)) (i32.const 0))
(assert_return (invoke "grow" (i32.const 1)) (i32.const 0))
(assert_return (invoke "grow" (i32.const 0)) (i32.const 1))
(assert_return (invoke "grow" (i32.const 2)) (i32.const 1))
(assert_return (invoke "grow" (i32.const 800)) (i32.const 3))
(assert_return (invoke "grow" (i32.const 0x10000)) (i32.const -1))
(assert_return (invoke "grow" (i32.const 64736)) (i32.const -1))
(assert_return (invoke "grow" (i32.const 1)) (i32.const 803))

(module
  (memory 0 10)
  (func (export "grow") (param i32) (result i32) (memory.grow (get_local 0)))
)

(assert_return (invoke "grow" (i32.const 0)) (i32.const 0))
(assert_return (invoke "grow" (i32.const 1)) (i32.const 0))
(assert_return (invoke "grow" (i32.const 1)) (i32.const 1))
(assert_return (invoke "grow" (i32.const 2)) (i32.const 2))
(assert_return (invoke "grow" (i32.const 6)) (i32.const 4))
(assert_return (invoke "grow" (i32.const 0)) (i32.const 10))
(assert_return (invoke "grow" (i32.const 1)) (i32.const -1))
(assert_return (invoke "grow" (i32.const 0x10000)) (i32.const -1))

;; Test that newly allocated memory (program start and memory.grow) is zeroed

(module
  (memory 1)
  (func (export "grow") (param i32) (result i32)
    (memory.grow (get_local 0))
  )
  (func (export "check-memory-zero") (param i32 i32) (result i32)
    (local i32)
    (set_local 2 (i32.const 1))
    (block
      (loop
        (set_local 2 (i32.load8_u (get_local 0)))
        (br_if 1 (i32.ne (get_local 2) (i32.const 0)))
        (br_if 1 (i32.ge_u (get_local 0) (get_local 1)))
        (set_local 0 (i32.add (get_local 0) (i32.const 1)))
        (br_if 0 (i32.le_u (get_local 0) (get_local 1)))
      )
    )
    (get_local 2)
  )
)

(assert_return (invoke "check-memory-zero" (i32.const 0) (i32.const 0xffff)) (i32.const 0))
(assert_return (invoke "grow" (i32.const 1)) (i32.const 1))
(assert_return (invoke "check-memory-zero" (i32.const 0x10000) (i32.const 0x1_ffff)) (i32.const 0))
(assert_return (invoke "grow" (i32.const 1)) (i32.const 2))
(assert_return (invoke "check-memory-zero" (i32.const 0x20000) (i32.const 0x2_ffff)) (i32.const 0))
(assert_return (invoke "grow" (i32.const 1)) (i32.const 3))
(assert_return (invoke "check-memory-zero" (i32.const 0x30000) (i32.const 0x3_ffff)) (i32.const 0))
(assert_return (invoke "grow" (i32.const 1)) (i32.const 4))
(assert_return (invoke "check-memory-zero" (i32.const 0x40000) (i32.const 0x4_ffff)) (i32.const 0))
(assert_return (invoke "grow" (i32.const 1)) (i32.const 5))
(assert_return (invoke "check-memory-zero" (i32.const 0x50000) (i32.const 0x5_ffff)) (i32.const 0))
