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
