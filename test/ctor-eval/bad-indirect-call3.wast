(module
  (type $funcref_=>_none (func (param funcref)))
  (memory 256 256)
  (data (i32.const 10) "waka waka waka waka waka")
  (table funcref (elem $callee))
  (export "sig_mismatch" (func $sig_mismatch))
  (func $callee (param $0 exnref)
    (i32.store8 (i32.const 40) (i32.const 67))
  )
  (func $sig_mismatch
    (call_indirect (type $funcref_=>_none) ;; unsafe to call, signature mismatch
      (ref.null)
      (i32.const 0)
    )
  )
)
