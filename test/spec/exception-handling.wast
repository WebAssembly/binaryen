(module
  (tag $e-v)
  (tag $e-i32 (param i32))
  (tag $e-f32 (param f32))
  (tag $e-i32-f32 (param i32 f32))

  (func $throw_single_value (export "throw_single_value")
    (throw $e-i32 (i32.const 5))
  )

  (func (export "throw_multiple_values")
    (throw $e-i32-f32 (i32.const 3) (f32.const 3.5))
  )

  (func (export "try_nothrow") (result i32)
    (try (result i32)
      (do
        (i32.const 3)
      )
      (catch $e-i32
        (drop (pop i32))
        (i32.const 0)
      )
    )
  )

  (func (export "try_throw_catch") (result i32)
    (try (result i32)
      (do
        (throw $e-i32 (i32.const 5))
      )
      (catch $e-i32
        (drop (pop i32))
        (i32.const 3)
      )
    )
  )

  (func (export "try_throw_nocatch") (result i32)
    (try (result i32)
      (do
        (throw $e-i32 (i32.const 5))
      )
      (catch $e-f32
        (drop (pop f32))
        (i32.const 3)
      )
    )
  )

  (func (export "try_throw_catchall") (result i32)
    (try (result i32)
      (do
        (throw $e-i32 (i32.const 5))
      )
      (catch $e-f32
        (drop (pop f32))
        (i32.const 4)
      )
      (catch_all
        (i32.const 3)
      )
    )
  )

  (func (export "try_call_catch") (result i32)
    (try (result i32)
      (do
        (call $throw_single_value)
        (unreachable)
      )
      (catch $e-i32
        (pop i32)
      )
    )
  )

  (func (export "try_throw_multivalue_catch") (result i32) (local $x (i32 f32))
    (try (result i32)
      (do
        (throw $e-i32-f32 (i32.const 5) (f32.const 1.5))
      )
      (catch $e-i32-f32
        (local.set $x
          (pop i32 f32)
        )
        (tuple.extract 0
          (local.get $x)
        )
      )
    )
  )

  (func (export "try_throw_rethrow")
    (try $l0
      (do
        (throw $e-i32 (i32.const 5))
      )
      (catch $e-i32
        (drop (pop i32))
        (rethrow $l0)
      )
    )
  )

  (func (export "try_call_rethrow")
    (try $l0
      (do
        (call $throw_single_value)
      )
      (catch_all
        (rethrow $l0)
      )
    )
  )

  (func (export "rethrow_target_test1") (result i32)
    (try (result i32)
      (do
        (try
          (do
            (throw $e-i32 (i32.const 1))
          )
          (catch_all
            (try $l0
              (do
                (throw $e-i32 (i32.const 2))
              )
              (catch $e-i32
                (drop (pop i32))
                (rethrow $l0) ;; rethrow (i32.const 2)
              )
            )
          )
        )
      )
      (catch $e-i32
        (pop i32) ;; result is (i32.const 2)
      )
    )
  )

  ;; Can we handle rethrows with the depth > 0?
  (func (export "rethrow_target_test2") (result i32)
    (try (result i32)
      (do
        (try $l0
          (do
            (throw $e-i32 (i32.const 1))
          )
          (catch_all
            (try
              (do
                (throw $e-i32 (i32.const 2))
              )
              (catch $e-i32
                (drop (pop i32))
                (rethrow 1) ;; rethrow (i32.const 1)
              )
            )
          )
        )
      )
      (catch $e-i32
        (pop i32) ;; result is (i32.const 1)
      )
    )
  )

  ;; Tests whether the exception stack is managed correctly after rethrows
  (func (export "rethrow_target_test3") (result i32)
    (try (result i32)
      (do
        (try $l0
          (do
            (try $l1
              (do
                (throw $e-i32 (i32.const 1))
              )
              (catch_all
                (try
                  (do
                    (throw $e-i32 (i32.const 2))
                  )
                  (catch $e-i32
                    (drop (pop i32))
                    (rethrow $l1) ;; rethrow (i32.const 1)
                  )
                )
              )
            )
          )
          (catch $e-i32
            (drop (pop i32))
            (rethrow $l0) ;; rethrow (i32.const 1) again
          )
        )
      )
      (catch $e-i32
        (pop i32) ;; result is (i32.const 1)
      )
    )
  )

  (func (export "try_delegate_caught") (result i32)
    (try $l0 (result i32)
      (do
        (try (result i32)
          (do
            (try (result i32)
              (do
                 (throw $e-i32 (i32.const 3))
              )
              (delegate $l0)
            )
          )
          (catch_all
            (i32.const 0)
          )
        )
      )
      (catch $e-i32
        (pop i32)
      )
    )
  )

  (func (export "try_delegate_to_catchless_try") (result i32)
    (try $l0 (result i32)
      (do
        (try (result i32)
          (do
            (try (result i32)
              (do
                 (throw $e-i32 (i32.const 3))
              )
              (delegate $l0)
            )
          )
          (catch_all
            (i32.const 0)
          )
        )
      )
    )
  )

  (func (export "try_delegate_to_delegate") (result i32)
    (try $l0 (result i32)
      (do
        (try $l1 (result i32)
          (do
            (try (result i32)
              (do
                 (throw $e-i32 (i32.const 3))
              )
              (delegate $l1)
            )
          )
          (delegate $l0)
        )
      )
      (catch $e-i32
        (pop i32)
      )
    )
  )

  (func (export "try_delegate_to_caller")
    (try $l0
      (do
        (try $l1
          (do
            (try
              (do
                 (throw $e-i32 (i32.const 3))
              )
              (delegate 2) ;; to caller
            )
          )
        )
      )
      (catch_all)
    )
  )
)

