(module
  ;; Two structs, A and B, each of which has a subtype.
  (rec
    (type $A (sub (struct)))
    (type $A2 (sub $A (struct)))

    (type $B (sub (struct)))
    (type $B2 (sub $B(struct)))
  )

  ;; Two imports, one which will be referenced.
  (import "module" "base" (func $import (param i32 anyref) (result eqref)))
  (import "module" "base" (func $import-reffed (param i32 anyref) (result eqref)))

  ;; Two exports, one which will be referenced.

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

  ;; An export without a ref.func but that has a tail call, which also prevents
  ;; us from refining its results. The called function and the caller both
  ;; return nullref initially, and each might be refined to a conflicting type,
  ;; if we are not careful here.

  (func $tail-called (export "tail-called") (result nullref)
    (ref.null $A)
  )

  (func $tail-caller (export "tail-caller") (param $x i32) (result nullref)
    (if
      (local.get $x)
      (then
        (return
          (ref.null $B)
        )
      )
    )
    (return_call $tail-called)
  )
)
