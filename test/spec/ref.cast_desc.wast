(module
  (rec
    (type $super (sub (descriptor $super.desc (struct))))
    (type $super.desc (sub (describes $super (struct))))

    (type $sub (sub $super (descriptor $sub.desc (struct))))
    (type $sub.desc (sub $super.desc (describes $sub (struct))))
  )

  ;; ref.cast_desc (ref null ht)

  (func $ref.cast_desc-null-unreachable (result anyref)
    (unreachable)
    (ref.cast_desc (ref null $super))
  )
  (func $ref.cast_desc-null-null (param anyref) (result anyref)
    (ref.cast_desc (ref null $super)
      (ref.null none)
      (ref.null none)
    )
  )
  (func $ref.cast_desc-null-upcast (param $sub (ref null $sub)) (param $super.desc (ref null $super.desc)) (result (ref null $super))
    (ref.cast_desc (ref null $super)
      (local.get $sub)
      (local.get $super.desc)
    )
  )
  (func $ref.cast_desc-null-exact (param $any anyref) (param $super.desc (ref null (exact $super.desc))) (result (ref null (exact $super)))
    ;; The cast type is exact because the descriptor is exact.
    (ref.cast_desc (ref null (exact $super))
      (local.get $any)
      (local.get $super.desc)
    )
  )

  ;; ref.cast_desc (ref ht)

  (func $ref.cast_desc-nn-unreachable (result anyref)
    (unreachable)
    (ref.cast_desc (ref $super))
  )
  (func $ref.cast_desc-nn-null (param anyref) (result anyref)
    (ref.cast_desc (ref $super)
      (ref.null none)
      (ref.null none)
    )
  )
  (func $ref.cast_desc-nn-upcast (param $sub (ref null $sub)) (param $super.desc (ref null $super.desc)) (result (ref null $super))
    (ref.cast_desc (ref $super)
      (local.get $sub)
      (local.get $super.desc)
    )
  )
  (func $ref.cast_desc-nn-exact (param $any anyref) (param $super.desc (ref null (exact $super.desc))) (result (ref null (exact $super)))
    ;; The cast type is exact because the descriptor is exact.
    (ref.cast_desc (ref (exact $super))
      (local.get $any)
      (local.get $super.desc)
    )
  )
)

(assert_malformed
  ;; Cast type must be a reference.
  (module quote "(module (func (unreachable) (ref.cast_desc i32) (unreachable)))")
  "expected reftype"
)

(assert_invalid
  (module
    (type (struct))
    (func (result anyref)
      (unreachable)
      ;; Cannot do a descriptor cast to a type without a descriptor.
      (ref.cast_desc (ref null 0))
    )
  )
  "cast target must have descriptor"
)

(assert_invalid
  (module
    (type (struct))
    (func (result anyref)
      (unreachable)
      ;; Cannot do a descriptor cast to a type without a descriptor.
      (ref.cast_desc (ref 0))
    )
  )
  "cast target must have descriptor"
)

(assert_invalid
  (module
    (rec
      (type $super (sub (descriptor $super.desc (struct))))
      (type $super.desc (sub (describes $super (struct))))

      (type $sub (sub $super (descriptor $sub.desc (struct))))
      (type $sub.desc (sub $super.desc (describes $sub (struct))))
    )
    (func (param $super.desc (ref null $super.desc)) (result anyref)
      (ref.cast_desc (ref null $sub)
        (local.get 0)
        ;; This should be a $sub.desc but it is a $super.desc.
        (local.get $super.desc)
      )
    )
  )
  "invalid type on stack"
)

(assert_invalid
  (module
    (rec
      (type $super (sub (descriptor $super.desc (struct))))
      (type $super.desc (sub (describes $super (struct))))

      (type $sub (sub $super (descriptor $sub.desc (struct))))
      (type $sub.desc (sub $super.desc (describes $sub (struct))))
    )
    (func (param $super.desc (ref null $super.desc)) (result anyref)
      (ref.cast_desc (ref $sub)
        (local.get 0)
        ;; This should be a $sub.desc but it is a $super.desc.
        (local.get $super.desc)
      )
    )
  )
  "invalid type on stack"
)

(assert_invalid
  (module
    (rec
      (type $struct (descriptor $desc (struct)))
      (type $desc (describes $struct (struct)))
    )
    (func (param $any anyref) (param $desc (ref null $desc)) (result anyref)
      ;; The cast type cannot be exact because the descriptor is not exact.
      (ref.cast_desc (ref null (exact $struct))
        (local.get $any)
        (local.get $desc)
      )
    )
  )
  "invalid type on stack"
)

(assert_invalid
  (module
    (rec
      (type $struct (descriptor $desc (struct)))
      (type $desc (describes $struct (struct)))
    )
    (func (param $any anyref) (param $desc (ref null $desc)) (result anyref)
      ;; The cast type cannot be exact because the descriptor is not exact.
      (ref.cast_desc (ref (exact $struct))
        (local.get $any)
        (local.get $desc)
      )
    )
  )
  "invalid type on stack"
)
