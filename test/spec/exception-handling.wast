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

  (func (export "try_table_nothrow") (result i32)
    (block $tryend (result i32)
      (drop
        (block $catch (result i32)
          (br $tryend
            (try_table (result i32) (catch $e-i32 $catch)
              (i32.const 3)
            )
          )
        )
      )
      (i32.const 0)
    )
  )

  (func (export "try_table_throw_catch") (result i32)
    (block $tryend (result i32)
      (drop
        (block $catch (result i32)
          (br $tryend
            (try_table (result i32) (catch $e-i32 $catch)
              (throw $e-i32 (i32.const 5))
            )
          )
        )
      )
      (i32.const 3)
    )
  )

  (func (export "try_table_throw_nocatch") (result i32)
    (block $tryend (result i32)
      (drop
        (block $catch (result f32)
          (br $tryend
            (try_table (result i32) (catch $e-f32 $catch)
              (throw $e-i32 (i32.const 5))
            )
          )
        )
      )
      (i32.const 3)
    )
  )

  (func (export "try_table_throw_catchall") (result i32)
    (block $tryend (result i32)
      (block $catch-all
        (drop
          (block $catch-f32 (result f32)
            (br $tryend
              (try_table (result i32) (catch $e-f32 $catch-f32) (catch_all $catch-all)
                (throw $e-i32 (i32.const 5))
              )
            )
          )
        )
        (br $tryend (i32.const 4))
      )
      (i32.const 3)
    )
  )

  (func (export "try_table_call_catch") (result i32)
    (block $tryend (result i32)
      (block $catch (result i32)
        (br $tryend
          (try_table (result i32) (catch $e-i32 $catch)
            (call $throw_single_value)
            (unreachable)
          )
        )
      )
    )
  )

  (func (export "try_table_throw_multivalue_catch") (result i32) (local $x (tuple i32 f32))
    (block $tryend (result i32)
      (local.set $x
        (block $catch (result i32) (result f32)
          (br $tryend
            (try_table (result i32) (catch $e-i32-f32 $catch)
              (throw $e-i32-f32 (i32.const 5) (f32.const 1.5))
            )
          )
        )
      )
      (tuple.extract 2 0
        (local.get $x)
      )
    )
  )

  (func (export "try_table_throw_throw_ref") (local $x (tuple i32 exnref))
    (block $tryend
      (local.set $x
        (block $catch (result i32) (result exnref)
          (try_table (catch_ref $e-i32 $catch)
            (throw $e-i32 (i32.const 5))
          )
          (br $tryend)
        )
      )
      (throw_ref
        (tuple.extract 2 1
          (local.get $x)
        )
      )
    )
  )

  (func (export "try_table_call_throw_ref")
    (block $tryend
      (throw_ref
        (block $catch (result exnref)
          (try_table (catch_all_ref $catch)
            (call $throw_single_value)
          )
          (br $tryend)
        )
      )
    )
  )
)

(assert_exception (invoke "throw_single_value"))
(assert_exception (invoke "throw_multiple_values"))
(assert_return (invoke "try_table_nothrow") (i32.const 3))
(assert_return (invoke "try_table_throw_catch") (i32.const 3))
(assert_exception (invoke "try_table_throw_nocatch"))
(assert_return (invoke "try_table_throw_catchall") (i32.const 3))
(assert_return (invoke "try_table_call_catch") (i32.const 5))
(assert_return (invoke "try_table_throw_multivalue_catch") (i32.const 5))
(assert_exception (invoke "try_table_throw_throw_ref"))
(assert_exception (invoke "try_table_call_throw_ref"))

(assert_invalid
  (module
    (tag $e-i32 (param i32))
    (func $f0
      (try_table
        (i32.const 0)
      )
    )
  )
  "try_table's type does not match try_table body's type"
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
      (block $l
        (try_table (catch $e $l))
      )
    )
  )
  "catch's tag name is invalid: e"
)

(assert_invalid
  (module
    (tag $e (param i32) (result i32))
    (func $f0
      (throw $e (i32.const 5))
    )
  )
  "tags with result types must not be used for exception handling"
)

(assert_invalid
  (module
    (tag $e (param i32) (result i32))
    (func $f0
      (block $l
        (try_table (catch $e $l))
      )
    )
  )
  "catch's tag (e) has result values, which is not allowed for exception handling"
)
