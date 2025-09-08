(module
  (rec
    (type $super (sub (descriptor $super.desc (struct))))
    (type $super.desc (sub (describes $super (struct))))

    (type $sub (sub $super (descriptor $sub.desc (struct))))
    (type $sub.desc (sub $super.desc (describes $sub (struct))))
  )

  (global $super.desc1 (ref (exact $super.desc)) (struct.new $super.desc))
  (global $super.desc2 (ref (exact $super.desc)) (struct.new $super.desc))
  (global $super1 (ref $super) (struct.new $super (global.get $super.desc1)))

  (global $sub.desc (ref (exact $sub.desc)) (struct.new $sub.desc))
  (global $sub (ref $sub) (struct.new $sub (global.get $sub.desc)))

  ;; br_on_cast_desc

  (func $br_on_cast_desc-unreachable (result anyref)
    (unreachable)
    (br_on_cast_desc 0 anyref (ref null $super))
  )
  (func $br_on_cast_desc-null (param anyref) (result anyref)
    (br_on_cast_desc 0 anyref (ref null $super)
      (ref.null none)
      (ref.null none)
    )
  )
  (func $br_on_cast_desc-upcast (param $sub (ref null $sub)) (param $super.desc (ref null $super.desc)) (result (ref null $super))
    (br_on_cast_desc 0 (ref null $sub) (ref null $super)
      (local.get $sub)
      (local.get $super.desc)
    )
  )
  (func $br_on_cast_desc-exact (param $any anyref) (param $super.desc (ref null (exact $super.desc))) (result (ref null (exact $super)))
    ;; The sent type is exact because the descriptor is exact.
    (br_on_cast_desc 0 anyref (ref null $super)
      (local.get $any)
      (local.get $super.desc)
    )
    (unreachable)
  )
  (func (export "cast-success") (result i32)
    (drop
      (block $l (result anyref)
        (br_on_cast_desc $l anyref (ref null $super)
          (global.get $super1)
          (global.get $super.desc1)
        )
        (return (i32.const 0))
      )
    )
    (i32.const 1)
  )
  (func (export "cast-success-supertype") (result i32)
    (drop
      (block $l (result anyref)
        (br_on_cast_desc $l anyref (ref null $super)
          (global.get $sub)
          (global.get $sub.desc)
        )
        (return (i32.const 0))
      )
    )
    (i32.const 1)
  )
  (func (export "cast-success-null") (result i32)
    (drop
      (block $l (result anyref)
        (br_on_cast_desc $l anyref (ref null $super)
          (ref.null none)
          (global.get $super.desc1)
        )
        (return (i32.const 0))
      )
    )
    (i32.const 1)
  )
  (func (export "cast-fail-null") (result i32)
    (drop
      (block $l (result anyref)
        (br_on_cast_desc $l anyref (ref $super)
          (ref.null none)
          (global.get $super.desc1)
        )
        (return (i32.const 0))
      )
    )
    (i32.const 1)
  )
  (func (export "cast-fail-wrong-desc") (result i32)
    (drop
      (block $l (result anyref)
        (br_on_cast_desc $l anyref (ref null $super)
          (global.get $super1)
          (global.get $super.desc2)
        )
        (return (i32.const 0))
      )
    )
    (i32.const 1)
  )
  (func (export "cast-fail-null-desc") (result i32)
    (drop
      (block $l (result anyref)
        (br_on_cast_desc $l anyref (ref null $super)
          (global.get $super1)
          (ref.null none)
        )
        (return (i32.const 0))
      )
    )
    (i32.const 1)
  )

  ;; br_on_cast_desc_fail

  (func $br_on_cast_desc_fail-unreachable (result anyref)
    (unreachable)
    (br_on_cast_desc_fail 0 anyref (ref null $super))
  )
  (func $br_on_cast_desc_fail-null (param anyref) (result anyref)
    (br_on_cast_desc_fail 0 anyref (ref null $super)
      (ref.null none)
      (ref.null none)
    )
  )
  (func $br_on_cast_desc_fail-upcast (param $sub (ref null $sub)) (param $super.desc (ref null $super.desc)) (result (ref null $super))
    (br_on_cast_desc_fail 0 (ref null $sub) (ref null $super)
      (local.get $sub)
      (local.get $super.desc)
    )
  )
  (func $br_on_cast_desc_fail-exact (param $any anyref) (param $super.desc (ref null (exact $super.desc))) (result anyref)
    (block (result (ref null (exact $super)))
      ;; The result type can be exact because the descriptor is exact.
      (br_on_cast_desc_fail 1 anyref (ref null (exact $super))
        (local.get $any)
        (local.get $super.desc)
      )
    )
  )
   (func (export "fail-cast-success") (result i32)
    (drop
      (block $l (result anyref)
        (br_on_cast_desc_fail $l anyref (ref null $super)
          (global.get $super1)
          (global.get $super.desc1)
        )
        (return (i32.const 0))
      )
    )
    (i32.const 1)
  )
  (func (export "fail-cast-success-supertype") (result i32)
    (drop
      (block $l (result anyref)
        (br_on_cast_desc_fail $l anyref (ref null $super)
          (global.get $sub)
          (global.get $sub.desc)
        )
        (return (i32.const 0))
      )
    )
    (i32.const 1)
  )
  (func (export "fail-cast-success-null") (result i32)
    (drop
      (block $l (result anyref)
        (br_on_cast_desc_fail $l anyref (ref null $super)
          (ref.null none)
          (global.get $super.desc1)
        )
        (return (i32.const 0))
      )
    )
    (i32.const 1)
  )
  (func (export "fail-cast-fail-null") (result i32)
    (drop
      (block $l (result anyref)
        (br_on_cast_desc_fail $l anyref (ref $super)
          (ref.null none)
          (global.get $super.desc1)
        )
        (return (i32.const 0))
      )
    )
    (i32.const 1)
  )
  (func (export "fail-cast-fail-wrong-desc") (result i32)
    (drop
      (block $l (result anyref)
        (br_on_cast_desc_fail $l anyref (ref null $super)
          (global.get $super1)
          (global.get $super.desc2)
        )
        (return (i32.const 0))
      )
    )
    (i32.const 1)
  )
  (func (export "fail-cast-fail-null-desc") (result i32)
    (drop
      (block $l (result anyref)
        (br_on_cast_desc_fail $l anyref (ref null $super)
          (global.get $super1)
          (ref.null none)
        )
        (return (i32.const 0))
      )
    )
    (i32.const 1)
  )
)

