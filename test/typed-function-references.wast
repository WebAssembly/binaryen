(module
  ;; inline ref type in result
  (type $f64_=>_ref_null<_->_eqref> (func (param f64) (result (ref null (func (result eqref))))))
  (type $=>eqref (func (result eqref)))

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
  (func $ref-in-sig (param $0 f64) (result (ref null (func (result eqref))))
    (ref.null $=>eqref)
  )
  (func $type-only-in-tuple-local
    (local $x (i32 (ref null (func (result anyref))) f64))
  )
  (func $type-only-in-tuple-block
    (drop
      (block (result i32 (ref null (func (result anyref f32 anyref f32))) f64)
        (unreachable)
      )
    )
  )
  (func $nested-type-only-there (result (ref (func (result (ref (func (param i32 i32 i32 i32 i32)))))))
    (unreachable)
  )
)
