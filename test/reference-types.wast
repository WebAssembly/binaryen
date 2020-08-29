;; reftype :: externref | funcref | exnref

;; NOTE: Subtyping relationship has been removed from reference-types, but has
;; been reintroduced in (the current state of) the GC proposal. hence, instead
;; of deleting most of the following tests, we are assuming that the following
;; minimal subtyping rules exists on top of reference-types:
;; funcref (<: anyref) <: externref
;; exnref (<: anyref) <: externref

(module
  (type $sig_externref (func (param externref)))
  (type $sig_funcref (func (param funcref)))
  (type $sig_exnref (func (param exnref)))

  (func $take_externref (param externref))
  (func $take_funcref (param funcref))
  (func $take_exnref (param exnref))
  (func $foo)

  (table funcref (elem $take_externref $take_funcref $take_exnref))

  (import "env" "import_func" (func $import_func (param externref) (result funcref)))
  (import "env" "import_global" (global $import_global externref))
  (export "export_func" (func $import_func (param externref) (result funcref)))
  (export "export_global" (global $import_global))

  ;; Test subtype relationship in global initializer expressions
  (global $global_externref (mut externref) (ref.null extern))
  (global $global_funcref (mut funcref) (ref.null func))
  (global $global_exnref (mut exnref) (ref.null exn))
  (global $global_externref2 (mut externref) (ref.func $foo))
  (global $global_funcref2 (mut funcref) (ref.func $foo))

  (func $test (local $local_externref externref) (local $local_funcref funcref)
        (local $local_exnref exnref)
    ;; Test subtype relationship for local.set & Test types for local.get
    (local.set $local_externref (local.get $local_externref))
    (local.set $local_externref (local.get $local_funcref))
    (local.set $local_externref (local.get $local_exnref))
    (local.set $local_externref (ref.null extern))
    (local.set $local_externref (ref.func $foo))
    (local.set $local_funcref (local.get $local_funcref))
    (local.set $local_funcref (ref.null func))
    (local.set $local_funcref (ref.func $foo))
    (local.set $local_exnref (local.get $local_exnref))
    (local.set $local_exnref (ref.null exn))

    ;; Test subtype relationship for global.set & Test types for global.get
    (global.set $global_externref (global.get $global_externref))
    (global.set $global_externref (global.get $global_funcref))
    (global.set $global_externref (global.get $global_exnref))
    (global.set $global_externref (ref.null extern))
    (global.set $global_externref (ref.func $foo))
    (global.set $global_funcref (global.get $global_funcref))
    (global.set $global_funcref (ref.null func))
    (global.set $global_funcref (ref.func $foo))
    (global.set $global_exnref (global.get $global_exnref))
    (global.set $global_exnref (ref.null exn))

    ;; Test subtype relationship for function call / call_indirect params
    (call $take_externref (local.get $local_externref))
    (call $take_externref (local.get $local_funcref))
    (call $take_externref (local.get $local_exnref))
    (call $take_externref (ref.null extern))
    (call_indirect (type $sig_externref) (local.get $local_externref) (i32.const 0))
    (call_indirect (type $sig_externref) (local.get $local_funcref) (i32.const 0))
    (call_indirect (type $sig_externref) (local.get $local_exnref) (i32.const 0))
    (call_indirect (type $sig_externref) (ref.null extern) (i32.const 0))
    (call_indirect (type $sig_funcref) (local.get $local_funcref) (i32.const 1))
    (call_indirect (type $sig_funcref) (ref.null func) (i32.const 1))
    (call_indirect (type $sig_exnref) (local.get $local_exnref) (i32.const 2))
    (call_indirect (type $sig_exnref) (ref.null exn) (i32.const 2))

    ;; Test subtype relationship for block return type
    (drop
      (block (result externref)
        (br_if 0 (local.get $local_externref) (i32.const 1))
      )
    )
    (drop
      (block (result externref)
        (br_if 0 (local.get $local_funcref) (i32.const 1))
      )
    )
    (drop
      (block (result externref)
        (br_if 0 (local.get $local_exnref) (i32.const 1))
      )
    )
    (drop
      (block (result externref)
        (br_if 0 (ref.null extern) (i32.const 1))
      )
    )
    (drop
      (block (result funcref)
        (br_if 0 (ref.null func) (i32.const 1))
      )
    )
    (drop
      (block (result exnref)
        (br_if 0 (ref.null exn) (i32.const 1))
      )
    )

    ;; Test subtype relationship for loop return type
    (drop
      (loop (result externref)
        (local.get $local_externref)
      )
    )
    (drop
      (loop (result externref)
        (local.get $local_funcref)
      )
    )
    (drop
      (loop (result externref)
        (local.get $local_exnref)
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
        (ref.null func)
      )
    )
    (drop
      (loop (result exnref)
        (local.get $local_exnref)
      )
    )
    (drop
      (loop (result exnref)
        (ref.null exn)
      )
    )

    ;; Test subtype relationship for if return type
    (drop
      (if (result externref)
        (i32.const 1)
        (local.get $local_externref)
        (local.get $local_exnref)
      )
    )
    (drop
      (if (result externref)
        (i32.const 1)
        (ref.func $foo)
        (ref.null extern)
      )
    )
    (drop
      (if (result funcref)
        (i32.const 1)
        (ref.func $foo)
        (ref.null func)
      )
    )
    (drop
      (if (result exnref)
        (i32.const 1)
        (local.get $local_exnref)
        (ref.null exn)
      )
    )

    ;; Test subtype relationship for try return type
    (drop
      (try (result externref)
        (do
          (local.get $local_externref)
        )
        (catch
          (exnref.pop)
        )
      )
    )
    (drop
      (try (result externref)
        (do
          (ref.func $foo)
        )
        (catch
          (drop (exnref.pop))
          (ref.null extern)
        )
      )
    )
    (drop
      (try (result funcref)
        (do
          (ref.func $foo)
        )
        (catch
          (drop (exnref.pop))
          (ref.null func)
        )
      )
    )
    (drop
      (try (result exnref)
        (do
          (ref.null exn)
        )
        (catch
          (exnref.pop)
        )
      )
    )

    ;; Test subtype relationship for typed select
    (drop
      (select (result externref)
        (local.get $local_externref)
        (ref.func $foo)
        (i32.const 1)
      )
    )
    (drop
      (select (result externref)
        (local.get $local_exnref)
        (local.get $local_externref)
        (i32.const 1)
      )
    )
    (drop
      (select (result externref)
        (local.get $local_externref)
        (ref.null extern)
        (i32.const 1)
      )
    )
    (drop
      (select (result externref)
        (ref.null extern)
        (ref.func $foo)
        (i32.const 1)
      )
    )
    (drop
      (select (result funcref)
        (ref.func $foo)
        (ref.null func)
        (i32.const 1)
      )
    )
    (drop
      (select (result exnref)
        (ref.null exn)
        (local.get $local_exnref)
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

    ;; ref.is_null takes any reference types
    (drop (ref.is_null (local.get $local_externref)))
    (drop (ref.is_null (local.get $local_exnref)))
    (drop (ref.is_null (ref.func $foo)))
    (drop (ref.is_null (ref.null extern)))
  )

  ;; Test subtype relationship in function return type
  (func $return_externref (result externref) (local $local_externref externref)
    (local.get $local_externref)
  )
  (func $return_externref2 (result externref)
    (ref.func $foo)
  )
  (func $return_externref3 (result externref) (local $local_exnref exnref)
    (local.get $local_exnref)
  )
  (func $return_externref4 (result externref)
    (ref.null extern)
  )
  (func $return_funcref (result funcref)
    (ref.func $foo)
  )
  (func $return_funcref2 (result funcref)
    (ref.null func)
  )
  (func $return_exnref (result exnref) (local $local_exnref exnref)
    (local.get $local_exnref)
  )
  (func $return_exnref2 (result exnref)
    (ref.null exn)
  )

  ;; Test subtype relationship in returns
  (func $return_externref_returns (result externref) (local $local_externref externref)
        (local $local_exnref exnref)
    (return (local.get $local_externref))
    (return (local.get $local_exnref))
    (return (ref.func $foo))
    (return (ref.null extern))
  )
  (func $return_funcref_returns (result funcref)
    (return (ref.func $foo))
    (return (ref.null func))
  )
  (func $return_exnref_returns (result exnref) (local $local_exnref exnref)
    (return (local.get $local_exnref))
    (return (ref.null exn))
  )
)
