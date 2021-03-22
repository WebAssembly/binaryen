(module
  (table $t 1 1 funcref)
  (elem (table $t) (i32.const 0) funcref (ref.null func))

  (func $call-refnull (export "call-refnull") (result f32)
    (call_indirect (result f32) (i32.const 0))
  )
)
(assert_trap
  (invoke "call-refnull")
  "uninitialized table element"
)