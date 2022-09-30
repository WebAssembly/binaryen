(module
  (memory $0 1)
  (data (i32.const 0) "__________")
  (data (i32.const 20) "__________")
  (func "test1"
    ;; A store that can be evalled.
    (i32.store8
      (i32.const 4)
      (i32.const 100)
    )

    ;; A memory init cannot be evalled since ctor-eval flattens memory segments
    ;; atm. We lose the identity of them as a result as they are all merged
    ;; into a single big segment. We could fix that eventually.
    (memory.init 1
      (i32.const 0)
      (i32.const 0)
      (i32.const 1)
    )
  )
)

