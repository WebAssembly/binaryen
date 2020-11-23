(module
  (type $i32-i32 (func (param i32) (result i32)))

  (func $call-ref
    (call_ref (ref.func $call-ref))
  )
  (func $return-call-ref
    (return_call_ref (ref.func $call-ref))
  )
  (func $call-ref-more (param i32) (result i32)
    (call_ref (i32.const 42) (ref.func $call-ref-more))
  )
  (func $call_from-param (param $f (ref $i32-i32)) (result i32)
    (call_ref (i32.const 42) (local.get $f))
  )
  (func $call_from-param-null (param $f (ref null $i32-i32)) (result i32)
    (call_ref (i32.const 42) (local.get $f))
  )
  (func $call_from-local-null (result i32)
    (local $f (ref null $i32-i32))
    (local.set $f (ref.func $call-ref-more))
    (call_ref (i32.const 42) (local.get $f))
  )
)
