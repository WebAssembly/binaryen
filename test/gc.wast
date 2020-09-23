;; A preliminary test for prototype GC types and instructions.
;; TODO: Move subtype tests from reference-types.wast here?

(module
  ;; TODO: There are no trivial global initializers for i31ref globals because
  ;; i31ref is non-nullable, hence `(ref.null i31)` cannot be used. The test
  ;; currently works around this limitation by importing a constant value.
  (import "env" "trivial_i31ref" (global $trivial_i31ref i31ref))

  ;; Test global initializer expressions
  (global $global_anyref (mut anyref) (ref.null any))
  (global $global_eqref (mut eqref) (ref.null eq))
  (global $global_i31ref (mut i31ref) (global.get $trivial_i31ref)) ;; ^

  ;; Test subtype relationship in global initializer expressions
  (global $global_anyref2 (mut anyref) (ref.null eq))
  (global $global_anyref3 (mut anyref) (global.get $trivial_i31ref)) ;; ^
  (global $global_eqref2 (mut eqref) (global.get $trivial_i31ref)) ;; ^

  (func $test
    (local $local_i32 i32)
    (local $local_anyref anyref)
    (local $local_eqref eqref)
    (local $local_i31ref i31ref)

    ;; Test types for local.get/set
    (local.set $local_anyref (local.get $local_anyref))
    (local.set $local_anyref (global.get $global_anyref))
    (local.set $local_anyref (ref.null any))
    (local.set $local_eqref (local.get $local_eqref))
    (local.set $local_eqref (global.get $global_eqref))
    (local.set $local_eqref (ref.null eq))
    (local.set $local_i31ref (local.get $local_i31ref))
    (local.set $local_i31ref (global.get $global_i31ref))
    (local.set $local_i31ref (global.get $trivial_i31ref)) ;; ^

    ;; Test subtype relationship for local.set
    (local.set $local_anyref (local.get $local_eqref))
    (local.set $local_anyref (global.get $global_eqref))
    (local.set $local_anyref (ref.null eq))
    (local.set $local_anyref (local.get $local_i31ref))
    (local.set $local_anyref (global.get $global_i31ref))
    (local.set $local_anyref (global.get $trivial_i31ref)) ;; ^
    (local.set $local_eqref (local.get $local_i31ref))
    (local.set $local_eqref (global.get $global_i31ref))
    (local.set $local_eqref (global.get $trivial_i31ref)) ;; ^

    ;; Test types for global.get/set
    (global.set $global_anyref (local.get $local_anyref))
    (global.set $global_anyref (global.get $global_anyref))
    (global.set $global_anyref (ref.null any))
    (global.set $global_eqref (local.get $local_eqref))
    (global.set $global_eqref (global.get $global_eqref))
    (global.set $global_eqref (ref.null eq))
    (global.set $global_i31ref (local.get $local_i31ref))
    (global.set $global_i31ref (global.get $global_i31ref))
    (global.set $global_i31ref (global.get $trivial_i31ref)) ;; ^

    ;; Test subtype relationship for global.set
    (global.set $global_anyref (local.get $local_eqref))
    (global.set $global_anyref (global.get $global_eqref))
    (global.set $global_anyref (ref.null eq))
    (global.set $global_anyref (local.get $local_i31ref))
    (global.set $global_anyref (global.get $global_i31ref))
    (global.set $global_anyref (global.get $trivial_i31ref)) ;; ^
    (global.set $global_eqref (local.get $local_i31ref))
    (global.set $global_eqref (global.get $global_i31ref))
    (global.set $global_eqref (global.get $trivial_i31ref)) ;; ^

    ;; Test i31.new
    (local.set $local_i31ref (i31.new (i32.const 0)))

    ;; Test subtype relationship for for i31.new
    (local.set $local_anyref (i31.new (i32.const 0)))
    (local.set $local_eqref (i31.new (i32.const 0)))

    ;; Test i31.get_s/u
    (local.set $local_i32 (i31.get_s (local.get $local_i31ref)))
    (local.set $local_i32 (i31.get_u (local.get $local_i31ref)))
  )
)
