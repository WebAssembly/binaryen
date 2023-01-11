;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --optimize-instructions --traps-never-happen -all --nominal -S -o - | filecheck %s --check-prefix TNH
;; RUN: wasm-opt %s --optimize-instructions                      -all --nominal -S -o - | filecheck %s --check-prefix NO_TNH

(module
  ;; TNH:      (type $struct (struct (field (mut i32))))
  ;; NO_TNH:      (type $struct (struct (field (mut i32))))
  (type $struct (struct_subtype (field (mut i32)) data))

  ;; TNH:      (type $void (func))
  ;; NO_TNH:      (type $void (func))
  (type $void (func))

  ;; TNH:      (func $ref.eq (type $eqref_eqref_=>_i32) (param $a eqref) (param $b eqref) (result i32)
  ;; TNH-NEXT:  (ref.eq
  ;; TNH-NEXT:   (local.get $a)
  ;; TNH-NEXT:   (local.get $b)
  ;; TNH-NEXT:  )
  ;; TNH-NEXT: )
  ;; NO_TNH:      (func $ref.eq (type $eqref_eqref_=>_i32) (param $a eqref) (param $b eqref) (result i32)
  ;; NO_TNH-NEXT:  (ref.eq
  ;; NO_TNH-NEXT:   (ref.cast $struct
  ;; NO_TNH-NEXT:    (local.get $a)
  ;; NO_TNH-NEXT:   )
  ;; NO_TNH-NEXT:   (ref.cast struct
  ;; NO_TNH-NEXT:    (local.get $b)
  ;; NO_TNH-NEXT:   )
  ;; NO_TNH-NEXT:  )
  ;; NO_TNH-NEXT: )
  (func $ref.eq (param $a (ref null eq)) (param $b (ref null eq)) (result i32)
    ;; When traps never happen we can remove all the casts here, since they do
    ;; not affect the comparison of the references.
    (ref.eq
      ;; When traps can happen we can still improve this by removing and
      ;; combining redundant casts.
      (ref.cast struct
        (ref.as_non_null
          (ref.cast null $struct
            (local.get $a)
          )
        )
      )
      ;; Note that we can remove the non-null casts here in both modes, as the
      ;; ref.cast struct also checks for null.
      (ref.cast struct
        (ref.as_non_null
          (ref.as_non_null
            (local.get $b)
          )
        )
      )
    )
  )

  ;; TNH:      (func $ref.eq-no (type $eqref_eqref_anyref_=>_none) (param $a eqref) (param $b eqref) (param $any anyref)
  ;; TNH-NEXT:  (drop
  ;; TNH-NEXT:   (i32.const 1)
  ;; TNH-NEXT:  )
  ;; TNH-NEXT: )
  ;; NO_TNH:      (func $ref.eq-no (type $eqref_eqref_anyref_=>_none) (param $a eqref) (param $b eqref) (param $any anyref)
  ;; NO_TNH-NEXT:  (drop
  ;; NO_TNH-NEXT:   (ref.eq
  ;; NO_TNH-NEXT:    (ref.cast null $struct
  ;; NO_TNH-NEXT:     (local.get $any)
  ;; NO_TNH-NEXT:    )
  ;; NO_TNH-NEXT:    (ref.cast struct
  ;; NO_TNH-NEXT:     (local.get $any)
  ;; NO_TNH-NEXT:    )
  ;; NO_TNH-NEXT:   )
  ;; NO_TNH-NEXT:  )
  ;; NO_TNH-NEXT: )
  (func $ref.eq-no (param $a (ref null eq)) (param $b (ref null eq)) (param $any anyref)
    ;; We must leave the inputs to ref.eq of type eqref or a subtype.
    (drop
      (ref.eq
        (ref.cast null $struct
          (local.get $any) ;; *Not* an eqref!
        )
        (ref.as_non_null
          (ref.cast struct
            (ref.as_non_null
              (local.get $any) ;; *Not* an eqref!
            )
          )
        )
      )
    )
  )

  ;; TNH:      (func $ref.is (type $eqref_=>_i32) (param $a eqref) (result i32)
  ;; TNH-NEXT:  (drop
  ;; TNH-NEXT:   (ref.cast $struct
  ;; TNH-NEXT:    (local.get $a)
  ;; TNH-NEXT:   )
  ;; TNH-NEXT:  )
  ;; TNH-NEXT:  (i32.const 0)
  ;; TNH-NEXT: )
  ;; NO_TNH:      (func $ref.is (type $eqref_=>_i32) (param $a eqref) (result i32)
  ;; NO_TNH-NEXT:  (drop
  ;; NO_TNH-NEXT:   (ref.cast $struct
  ;; NO_TNH-NEXT:    (local.get $a)
  ;; NO_TNH-NEXT:   )
  ;; NO_TNH-NEXT:  )
  ;; NO_TNH-NEXT:  (i32.const 0)
  ;; NO_TNH-NEXT: )
  (func $ref.is (param $a (ref null eq)) (result i32)
    ;; In this case non-nullability is enough to tell that the ref.is will
    ;; return 0. TNH does not help here.
    (ref.is_null
      (ref.cast $struct
        (ref.as_non_null
          (ref.cast struct
            (local.get $a)
          )
        )
      )
    )
  )

  ;; TNH:      (func $ref.is_b (type $eqref_funcref_=>_i32) (param $a eqref) (param $f funcref) (result i32)
  ;; TNH-NEXT:  (drop
  ;; TNH-NEXT:   (ref.is_null
  ;; TNH-NEXT:    (local.get $a)
  ;; TNH-NEXT:   )
  ;; TNH-NEXT:  )
  ;; TNH-NEXT:  (ref.is_null
  ;; TNH-NEXT:   (local.get $f)
  ;; TNH-NEXT:  )
  ;; TNH-NEXT: )
  ;; NO_TNH:      (func $ref.is_b (type $eqref_funcref_=>_i32) (param $a eqref) (param $f funcref) (result i32)
  ;; NO_TNH-NEXT:  (drop
  ;; NO_TNH-NEXT:   (ref.is_null
  ;; NO_TNH-NEXT:    (ref.cast null $struct
  ;; NO_TNH-NEXT:     (local.get $a)
  ;; NO_TNH-NEXT:    )
  ;; NO_TNH-NEXT:   )
  ;; NO_TNH-NEXT:  )
  ;; NO_TNH-NEXT:  (ref.is_null
  ;; NO_TNH-NEXT:   (ref.cast null $void
  ;; NO_TNH-NEXT:    (local.get $f)
  ;; NO_TNH-NEXT:   )
  ;; NO_TNH-NEXT:  )
  ;; NO_TNH-NEXT: )
  (func $ref.is_b (param $a eqref) (param $f funcref) (result i32)
    ;; Here we only have a cast, and no ref.as operations that force the value
    ;; to be non-nullable. That means we cannot remove the ref.is, but we can
    ;; remove the cast in TNH.
    (drop
      (ref.is_null
        (ref.cast null $struct
          (local.get $a)
        )
      )
    )
    ;; It works on func and references, too.
    (ref.is_null
      (ref.cast null $void
        (local.get $f)
      )
    )
  )

  ;; TNH:      (func $ref.is_func (type $funcref_=>_i32) (param $a funcref) (result i32)
  ;; TNH-NEXT:  (drop
  ;; TNH-NEXT:   (ref.as_non_null
  ;; TNH-NEXT:    (local.get $a)
  ;; TNH-NEXT:   )
  ;; TNH-NEXT:  )
  ;; TNH-NEXT:  (i32.const 1)
  ;; TNH-NEXT: )
  ;; NO_TNH:      (func $ref.is_func (type $funcref_=>_i32) (param $a funcref) (result i32)
  ;; NO_TNH-NEXT:  (drop
  ;; NO_TNH-NEXT:   (ref.as_non_null
  ;; NO_TNH-NEXT:    (local.get $a)
  ;; NO_TNH-NEXT:   )
  ;; NO_TNH-NEXT:  )
  ;; NO_TNH-NEXT:  (i32.const 1)
  ;; NO_TNH-NEXT: )
  (func $ref.is_func (param $a funcref) (result i32)
    ;; The check must succeed. We can return 1 here, and drop the rest, with or
    ;; without TNH (in particular, TNH should not just remove the cast but not
    ;; return a 1).
    (ref.is_func
      (ref.as_func
        (local.get $a)
      )
    )
  )

  ;; TNH:      (func $if.arm.null (type $i32_ref|$struct|_=>_none) (param $x i32) (param $ref (ref $struct))
  ;; TNH-NEXT:  (struct.set $struct 0
  ;; TNH-NEXT:   (block (result (ref $struct))
  ;; TNH-NEXT:    (drop
  ;; TNH-NEXT:     (local.get $x)
  ;; TNH-NEXT:    )
  ;; TNH-NEXT:    (local.get $ref)
  ;; TNH-NEXT:   )
  ;; TNH-NEXT:   (i32.const 1)
  ;; TNH-NEXT:  )
  ;; TNH-NEXT:  (struct.set $struct 0
  ;; TNH-NEXT:   (block (result (ref $struct))
  ;; TNH-NEXT:    (drop
  ;; TNH-NEXT:     (local.get $x)
  ;; TNH-NEXT:    )
  ;; TNH-NEXT:    (local.get $ref)
  ;; TNH-NEXT:   )
  ;; TNH-NEXT:   (i32.const 2)
  ;; TNH-NEXT:  )
  ;; TNH-NEXT: )
  ;; NO_TNH:      (func $if.arm.null (type $i32_ref|$struct|_=>_none) (param $x i32) (param $ref (ref $struct))
  ;; NO_TNH-NEXT:  (struct.set $struct 0
  ;; NO_TNH-NEXT:   (if (result (ref null $struct))
  ;; NO_TNH-NEXT:    (local.get $x)
  ;; NO_TNH-NEXT:    (local.get $ref)
  ;; NO_TNH-NEXT:    (ref.null none)
  ;; NO_TNH-NEXT:   )
  ;; NO_TNH-NEXT:   (i32.const 1)
  ;; NO_TNH-NEXT:  )
  ;; NO_TNH-NEXT:  (struct.set $struct 0
  ;; NO_TNH-NEXT:   (if (result (ref null $struct))
  ;; NO_TNH-NEXT:    (local.get $x)
  ;; NO_TNH-NEXT:    (ref.null none)
  ;; NO_TNH-NEXT:    (local.get $ref)
  ;; NO_TNH-NEXT:   )
  ;; NO_TNH-NEXT:   (i32.const 2)
  ;; NO_TNH-NEXT:  )
  ;; NO_TNH-NEXT: )
  (func $if.arm.null (param $x i32) (param $ref (ref $struct))
    ;; A set will trap on a null, so in tnh mode we know the null arm is not
    ;; executed, and the other one is.
    (struct.set $struct 0
      (if (result (ref null $struct))
        (local.get $x)
        (local.get $ref)
        (ref.null none)
      )
      (i32.const 1)
    )
    (struct.set $struct 0
      (if (result (ref null $struct))
        (local.get $x)
        (ref.null none)
        (local.get $ref)
      )
      (i32.const 2)
    )
  )

  ;; TNH:      (func $select.arm.null (type $i32_ref|$struct|_=>_none) (param $x i32) (param $ref (ref $struct))
  ;; TNH-NEXT:  (struct.set $struct 0
  ;; TNH-NEXT:   (block (result (ref $struct))
  ;; TNH-NEXT:    (block
  ;; TNH-NEXT:     (drop
  ;; TNH-NEXT:      (ref.null none)
  ;; TNH-NEXT:     )
  ;; TNH-NEXT:     (drop
  ;; TNH-NEXT:      (local.get $x)
  ;; TNH-NEXT:     )
  ;; TNH-NEXT:    )
  ;; TNH-NEXT:    (local.get $ref)
  ;; TNH-NEXT:   )
  ;; TNH-NEXT:   (i32.const 1)
  ;; TNH-NEXT:  )
  ;; TNH-NEXT:  (struct.set $struct 0
  ;; TNH-NEXT:   (block (result (ref $struct))
  ;; TNH-NEXT:    (drop
  ;; TNH-NEXT:     (ref.null none)
  ;; TNH-NEXT:    )
  ;; TNH-NEXT:    (block (result (ref $struct))
  ;; TNH-NEXT:     (drop
  ;; TNH-NEXT:      (local.get $x)
  ;; TNH-NEXT:     )
  ;; TNH-NEXT:     (local.get $ref)
  ;; TNH-NEXT:    )
  ;; TNH-NEXT:   )
  ;; TNH-NEXT:   (i32.const 2)
  ;; TNH-NEXT:  )
  ;; TNH-NEXT: )
  ;; NO_TNH:      (func $select.arm.null (type $i32_ref|$struct|_=>_none) (param $x i32) (param $ref (ref $struct))
  ;; NO_TNH-NEXT:  (struct.set $struct 0
  ;; NO_TNH-NEXT:   (select (result (ref null $struct))
  ;; NO_TNH-NEXT:    (local.get $ref)
  ;; NO_TNH-NEXT:    (ref.null none)
  ;; NO_TNH-NEXT:    (local.get $x)
  ;; NO_TNH-NEXT:   )
  ;; NO_TNH-NEXT:   (i32.const 1)
  ;; NO_TNH-NEXT:  )
  ;; NO_TNH-NEXT:  (struct.set $struct 0
  ;; NO_TNH-NEXT:   (select (result (ref null $struct))
  ;; NO_TNH-NEXT:    (ref.null none)
  ;; NO_TNH-NEXT:    (local.get $ref)
  ;; NO_TNH-NEXT:    (local.get $x)
  ;; NO_TNH-NEXT:   )
  ;; NO_TNH-NEXT:   (i32.const 2)
  ;; NO_TNH-NEXT:  )
  ;; NO_TNH-NEXT: )
  (func $select.arm.null (param $x i32) (param $ref (ref $struct))
    ;; As above but with a select.
    (struct.set $struct 0
      (select (result (ref null $struct))
        (local.get $ref)
        (ref.null none)
        (local.get $x)
      )
      (i32.const 1)
    )
    (struct.set $struct 0
      (select (result (ref null $struct))
        (ref.null none)
        (local.get $ref)
        (local.get $x)
      )
      (i32.const 2)
    )
  )

  ;; TNH:      (func $select.arm.null.effects (type $void)
  ;; TNH-NEXT:  (local $0 (ref $struct))
  ;; TNH-NEXT:  (local $1 (ref $struct))
  ;; TNH-NEXT:  (struct.set $struct 0
  ;; TNH-NEXT:   (block (result (ref $struct))
  ;; TNH-NEXT:    (local.set $0
  ;; TNH-NEXT:     (call $get-ref)
  ;; TNH-NEXT:    )
  ;; TNH-NEXT:    (block
  ;; TNH-NEXT:     (drop
  ;; TNH-NEXT:      (call $get-null)
  ;; TNH-NEXT:     )
  ;; TNH-NEXT:     (drop
  ;; TNH-NEXT:      (call $get-i32)
  ;; TNH-NEXT:     )
  ;; TNH-NEXT:    )
  ;; TNH-NEXT:    (local.get $0)
  ;; TNH-NEXT:   )
  ;; TNH-NEXT:   (i32.const 1)
  ;; TNH-NEXT:  )
  ;; TNH-NEXT:  (struct.set $struct 0
  ;; TNH-NEXT:   (block (result (ref $struct))
  ;; TNH-NEXT:    (drop
  ;; TNH-NEXT:     (call $get-null)
  ;; TNH-NEXT:    )
  ;; TNH-NEXT:    (block (result (ref $struct))
  ;; TNH-NEXT:     (local.set $1
  ;; TNH-NEXT:      (call $get-ref)
  ;; TNH-NEXT:     )
  ;; TNH-NEXT:     (drop
  ;; TNH-NEXT:      (call $get-i32)
  ;; TNH-NEXT:     )
  ;; TNH-NEXT:     (local.get $1)
  ;; TNH-NEXT:    )
  ;; TNH-NEXT:   )
  ;; TNH-NEXT:   (i32.const 2)
  ;; TNH-NEXT:  )
  ;; TNH-NEXT: )
  ;; NO_TNH:      (func $select.arm.null.effects (type $void)
  ;; NO_TNH-NEXT:  (struct.set $struct 0
  ;; NO_TNH-NEXT:   (select (result (ref null $struct))
  ;; NO_TNH-NEXT:    (call $get-ref)
  ;; NO_TNH-NEXT:    (call $get-null)
  ;; NO_TNH-NEXT:    (call $get-i32)
  ;; NO_TNH-NEXT:   )
  ;; NO_TNH-NEXT:   (i32.const 1)
  ;; NO_TNH-NEXT:  )
  ;; NO_TNH-NEXT:  (struct.set $struct 0
  ;; NO_TNH-NEXT:   (select (result (ref null $struct))
  ;; NO_TNH-NEXT:    (call $get-null)
  ;; NO_TNH-NEXT:    (call $get-ref)
  ;; NO_TNH-NEXT:    (call $get-i32)
  ;; NO_TNH-NEXT:   )
  ;; NO_TNH-NEXT:   (i32.const 2)
  ;; NO_TNH-NEXT:  )
  ;; NO_TNH-NEXT: )
  (func $select.arm.null.effects
    ;; As above but there are conflicting effects and we must add a local when
    ;; we optimize.
    (struct.set $struct 0
      (select (result (ref null $struct))
        (call $get-ref)
        (call $get-null)
        (call $get-i32)
      )
      (i32.const 1)
    )
    (struct.set $struct 0
      (select (result (ref null $struct))
        (call $get-null)
        (call $get-ref)
        (call $get-i32)
      )
      (i32.const 2)
    )
  )

  ;; TNH:      (func $null.arm.null.effects (type $void)
  ;; TNH-NEXT:  (block ;; (replaces something unreachable we can't emit)
  ;; TNH-NEXT:   (drop
  ;; TNH-NEXT:    (block (result nullref)
  ;; TNH-NEXT:     (drop
  ;; TNH-NEXT:      (ref.as_non_null
  ;; TNH-NEXT:       (ref.null none)
  ;; TNH-NEXT:      )
  ;; TNH-NEXT:     )
  ;; TNH-NEXT:     (block (result nullref)
  ;; TNH-NEXT:      (drop
  ;; TNH-NEXT:       (call $get-i32)
  ;; TNH-NEXT:      )
  ;; TNH-NEXT:      (ref.null none)
  ;; TNH-NEXT:     )
  ;; TNH-NEXT:    )
  ;; TNH-NEXT:   )
  ;; TNH-NEXT:   (drop
  ;; TNH-NEXT:    (i32.const 1)
  ;; TNH-NEXT:   )
  ;; TNH-NEXT:   (unreachable)
  ;; TNH-NEXT:  )
  ;; TNH-NEXT: )
  ;; NO_TNH:      (func $null.arm.null.effects (type $void)
  ;; NO_TNH-NEXT:  (struct.set $struct 0
  ;; NO_TNH-NEXT:   (select (result (ref null $struct))
  ;; NO_TNH-NEXT:    (ref.as_non_null
  ;; NO_TNH-NEXT:     (ref.null none)
  ;; NO_TNH-NEXT:    )
  ;; NO_TNH-NEXT:    (ref.null none)
  ;; NO_TNH-NEXT:    (call $get-i32)
  ;; NO_TNH-NEXT:   )
  ;; NO_TNH-NEXT:   (i32.const 1)
  ;; NO_TNH-NEXT:  )
  ;; NO_TNH-NEXT: )
  (func $null.arm.null.effects
    ;; Verify we do not error on a null reference in a select, even if cast to
    ;; non-null.
    (struct.set $struct 0
      (select (result (ref null $struct))
        (ref.as_non_null
          (ref.null none)
        )
        (ref.null none)
        (call $get-i32)
      )
      (i32.const 1)
    )
  )

  ;; TNH:      (func $set-get-cast (type $structref_=>_none) (param $ref structref)
  ;; TNH-NEXT:  (drop
  ;; TNH-NEXT:   (struct.get $struct 0
  ;; TNH-NEXT:    (ref.cast $struct
  ;; TNH-NEXT:     (local.get $ref)
  ;; TNH-NEXT:    )
  ;; TNH-NEXT:   )
  ;; TNH-NEXT:  )
  ;; TNH-NEXT:  (struct.set $struct 0
  ;; TNH-NEXT:   (ref.cast $struct
  ;; TNH-NEXT:    (local.get $ref)
  ;; TNH-NEXT:   )
  ;; TNH-NEXT:   (i32.const 1)
  ;; TNH-NEXT:  )
  ;; TNH-NEXT:  (struct.set $struct 0
  ;; TNH-NEXT:   (ref.cast null $struct
  ;; TNH-NEXT:    (local.get $ref)
  ;; TNH-NEXT:   )
  ;; TNH-NEXT:   (block (result i32)
  ;; TNH-NEXT:    (return)
  ;; TNH-NEXT:    (i32.const 1)
  ;; TNH-NEXT:   )
  ;; TNH-NEXT:  )
  ;; TNH-NEXT: )
  ;; NO_TNH:      (func $set-get-cast (type $structref_=>_none) (param $ref structref)
  ;; NO_TNH-NEXT:  (drop
  ;; NO_TNH-NEXT:   (struct.get $struct 0
  ;; NO_TNH-NEXT:    (ref.cast $struct
  ;; NO_TNH-NEXT:     (local.get $ref)
  ;; NO_TNH-NEXT:    )
  ;; NO_TNH-NEXT:   )
  ;; NO_TNH-NEXT:  )
  ;; NO_TNH-NEXT:  (struct.set $struct 0
  ;; NO_TNH-NEXT:   (ref.cast null $struct
  ;; NO_TNH-NEXT:    (local.get $ref)
  ;; NO_TNH-NEXT:   )
  ;; NO_TNH-NEXT:   (i32.const 1)
  ;; NO_TNH-NEXT:  )
  ;; NO_TNH-NEXT:  (struct.set $struct 0
  ;; NO_TNH-NEXT:   (ref.cast null $struct
  ;; NO_TNH-NEXT:    (local.get $ref)
  ;; NO_TNH-NEXT:   )
  ;; NO_TNH-NEXT:   (block (result i32)
  ;; NO_TNH-NEXT:    (return)
  ;; NO_TNH-NEXT:    (i32.const 1)
  ;; NO_TNH-NEXT:   )
  ;; NO_TNH-NEXT:  )
  ;; NO_TNH-NEXT: )
  (func $set-get-cast (param $ref (ref null struct))
    ;; A nullable cast flowing into a place that traps on null can become a
    ;; non-nullable cast.
    (drop
      (struct.get $struct 0
        (ref.cast null $struct
          (local.get $ref)
        )
      )
    )
    ;; Ditto for a set, at least in traps-happen mode.
    ;; TODO handle non-TNH as well, but we need to be careful of effects in
    ;;      other children.
    (struct.set $struct 0
      (ref.cast null $struct
        (local.get $ref)
      )
      (i32.const 1)
    )
    ;; Even in TNH mode, a child with an effect of control flow transfer
    ;; prevents us from optimizing - if the parent is not necessarily reached,
    ;; we cannot infer the child won't trap.
    (struct.set $struct 0
      (ref.cast null $struct
        (local.get $ref)
      )
      (block (result i32)
        ;; This block has type i32, to check that we don't just look for
        ;; unreachable. We must scan for any transfer of control flow in the
        ;; child of the struct.set.
        (return)
        (i32.const 1)
      )
    )
  )

  ;; Helper functions.

  ;; TNH:      (func $get-i32 (type $none_=>_i32) (result i32)
  ;; TNH-NEXT:  (unreachable)
  ;; TNH-NEXT: )
  ;; NO_TNH:      (func $get-i32 (type $none_=>_i32) (result i32)
  ;; NO_TNH-NEXT:  (unreachable)
  ;; NO_TNH-NEXT: )
  (func $get-i32 (result i32)
    (unreachable)
  )
  ;; TNH:      (func $get-ref (type $none_=>_ref|$struct|) (result (ref $struct))
  ;; TNH-NEXT:  (unreachable)
  ;; TNH-NEXT: )
  ;; NO_TNH:      (func $get-ref (type $none_=>_ref|$struct|) (result (ref $struct))
  ;; NO_TNH-NEXT:  (unreachable)
  ;; NO_TNH-NEXT: )
  (func $get-ref (result (ref $struct))
    (unreachable)
  )
  ;; TNH:      (func $get-null (type $none_=>_nullref) (result nullref)
  ;; TNH-NEXT:  (unreachable)
  ;; TNH-NEXT: )
  ;; NO_TNH:      (func $get-null (type $none_=>_nullref) (result nullref)
  ;; NO_TNH-NEXT:  (unreachable)
  ;; NO_TNH-NEXT: )
  (func $get-null (result (ref null none))
    (unreachable)
  )
)
