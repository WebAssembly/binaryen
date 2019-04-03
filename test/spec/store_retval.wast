(assert_invalid
  (module (func (param i32) (result i32) (local.set 0 (i32.const 1))))
  "type mismatch"
)
(assert_invalid
  (module (func (param i64) (result i64) (local.set 0 (i64.const 1))))
  "type mismatch"
)
(assert_invalid
  (module (func (param f32) (result f32) (local.set 0 (f32.const 1))))
  "type mismatch"
)
(assert_invalid
  (module (func (param f64) (result f64) (local.set 0 (f64.const 1))))
  "type mismatch"
)

(assert_invalid
  (module (memory 1) (func (param i32) (result i32) (i32.store (i32.const 0) (i32.const 1))))
  "type mismatch"
)
(assert_invalid
  (module (memory 1) (func (param i64) (result i64) (i64.store (i32.const 0) (i64.const 1))))
  "type mismatch"
)
(assert_invalid
  (module (memory 1) (func (param f32) (result f32) (f32.store (i32.const 0) (f32.const 1))))
  "type mismatch"
)
(assert_invalid
  (module (memory 1) (func (param f64) (result f64) (f64.store (i32.const 0) (f64.const 1))))
  "type mismatch"
)

(assert_invalid
  (module (memory 1) (func (param i32) (result i32) (i32.store8 (i32.const 0) (i32.const 1))))
  "type mismatch"
)
(assert_invalid
  (module (memory 1) (func (param i32) (result i32) (i32.store16 (i32.const 0) (i32.const 1))))
  "type mismatch"
)
(assert_invalid
  (module (memory 1) (func (param i64) (result i64) (i64.store8 (i32.const 0) (i64.const 1))))
  "type mismatch"
)
(assert_invalid
  (module (memory 1) (func (param i64) (result i64) (i64.store16 (i32.const 0) (i64.const 1))))
  "type mismatch"
)
(assert_invalid
  (module (memory 1) (func (param i64) (result i64) (i64.store32 (i32.const 0) (i64.const 1))))
  "type mismatch"
)

