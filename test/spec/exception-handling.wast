(module
  (event $e0 (attr 0) (param i32))
  (event $e1 (attr 0) (param i32 f32))

  (func (export "throw_single_value")
    (throw $e0 (i32.const 5))
  )

  (func (export "throw_multiple_values")
    (throw $e1 (i32.const 3) (f32.const 3.5))
  )

  (func (export "rethrow_nullref")
    (rethrow (ref.null))
  )

  (func (export "try_nothrow") (result i32)
    (try (result i32)
      (i32.const 3)
      (catch
        (drop (exnref.pop))
        (i32.const 0)
      )
    )
  )

  (func (export "try_throw_catch") (result i32)
    (try (result i32)
      (throw $e0 (i32.const 5))
      (catch
        (drop (exnref.pop))
        (i32.const 3)
      )
    )
  )

  (func (export "try_throw_rethrow")
    (try
      (throw $e0 (i32.const 5))
      (catch
        (rethrow (exnref.pop))
      )
    )
  )

  (func (export "br_on_exn_nullref") (result i32)
    (block $l0 (result i32)
      (drop
        (br_on_exn $l0 $e0 (ref.null))
      )
      (i32.const 0)
    )
  )

  (func (export "br_on_exn_match_single_value") (result i32) (local $exn exnref)
    (try (result i32)
      (throw $e0 (i32.const 5))
      (catch
        (local.set $exn (exnref.pop))
        (block $l0 (result i32)
          (rethrow
            (br_on_exn $l0 $e0 (local.get $exn))
          )
        )
      )
    )
  )

  (func (export "br_on_exn_match_multiple_values") (result i32 f32)
        (local $exn exnref)
    (try (result i32 f32)
      (throw $e1 (i32.const 3) (f32.const 3.5))
      (catch
        (local.set $exn (exnref.pop))
        (block $l0 (result i32 f32)
          (rethrow
            (br_on_exn $l0 $e1 (local.get $exn))
          )
        )
      )
    )
  )

  (func (export "br_on_exn_dont_match") (result i32) (local $exn exnref)
    (try (result i32)
      (throw $e1 (i32.const 3) (f32.const 3.5))
      (catch
        (local.set $exn (exnref.pop))
        (block $l0 (result i32)
          (rethrow
            (br_on_exn $l0 $e0 (local.get $exn))
          )
        )
      )
    )
  )
)

(assert_trap (invoke "throw_single_value"))
(assert_trap (invoke "throw_multiple_values"))
(assert_trap (invoke "rethrow_nullref"))
(assert_return (invoke "try_nothrow") (i32.const 3))
(assert_return (invoke "try_throw_catch") (i32.const 3))
(assert_trap (invoke "try_throw_rethrow"))
(assert_trap (invoke "br_on_exn_nullref"))
(assert_return (invoke "br_on_exn_match_single_value") (i32.const 5))
(assert_return (invoke "br_on_exn_match_multiple_values") (tuple.make (i32.const 3) (f32.const 3.5)))
(assert_trap (invoke "br_on_exn_dont_match"))

(assert_invalid
  (module
    (func $f0
      (try
        (nop)
        (catch (i32.const 0))
      )
    )
  )
  "try's body type must match catch's body type"
)

(assert_invalid
  (module
    (func $f0
      (try
        (i32.const 0)
        (catch (i32.const 0))
      )
    )
  )
   "try's type does not match try body's type"
)

(assert_invalid
  (module
    (event $e0 (attr 0) (param i32))
    (func $f0
      (throw $e0 (f32.const 0))
    )
  )
  "event param types must match"
)

(assert_invalid
  (module
    (event $e0 (attr 0) (param i32 f32))
    (func $f0
      (throw $e0 (f32.const 0))
    )
  )
  "event's param numbers must match"
)

(assert_invalid
  (module
    (func $f0
      (rethrow (i32.const 0))
    )
  )
  "rethrow's argument must be exnref type"
)

(assert_invalid
  (module
    (event $e0 (attr 0) (param i32))
    (func $f0 (result i32)
      (block $l0 (result i32)
        (drop
          (br_on_exn $l0 $e0 (i32.const 0))
        )
        (i32.const 0)
      )
    )
  )
  "br_on_exn's argument must be unreachable or exnref type"
)

(assert_invalid
  (module
    (event $e0 (attr 0) (param i32))
    (func $f0 (result i32) (local $0 exnref)
      (block $l0 (result i32)
        (i32.eqz
          (br_on_exn $l0 $e0 (local.get $0))
        )
      )
    )
  )
  "i32.eqz input must be i32"
)

(assert_invalid
  (module
    (event $e0 (attr 0) (param i32))
    (func $f0 (result f32) (local $0 exnref)
      (block $l0 (result f32)
        (drop
          (br_on_exn $l0 $e0 (local.get $0))
        )
        (f32.const 0)
      )
    )
  )
  "block+breaks must have right type if breaks return a value"
)
