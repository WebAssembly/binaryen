;; Test `local.set` operator

(module
  ;; Typing

  (func (export "type-local-i32") (local i32) (local.set 0 (i32.const 0)))
  (func (export "type-local-i64") (local i64) (local.set 0 (i64.const 0)))
  (func (export "type-local-f32") (local f32) (local.set 0 (f32.const 0)))
  (func (export "type-local-f64") (local f64) (local.set 0 (f64.const 0)))

  (func (export "type-param-i32") (param i32) (local.set 0 (i32.const 10)))
  (func (export "type-param-i64") (param i64) (local.set 0 (i64.const 11)))
  (func (export "type-param-f32") (param f32) (local.set 0 (f32.const 11.1)))
  (func (export "type-param-f64") (param f64) (local.set 0 (f64.const 12.2)))

  (func (export "type-mixed") (param i64 f32 f64 i32 i32) (local f32 i64 i64 f64)
    (local.set 0 (i64.const 0))
    (local.set 1 (f32.const 0))
    (local.set 2 (f64.const 0))
    (local.set 3 (i32.const 0))
    (local.set 4 (i32.const 0))
    (local.set 5 (f32.const 0))
    (local.set 6 (i64.const 0))
    (local.set 7 (i64.const 0))
    (local.set 8 (f64.const 0))
  )

  ;; Writing

  (func (export "write") (param i64 f32 f64 i32 i32) (result i64)
    (local f32 i64 i64 f64)
    (local.set 1 (f32.const -0.3))
    (local.set 3 (i32.const 40))
    (local.set 4 (i32.const -7))
    (local.set 5 (f32.const 5.5))
    (local.set 6 (i64.const 6))
    (local.set 8 (f64.const 8))
    (i64.trunc_f64_s
      (f64.add
        (f64.convert_i64_u (local.get 0))
        (f64.add
          (f64.promote_f32 (local.get 1))
          (f64.add
            (local.get 2)
            (f64.add
              (f64.convert_i32_u (local.get 3))
              (f64.add
                (f64.convert_i32_s (local.get 4))
                (f64.add
                  (f64.promote_f32 (local.get 5))
                  (f64.add
                    (f64.convert_i64_u (local.get 6))
                    (f64.add
                      (f64.convert_i64_u (local.get 7))
                      (local.get 8)
                    )
                  )
                )
              )
            )
          )
        )
      )
    )
  )
)

(assert_return (invoke "type-local-i32"))
(assert_return (invoke "type-local-i64"))
(assert_return (invoke "type-local-f32"))
(assert_return (invoke "type-local-f64"))

(assert_return (invoke "type-param-i32" (i32.const 2)))
(assert_return (invoke "type-param-i64" (i64.const 3)))
(assert_return (invoke "type-param-f32" (f32.const 4.4)))
(assert_return (invoke "type-param-f64" (f64.const 5.5)))

(assert_return
  (invoke "type-mixed"
    (i64.const 1) (f32.const 2.2) (f64.const 3.3) (i32.const 4) (i32.const 5)
  )
)

(assert_return
  (invoke "write"
    (i64.const 1) (f32.const 2) (f64.const 3.3) (i32.const 4) (i32.const 5)
  )
  (i64.const 56)
)


;; Invalid typing of access to locals

(assert_invalid
  (module (func $type-local-num-vs-num (result i64) (local i32)
    (local.set 0 (i32.const 0))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-local-num-vs-num (local f32)
    (i32.eqz (local.set 0 (f32.const 0)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-local-num-vs-num (local f64 i64)
    (f64.neg (local.set 1 (i64.const 0)))
  ))
  "type mismatch"
)

(assert_invalid
  (module (func $type-local-arg-void-vs-num (local i32) (local.set 0 (nop))))
  "type mismatch"
)
(assert_invalid
  (module (func $type-local-arg-num-vs-num (local i32) (local.set 0 (f32.const 0))))
  "type mismatch"
)
(assert_invalid
  (module (func $type-local-arg-num-vs-num (local f32) (local.set 0 (f64.const 0))))
  "type mismatch"
)
(assert_invalid
  (module (func $type-local-arg-num-vs-num (local f64 i64) (local.set 1 (f64.const 0))))
  "type mismatch"
)


;; Invalid typing of access to parameters

(assert_invalid
  (module (func $type-param-num-vs-num (param i32) (result i64) (local.get 0)))
  "type mismatch"
)
(assert_invalid
  (module (func $type-param-num-vs-num (param f32) (i32.eqz (local.get 0))))
  "type mismatch"
)
(assert_invalid
  (module (func $type-param-num-vs-num (param f64 i64) (f64.neg (local.get 1))))
  "type mismatch"
)

(assert_invalid
  (module (func $type-param-arg-void-vs-num (param i32) (local.set 0 (nop))))
  "type mismatch"
)
(assert_invalid
  (module (func $type-param-arg-num-vs-num (param i32) (local.set 0 (f32.const 0))))
  "type mismatch"
)
(assert_invalid
  (module (func $type-param-arg-num-vs-num (param f32) (local.set 0 (f64.const 0))))
  "type mismatch"
)
(assert_invalid
  (module (func $type-param-arg-num-vs-num (param f64 i64) (local.set 1 (f64.const 0))))
  "type mismatch"
)


;; Invalid local index

(assert_invalid
  (module (func $unbound-local (local i32 i64) (local.get 3)))
  "unknown local"
)
(assert_invalid
  (module (func $large-local (local i32 i64) (local.get 14324343)))
  "unknown local"
)

(assert_invalid
  (module (func $unbound-param (param i32 i64) (local.get 2)))
  "unknown local"
)
(assert_invalid
  (module (func $large-param (local i32 i64) (local.get 714324343)))
  "unknown local"
)

(assert_invalid
  (module (func $unbound-mixed (param i32) (local i32 i64) (local.get 3)))
  "unknown local"
)
(assert_invalid
  (module (func $large-mixed (param i64) (local i32 i64) (local.get 214324343)))
  "unknown local"
)

(assert_invalid
  (module (func $type-mixed-arg-num-vs-num (param f32) (local i32) (local.set 1 (f32.const 0))))
  "type mismatch"
)
(assert_invalid
  (module (func $type-mixed-arg-num-vs-num (param i64 i32) (local f32) (local.set 1 (f32.const 0))))
  "type mismatch"
)
(assert_invalid
  (module (func $type-mixed-arg-num-vs-num (param i64) (local f64 i64) (local.set 1 (i64.const 0))))
  "type mismatch"
)

