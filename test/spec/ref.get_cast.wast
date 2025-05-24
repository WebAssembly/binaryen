(module
  (rec
    (type $struct (descriptor $desc (struct)))
    (type $desc (describes $struct (struct)))
  )
  (func $unreachable (param $struct (ref null $struct)) (result (ref $desc))
    (ref.get_desc $struct
      (unreachable)
    )
  )
  (func $null (param $struct (ref null $struct)) (result (ref $desc))
    (ref.get_desc $struct
      (ref.null none)
    )
  )
  (func $inexact (param $struct (ref null $struct)) (result (ref $desc))
    (ref.get_desc $struct
      (local.get $struct)
    )
  )
  (func $exact (param $struct (ref null (exact $struct))) (result (ref (exact $desc)))
    (ref.get_desc $struct
      (local.get $struct)
    )
  )
)

(assert_invalid
  (module
    (rec
      (type $struct (descriptor $desc (struct)))
      (type $desc (describes $struct (struct)))
    )
    (func (param $struct (ref null $struct)) (result (ref (exact $desc)))
      ;; The result is not exact if the input is not exact.
      (ref.get_desc $struct
        (local.get $struct)
      )
    )
  )
  "function body must match"
)

(assert_invalid
  (module
    (type $struct (struct))
    (func (param $struct (ref null $struct)) (result anyref)
      ;; The type must have a descriptor
      (ref.get_desc $struct
        (local.get $struct)
      )
    )
  )
  "expected type with descriptor"
)
