(module
  (rec
    (type $pair (descriptor $pair.desc (struct (field i32 i64))))
    (type $pair.desc (describes $pair (struct)))
  )
  (func $struct.new (result (ref (exact $pair)))
    (local $desc (ref null (exact $pair.desc)))
    (struct.new $pair
      (i32.const 0)
      (i64.const 1)
      (local.get $desc)
    )
  )
  (func $struct.new_default (result (ref (exact $pair)))
    (local $desc (ref null (exact $pair.desc)))
    (struct.new_default $pair
      (local.get $desc)
    )
  )
)

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
