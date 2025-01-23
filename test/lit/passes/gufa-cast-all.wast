;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: foreach %s %t wasm-opt -all --gufa-cast-all -S -o - | filecheck %s

(module
  ;; CHECK:      (type $none_=>_none (func))
  (type $none_=>_none (func))

  ;; CHECK:      (type $A (sub (struct)))
  (type $A (sub (struct)))

  ;; CHECK:      (type $B (sub $A (struct)))
  (type $B (sub $A (struct)))

  ;; CHECK:      (type $3 (func (result i32)))

  ;; CHECK:      (import "a" "b" (func $import (type $3) (result i32)))
  (import "a" "b" (func $import (result i32)))

  ;; CHECK:      (elem declare func $func $funcs)

  ;; CHECK:      (export "export1" (func $ref))

  ;; CHECK:      (export "export2" (func $int))

  ;; CHECK:      (export "export3" (func $func))

  ;; CHECK:      (export "export4" (func $funcs))

  ;; CHECK:      (export "export5" (func $unreachable))

  ;; CHECK:      (func $ref (type $none_=>_none)
  ;; CHECK-NEXT:  (local $a (ref $A))
  ;; CHECK-NEXT:  (local.set $a
  ;; CHECK-NEXT:   (struct.new_default $B)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.cast (ref $B)
  ;; CHECK-NEXT:    (local.get $a)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $ref (export "export1")
    (local $a (ref $A))
    (local.set $a
      (struct.new $B)
    )
    (drop
      ;; We can infer that this contains B, and add a cast to that type.
      (local.get $a)
    )
  )

  ;; CHECK:      (func $int (type $none_=>_none)
  ;; CHECK-NEXT:  (local $a i32)
  ;; CHECK-NEXT:  (local.set $a
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $int (export "export2")
    (local $a i32)
    (local.set $a
      (i32.const 1)
    )
    (drop
      ;; We can infer that this contains 1, but there is nothing to do regarding
      ;; the type, which is not a reference.
      (local.get $a)
    )
  )

  ;; CHECK:      (func $func (type $none_=>_none)
  ;; CHECK-NEXT:  (local $a funcref)
  ;; CHECK-NEXT:  (local.set $a
  ;; CHECK-NEXT:   (ref.func $func)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.func $func)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $func (export "export3") (type $none_=>_none)
    (local $a funcref)
    (local.set $a
      (ref.func $func)
    )
    (drop
      ;; We can infer that this contains a ref to $func, which we can apply
      ;; here. We don't need to add a cast in addition to that, as the ref.func
      ;; we add has the refined type already.
      (local.get $a)
    )
  )

  ;; CHECK:      (func $funcs (type $none_=>_none)
  ;; CHECK-NEXT:  (local $a funcref)
  ;; CHECK-NEXT:  (local.set $a
  ;; CHECK-NEXT:   (select (result (ref $none_=>_none))
  ;; CHECK-NEXT:    (ref.func $func)
  ;; CHECK-NEXT:    (ref.func $funcs)
  ;; CHECK-NEXT:    (call $import)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.cast (ref $none_=>_none)
  ;; CHECK-NEXT:    (local.get $a)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $funcs (export "export4") (type $none_=>_none)
    (local $a funcref)
    (local.set $a
      (select
        (ref.func $func)
        (ref.func $funcs)
        (call $import)
      )
    )
    (drop
      ;; We can infer that this contains a ref to $func or $funcs, so all we
      ;; can infer is the type, and we add a cast to $none_=>_none.
      (local.get $a)
    )
  )

  ;; CHECK:      (func $unreachable (type $none_=>_none)
  ;; CHECK-NEXT:  (local $a (ref $A))
  ;; CHECK-NEXT:  (local.tee $a
  ;; CHECK-NEXT:   (unreachable)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (unreachable)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $unreachable (export "export5")
    (local $a (ref $A))
    (local.set $a
      (unreachable)
    )
    (drop
      ;; We can infer that the type here is unreachable, and emit that in the
      ;; IR. This checks we don't error on the inferred type not being a ref.
      (local.get $a)
    )
  )
)
