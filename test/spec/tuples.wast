(assert_invalid
  (module
    (func $foo
      (local $temp ((ref func) i32))
    )
  )
  "var must be defaultable"
)

