(module
  (func $call-ref
    (call_ref (ref.func $call-ref))
  )
  (func $call-ref-result (result i32)
    (call_ref (ref.func $call-ref-result))
  )
)
