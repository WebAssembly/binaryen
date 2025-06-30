(module
  (rec
    (type $struct (descriptor $desc (struct)))
    (type $desc (describes $struct (struct)))
  )

  (global $desc1 (ref (exact $desc)) (struct.new $desc))
  (global $desc2 (ref (exact $desc)) (struct.new $desc))
  (global $struct1 (ref $struct) (struct.new $struct (global.get $desc1)))
  (global $struct2 (ref $struct) (struct.new $struct (global.get $desc2)))

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

  (func (export "check-descs") (result i32)
    (i32.and
      (i32.and
        (ref.eq (ref.get_desc $struct (global.get $struct1)) (global.get $desc1))
        (ref.eq (ref.get_desc $struct (global.get $struct2)) (global.get $desc2))
      )
      (i32.eqz (ref.eq (global.get $desc1) (global.get $desc2)))
    )
  )

  (func (export "desc-trap") (result (ref $struct))
    (struct.new $struct (unreachable))
  )
)

(assert_return (invoke "check-descs") (i32.const 1))
(assert_trap (invoke "desc-trap") "unreachable")

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
