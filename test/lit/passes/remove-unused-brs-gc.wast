;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --remove-unused-brs -all -S -o - \
;; RUN:  | filecheck %s

(module
 (rec
  ;; CHECK:      (rec
  ;; CHECK-NEXT:  (type $struct (sub (struct)))
  (type $struct (sub (struct)))
  ;; CHECK:       (type $struct2 (struct))
  (type $struct2 (struct))
  ;; CHECK:       (type $substruct (sub $struct (struct)))
  (type $substruct (sub $struct (struct)))
 )

 ;; CHECK:      (type $struct-nn (struct (field (ref any))))
 (type $struct-nn (struct (field (ref any))))

 ;; CHECK:      (global $struct (ref $struct) (struct.new_default $struct))
 (global $struct (ref $struct) (struct.new $struct))

 ;; CHECK:      (func $br_on-if (type $9) (param $0 (ref struct))
 ;; CHECK-NEXT:  (block $label
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (select (result (ref struct))
 ;; CHECK-NEXT:     (local.get $0)
 ;; CHECK-NEXT:     (local.get $0)
 ;; CHECK-NEXT:     (i32.const 0)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $br_on-if (param $0 (ref struct))
  (block $label
   (drop
    ;; This br is never taken, as the input is non-nullable, so we can remove
    ;; it. When we do so, we replace it with the if. We should not rescan that
    ;; if, which has already been walked, as that would hit an assertion.
    ;;
    (br_on_null $label
     ;; This if can also be turned into a select, separately from the above
     ;; (that is not specifically intended to be tested here).
     (if (result (ref struct))
      (i32.const 0)
      (then
       (local.get $0)
      )
      (else
       (local.get $0)
      )
     )
    )
   )
  )
 )

 ;; CHECK:      (func $br_on_cast (type $5) (result (ref $struct))
 ;; CHECK-NEXT:  (local $struct (ref null $struct))
 ;; CHECK-NEXT:  (block $block (result (ref $struct))
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (br $block
 ;; CHECK-NEXT:     (struct.new_default $struct)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (block (result nullref)
 ;; CHECK-NEXT:     (br_on_non_null $block
 ;; CHECK-NEXT:      (local.get $struct)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:     (ref.null none)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (br_on_cast $block (ref $struct) (ref $substruct)
 ;; CHECK-NEXT:     (struct.new_default $struct)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (unreachable)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $br_on_cast (result (ref $struct))
  (local $struct (ref null $struct))
  (block $block (result (ref $struct))
   (drop
    ;; This cast can be computed at compile time: it will definitely be taken,
    ;; so we can turn it into a normal br.
    (br_on_cast $block anyref (ref $struct)
     (struct.new $struct)
    )
   )
   (drop
    ;; This cast can be partially computed at compile time, but we still need to
    ;; do a null check.
    (br_on_cast $block anyref (ref $struct)
     (local.get $struct)
    )
   )
   (drop
    ;; This cast cannot be optimized at all.
    (br_on_cast $block anyref (ref $substruct)
     (struct.new $struct)
    )
   )
   (unreachable)
  )
 )

 ;; CHECK:      (func $br_on_cast-fallthrough (type $5) (result (ref $struct))
 ;; CHECK-NEXT:  (local $struct (ref null $struct))
 ;; CHECK-NEXT:  (local $any anyref)
 ;; CHECK-NEXT:  (block $block (result (ref $struct))
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (br $block
 ;; CHECK-NEXT:     (ref.cast (ref $struct)
 ;; CHECK-NEXT:      (local.tee $any
 ;; CHECK-NEXT:       (struct.new_default $struct)
 ;; CHECK-NEXT:      )
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (block (result nullref)
 ;; CHECK-NEXT:     (br_on_non_null $block
 ;; CHECK-NEXT:      (ref.cast (ref null $struct)
 ;; CHECK-NEXT:       (local.tee $any
 ;; CHECK-NEXT:        (local.get $struct)
 ;; CHECK-NEXT:       )
 ;; CHECK-NEXT:      )
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:     (ref.null none)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (br_on_cast $block anyref (ref $substruct)
 ;; CHECK-NEXT:     (local.tee $any
 ;; CHECK-NEXT:      (struct.new_default $struct)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (unreachable)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $br_on_cast-fallthrough (result (ref $struct))
  ;; Same as above, but now the type information comes from fallthrough values.
  (local $struct (ref null $struct))
  (local $any anyref)
  (block $block (result (ref $struct))
   (drop
    ;; Definitely taken, but will need a cast for validity.
    (br_on_cast $block anyref (ref $struct)
     (local.tee $any (struct.new $struct))
    )
   )
   (drop
    ;; Needs a null check and cast for validity.
    (br_on_cast $block anyref (ref $struct)
     (local.tee $any (local.get $struct))
    )
   )
   (drop
    ;; This cannot be optimized, but at least it still doesn't need an
    ;; additional cast.
    (br_on_cast $block anyref (ref $substruct)
     (local.tee $any (struct.new $struct))
    )
   )
   (unreachable)
  )
 )

 ;; CHECK:      (func $nested_br_on_cast (type $10) (result i31ref)
 ;; CHECK-NEXT:  (block $label$1 (result (ref i31))
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (br $label$1
 ;; CHECK-NEXT:     (ref.i31
 ;; CHECK-NEXT:      (i32.const 0)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (unreachable)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $nested_br_on_cast (result i31ref)
  (block $label$1 (result i31ref)
   (drop
    ;; The inner br_on_cast will become a direct br since the type proves it
    ;; is in fact i31. That then becomes unreachable, and the parent must
    ;; handle that properly (do nothing without hitting an assertion).
    (br_on_cast $label$1 (ref any) (ref i31)
     (br_on_cast $label$1 (ref any) (ref i31)
      (ref.i31 (i32.const 0))
     )
    )
   )
   (unreachable)
  )
 )

 ;; CHECK:      (func $br_on_cast_unrelated (type $6) (result (ref null $struct))
 ;; CHECK-NEXT:  (local $nullable-struct2 (ref null $struct2))
 ;; CHECK-NEXT:  (block $block (result nullref)
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (struct.new_default $struct2)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (struct.new_default $struct2)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (local.get $nullable-struct2)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (br_on_cast $block (ref null $struct2) nullref
 ;; CHECK-NEXT:     (local.get $nullable-struct2)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (unreachable)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $br_on_cast_unrelated (result (ref null $struct))
  (local $nullable-struct2 (ref null $struct2))
  (block $block (result (ref null $struct))
   (drop
    ;; This cast can be computed at compile time: it will definitely fail, so we
    ;; can remove it.
    (br_on_cast $block anyref (ref $struct)
     (struct.new $struct2)
    )
   )
   (drop
    ;; We can still remove it even if the cast allows nulls.
    (br_on_cast $block anyref (ref null $struct)
     (struct.new $struct2)
    )
   )
   (drop
    ;; Or if the cast does not allow nulls and the value is nullable.
    (br_on_cast $block anyref (ref $struct)
     (local.get $nullable-struct2)
    )
   )
   (drop
    ;; But if both are nullable, then the cast will succeed only if the value is
    ;; null, so we can partially optimize.
    ;; TODO: Optimize this.
    (br_on_cast $block anyref (ref null $struct)
     (local.get $nullable-struct2)
    )
   )
   (unreachable)
  )
 )

 ;; CHECK:      (func $br_on_cast_unrelated-fallthrough (type $6) (result (ref null $struct))
 ;; CHECK-NEXT:  (local $any anyref)
 ;; CHECK-NEXT:  (local $nullable-struct2 (ref null $struct2))
 ;; CHECK-NEXT:  (block $block (result nullref)
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (local.tee $any
 ;; CHECK-NEXT:     (struct.new_default $struct2)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (ref.as_non_null
 ;; CHECK-NEXT:     (local.tee $any
 ;; CHECK-NEXT:      (struct.new_default $struct2)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (local.tee $any
 ;; CHECK-NEXT:     (local.get $nullable-struct2)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (br_on_cast $block anyref nullref
 ;; CHECK-NEXT:     (local.tee $any
 ;; CHECK-NEXT:      (local.get $nullable-struct2)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (unreachable)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $br_on_cast_unrelated-fallthrough (result (ref null $struct))
  ;; Same as above, but now all the type information comes from fallthrough values.
  (local $any anyref)
  (local $nullable-struct2 (ref null $struct2))
  (block $block (result (ref null $struct))
   (drop
    ;; Definitely not taken.
    (br_on_cast $block anyref (ref $struct)
     (local.tee $any (struct.new $struct2))
    )
   )
   (drop
    ;; Still not taken. Note that we start by flowing out a non-nullable value,
    ;; and will add a cast to ensure we still do after optimization.
    (br_on_cast $block anyref (ref null $struct)
     (local.tee $any (struct.new $struct2))
    )
   )
   (drop
    ;; Also not taken.
    (br_on_cast $block anyref (ref $struct)
     (local.tee $any (local.get $nullable-struct2))
    )
   )
   (drop
    ;; Taken only if null.
    ;; TODO: Optimize this.
    (br_on_cast $block anyref (ref null $struct)
     (local.tee $any (local.get $nullable-struct2))
    )
   )
   (unreachable)
  )
 )

 ;; CHECK:      (func $br_on_cast_fail (type $3) (result anyref)
 ;; CHECK-NEXT:  (local $struct (ref null $struct))
 ;; CHECK-NEXT:  (block $block (result (ref null $struct))
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (struct.new_default $struct)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (br_on_cast_fail $block (ref null $struct) (ref $struct)
 ;; CHECK-NEXT:     (local.get $struct)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (br_on_cast_fail $block (ref $struct) (ref $substruct)
 ;; CHECK-NEXT:     (struct.new_default $struct)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (unreachable)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $br_on_cast_fail (result anyref)
  (local $struct (ref null $struct))
  (block $block (result anyref)
   (drop
    ;; This cast can be computed at compile time: it will definitely succeed so
    ;; the branch will not be taken.
    (br_on_cast_fail $block anyref (ref $struct)
     (struct.new $struct)
    )
   )
   (drop
    ;; This cast can be partially computed at compile time, but we still need to
    ;; do a null check.
    ;; TODO: optimize this.
    (br_on_cast_fail $block anyref (ref $struct)
     (local.get $struct)
    )
   )
   (drop
    ;; This cast cannot be optimized at all.
    (br_on_cast_fail $block anyref (ref $substruct)
     (struct.new $struct)
    )
   )
   (unreachable)
  )
 )

 ;; CHECK:      (func $br_on_cast_fail-fallthrough (type $3) (result anyref)
 ;; CHECK-NEXT:  (local $any anyref)
 ;; CHECK-NEXT:  (local $struct (ref null $struct))
 ;; CHECK-NEXT:  (block $block (result anyref)
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (ref.cast (ref $struct)
 ;; CHECK-NEXT:     (local.tee $any
 ;; CHECK-NEXT:      (struct.new_default $struct)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (br_on_cast_fail $block anyref (ref $struct)
 ;; CHECK-NEXT:     (local.tee $any
 ;; CHECK-NEXT:      (local.get $struct)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (br_on_cast_fail $block anyref (ref $substruct)
 ;; CHECK-NEXT:     (local.tee $any
 ;; CHECK-NEXT:      (struct.new_default $struct)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (unreachable)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $br_on_cast_fail-fallthrough (result anyref)
  ;; Same as above, but now the type information comes from fallthrough values.
  (local $any anyref)
  (local $struct (ref null $struct))
  (block $block (result anyref)
   (drop
    ;; This cast will succeed. We will need a cast for validity.
    (br_on_cast_fail $block anyref (ref $struct)
     (local.tee $any (struct.new $struct))
    )
   )
   (drop
    ;; We will still need a null check.
    ;; TODO: optimize this.
    (br_on_cast_fail $block anyref (ref $struct)
     (local.tee $any (local.get $struct))
    )
   )
   (drop
    ;; This cast cannot be optimized at all.
    (br_on_cast_fail $block anyref (ref $substruct)
     (local.tee $any (struct.new $struct))
    )
   )
   (unreachable)
  )
 )

 ;; CHECK:      (func $br_on_cast_fail_unrelated (type $3) (result anyref)
 ;; CHECK-NEXT:  (local $nullable-struct2 (ref null $struct2))
 ;; CHECK-NEXT:  (block $block (result (ref null $struct2))
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (br $block
 ;; CHECK-NEXT:     (struct.new_default $struct2)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (br $block
 ;; CHECK-NEXT:     (struct.new_default $struct2)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (br $block
 ;; CHECK-NEXT:     (local.get $nullable-struct2)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (block (result nullref)
 ;; CHECK-NEXT:     (br_on_non_null $block
 ;; CHECK-NEXT:      (local.get $nullable-struct2)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:     (ref.null none)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (unreachable)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $br_on_cast_fail_unrelated (result anyref)
  (local $nullable-struct2 (ref null $struct2))
  (block $block (result anyref)
   (drop
    ;; This cast can be computed at compile time: it will definitely fail, so we
    ;; can replace it with an unconditional br.
    (br_on_cast_fail $block anyref (ref $struct)
     (struct.new $struct2)
    )
   )
   (drop
    ;; We can still replace it even if the cast allows nulls.
    (br_on_cast_fail $block anyref (ref null $struct)
     (struct.new $struct2)
    )
   )
   (drop
    ;; Or if the cast does not allow nulls and the value is nullable.
    (br_on_cast_fail $block anyref (ref $struct)
     (local.get $nullable-struct2)
    )
   )
   (drop
    ;; But if both are nullable, then we can only partially optimize because we
    ;; still have to do a null check.
    (br_on_cast_fail $block anyref (ref null $struct)
     (local.get $nullable-struct2)
    )
   )
   (unreachable)
  )
 )

 ;; CHECK:      (func $br_on_cast_fail_unrelated-fallthrough (type $3) (result anyref)
 ;; CHECK-NEXT:  (local $any anyref)
 ;; CHECK-NEXT:  (local $nullable-struct2 (ref null $struct2))
 ;; CHECK-NEXT:  (block $block (result anyref)
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (br $block
 ;; CHECK-NEXT:     (local.tee $any
 ;; CHECK-NEXT:      (struct.new_default $struct2)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (br $block
 ;; CHECK-NEXT:     (local.tee $any
 ;; CHECK-NEXT:      (struct.new_default $struct2)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (br $block
 ;; CHECK-NEXT:     (local.tee $any
 ;; CHECK-NEXT:      (local.get $nullable-struct2)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (block (result nullref)
 ;; CHECK-NEXT:     (br_on_non_null $block
 ;; CHECK-NEXT:      (local.tee $any
 ;; CHECK-NEXT:       (local.get $nullable-struct2)
 ;; CHECK-NEXT:      )
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:     (ref.null none)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (unreachable)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $br_on_cast_fail_unrelated-fallthrough (result anyref)
  ;; Same as above, but now type information comes from fallthrough values.
  (local $any anyref)
  (local $nullable-struct2 (ref null $struct2))
  (block $block (result anyref)
   (drop
    ;; Will definitely take the branch.
    (br_on_cast_fail $block anyref (ref $struct)
     (local.tee $any (struct.new $struct2))
    )
   )
   (drop
    ;; Ditto.
    (br_on_cast_fail $block anyref (ref null $struct)
     (local.tee $any (struct.new $struct2))
    )
   )
   (drop
    ;; Ditto.
    (br_on_cast_fail $block anyref (ref $struct)
     (local.tee $any (local.get $nullable-struct2))
    )
   )
   (drop
    ;; Still has to do a null check.
    (br_on_cast_fail $block anyref (ref null $struct)
     (local.tee $any (local.get $nullable-struct2))
    )
   )
   (unreachable)
  )
 )

 ;; CHECK:      (func $br_on_cast-unreachable (type $7) (param $i31ref i31ref) (result anyref)
 ;; CHECK-NEXT:  (block $block
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (block
 ;; CHECK-NEXT:     (drop
 ;; CHECK-NEXT:      (block (result (ref none))
 ;; CHECK-NEXT:       (ref.cast (ref none)
 ;; CHECK-NEXT:        (block (result i31ref)
 ;; CHECK-NEXT:         (local.get $i31ref)
 ;; CHECK-NEXT:        )
 ;; CHECK-NEXT:       )
 ;; CHECK-NEXT:      )
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:     (unreachable)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (block
 ;; CHECK-NEXT:    (drop
 ;; CHECK-NEXT:     (block (result (ref none))
 ;; CHECK-NEXT:      (ref.cast (ref none)
 ;; CHECK-NEXT:       (block (result i31ref)
 ;; CHECK-NEXT:        (local.get $i31ref)
 ;; CHECK-NEXT:       )
 ;; CHECK-NEXT:      )
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (unreachable)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $br_on_cast-unreachable (param $i31ref i31ref) (result anyref)
  ;; Optimize out br_on_cast* where the input is uninhabitable.
  (block $block (result anyref)
   (drop
    (br_on_cast $block anyref (ref i31)
     (block (result anyref)
      (ref.cast (ref struct)
       (block (result anyref)
        (local.get $i31ref)
       )
      )
     )
    )
   )
   (br_on_cast_fail $block anyref (ref i31)
    (block (result anyref)
     (ref.cast (ref struct)
      (block (result anyref)
       (local.get $i31ref)
      )
     )
    )
   )
  )
 )

 ;; CHECK:      (func $fallthrough-unreachable (type $7) (param $0 i31ref) (result anyref)
 ;; CHECK-NEXT:  (block $outer
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (block ;; (replaces unreachable RefCast we can't emit)
 ;; CHECK-NEXT:     (drop
 ;; CHECK-NEXT:      (block
 ;; CHECK-NEXT:       (drop
 ;; CHECK-NEXT:        (ref.cast (ref none)
 ;; CHECK-NEXT:         (local.get $0)
 ;; CHECK-NEXT:        )
 ;; CHECK-NEXT:       )
 ;; CHECK-NEXT:       (unreachable)
 ;; CHECK-NEXT:      )
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:     (unreachable)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (unreachable)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $fallthrough-unreachable (param $0 i31ref) (result anyref)
  (block $outer (result (ref none))
   (drop
    ;; This should not crash due to the new unreachable below.
    (br_on_cast $outer (ref none) (ref none)
     (ref.cast (ref none)
      ;; This will be optimized to a drop + unreachable.
      (br_on_cast $outer (ref none) (ref none)
       (ref.cast (ref none)
        (local.get $0)
       )
      )
     )
    )
   )
   (unreachable)
  )
 )

 ;; CHECK:      (func $casts-are-costly (type $8) (param $x i32)
 ;; CHECK-NEXT:  (local $struct (ref null $struct))
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (if (result i32)
 ;; CHECK-NEXT:    (local.get $x)
 ;; CHECK-NEXT:    (then
 ;; CHECK-NEXT:     (ref.test (ref none)
 ;; CHECK-NEXT:      (ref.null none)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (else
 ;; CHECK-NEXT:     (i32.const 0)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (if (result nullref)
 ;; CHECK-NEXT:    (local.get $x)
 ;; CHECK-NEXT:    (then
 ;; CHECK-NEXT:     (ref.null none)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (else
 ;; CHECK-NEXT:     (ref.cast nullref
 ;; CHECK-NEXT:      (ref.null none)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (if (result (ref null $struct))
 ;; CHECK-NEXT:    (local.get $x)
 ;; CHECK-NEXT:    (then
 ;; CHECK-NEXT:     (block $something (result (ref null $struct))
 ;; CHECK-NEXT:      (drop
 ;; CHECK-NEXT:       (block (result nullref)
 ;; CHECK-NEXT:        (br_on_non_null $something
 ;; CHECK-NEXT:         (local.get $struct)
 ;; CHECK-NEXT:        )
 ;; CHECK-NEXT:        (ref.null none)
 ;; CHECK-NEXT:       )
 ;; CHECK-NEXT:      )
 ;; CHECK-NEXT:      (ref.null none)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (else
 ;; CHECK-NEXT:     (ref.null none)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (select (result nullref)
 ;; CHECK-NEXT:    (block (result nullref)
 ;; CHECK-NEXT:     (block $nothing
 ;; CHECK-NEXT:      (drop
 ;; CHECK-NEXT:       (block
 ;; CHECK-NEXT:        (drop
 ;; CHECK-NEXT:         (ref.null none)
 ;; CHECK-NEXT:        )
 ;; CHECK-NEXT:        (br $nothing)
 ;; CHECK-NEXT:       )
 ;; CHECK-NEXT:      )
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:     (ref.null none)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (ref.null none)
 ;; CHECK-NEXT:    (local.get $x)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $casts-are-costly (param $x i32)
  ;; We never turn an if into a select if an arm has a cast of any kind, as
  ;; those things involve branches internally, so we'd be adding more than we
  ;; save.
  (local $struct (ref null $struct))
  (drop
   (if (result i32)
    (local.get $x)
    (then
     (ref.test (ref $struct)
      (ref.null any)
     )
    )
    (else
     (i32.const 0)
    )
   )
  )
  (drop
   (if (result anyref)
    (local.get $x)
    (then
     (ref.null any)
    )
    (else
     (ref.cast (ref null $struct)
      (ref.null any)
     )
    )
   )
  )
  ;; We do not selectify here because the amount of work in the if is
  ;; significant (there is a cast and a branch).
  (drop
   (if (result anyref)
    (local.get $x)
    (then
     (block (result anyref)
      (block $something (result anyref)
       (drop
        (br_on_cast $something anyref (ref $struct)
         (local.get $struct)
        )
       )
       (ref.null any)
      )
     )
    )
    (else
     (ref.null any)
    )
   )
  )
  ;; However, null checks are fairly fast, and we will emit a select here.
  (drop
   (if (result anyref)
    (local.get $x)
    (then
     (block (result anyref)
      (block $nothing
       (drop
        (br_on_null $nothing
         (ref.null $struct)
        )
       )
      )
      (ref.null any)
     )
    )
    (else
     (ref.null any)
    )
   )
  )
 )

 ;; CHECK:      (func $allocations-are-costly (type $8) (param $x i32)
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (if (result (ref null $struct))
 ;; CHECK-NEXT:    (local.get $x)
 ;; CHECK-NEXT:    (then
 ;; CHECK-NEXT:     (struct.new_default $struct)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (else
 ;; CHECK-NEXT:     (ref.null none)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (select (result nullref)
 ;; CHECK-NEXT:    (ref.null none)
 ;; CHECK-NEXT:    (ref.null none)
 ;; CHECK-NEXT:    (local.get $x)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $allocations-are-costly (param $x i32)
  ;; Allocations are too expensive for us to unconditionalize and selectify
  ;; here.
  (drop
   (if (result anyref)
    (local.get $x)
    (then
     (struct.new $struct)
    )
    (else
     (ref.null any)
    )
   )
  )
  ;; But two nulls are fine.
  (drop
   (if (result anyref)
    (local.get $x)
    (then
     (ref.null any)
    )
    (else
     (ref.null any)
    )
   )
  )
 )

 ;; CHECK:      (func $threading (type $11) (param $x anyref)
 ;; CHECK-NEXT:  (block $outer
 ;; CHECK-NEXT:   (block $inner
 ;; CHECK-NEXT:    (drop
 ;; CHECK-NEXT:     (br_on_null $outer
 ;; CHECK-NEXT:      (local.get $x)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $threading (param $x anyref)
  (block $outer
   (block $inner
    ;; This jump can go to $outer.
    (drop
     (br_on_null $inner
      (local.get $x)
     )
    )
   )
  )
 )

 ;; CHECK:      (func $test (type $12) (param $x (ref any))
 ;; CHECK-NEXT:  (local $temp anyref)
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (block $block (result (ref $struct-nn))
 ;; CHECK-NEXT:    (struct.new $struct-nn
 ;; CHECK-NEXT:     (ref.as_non_null
 ;; CHECK-NEXT:      (br_on_cast $block anyref (ref $struct-nn)
 ;; CHECK-NEXT:       (local.tee $temp
 ;; CHECK-NEXT:        (local.get $x)
 ;; CHECK-NEXT:       )
 ;; CHECK-NEXT:      )
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $test (param $x (ref any))
  (local $temp anyref)
  ;; Read the inline comments blow from the bottom to the top (order of
  ;; execution). Basically, the story is that the br_on_cast begins as
  ;; flowing out a non-nullable type, since the cast allows nulls (so only a
  ;; non-null can flow out). We can see that the br_on_cast receives a non-
  ;; nullable value, even though it flows through a local.tee that un-refines
  ;; it. Using the non-nullability, we can refine the cast type (type sent on
  ;; the branch) to be non-nullable. But then the type of the br_on_cast itself
  ;; becomes nullable, since nulls no longer get sent on the branch, which
  ;; breaks the parent that must receive a non-nullable value.
  ;;
  ;; To fix this, we add a cast on the br's output, forcing it to the exact
  ;; same type it had before.
  (drop
   (block $block (result anyref)
    (struct.new $struct-nn                           ;; must provide a NON-
                                                     ;; nullable value for the
                                                     ;; struct field

     (br_on_cast $block anyref (ref null $struct-nn) ;; GLB on the castType
                                                     ;; makes it non-nullable,
                                                     ;; which makes the type
                                                     ;; of the br_on_cast
                                                     ;; nullable

      (local.tee $temp                               ;; nullable

       (local.get $x)                                ;; non-nullable
      )
     )
    )
   )
  )
 )

 ;; CHECK:      (func $select-refinalize (type $13) (param $param (ref $struct)) (result (ref struct))
 ;; CHECK-NEXT:  (select (result (ref $struct))
 ;; CHECK-NEXT:   (select (result (ref $struct))
 ;; CHECK-NEXT:    (global.get $struct)
 ;; CHECK-NEXT:    (global.get $struct)
 ;; CHECK-NEXT:    (i32.const 0)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (local.get $param)
 ;; CHECK-NEXT:   (i32.const 0)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $select-refinalize (param $param (ref $struct)) (result (ref struct))
  ;; The inner if can turn into a select. The type then changes, allowing the
  ;; outer select to be refined, which will error if we do not refinalize.
  (select (result (ref struct))
   (if (result (ref struct))
    (i32.const 0)
    (then
     (global.get $struct)
    )
    (else
     (global.get $struct)
    )
   )
   (local.get $param)
   (i32.const 0)
  )
 )
)
