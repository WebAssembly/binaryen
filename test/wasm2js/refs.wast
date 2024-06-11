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
    ;; Test that we are aware that "$ref.func" below refers to the function and
    ;; not the local. This code will keep the local around (at least in an
    ;; unoptimized build), and it should use a different name than the function.
    (local $ref.func i32)
    (local.set $ref.func
      (i32.add
        (local.get $ref.func)
        (i32.const 1)
      )
    )

    (ref.func $ref.func)
  )

  (func $ref.eq (export "ref.eq") (param $x eqref) (param $y eqref) (result i32)
    (ref.eq
      (local.get $x)
      (local.get $y)
    )
  )

  (func $ref.as (export "ref.as") (param $x anyref) (result anyref)
    (ref.as_non_null
      (local.get $x)
    )
  )
)
