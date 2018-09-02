;; Test memory section structure

(module (memory 0 0))
(module (memory 0 1))
(module (memory 1 256))
(module (memory 0 65536))

(assert_invalid (module (memory 0) (memory 0)) "multiple memories")
(assert_invalid (module (memory (import "spectest" "memory") 0) (memory 0)) "multiple memories")

(module (memory (data)) (func (export "memsize") (result i32) (memory.size)))
(assert_return (invoke "memsize") (i32.const 0))
(module (memory (data "")) (func (export "memsize") (result i32) (memory.size)))
(assert_return (invoke "memsize") (i32.const 0))
(module (memory (data "x")) (func (export "memsize") (result i32) (memory.size)))
(assert_return (invoke "memsize") (i32.const 1))

(assert_invalid (module (data (i32.const 0))) "unknown memory")
(assert_invalid (module (data (i32.const 0) "")) "unknown memory")
(assert_invalid (module (data (i32.const 0) "x")) "unknown memory")

(assert_invalid
  (module (func (drop (f32.load (i32.const 0)))))
  "unknown memory"
)
(assert_invalid
  (module (func (f32.store (f32.const 0) (i32.const 0))))
  "unknown memory"
)
(assert_invalid
  (module (func (drop (i32.load8_s (i32.const 0)))))
  "unknown memory"
)
(assert_invalid
  (module (func (i32.store8 (i32.const 0) (i32.const 0))))
  "unknown memory"
)
(assert_invalid
  (module (func (drop (memory.size))))
  "unknown memory"
)
(assert_invalid
  (module (func (drop (memory.grow (i32.const 0)))))
  "unknown memory"
)


(assert_invalid
  (module (memory 1 0))
  "size minimum must not be greater than maximum"
)
(assert_invalid
  (module (memory 65537))
  "memory size must be at most 65536 pages (4GiB)"
)
(assert_invalid
  (module (memory 2147483648))
  "memory size must be at most 65536 pages (4GiB)"
)
(assert_invalid
  (module (memory 4294967295))
  "memory size must be at most 65536 pages (4GiB)"
)
(assert_invalid
  (module (memory 0 65537))
  "memory size must be at most 65536 pages (4GiB)"
)
(assert_invalid
  (module (memory 0 2147483648))
  "memory size must be at most 65536 pages (4GiB)"
)
(assert_invalid
  (module (memory 0 4294967295))
  "memory size must be at most 65536 pages (4GiB)"
)

(module
  (memory 1)
  (data (i32.const 0) "ABC\a7D") (data (i32.const 20) "WASM")

  ;; Data section
  (func (export "data") (result i32)
    (i32.and
      (i32.and
        (i32.and
          (i32.eq (i32.load8_u (i32.const 0)) (i32.const 65))
          (i32.eq (i32.load8_u (i32.const 3)) (i32.const 167))
        )
        (i32.and
          (i32.eq (i32.load8_u (i32.const 6)) (i32.const 0))
          (i32.eq (i32.load8_u (i32.const 19)) (i32.const 0))
        )
      )
      (i32.and
        (i32.and
          (i32.eq (i32.load8_u (i32.const 20)) (i32.const 87))
          (i32.eq (i32.load8_u (i32.const 23)) (i32.const 77))
        )
        (i32.and
          (i32.eq (i32.load8_u (i32.const 24)) (i32.const 0))
          (i32.eq (i32.load8_u (i32.const 1023)) (i32.const 0))
        )
      )
    )
  )

  ;; Memory cast
  (func (export "cast") (result f64)
    (i64.store (i32.const 8) (i64.const -12345))
    (if
      (f64.eq
        (f64.load (i32.const 8))
        (f64.reinterpret/i64 (i64.const -12345))
      )
      (then (return (f64.const 0)))
    )
    (i64.store align=1 (i32.const 9) (i64.const 0))
    (i32.store16 align=1 (i32.const 15) (i32.const 16453))
    (f64.load align=1 (i32.const 9))
  )

  ;; Sign and zero extending memory loads
  (func (export "i32_load8_s") (param $i i32) (result i32)
	(i32.store8 (i32.const 8) (get_local $i))
	(i32.load8_s (i32.const 8))
  )
  (func (export "i32_load8_u") (param $i i32) (result i32)
	(i32.store8 (i32.const 8) (get_local $i))
	(i32.load8_u (i32.const 8))
  )
  (func (export "i32_load16_s") (param $i i32) (result i32)
	(i32.store16 (i32.const 8) (get_local $i))
	(i32.load16_s (i32.const 8))
  )
  (func (export "i32_load16_u") (param $i i32) (result i32)
	(i32.store16 (i32.const 8) (get_local $i))
	(i32.load16_u (i32.const 8))
  )
  (func (export "i64_load8_s") (param $i i64) (result i64)
	(i64.store8 (i32.const 8) (get_local $i))
	(i64.load8_s (i32.const 8))
  )
  (func (export "i64_load8_u") (param $i i64) (result i64)
	(i64.store8 (i32.const 8) (get_local $i))
	(i64.load8_u (i32.const 8))
  )
  (func (export "i64_load16_s") (param $i i64) (result i64)
	(i64.store16 (i32.const 8) (get_local $i))
	(i64.load16_s (i32.const 8))
  )
  (func (export "i64_load16_u") (param $i i64) (result i64)
	(i64.store16 (i32.const 8) (get_local $i))
	(i64.load16_u (i32.const 8))
  )
  (func (export "i64_load32_s") (param $i i64) (result i64)
	(i64.store32 (i32.const 8) (get_local $i))
	(i64.load32_s (i32.const 8))
  )
  (func (export "i64_load32_u") (param $i i64) (result i64)
	(i64.store32 (i32.const 8) (get_local $i))
	(i64.load32_u (i32.const 8))
  )
)

