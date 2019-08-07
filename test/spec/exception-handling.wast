(module
  (event $e0 (attr 0) (param i32))
  (event $e1 (attr 0) (param i32 f32))

  (func $exnref_test (param $0 exnref) (result exnref)
    (local.get $0)
  )

  (func $eh_test (local $exn exnref)
    (try
      (throw $e0 (i32.const 0))
      (catch
        ;; Multi-value is not available yet, so block can't take a value from
        ;; stack. So this uses locals for now.
        (local.set $exn (exnref.pop))
        (drop
          (block $l0 (result i32)
            (rethrow
              (br_on_exn $l0 $e0 (local.get $exn))
            )
          )
        )
      )
    )
  )
)

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