(assert_return (invoke "cast-success") (i32.const 1))
(assert_return (invoke "cast-success-supertype") (i32.const 1))
(assert_return (invoke "cast-success-null") (i32.const 1))
(assert_return (invoke "cast-fail-null") (i32.const 0))
(assert_return (invoke "cast-fail-wrong-desc") (i32.const 0))
(assert_trap (invoke "cast-fail-null-desc") "null descriptor")
(assert_return (invoke "fail-cast-success") (i32.const 0))
(assert_return (invoke "fail-cast-success-supertype") (i32.const 0))
(assert_return (invoke "fail-cast-success-null") (i32.const 0))
(assert_return (invoke "fail-cast-fail-null") (i32.const 1))
(assert_return (invoke "fail-cast-fail-wrong-desc") (i32.const 1))
(assert_trap (invoke "fail-cast-fail-null-desc") "null descriptor")

(assert_malformed
  ;; Input type must be a reference.
  (module quote "(module (rec (type $struct (descriptor $desc (struct))) (type $desc (describes $struct (struct)))) (func (result anyref) (unreachable) (br_on_cast_desc 0 i32 (ref null $struct))))")
  "expected reftype"
)

(assert_malformed
  ;; Input type must be a reference.
  (module quote "(module (rec (type $struct (descriptor $desc (struct))) (type $desc (describes $struct (struct)))) (func (result anyref) (unreachable) (br_on_cast_desc_fail 0 i32 (ref null $struct))))")
  "expected reftype"
)

(assert_malformed
  ;; Cast type must be a reference.
  (module quote "(module (func (unreachable) (br_on_cast_desc 0 anyref i32) (unreachable)))")
  "expected reftype"
)

(assert_malformed
  ;; Cast type must be a reference.
  (module quote "(module (func (unreachable) (br_on_cast_desc_fail 0 anyref i32) (unreachable)))")
  "expected reftype"
)

(assert_invalid
  (module
    (type (struct))
    (func (result anyref)
      (unreachable)
      ;; Cannot do a descriptor cast to a type without a descriptor.
      (br_on_cast_desc 0 anyref (ref null 0))
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
      (br_on_cast_desc_fail 0 anyref (ref null 0))
    )
  )
  "cast target must have descriptor"
)

(assert_invalid
  (module
    (rec
      (type (descriptor 1 (struct)))
      (type (describes 0 (struct)))
    )
    (func (param anyref) (result anyref)
      (br_on_cast_desc 0 eqref (ref null 0)
        ;; This should be an eqref but is an anyref.
        (local.get 0)
        (ref.null none)
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
    (func (param anyref) (result anyref)
      (br_on_cast_desc_fail 0 eqref (ref null $struct)
        ;; This should be an eqref but is an anyref.
        (local.get 0)
        (ref.null none)
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
    (func (param $any anyref) (param $super.desc (ref null $super.desc)) (result anyref)
      (br_on_cast_desc 0 anyref (ref null $sub)
        (local.get $any)
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
    (func (param $any anyref) (param $super.desc (ref null $super.desc)) (result anyref)
      (br_on_cast_desc_fail 0 anyref (ref null $sub)
        (local.get $any)
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
    (func (param $any anyref) (param $desc (ref null $desc)) (result (ref null (exact $struct)))
      ;; The sent type cannnot be exact because the descriptor is not exact.
      (br_on_cast_desc 0 anyref (ref null $struct)
        (local.get $any)
        (local.get $desc)
      )
      (unreachable)
    )
  )
  "break type must be a subtype"
)

(assert_invalid
  (module
    (rec
      (type $struct (descriptor $desc (struct)))
      (type $desc (describes $struct (struct)))
    )
    (func (param $any anyref) (param $desc (ref null $desc)) (result anyref)
      (block (result (ref null (exact $struct)))
        ;; The result type can be exact because the descriptor is exact.
        (br_on_cast_desc_fail 1 anyref (ref null (exact $struct))
          (local.get $any)
          (local.get $desc)
        )
      )
    )
  )
  "function body type must match"
)
