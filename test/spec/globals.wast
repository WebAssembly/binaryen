;; Test globals

(module
  (global $a i32 (i32.const -2))
  (global (;1;) f32 (f32.const -3))
  (global (;2;) f64 (f64.const -4))
  (global $b i64 (i64.const -5))

  (global $x (mut i32) (i32.const -12))
  (global (;5;) (mut f32) (f32.const -13))
  (global (;6;) (mut f64) (f64.const -14))
  (global $y (mut i64) (i64.const -15))

  (func (export "get-a") (result i32) (global.get $a))
  (func (export "get-b") (result i64) (global.get $b))
  (func (export "get-x") (result i32) (global.get $x))
  (func (export "get-y") (result i64) (global.get $y))
  (func (export "set-x") (param i32) (global.set $x (local.get 0)))
  (func (export "set-y") (param i64) (global.set $y (local.get 0)))

  (func (export "get-1") (result f32) (global.get 1))
  (func (export "get-2") (result f64) (global.get 2))
  (func (export "get-5") (result f32) (global.get 5))
  (func (export "get-6") (result f64) (global.get 6))
  (func (export "set-5") (param f32) (global.set 5 (local.get 0)))
  (func (export "set-6") (param f64) (global.set 6 (local.get 0)))
)

(assert_return (invoke "get-a") (i32.const -2))
(assert_return (invoke "get-b") (i64.const -5))
(assert_return (invoke "get-x") (i32.const -12))
(assert_return (invoke "get-y") (i64.const -15))

(assert_return (invoke "get-1") (f32.const -3))
(assert_return (invoke "get-2") (f64.const -4))
(assert_return (invoke "get-5") (f32.const -13))
(assert_return (invoke "get-6") (f64.const -14))

(assert_return (invoke "set-x" (i32.const 6)))
(assert_return (invoke "set-y" (i64.const 7)))
(assert_return (invoke "set-5" (f32.const 8)))
(assert_return (invoke "set-6" (f64.const 9)))

(assert_return (invoke "get-x") (i32.const 6))
(assert_return (invoke "get-y") (i64.const 7))
(assert_return (invoke "get-5") (f32.const 8))
(assert_return (invoke "get-6") (f64.const 9))

(assert_invalid
  (module (global f32 (f32.const 0)) (func (global.set 0 (i32.const 1))))
  "global is immutable"
)

(assert_invalid
  (module (global f32 (f32.neg (f32.const 0))))
  "constant expression required"
)

(assert_invalid
  (module (global f32 (local.get 0)))
  "constant expression required"
)

(assert_invalid
  (module (global i32 (f32.const 0)))
  "type mismatch"
)

(assert_invalid
  (module (global i32 (global.get 0)))
  "unknown global"
)
