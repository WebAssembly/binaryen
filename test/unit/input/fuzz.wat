(module
  ;; Two structs, A and B, each of which has a subtype.
  (rec
    (type $A (sub (struct)))
    (type $A2 (sub $A (struct)))

    (type $B (sub (struct)))
    (type $B2 (sub $B(struct)))
  )

  ;; Two imports, one which will be reffed.
  (import "module" "base" (func $import (param i32 anyref) (result eqref)))
  (import "module" "base" (func $import-reffed (param i32 anyref) (result eqref)))

  ;; Two exports, one which will be reffed.

  (func $export (export "export") (param $0 i32) (param $1 anyref) (result eqref)
    ;; Add the refs.
    (drop
      (ref.func $import-reffed)
    )
    (drop
      (ref.func $export-reffed)
    )

    ;; Call the imports.
    (drop
      (call $import
        (i32.const 10)
        ;; Send $A. We can refine the anyref to $A or $A2 (but not $B or $B2).
        (struct.new $A)
      )
    )
    (drop
      (call $import-reffed
        (i32.const 20)
        (struct.new $A)
      )
    )

    ;; Return $B. We can refine the eqref to $B or $B2 (but not $A or $A2).
    (struct.new $B)
  )

  (func $export-reffed (export "export-reffed") (param $0 i32) (param $1 anyref) (result eqref)
    (struct.new $A)
  )
)
