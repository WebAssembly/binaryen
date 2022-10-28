(module
  (type $sig_eqref (func (param eqref)))
  (type $sig_funcref (func (param funcref)))
  (type $sig_anyref (func (param anyref)))

  (func $take_eqref (param eqref))
  (func $take_funcref (param funcref))
  (func $take_anyref (param anyref))
  (func $foo)

  (table funcref (elem $take_eqref $take_funcref $take_anyref))
  (elem declare func $ref-taken-but-not-in-table)

  (import "env" "import_func" (func $import_func (param eqref) (result funcref)))
  (import "env" "import_global" (global $import_global eqref))
  (export "export_func" (func $import_func (param eqref) (result funcref)))
  (export "export_global" (global $import_global))

  ;; Test global initializer expressions
  (global $global_eqref (mut eqref) (ref.null eq))
  (global $global_funcref (mut funcref) (ref.null func))
  (global $global_funcref_func (mut funcref) (ref.func $foo))
  (global $global_anyref (mut anyref) (ref.null any))

  ;; Test subtype relationship in global initializer expressions
  (global $global_anyref2 (mut anyref) (ref.null eq))

  (tag $e-i32 (param i32))

  (func $test
    (local $local_eqref eqref)
    (local $local_funcref funcref)
    (local $local_anyref anyref)

    ;; Test types for local.get/set
    (local.set $local_eqref (local.get $local_eqref))
    (local.set $local_eqref (global.get $global_eqref))
    (local.set $local_eqref (ref.null eq))
    (local.set $local_funcref (local.get $local_funcref))
    (local.set $local_funcref (global.get $global_funcref))
    (local.set $local_funcref (ref.null func))
    (local.set $local_funcref (ref.func $foo))
    (local.set $local_anyref (local.get $local_anyref))
    (local.set $local_anyref (global.get $global_anyref))
    (local.set $local_anyref (ref.null any))

    ;; Test subtype relationship for local.set
    (local.set $local_anyref (local.get $local_eqref))
    (local.set $local_anyref (global.get $global_eqref))
    (local.set $local_anyref (ref.null eq))

    ;; Test types for global.get/set
    (global.set $global_eqref (global.get $global_eqref))
    (global.set $global_eqref (local.get $local_eqref))
    (global.set $global_eqref (ref.null eq))
    (global.set $global_funcref (global.get $global_funcref))
    (global.set $global_funcref (local.get $local_funcref))
    (global.set $global_funcref (ref.null func))
    (global.set $global_funcref (ref.func $foo))
    (global.set $global_anyref (global.get $global_anyref))
    (global.set $global_anyref (local.get $local_anyref))
    (global.set $global_anyref (ref.null any))

    ;; Test subtype relationship for global.set
    (global.set $global_anyref (global.get $global_eqref))
    (global.set $global_anyref (local.get $local_eqref))
    (global.set $global_anyref (ref.null eq))

    ;; Test function call params
    (call $take_eqref (local.get $local_eqref))
    (call $take_eqref (global.get $global_eqref))
    (call $take_eqref (ref.null eq))
    (call $take_funcref (local.get $local_funcref))
    (call $take_funcref (global.get $global_funcref))
    (call $take_funcref (ref.null func))
    (call $take_funcref (ref.func $foo))
    (call $take_anyref (local.get $local_anyref))
    (call $take_anyref (global.get $global_anyref))
    (call $take_anyref (ref.null any))

    ;; Test subtype relationship for function call params
    (call $take_anyref (local.get $local_eqref))
    (call $take_anyref (global.get $global_eqref))
    (call $take_anyref (ref.null eq))

    ;; Test call_indirect params
    (call_indirect (type $sig_eqref) (local.get $local_eqref) (i32.const 0))
    (call_indirect (type $sig_eqref) (global.get $global_eqref) (i32.const 0))
    (call_indirect (type $sig_eqref) (ref.null eq) (i32.const 0))
    (call_indirect (type $sig_funcref) (local.get $local_funcref) (i32.const 1))
    (call_indirect (type $sig_funcref) (global.get $global_funcref) (i32.const 1))
    (call_indirect (type $sig_funcref) (ref.null func) (i32.const 1))
    (call_indirect (type $sig_funcref) (ref.func $foo) (i32.const 1))
    (call_indirect (type $sig_anyref) (local.get $local_anyref) (i32.const 3))
    (call_indirect (type $sig_anyref) (global.get $global_anyref) (i32.const 3))
    (call_indirect (type $sig_anyref) (ref.null any) (i32.const 3))

    ;; Test subtype relationship for call_indirect params
    (call_indirect (type $sig_anyref) (local.get $local_eqref) (i32.const 3))
    (call_indirect (type $sig_anyref) (global.get $global_eqref) (i32.const 3))
    (call_indirect (type $sig_anyref) (ref.null eq) (i32.const 3))

    ;; Test block return type
    (drop
      (block (result eqref)
        (br_if 0 (local.get $local_eqref) (i32.const 1))
      )
    )
    (drop
      (block (result eqref)
        (br_if 0 (global.get $global_eqref) (i32.const 1))
      )
    )
    (drop
      (block (result eqref)
        (br_if 0 (ref.null eq) (i32.const 1))
      )
    )
    (drop
      (block (result funcref)
        (br_if 0 (local.get $local_funcref) (i32.const 1))
      )
    )
    (drop
      (block (result funcref)
        (br_if 0 (global.get $global_funcref) (i32.const 1))
      )
    )
    (drop
      (block (result funcref)
        (br_if 0 (ref.null func) (i32.const 1))
      )
    )
    (drop
      (block (result funcref)
        (br_if 0 (ref.func $foo) (i32.const 1))
      )
    )
    (drop
      (block (result anyref)
        (br_if 0 (local.get $local_anyref) (i32.const 1))
      )
    )
    (drop
      (block (result anyref)
        (br_if 0 (global.get $global_anyref) (i32.const 1))
      )
    )
    (drop
      (block (result anyref)
        (br_if 0 (ref.null any) (i32.const 1))
      )
    )

    ;; Test subtype relationship for block return type
    (drop
      (block (result anyref)
        (br_if 0 (local.get $local_eqref) (i32.const 1))
      )
    )
    (drop
      (block (result anyref)
        (br_if 0 (ref.null eq) (i32.const 1))
      )
    )

    ;; Test loop return type
    (drop
      (loop (result eqref)
        (local.get $local_eqref)
      )
    )
    (drop
      (loop (result eqref)
        (global.get $global_eqref)
      )
    )
    (drop
      (loop (result eqref)
        (ref.null eq)
      )
    )
    (drop
      (loop (result funcref)
        (local.get $local_funcref)
      )
    )
    (drop
      (loop (result funcref)
        (global.get $global_funcref)
      )
    )
    (drop
      (loop (result funcref)
        (ref.null func)
      )
    )
    (drop
      (loop (result funcref)
        (ref.func $foo)
      )
    )
    (drop
      (loop (result anyref)
        (local.get $local_anyref)
      )
    )
    (drop
      (loop (result anyref)
        (global.get $global_anyref)
      )
    )
    (drop
      (loop (result anyref)
        (ref.null any)
      )
    )

    ;; Test subtype relationship for loop return type
    (drop
      (loop (result anyref)
        (local.get $local_eqref)
      )
    )
    (drop
      (loop (result anyref)
        (global.get $global_eqref)
      )
    )
    (drop
      (loop (result anyref)
        (ref.null eq)
      )
    )

    ;; Test if return type
    (drop
      (if (result eqref)
        (i32.const 1)
        (local.get $local_eqref)
        (ref.null eq)
      )
    )
    (drop
      (if (result funcref)
        (i32.const 1)
        (local.get $local_funcref)
        (ref.null func)
      )
    )
    (drop
      (if (result anyref)
        (i32.const 1)
        (local.get $local_anyref)
        (ref.null any)
      )
    )

    ;; Test subtype relationship for if return type
    (drop
      (if (result anyref)
        (i32.const 1)
        (local.get $local_eqref)
        (local.get $local_eqref)
      )
    )
    (drop
      (if (result anyref)
        (i32.const 1)
        (ref.null eq)
        (ref.null i31)
      )
    )
    (drop
      (if (result anyref)
        (i32.const 1)
        (i31.new
          (i32.const 0)
        )
        (ref.null eq)
      )
    )

    ;; Test try return type
    (drop
      (try (result eqref)
        (do
          (local.get $local_eqref)
        )
        (catch $e-i32
          (drop (pop i32))
          (ref.null eq)
        )
      )
    )
    (drop
      (try (result funcref)
        (do
          (ref.func $foo)
        )
        (catch $e-i32
          (drop (pop i32))
          (ref.null func)
        )
      )
    )

    ;; Test subtype relationship for try return type
    (drop
      (try (result anyref)
        (do
          (local.get $local_eqref)
        )
        (catch $e-i32
          (drop (pop i32))
          (ref.null any)
        )
      )
    )
    (drop
      (try (result anyref)
        (do
          (ref.null eq)
        )
        (catch $e-i32
          (drop (pop i32))
          (local.get $local_eqref)
        )
      )
    )

    ;; Test typed select
    (drop
      (select (result eqref)
        (local.get $local_eqref)
        (ref.null eq)
        (i32.const 1)
      )
    )
    (drop
      (select (result funcref)
        (local.get $local_funcref)
        (ref.null func)
        (i32.const 1)
      )
    )
    (drop
      (select (result i32)
        (i32.const 0)
        (i32.const 2)
        (i32.const 1)
      )
    )

    ;; Test subtype relationship for typed select
    (drop
      (select (result anyref)
        (local.get $local_eqref)
        (i31.new
          (i32.const 0)
        )
        (i32.const 1)
      )
    )

    ;; ref.is_null takes any reference types
    (drop (ref.is_null (local.get $local_eqref)))
    (drop (ref.is_null (global.get $global_eqref)))
    (drop (ref.is_null (ref.null eq)))
    (drop (ref.is_null (local.get $local_funcref)))
    (drop (ref.is_null (global.get $global_funcref)))
    (drop (ref.is_null (ref.null func)))
    (drop (ref.is_null (ref.func $foo)))
    (drop (ref.is_null (local.get $local_anyref)))
    (drop (ref.is_null (global.get $global_anyref)))
    (drop (ref.is_null (ref.null any)))
  )

  ;; Test function return type
  (func $return_eqref_local (result eqref)
    (local $local_eqref eqref)
    (local.get $local_eqref)
  )
  (func $return_eqref_global (result eqref)
    (global.get $global_eqref)
  )
  (func $return_eqref_null (result eqref)
    (ref.null eq)
  )
  (func $return_funcref_local (result funcref)
    (local $local_funcref funcref)
    (local.get $local_funcref)
  )
  (func $return_funcref_global (result funcref)
    (global.get $global_funcref)
  )
  (func $return_funcref_null (result funcref)
    (ref.null func)
  )
  (func $return_funcref_func (result funcref)
    (ref.func $foo)
  )
  (func $return_anyref_local (result anyref)
    (local $local_anyref anyref)
    (local.get $local_anyref)
  )
  (func $return_anyref_global (result anyref)
    (global.get $global_anyref)
  )
  (func $return_anyref_null (result anyref)
    (ref.null any)
  )

  ;; Test subtype relationship in function return type
  (func $return_anyref2 (result anyref)
    (local $local_eqref eqref)
    (local.get $local_eqref)
  )
  (func $return_anyref3 (result anyref)
    (global.get $global_eqref)
  )
  (func $return_anyref4 (result anyref)
    (ref.null eq)
  )

  ;; Test returns
  (func $returns_eqref (result eqref)
    (local $local_eqref eqref)
    (return (local.get $local_eqref))
    (return (global.get $global_eqref))
    (return (ref.null eq))
  )
  (func $returns_funcref (result funcref)
    (local $local_funcref funcref)
    (return (local.get $local_funcref))
    (return (global.get $global_funcref))
    (return (ref.func $foo))
    (return (ref.null func))
  )
  (func $returns_anyref (result anyref)
    (local $local_anyref anyref)
    (return (local.get $local_anyref))
    (return (global.get $global_anyref))
    (return (ref.null any))
  )

  ;; Test subtype relationship in returns
  (func $returns_anyref2 (result anyref)
    (local $local_eqref eqref)
    (local $local_funcref funcref)
    (return (local.get $local_eqref))
    (return (global.get $global_eqref))
    (return (ref.null eq))
  )

  (func $ref-user
    (drop
      ;; an "elem declare func" must be emitted for this ref.func which is not
      ;; in the table
      (ref.func $ref-taken-but-not-in-table)
    )
  )
  (func $ref-taken-but-not-in-table)
)
