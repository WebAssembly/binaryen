(module
  ;; inline ref type in result
  (type $_=>_eqref (func (result eqref)))
  (type $f64_=>_ref_null<_->_eqref> (func (param f64) (result (ref null $_=>_eqref))))
  (type $=>eqref (func (result eqref)))
  (type $=>anyref (func (result anyref)))
  (type $mixed_results (func (result anyref f32 anyref f32)))

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
  (func $ref-in-sig (param $0 f64) (result (ref null $=>eqref))
    (ref.null $=>eqref)
  )
  (func $type-only-in-tuple-local
    (local $x (i32 (ref null $=>anyref) f64))
  )
  (func $type-only-in-tuple-block
    (drop
      (block (result i32 (ref null $mixed_results) f64)
        (unreachable)
      )
    )
  )
  (func $ref-types-first
    ;; 6 reference types and 3 MVP types. The binary format should emit all the
    ;; reference types first since a reference type appears first. In addition,
    ;; types should be emitted in blocks there, that is, locals of identical
    ;; types should be adjacent.
    (local $r1 (ref null $mixed_results))
    (local $r2 (ref null $mixed_results))
    (local $i1 i32)
    (local $r3 anyref)
    (local $i2 i64)
    (local $r4 anyref)
    (local $i3 i64)
    (local $r5 anyref)
    (local $r6 funcref)
  )
  (func $mvp-types-first
    ;; Reversed from before, now an MVP type appears first, so they should all
    ;; be before reference types in the binary format.
    (local $i1 i32) ;; only this local was moved up.
    (local $r1 (ref null $mixed_results))
    (local $r2 (ref null $mixed_results))
    (local $r3 anyref)
    (local $i2 i64)
    (local $r4 anyref)
    (local $i3 i64)
    (local $r5 anyref)
    (local $r6 funcref)
  )
  (func $mvp-types-first-param (param $r0 (ref null $mixed_results))
    ;; As before, but now there is a reference type *parameter*. We should
    ;; ignore that and sort as in the last function.
    (local $i1 i32) ;; only this local was moved up.
    (local $r1 (ref null $mixed_results))
    (local $r2 (ref null $mixed_results))
    (local $r3 anyref)
    (local $i2 i64)
    (local $r4 anyref)
    (local $i3 i64)
    (local $r5 anyref)
    (local $r6 funcref)
  )
)