(assert_trap (invoke "throw_single_value"))
(assert_trap (invoke "throw_multiple_values"))
(assert_return (invoke "try_nothrow") (i32.const 3))
(assert_return (invoke "try_throw_catch") (i32.const 3))
(assert_trap (invoke "try_throw_nocatch"))
(assert_return (invoke "try_throw_catchall") (i32.const 3))
(assert_return (invoke "try_call_catch") (i32.const 5))
(assert_return (invoke "try_throw_multivalue_catch") (i32.const 5))
(assert_trap (invoke "try_throw_rethrow"))
(assert_trap (invoke "try_call_rethrow"))
(assert_return (invoke "rethrow_target_test1") (i32.const 2))
(assert_return (invoke "rethrow_target_test2") (i32.const 1))
(assert_return (invoke "rethrow_target_test3") (i32.const 1))
(assert_return (invoke "try_delegate_caught") (i32.const 3))
(assert_trap (invoke "try_delegate_to_catchless_try"))
(assert_return (invoke "try_delegate_to_delegate") (i32.const 3))
(assert_trap (invoke "try_delegate_to_caller"))

(assert_invalid
  (module
    (func $f0
      (try
        (do (nop))
        (catch $e-i32
          (pop i32)
        )
      )
    )
  )
  "try's body type must match catch's body type"
)

(assert_invalid
  (module
    (tag $e-i32 (param i32))
    (func $f0
      (try
        (do (i32.const 0))
        (catch $e-i32
          (pop i32)
        )
      )
    )
  )
  "try's type does not match try body's type"
)

(assert_invalid
  (module
    (tag $e-i32 (param i32))
    (func $f0
      (throw $e-i32 (f32.const 0))
    )
  )
  "tag param types must match"
)

(assert_invalid
  (module
    (tag $e-i32 (param i32 f32))
    (func $f0
      (throw $e-i32 (f32.const 0))
    )
  )
  "tag's param numbers must match"
)

(assert_invalid
  (module
    (func $f0
      (block $l0
        (try
          (do
            (try
              (do)
              (delegate $l0) ;; target is a block
            )
          )
          (catch_all)
        )
      )
    )
  )
  "all delegate targets must be valid"
)

(assert_invalid
  (module
    (func $f0
      (try $l0
        (do)
        (catch_all
          (try
            (do)
            (delegate $l0) ;; the target catch is above the delegate
          )
        )
      )
    )
  )
  "all delegate targets must be valid"
)

