(module
  (rec
    (type $pair (descriptor $pair.desc (struct (field i32 i64))))
    (type $pair.desc (describes $pair (struct)))
  )
  (func $struct.new (param $desc (ref null (exact $pair.desc))) (result (ref (exact $pair)))
    (struct.new $pair
      (i32.const 1)
      (i64.const 2)
      (local.get $desc)
    )
  )
  (func (export "check-new") (result i32)
    (local $pair (ref null $pair))
    (local.set $pair (call $struct.new (struct.new $pair.desc)))
    (i32.and
      (i32.eq (struct.get $pair 0 (local.get $pair)) (i32.const 1))
      (i64.eq (struct.get $pair 1 (local.get $pair)) (i64.const 2))
    )
  )
  (func (export "new-null-desc")
    (drop (call $struct.new (ref.null none)))
  )
  (func $struct.new_default (param $desc (ref null (exact $pair.desc))) (result (ref (exact $pair)))
    (struct.new_default $pair
      (local.get $desc)
    )
  )
  (func (export "check-new-default") (result i32)
    (local $pair (ref null $pair))
    (local.set $pair (call $struct.new_default (struct.new $pair.desc)))
    (i32.and
      (i32.eq (struct.get $pair 0 (local.get $pair)) (i32.const 0))
      (i64.eq (struct.get $pair 1 (local.get $pair)) (i64.const 0))
    )
  )
  (func (export "new-default-null-desc")
    (drop (call $struct.new_default (ref.null none)))
  )
)

(assert_return (invoke "check-new") (i32.const 1))
(assert_return (invoke "check-new-default") (i32.const 1))
(assert_trap (invoke "new-null-desc") "null descriptor")
(assert_trap (invoke "new-default-null-desc") "null descriptor")

(assert_invalid
  (module
    (rec
      (type $pair (descriptor $pair.desc (struct (field i32 i64))))
      (type $pair.desc (describes $pair (struct)))
    )
    (func (result (ref (exact $pair)))
      ;; The descriptor operand is missing.
      (struct.new $pair
        (i32.const 0)
        (i64.const 1)
      )
    )
  )
  "popping from empty stack"
)

(assert_invalid
  (module
    (rec
      (type $pair (descriptor $pair.desc (struct (field i32 i64))))
      (type $pair.desc (describes $pair (struct)))
    )
    (func (result (ref (exact $pair)))
       The descriptor operand is missing.
      (struct.new_default $pair)
    )
  )
  "popping from empty stack"
)

(assert_invalid
  (module
    (rec
      (type $pair (descriptor $pair.desc (struct (field i32 i64))))
      (type $pair.desc (describes $pair (struct)))
    )
    (func (result (ref (exact $pair)))
      ;; The descriptor needs to be exact.
      (local $desc (ref null $pair.desc))
      (struct.new $pair
        (i32.const 0)
        (i64.const 1)
        (local.get $desc)
      )
    )
  )
  "struct.new descriptor operand should have proper type"
)

(assert_invalid
  (module
    (rec
      (type $pair (descriptor $pair.desc (struct (field i32 i64))))
      (type $pair.desc (describes $pair (struct)))
    )
    (func (result (ref (exact $pair)))
      ;; The descriptor needs to be exact.
      (local $desc (ref null $pair.desc))
      (struct.new_default $pair
        (local.get $desc)
      )
    )
  )
  "struct.new descriptor operand should have proper type"
)

(assert_invalid
  (module
    (rec
      (type $pair (descriptor $pair.desc (struct (field i32 i64))))
      (type $pair.desc (describes $pair (struct)))
      (type $other (struct))
    )
    (func (result (ref (exact $pair)))
      ;; The descriptor has the wrong heap type.
      (struct.new $pair
        (i32.const 0)
        (i64.const 1)
        (struct.new $other)
      )
    )
  )
  "struct.new descriptor operand should have proper type"
)

(assert_invalid
  (module
    (rec
      (type $pair (descriptor $pair.desc (struct (field i32 i64))))
      (type $pair.desc (describes $pair (struct)))
      (type $other (struct))
    )
    (func (result (ref (exact $pair)))
      ;; The descriptor has the wrong heap type.
      (struct.new_default $pair
        (struct.new $other)
      )
    )
  )
  "struct.new descriptor operand should have proper type"
)
