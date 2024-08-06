;; Test float 16 operations.

(module
  (memory (data "\40\51\AD\DE"))

  (func (export "f32.load_f16") (result f32) (f32.load_f16 (i32.const 0)))
  (func (export "f32.store_f16") (f32.store_f16 (i32.const 0) (f32.const 100.5)))
  (func (export "i32.load16_u") (result i32) (i32.load16_u (i32.const 2)))
)

(assert_return (invoke "f32.load_f16") (f32.const 42.0))
(invoke "f32.store_f16")
(assert_return (invoke "f32.load_f16") (f32.const 100.5))
;; Ensure that the above operations didn't write to memory they shouldn't have.
(assert_return (invoke "i32.load16_u") (i32.const 0xDEAD))