(assert_invalid
  (module
    (func $f0
      (block $l0
        (try
          (do)
          (catch_all
            (rethrow $l0) ;; target is a block
          )
        )
      )
    )
  )
  "all rethrow targets must be valid"
)

(assert_invalid
  (module
    (func $f0
      (try $l0
        (do
          (rethrow $l0) ;; Not within the target try's catch
        )
        (catch_all)
      )
    )
  )
  "all rethrow targets must be valid"
)

(assert_invalid
  (module
    (func $f0
      (try
        (do)
        (catch $e)
      )
    )
  )
  "catch's tag name is invalid: e"
)

(assert_invalid
  (module
    (tag $e-none (param))
    (func $f0 (result i32)
      (try (result i32)
        (do
          (i32.const 0)
        )
        (catch $e-none
          (pop i32)
        )
      )
    )
  )
  "catch's tag (e-none) doesn't have any params, but there are pops"
)

(assert_invalid
  (module
    (tag $e-i32 (param i32))
    (func $f0
      (try
        (do)
        (catch $e-i32)
      )
    )
  )
  "catch's tag (e-i32) has params, so there should be a single pop within the catch body"
)

(assert_invalid
  (module
    (tag $e-i32 (param i32))
    (func $f0
      (try
        (do)
        (catch $e-i32
          (drop
            (pop i32)
          )
          (drop
            (pop i32)
          )
        )
      )
    )
  )
  "catch's tag (e-i32) has params, so there should be a single pop within the catch body"
)

(assert_invalid
  (module
    (func $f0 (result i32)
      (try (result i32)
        (do
          (i32.const 0)
        )
        (catch_all
          (pop i32)
        )
      )
    )
  )
  "catch_all's body should not have pops"
)

(assert_invalid
  (module
    (tag $e-i32 (param i32))
    (func $f0 (result f32)
      (try (result f32)
        (do
          (f32.const 0)
        )
        (catch $e-i32
          (pop f32)
        )
      )
    )
  )
  "catch's tag (e-i32)'s pop doesn't have the same type as the tag's params"
)

(assert_invalid
  (module
    (tag $e-i32 (param i32))
    (func $f0 (result i32)
      (try (result i32)
        (do
          (i32.const 0)
        )
        (catch $e-i32
          (drop
            (i32.const 0)
          )
          (pop i32) ;; Not the first children within 'catch'
        )
      )
    )
  )
  "catch's body (e-i32)'s pop's location is not valid"
)

(assert_invalid
  (module
    (tag $e-i32 (param i32))
    (func $f0
      (try
        (do)
        (catch $e-i32
          (throw $e-i32
            (block (result i32)
              (pop i32) ;; pop is within a block
            )
          )
        )
      )
    )
  )
  "catch's body (e-i32)'s pop's location is not valid"
)

(assert_invalid
  (module
    (tag $e-i32 (param i32))
    (func $f0
      (try
        (do)
        (catch $e-i32
          (throw $e-i32
            (loop (result i32)
              (pop i32) ;; pop is within a loop
            )
          )
        )
      )
    )
  )
  "catch's body (e-i32)'s pop's location is not valid"
)

(assert_invalid
  (module
    (tag $e-i32 (param i32))
    (func $f0
      (try
        (do)
        (catch $e-i32
          (throw $e-i32
            (try (result i32)
              (do
                (pop i32) ;; pop is within a try
              )
              (catch_all
                (i32.const 0)
              )
            )
          )
        )
      )
    )
  )
  "catch's body (e-i32)'s pop's location is not valid"
)

(assert_invalid
  (module
    (tag $e-i32 (param i32))
    (func $f0
      (try
        (do)
        (catch $e-i32
          (throw $e-i32
            (if (result i32)
              (i32.const 0)
              (pop i32) ;; pop is within an if true body
              (i32.const 3)
            )
          )
        )
      )
    )
  )
  "catch's body (e-i32)'s pop's location is not valid"
)
