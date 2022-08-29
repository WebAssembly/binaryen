;; Test `local.tee` operator

(module
  ;; Typing

  (func (export "type-local-i32") (result i32) (local i32) (local.tee 0 (i32.const 0)))
  (func (export "type-local-i64") (result i64) (local i64) (local.tee 0 (i64.const 0)))
  (func (export "type-local-f32") (result f32) (local f32) (local.tee 0 (f32.const 0)))
  (func (export "type-local-f64") (result f64) (local f64) (local.tee 0 (f64.const 0)))

  (func (export "type-param-i32") (param i32) (result i32) (local.tee 0 (i32.const 10)))
  (func (export "type-param-i64") (param i64) (result i64) (local.tee 0 (i64.const 11)))
  (func (export "type-param-f32") (param f32) (result f32) (local.tee 0 (f32.const 11.1)))
  (func (export "type-param-f64") (param f64) (result f64) (local.tee 0 (f64.const 12.2)))

  (func (export "type-mixed") (param i64 f32 f64 i32 i32) (local f32 i64 i64 f64)
    (drop (i64.eqz (local.tee 0 (i64.const 0))))
    (drop (f32.neg (local.tee 1 (f32.const 0))))
    (drop (f64.neg (local.tee 2 (f64.const 0))))
    (drop (i32.eqz (local.tee 3 (i32.const 0))))
    (drop (i32.eqz (local.tee 4 (i32.const 0))))
    (drop (f32.neg (local.tee 5 (f32.const 0))))
    (drop (i64.eqz (local.tee 6 (i64.const 0))))
    (drop (i64.eqz (local.tee 7 (i64.const 0))))
    (drop (f64.neg (local.tee 8 (f64.const 0))))
  )

  ;; Writing

  (func (export "write") (param i64 f32 f64 i32 i32) (result i64) (local f32 i64 i64 f64)
    (drop (local.tee 1 (f32.const -0.3)))
    (drop (local.tee 3 (i32.const 40)))
    (drop (local.tee 4 (i32.const -7)))
    (drop (local.tee 5 (f32.const 5.5)))
    (drop (local.tee 6 (i64.const 6)))
    (drop (local.tee 8 (f64.const 8)))
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

  ;; Result

  (func (export "result") (param i64 f32 f64 i32 i32) (result f64)
    (local f32 i64 i64 f64)
    (f64.add
      (f64.convert_i64_u (local.tee 0 (i64.const 1)))
      (f64.add
        (f64.promote_f32 (local.tee 1 (f32.const 2)))
        (f64.add
          (local.tee 2 (f64.const 3.3))
          (f64.add
            (f64.convert_i32_u (local.tee 3 (i32.const 4)))
            (f64.add
              (f64.convert_i32_s (local.tee 4 (i32.const 5)))
              (f64.add
                (f64.promote_f32 (local.tee 5 (f32.const 5.5)))
                (f64.add
                  (f64.convert_i64_u (local.tee 6 (i64.const 6)))
                  (f64.add
                    (f64.convert_i64_u (local.tee 7 (i64.const 0)))
                    (local.tee 8 (f64.const 8))
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

(assert_return (invoke "type-local-i32") (i32.const 0))
(assert_return (invoke "type-local-i64") (i64.const 0))
(assert_return (invoke "type-local-f32") (f32.const 0))
(assert_return (invoke "type-local-f64") (f64.const 0))

(assert_return (invoke "type-param-i32" (i32.const 2)) (i32.const 10))
(assert_return (invoke "type-param-i64" (i64.const 3)) (i64.const 11))
(assert_return (invoke "type-param-f32" (f32.const 4.4)) (f32.const 11.1))
(assert_return (invoke "type-param-f64" (f64.const 5.5)) (f64.const 12.2))

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

(assert_return
  (invoke "result"
    (i64.const -1) (f32.const -2) (f64.const -3.3) (i32.const -4) (i32.const -5)
  )
  (f64.const 34.8)
)


;; Invalid typing of access to locals

(assert_invalid
  (module (func $type-local-num-vs-num (result i64) (local i32) (local.tee 0 (i32.const 0))))
  "type mismatch"
)
(assert_invalid
  (module (func $type-local-num-vs-num (local f32) (i32.eqz (local.tee 0 (f32.const 0)))))
  "type mismatch"
)
(assert_invalid
  (module (func $type-local-num-vs-num (local f64 i64) (f64.neg (local.tee 1 (i64.const 0)))))
  "type mismatch"
)

(assert_invalid
  (module (func $type-local-arg-void-vs-num (local i32) (local.tee 0 (nop))))
  "type mismatch"
)
(assert_invalid
  (module (func $type-local-arg-num-vs-num (local i32) (local.tee 0 (f32.const 0))))
  "type mismatch"
)
(assert_invalid
  (module (func $type-local-arg-num-vs-num (local f32) (local.tee 0 (f64.const 0))))
  "type mismatch"
)
(assert_invalid
  (module (func $type-local-arg-num-vs-num (local f64 i64) (local.tee 1 (f64.const 0))))
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
  (module (func $type-param-arg-void-vs-num (param i32) (local.tee 0 (nop))))
  "type mismatch"
)
(assert_invalid
  (module (func $type-param-arg-num-vs-num (param i32) (local.tee 0 (f32.const 0))))
  "type mismatch"
)
(assert_invalid
  (module (func $type-param-arg-num-vs-num (param f32) (local.tee 0 (f64.const 0))))
  "type mismatch"
)
(assert_invalid
  (module (func $type-param-arg-num-vs-num (param f64 i64) (local.tee 1 (f64.const 0))))
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
  (module (func $type-mixed-arg-num-vs-num (param f32) (local i32) (local.tee 1 (f32.const 0))))
  "type mismatch"
)
(assert_invalid
  (module (func $type-mixed-arg-num-vs-num (param i64 i32) (local f32) (local.tee 1 (f32.const 0))))
  "type mismatch"
)
(assert_invalid
  (module (func $type-mixed-arg-num-vs-num (param i64) (local f64 i64) (local.tee 1 (i64.const 0))))
  "type mismatch"
)