(assert_return (invoke "data") (i32.const 1))
(assert_return (invoke "cast") (f64.const 42.0))

(assert_return (invoke "i32_load8_s" (i32.const -1)) (i32.const -1))
(assert_return (invoke "i32_load8_u" (i32.const -1)) (i32.const 255))
(assert_return (invoke "i32_load16_s" (i32.const -1)) (i32.const -1))
(assert_return (invoke "i32_load16_u" (i32.const -1)) (i32.const 65535))

(assert_return (invoke "i32_load8_s" (i32.const 100)) (i32.const 100))
(assert_return (invoke "i32_load8_u" (i32.const 200)) (i32.const 200))
(assert_return (invoke "i32_load16_s" (i32.const 20000)) (i32.const 20000))
(assert_return (invoke "i32_load16_u" (i32.const 40000)) (i32.const 40000))

(assert_return (invoke "i32_load8_s" (i32.const 0xfedc6543)) (i32.const 0x43))
(assert_return (invoke "i32_load8_s" (i32.const 0x3456cdef)) (i32.const 0xffffffef))
(assert_return (invoke "i32_load8_u" (i32.const 0xfedc6543)) (i32.const 0x43))
(assert_return (invoke "i32_load8_u" (i32.const 0x3456cdef)) (i32.const 0xef))
(assert_return (invoke "i32_load16_s" (i32.const 0xfedc6543)) (i32.const 0x6543))
(assert_return (invoke "i32_load16_s" (i32.const 0x3456cdef)) (i32.const 0xffffcdef))
(assert_return (invoke "i32_load16_u" (i32.const 0xfedc6543)) (i32.const 0x6543))
(assert_return (invoke "i32_load16_u" (i32.const 0x3456cdef)) (i32.const 0xcdef))

(assert_return (invoke "i64_load8_s" (i64.const -1)) (i64.const -1))
(assert_return (invoke "i64_load8_u" (i64.const -1)) (i64.const 255))
(assert_return (invoke "i64_load16_s" (i64.const -1)) (i64.const -1))
(assert_return (invoke "i64_load16_u" (i64.const -1)) (i64.const 65535))
(assert_return (invoke "i64_load32_s" (i64.const -1)) (i64.const -1))
(assert_return (invoke "i64_load32_u" (i64.const -1)) (i64.const 4294967295))

(assert_return (invoke "i64_load8_s" (i64.const 100)) (i64.const 100))
(assert_return (invoke "i64_load8_u" (i64.const 200)) (i64.const 200))
(assert_return (invoke "i64_load16_s" (i64.const 20000)) (i64.const 20000))
(assert_return (invoke "i64_load16_u" (i64.const 40000)) (i64.const 40000))
(assert_return (invoke "i64_load32_s" (i64.const 20000)) (i64.const 20000))
(assert_return (invoke "i64_load32_u" (i64.const 40000)) (i64.const 40000))

