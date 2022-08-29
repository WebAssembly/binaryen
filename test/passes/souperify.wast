(module
  ;; This tests if we can create dataflow graph correctly in the presence of
  ;; loops.
  (func $if-loop-test (local $0 i32)
    (if
      (i32.const 0)
      (loop $label$0
        (local.set $0
          (i32.sub
            (i32.const 0)
            (i32.const 0)
          )
        )
      )
    )
  )
)
