(module
  (func $null (export "null") (result anyref)
    (ref.null any)
  )

  (func $is_null (export "is_null") (param $ref anyref) (result i32)
    (ref.is_null
      (local.get $ref)
    )
  )

  (func $ref.func (export "ref.func") (result funcref)
    (ref.func $ref.func)
  )

  (func $ref.eq (export "ref.eq") (param $x eqref) (param $y eqref) (result i32)
    (ref.eq
      (local.get $x)
      (local.get $y)
    )
  )
)
