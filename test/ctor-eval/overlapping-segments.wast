(module
  (type $none_=>_i32 (func (result i32)))

  (table $0 46 funcref)
  (elem $0 (i32.const 9) $1)
  (elem $1 (i32.const 9) $0)

  (export "test1" (func $2))

  (func $0 (result i32)
    (unreachable)
  )
  (func $1 (result i32)
    (i32.const 65)
  )
  (func $2
    (drop
      (call_indirect (type $none_=>_i32)
        ;; Calling the item at index $9 should call $0, which appears in the
        ;; last of the overlapping segments. That function traps, which stops
        ;; us from evalling anything here.
        (i32.const 9)
      )
    )
  )
)

