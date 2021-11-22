(module
  (type $funcref_=>_none (func (param funcref)))
  (table funcref (elem $callee))
  (export "sig_mismatch" (func $sig_mismatch))
  (func $callee (param $0 externref))
  (func $sig_mismatch
    (call_indirect (type $funcref_=>_none)
      (ref.null func)
      (i32.const 0)
    )
  )
)

(assert_trap (invoke "sig_mismatch") "callIndirect: function signatures don't match")
