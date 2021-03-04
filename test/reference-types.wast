;; reftype :: externref | funcref

;; NOTE: the subtyping relationship has been removed from the reference-types proposal but an
;; `--enable-anyref` feature flag is present in Binaryen that we use below to test subtyping.
;;
;; reftype :: reftype | anyref
;; reftype <: anyref

(module
  (type $sig_externref (func (param externref)))
  (type $sig_funcref (func (param funcref)))
  (type $sig_anyref (func (param anyref)))

  (func $take_externref (param externref))
  (func $take_funcref (param funcref))
  (func $take_anyref (param anyref))
  (func $foo)

  (table funcref (elem $take_externref $take_funcref $take_anyref))
  (elem declare func $ref-taken-but-not-in-table)

  (import "env" "import_func" (func $import_func (param externref) (result funcref)))
  (import "env" "import_global" (global $import_global externref))
  (export "export_func" (func $import_func (param externref) (result funcref)))
  (export "export_global" (global $import_global))

  ;; Test global initializer expressions
  (global $global_externref (mut externref) (ref.null extern))
  (global $global_funcref (mut funcref) (ref.null func))
  (global $global_funcref_func (mut funcref) (ref.func $foo))
  (global $global_anyref (mut anyref) (ref.null any))

  ;; Test subtype relationship in global initializer expressions
  (global $global_anyref2 (mut anyref) (ref.null extern))
  (global $global_anyref3 (mut anyref) (ref.null func))
  (global $global_anyref4 (mut anyref) (ref.func $foo))

  (event $e-i32 (attr 0) (param i32))

  (func $test
    (local $local_externref externref)
    (local $local_funcref funcref)
    (local $local_anyref anyref)

    ;; Test types for local.get/set
    (local.set $local_externref (local.get $local_externref))
    (local.set $local_externref (global.get $global_externref))
    (local.set $local_externref (ref.null extern))
    (local.set $local_funcref (local.get $local_funcref))
    (local.set $local_funcref (global.get $global_funcref))
    (local.set $local_funcref (ref.null func))
    (local.set $local_funcref (ref.func $foo))
    (local.set $local_anyref (local.get $local_anyref))
    (local.set $local_anyref (global.get $global_anyref))
    (local.set $local_anyref (ref.null any))

    ;; Test subtype relationship for local.set
    (local.set $local_anyref (local.get $local_externref))
    (local.set $local_anyref (global.get $global_externref))
    (local.set $local_anyref (ref.null extern))
    (local.set $local_anyref (local.get $local_funcref))
    (local.set $local_anyref (global.get $global_funcref))
    (local.set $local_anyref (ref.null func))
    (local.set $local_anyref (ref.func $foo))

    ;; Test types for global.get/set
    (global.set $global_externref (global.get $global_externref))
    (global.set $global_externref (local.get $local_externref))
    (global.set $global_externref (ref.null extern))
    (global.set $global_funcref (global.get $global_funcref))
    (global.set $global_funcref (local.get $local_funcref))
    (global.set $global_funcref (ref.null func))
    (global.set $global_funcref (ref.func $foo))
    (global.set $global_anyref (global.get $global_anyref))
    (global.set $global_anyref (local.get $local_anyref))
    (global.set $global_anyref (ref.null any))

    ;; Test subtype relationship for global.set
    (global.set $global_anyref (global.get $global_externref))
    (global.set $global_anyref (local.get $local_externref))
    (global.set $global_anyref (ref.null extern))
    (global.set $global_anyref (global.get $global_funcref))
    (global.set $global_anyref (local.get $local_funcref))
    (global.set $global_anyref (ref.null func))
    (global.set $global_anyref (ref.func $foo))

    ;; Test function call params
    (call $take_externref (local.get $local_externref))
    (call $take_externref (global.get $global_externref))
    (call $take_externref (ref.null extern))
    (call $take_funcref (local.get $local_funcref))
    (call $take_funcref (global.get $global_funcref))
    (call $take_funcref (ref.null func))
    (call $take_funcref (ref.func $foo))
    (call $take_anyref (local.get $local_anyref))
    (call $take_anyref (global.get $global_anyref))
    (call $take_anyref (ref.null any))

    ;; Test subtype relationship for function call params
    (call $take_anyref (local.get $local_externref))
    (call $take_anyref (global.get $global_externref))
    (call $take_anyref (ref.null extern))
    (call $take_anyref (local.get $local_funcref))
    (call $take_anyref (global.get $global_funcref))
    (call $take_anyref (ref.null func))
    (call $take_anyref (ref.func $foo))

    ;; Test call_indirect params
    (call_indirect (type $sig_externref) (local.get $local_externref) (i32.const 0))
    (call_indirect (type $sig_externref) (global.get $global_externref) (i32.const 0))
    (call_indirect (type $sig_externref) (ref.null extern) (i32.const 0))
    (call_indirect (type $sig_funcref) (local.get $local_funcref) (i32.const 1))
    (call_indirect (type $sig_funcref) (global.get $global_funcref) (i32.const 1))
    (call_indirect (type $sig_funcref) (ref.null func) (i32.const 1))
    (call_indirect (type $sig_funcref) (ref.func $foo) (i32.const 1))
    (call_indirect (type $sig_anyref) (local.get $local_anyref) (i32.const 3))
    (call_indirect (type $sig_anyref) (global.get $global_anyref) (i32.const 3))
    (call_indirect (type $sig_anyref) (ref.null any) (i32.const 3))

    ;; Test subtype relationship for call_indirect params
    (call_indirect (type $sig_anyref) (local.get $local_externref) (i32.const 3))
    (call_indirect (type $sig_anyref) (global.get $global_externref) (i32.const 3))
    (call_indirect (type $sig_anyref) (ref.null extern) (i32.const 3))
    (call_indirect (type $sig_anyref) (local.get $local_funcref) (i32.const 3))
    (call_indirect (type $sig_anyref) (global.get $global_funcref) (i32.const 3))
    (call_indirect (type $sig_anyref) (ref.null func) (i32.const 3))
    (call_indirect (type $sig_anyref) (ref.func $foo) (i32.const 3))

    ;; Test block return type
    (drop
      (block (result externref)
        (br_if 0 (local.get $local_externref) (i32.const 1))
      )
    )
    (drop
      (block (result externref)
        (br_if 0 (global.get $global_externref) (i32.const 1))
      )
    )
    (drop
      (block (result externref)
        (br_if 0 (ref.null extern) (i32.const 1))
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
        (br_if 0 (local.get $local_externref) (i32.const 1))
      )
    )
    (drop
      (block (result anyref)
        (br_if 0 (local.get $local_funcref) (i32.const 1))
      )
    )
    (drop
      (block (result anyref)
        (br_if 0 (ref.null extern) (i32.const 1))
      )
    )
    (drop
      (block (result anyref)
        (br_if 0 (ref.null func) (i32.const 1))
      )
    )
    (drop
      (block (result anyref)
        (br_if 0 (ref.func $foo) (i32.const 1))
      )
    )

    ;; Test loop return type
    (drop
      (loop (result externref)
        (local.get $local_externref)
      )
    )
    (drop
      (loop (result externref)
        (global.get $global_externref)
      )
    )
    (drop
      (loop (result externref)
        (ref.null extern)
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
        (local.get $local_externref)
      )
    )
    (drop
      (loop (result anyref)
        (global.get $global_externref)
      )
    )
    (drop
      (loop (result anyref)
        (ref.null extern)
      )
    )
    (drop
      (loop (result anyref)
        (local.get $local_funcref)
      )
    )
    (drop
      (loop (result anyref)
        (global.get $global_funcref)
      )
    )
    (drop
      (loop (result anyref)
        (ref.null func)
      )
    )
    (drop
      (loop (result anyref)
        (ref.func $foo)
      )
    )

    ;; Test if return type
    (drop
      (if (result externref)
        (i32.const 1)
        (local.get $local_externref)
        (ref.null extern)
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
        (local.get $local_externref)
        (local.get $local_funcref)
      )
    )
    (drop
      (if (result anyref)
        (i32.const 1)
        (ref.null extern)
        (ref.null func)
      )
    )
    (drop
      (if (result anyref)
        (i32.const 1)
        (ref.func $foo)
        (ref.null extern)
      )
    )

    ;; Test try return type
    (drop
      (try (result externref)
        (do
          (local.get $local_externref)
        )
        (catch $e-i32
          (drop (pop i32))
          (ref.null extern)
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
          (local.get $local_externref)
        )
        (catch $e-i32
          (drop (pop i32))
          (ref.func $foo)
        )
      )
    )
    (drop
      (try (result anyref)
        (do
          (ref.func $foo)
        )
        (catch $e-i32
          (drop (pop i32))
          (local.get $local_externref)
        )
      )
    )

    ;; Test typed select
    (drop
      (select (result externref)
        (local.get $local_externref)
        (ref.null extern)
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
        (local.get $local_externref)
        (local.get $local_funcref)
        (i32.const 1)
      )
    )
    (drop
      (select (result anyref)
        (local.get $local_funcref)
        (local.get $local_externref)
        (i32.const 1)
      )
    )

    ;; ref.is_null takes any reference types
    (drop (ref.is_null (local.get $local_externref)))
    (drop (ref.is_null (global.get $global_externref)))
    (drop (ref.is_null (ref.null extern)))
    (drop (ref.is_null (local.get $local_funcref)))
    (drop (ref.is_null (global.get $global_funcref)))
    (drop (ref.is_null (ref.null func)))
    (drop (ref.is_null (ref.func $foo)))
    (drop (ref.is_null (local.get $local_anyref)))
    (drop (ref.is_null (global.get $global_anyref)))
    (drop (ref.is_null (ref.null any)))
  )

  ;; Test function return type
  (func $return_externref_local (result externref)
    (local $local_externref externref)
    (local.get $local_externref)
  )
  (func $return_externref_global (result externref)
    (global.get $global_externref)
  )
  (func $return_externref_null (result externref)
    (ref.null extern)
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
    (local $local_externref externref)
    (local.get $local_externref)
  )
  (func $return_anyref3 (result anyref)
    (global.get $global_externref)
  )
  (func $return_anyref4 (result anyref)
    (ref.null extern)
  )
  (func $return_anyref5 (result anyref)
    (local $local_funcref funcref)
    (local.get $local_funcref)
  )
  (func $return_anyref6 (result anyref)
    (global.get $global_funcref)
  )
  (func $return_anyref7 (result anyref)
    (ref.null func)
  )
  (func $return_anyref8 (result anyref)
    (ref.func $foo)
  )

  ;; Test returns
  (func $returns_externref (result externref)
    (local $local_externref externref)
    (return (local.get $local_externref))
    (return (global.get $global_externref))
    (return (ref.null extern))
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
    (local $local_externref externref)
    (local $local_funcref funcref)
    (return (local.get $local_externref))
    (return (global.get $global_externref))
    (return (ref.null extern))
    (return (local.get $local_funcref))
    (return (global.get $global_funcref))
    (return (ref.func $foo))
    (return (ref.null func))
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