(assert_return (invoke "i64_load8_s" (i64.const 0xfedcba9856346543)) (i64.const 0x43))
(assert_return (invoke "i64_load8_s" (i64.const 0x3456436598bacdef)) (i64.const 0xffffffffffffffef))
(assert_return (invoke "i64_load8_u" (i64.const 0xfedcba9856346543)) (i64.const 0x43))
(assert_return (invoke "i64_load8_u" (i64.const 0x3456436598bacdef)) (i64.const 0xef))
(assert_return (invoke "i64_load16_s" (i64.const 0xfedcba9856346543)) (i64.const 0x6543))
(assert_return (invoke "i64_load16_s" (i64.const 0x3456436598bacdef)) (i64.const 0xffffffffffffcdef))
(assert_return (invoke "i64_load16_u" (i64.const 0xfedcba9856346543)) (i64.const 0x6543))
(assert_return (invoke "i64_load16_u" (i64.const 0x3456436598bacdef)) (i64.const 0xcdef))
(assert_return (invoke "i64_load32_s" (i64.const 0xfedcba9856346543)) (i64.const 0x56346543))
(assert_return (invoke "i64_load32_s" (i64.const 0x3456436598bacdef)) (i64.const 0xffffffff98bacdef))
(assert_return (invoke "i64_load32_u" (i64.const 0xfedcba9856346543)) (i64.const 0x56346543))
(assert_return (invoke "i64_load32_u" (i64.const 0x3456436598bacdef)) (i64.const 0x98bacdef))

(assert_malformed
  (module quote
    "(memory 1)"
    "(func (param i32) (result i32) (i32.load32 (get_local 0)))"
  )
  "unknown operator"
)
(assert_malformed
  (module quote
    "(memory 1)"
    "(func (param i32) (result i32) (i32.load32_u (get_local 0)))"
  )
  "unknown operator"
)
(assert_malformed
  (module quote
    "(memory 1)"
    "(func (param i32) (result i32) (i32.load32_s (get_local 0)))"
  )
  "unknown operator"
)
(assert_malformed
  (module quote
    "(memory 1)"
    "(func (param i32) (result i32) (i32.load64 (get_local 0)))"
  )
  "unknown operator"
)
(assert_malformed
  (module quote
    "(memory 1)"
    "(func (param i32) (result i32) (i32.load64_u (get_local 0)))"
  )
  "unknown operator"
)
(assert_malformed
  (module quote
    "(memory 1)"
    "(func (param i32) (result i32) (i32.load64_s (get_local 0)))"
  )
  "unknown operator"
)
(assert_malformed
  (module quote
    "(memory 1)"
    "(func (param i32) (i32.store32 (get_local 0) (i32.const 0)))"
  )
  "unknown operator"
)
(assert_malformed
  (module quote
    "(memory 1)"
    "(func (param i32) (i32.store64 (get_local 0) (i64.const 0)))"
  )
  "unknown operator"
)

(assert_malformed
  (module quote
    "(memory 1)"
    "(func (param i32) (result i64) (i64.load64 (get_local 0)))"
  )
  "unknown operator"
)
(assert_malformed
  (module quote
    "(memory 1)"
    "(func (param i32) (result i64) (i64.load64_u (get_local 0)))"
  )
  "unknown operator"
)
(assert_malformed
  (module quote
    "(memory 1)"
    "(func (param i32) (result i64) (i64.load64_s (get_local 0)))"
  )
  "unknown operator"
)
(assert_malformed
  (module quote
    "(memory 1)"
    "(func (param i32) (i64.store64 (get_local 0) (i64.const 0)))"
  )
  "unknown operator"
)

(assert_malformed
  (module quote
    "(memory 1)"
    "(func (param i32) (result f32) (f32.load32 (get_local 0)))"
  )
  "unknown operator"
)
(assert_malformed
  (module quote
    "(memory 1)"
    "(func (param i32) (result f32) (f32.load64 (get_local 0)))"
  )
  "unknown operator"
)
(assert_malformed
  (module quote
    "(memory 1)"
    "(func (param i32) (f32.store32 (get_local 0) (f32.const 0)))"
  )
  "unknown operator"
)
(assert_malformed
  (module quote
    "(memory 1)"
    "(func (param i32) (f32.store64 (get_local 0) (f64.const 0)))"
  )
  "unknown operator"
)

(assert_malformed
  (module quote
    "(memory 1)"
    "(func (param i32) (result f64) (f64.load32 (get_local 0)))"
  )
  "unknown operator"
)
(assert_malformed
  (module quote
    "(memory 1)"
    "(func (param i32) (result f64) (f64.load64 (get_local 0)))"
  )
  "unknown operator"
)
(assert_malformed
  (module quote
    "(memory 1)"
    "(func (param i32) (f64.store32 (get_local 0) (f32.const 0)))"
  )
  "unknown operator"
)
(assert_malformed
  (module quote
    "(memory 1)"
    "(func (param i32) (f64.store64 (get_local 0) (f64.const 0)))"
  )
  "unknown operator"
)
