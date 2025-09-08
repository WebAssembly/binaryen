(module
  (type $func (func (result funcref)))

  (global $global (mut anyref) (ref.null any))

  (global $global-ref (mut funcref) (ref.func $use-global-ref))

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

  (func $use-global (export "use-global") (param $x anyref) (result anyref)
    (local $temp anyref)
    (local.set $temp
      (global.get $global)
    )
    (global.set $global
      (local.get $x)
    )
    (local.get $temp)
  )

  (func $use-global-ref (export "use-global-ref") (param $x funcref) (result funcref)
    (local $temp funcref)
    (local.set $temp
      (global.get $global-ref)
    )
    (global.set $global-ref
      (local.get $x)
    )
    (local.get $temp)
  )

  (func $funcref_temps (export "funcref_temps") (param $0 funcref) (param $1 f64)
    ;; A deeply-nested expression that ends up requiring multiple function type
    ;; temp variables.
    (call $funcref_temps
      (ref.func $funcref_temps)
      (f64.convert_i32_s
        (ref.is_null
          (select (result funcref)
            (local.get $0)
            (loop $loop (result funcref)
              (ref.func $funcref_temps)
            )
            (i32.const 0)
          )
        )
      )
    )
  )

  (func $named_type_temps (export "named_type_temps") (result funcref)
    ;; This nested expression ends up needing to use temp vars, and one such
    ;; name contains the type $func. We should emit that in form that is
    ;; mangled for JS, without '(' which appears in the stringified name of the
    ;; type, "(ref null $func)".
    (select (result (ref null $func))
      (ref.null nofunc)
      (if (result (ref $func))
        (i32.const 1)
        (then
          (ref.func $named_type_temps)
        )
        (else
          (unreachable)
        )
      )
      (i32.const 0)
    )
  )
)
