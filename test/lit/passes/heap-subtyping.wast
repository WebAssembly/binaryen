;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; RUN: foreach %s %t wasm-opt --nominal --heap-refining -all -S -o - | filecheck %s

(module
  ;; A struct with three fields. The first will have no writes, the second one
  ;; write of the same type, and the last a write of a subtype, which will allow
  ;; us to specialize that one.
  ;; CHECK:      (type $struct (struct_subtype (field (mut anyref)) (field (mut anyref)) (field (mut (ref $ref|$struct|_=>_none))) data))
  (type $struct (struct_subtype (field (mut anyref)) (field (mut anyref)) (field (mut anyref)) data))

  ;; CHECK:      (type $ref|$struct|_=>_none (func_subtype (param (ref $struct)) func))

  ;; CHECK:      (elem declare func $work)

  ;; CHECK:      (func $work (type $ref|$struct|_=>_none) (param $struct (ref $struct))
  ;; CHECK-NEXT:  (struct.set $struct 1
  ;; CHECK-NEXT:   (local.get $struct)
  ;; CHECK-NEXT:   (ref.null any)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (struct.set $struct 2
  ;; CHECK-NEXT:   (local.get $struct)
  ;; CHECK-NEXT:   (ref.func $work)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $struct 2
  ;; CHECK-NEXT:    (local.get $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $work (param $struct (ref $struct))
    (struct.set $struct 1
      (local.get $struct)
      (ref.null any)
    )
    (struct.set $struct 2
      (local.get $struct)
      (ref.func $work)
    )
    (drop
      ;; The type of this struct.get must be updated after the field's type
      ;; changes, or the validator will complain.
      (struct.get $struct 2
        (local.get $struct)
      )
    )
  )
)

(module
  ;; A struct with a nullable field and a write of a non-nullable value. We
  ;; must keep the type nullable, unlike in the previous module, due to the
  ;; default value being null.

  ;; CHECK:      (type $struct (struct_subtype (field (mut (ref null $ref|$struct|_=>_none))) data))
  (type $struct (struct_subtype (field (mut anyref)) data))

  ;; CHECK:      (type $ref|$struct|_=>_none (func_subtype (param (ref $struct)) func))

  ;; CHECK:      (elem declare func $work)

  ;; CHECK:      (func $work (type $ref|$struct|_=>_none) (param $struct (ref $struct))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new_default $struct)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (struct.set $struct 0
  ;; CHECK-NEXT:   (local.get $struct)
  ;; CHECK-NEXT:   (ref.func $work)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $work (param $struct (ref $struct))
    (drop
      (struct.new_default $struct)
    )
    (struct.set $struct 0
      (local.get $struct)
      (ref.func $work)
    )
  )
)

(module
  ;; Multiple writes to a field, with a LUB that is not equal to any of them.
  ;; We can at least improve from dataref to a ref of $struct here. Note also
  ;; that we do so in all three types, not just the parent to which we write
  ;; (the children have no writes, but must still be updated).

  ;; CHECK:      (type $struct (struct_subtype (field (mut (ref $struct))) data))
  (type $struct (struct_subtype (field (mut dataref)) data))

  ;; CHECK:      (type $ref|$struct|_ref|$child-A|_ref|$child-B|_=>_none (func_subtype (param (ref $struct) (ref $child-A) (ref $child-B)) func))

  ;; CHECK:      (type $child-A (struct_subtype (field (mut (ref $struct))) $struct))
  (type $child-A (struct_subtype (field (mut dataref)) $struct))

  ;; CHECK:      (type $child-B (struct_subtype (field (mut (ref $struct))) $struct))
  (type $child-B (struct_subtype (field (mut dataref)) $struct))

  ;; CHECK:      (func $work (type $ref|$struct|_ref|$child-A|_ref|$child-B|_=>_none) (param $struct (ref $struct)) (param $child-A (ref $child-A)) (param $child-B (ref $child-B))
  ;; CHECK-NEXT:  (struct.set $struct 0
  ;; CHECK-NEXT:   (local.get $struct)
  ;; CHECK-NEXT:   (local.get $child-A)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (struct.set $struct 0
  ;; CHECK-NEXT:   (local.get $struct)
  ;; CHECK-NEXT:   (local.get $child-B)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $work (param $struct (ref $struct)) (param $child-A (ref $child-A)) (param $child-B (ref $child-B))
    (struct.set $struct 0
      (local.get $struct)
      (local.get $child-A)
    )
    (struct.set $struct 0
      (local.get $struct)
      (local.get $child-B)
    )
  )
)

(module
  ;; As above, but all writes are of $child-A, which allows more optimization
  ;; up to that type.

  ;; CHECK:      (type $child-A (struct_subtype (field (mut (ref $child-A))) $struct))
  (type $child-A (struct_subtype (field (mut dataref)) $struct))

  ;; CHECK:      (type $struct (struct_subtype (field (mut (ref $child-A))) data))
  (type $struct (struct_subtype (field (mut dataref)) data))

  ;; CHECK:      (type $ref|$struct|_ref|$child-A|_=>_none (func_subtype (param (ref $struct) (ref $child-A)) func))

  ;; CHECK:      (type $none_=>_none (func_subtype func))

  ;; CHECK:      (type $child-B (struct_subtype (field (mut (ref $child-A))) $struct))
  (type $child-B (struct_subtype (field (mut dataref)) $struct))

  ;; CHECK:      (func $work (type $ref|$struct|_ref|$child-A|_=>_none) (param $struct (ref $struct)) (param $child-A (ref $child-A))
  ;; CHECK-NEXT:  (struct.set $struct 0
  ;; CHECK-NEXT:   (local.get $struct)
  ;; CHECK-NEXT:   (local.get $child-A)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (struct.set $struct 0
  ;; CHECK-NEXT:   (local.get $struct)
  ;; CHECK-NEXT:   (local.get $child-A)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $work (param $struct (ref $struct)) (param $child-A (ref $child-A))
    (struct.set $struct 0
      (local.get $struct)
      (local.get $child-A)
    )
    (struct.set $struct 0
      (local.get $struct)
      (local.get $child-A)
    )
  )

  ;; CHECK:      (func $keepalive (type $none_=>_none)
  ;; CHECK-NEXT:  (local $temp (ref null $child-B))
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $keepalive
   ;; Add a reference to $child-B just to keep it alive in the output for easier
   ;; comparisons to the previous testcase. Note that $child-B's field will be
   ;; refined, because its parent $struct forces it to be.
   (local $temp (ref null $child-B))
  )
)

(module
  ;; Write to the parent a child, and to the child a parent. The write to the
  ;; child prevents specialization even in the parent and we only improve up to
  ;; $struct but not to $child.

  ;; CHECK:      (type $struct (struct_subtype (field (mut (ref $struct))) data))
  (type $struct (struct_subtype (field (mut dataref)) data))

  ;; CHECK:      (type $child (struct_subtype (field (mut (ref $struct))) $struct))
  (type $child (struct_subtype (field (mut dataref)) $struct))

  ;; CHECK:      (type $ref|$struct|_ref|$child|_=>_none (func_subtype (param (ref $struct) (ref $child)) func))

  ;; CHECK:      (func $work (type $ref|$struct|_ref|$child|_=>_none) (param $struct (ref $struct)) (param $child (ref $child))
  ;; CHECK-NEXT:  (struct.set $struct 0
  ;; CHECK-NEXT:   (local.get $struct)
  ;; CHECK-NEXT:   (local.get $child)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (struct.set $child 0
  ;; CHECK-NEXT:   (local.get $child)
  ;; CHECK-NEXT:   (local.get $struct)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $work (param $struct (ref $struct)) (param $child (ref $child))
    (struct.set $struct 0
      (local.get $struct)
      (local.get $child)
    )
    (struct.set $child 0
      (local.get $child)
      (local.get $struct)
    )
  )
)

(module
  ;; As above, but both writes are of $child, so we can optimize.

  ;; CHECK:      (type $child (struct_subtype (field (mut (ref $child))) $struct))
  (type $child (struct_subtype (field (mut dataref)) $struct))

  ;; CHECK:      (type $struct (struct_subtype (field (mut (ref $child))) data))
  (type $struct (struct_subtype (field (mut dataref)) data))

  ;; CHECK:      (type $ref|$struct|_ref|$child|_=>_none (func_subtype (param (ref $struct) (ref $child)) func))

  ;; CHECK:      (func $work (type $ref|$struct|_ref|$child|_=>_none) (param $struct (ref $struct)) (param $child (ref $child))
  ;; CHECK-NEXT:  (struct.set $struct 0
  ;; CHECK-NEXT:   (local.get $struct)
  ;; CHECK-NEXT:   (local.get $child)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (struct.set $child 0
  ;; CHECK-NEXT:   (local.get $child)
  ;; CHECK-NEXT:   (local.get $child)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $work (param $struct (ref $struct)) (param $child (ref $child))
    (struct.set $struct 0
      (local.get $struct)
      (local.get $child)
    )
    (struct.set $child 0
      (local.get $child)
      (local.get $child)
    )
  )
)

(module
  ;; As in 2 testcases ago, write to the parent a child, and to the child a
  ;; parent, but now the writes happen in struct.new. Even with that precise
  ;; info, however, we can't make the parent field more specific than the
  ;; child's.

  ;; CHECK:      (type $struct (struct_subtype (field (mut (ref $struct))) data))
  (type $struct (struct_subtype (field (mut dataref)) data))

  ;; CHECK:      (type $child (struct_subtype (field (mut (ref $struct))) $struct))
  (type $child (struct_subtype (field (mut dataref)) $struct))

  ;; CHECK:      (type $ref|$struct|_ref|$child|_=>_none (func_subtype (param (ref $struct) (ref $child)) func))

  ;; CHECK:      (func $work (type $ref|$struct|_ref|$child|_=>_none) (param $struct (ref $struct)) (param $child (ref $child))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new $struct
  ;; CHECK-NEXT:    (local.get $child)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new $child
  ;; CHECK-NEXT:    (local.get $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $work (param $struct (ref $struct)) (param $child (ref $child))
    (drop
      (struct.new $struct
        (local.get $child)
      )
    )
    (drop
      (struct.new $child
        (local.get $struct)
      )
    )
  )
)

(module
  ;; Write a parent to the parent and a child to the child. We can specialize
  ;; each of them to contain their own type. This tests that we are aware that
  ;; a struct.new is of a precise type, which means that seeing a type written
  ;; to a parent does not limit specialization in a child.
  ;;
  ;; (Note that we can't do a similar test with struct.set, as that would
  ;; imply the fields are mutable, which limits optimization, see the next
  ;; testcase after this.)

  ;; CHECK:      (type $struct (struct_subtype (field (ref $struct)) data))
  (type $struct (struct_subtype (field dataref) data))

  ;; CHECK:      (type $child (struct_subtype (field (ref $child)) $struct))
  (type $child (struct_subtype (field dataref) $struct))

  ;; CHECK:      (type $ref|$struct|_ref|$child|_=>_none (func_subtype (param (ref $struct) (ref $child)) func))

  ;; CHECK:      (func $work (type $ref|$struct|_ref|$child|_=>_none) (param $struct (ref $struct)) (param $child (ref $child))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new $struct
  ;; CHECK-NEXT:    (local.get $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new $child
  ;; CHECK-NEXT:    (local.get $child)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $work (param $struct (ref $struct)) (param $child (ref $child))
    (drop
      (struct.new $struct
        (local.get $struct)
      )
    )
    (drop
      (struct.new $child
        (local.get $child)
      )
    )
  )
)

(module
  ;; As above, but the fields are mutable. We cannot specialize them to
  ;; different types in this case, and both will become $struct (still an
  ;; improvement!)

  ;; CHECK:      (type $struct (struct_subtype (field (mut (ref $struct))) data))
  (type $struct (struct_subtype (field (mut dataref)) data))

  ;; CHECK:      (type $child (struct_subtype (field (mut (ref $struct))) $struct))
  (type $child (struct_subtype (field (mut dataref)) $struct))

  ;; CHECK:      (type $ref|$struct|_ref|$child|_=>_none (func_subtype (param (ref $struct) (ref $child)) func))

  ;; CHECK:      (func $work (type $ref|$struct|_ref|$child|_=>_none) (param $struct (ref $struct)) (param $child (ref $child))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new $struct
  ;; CHECK-NEXT:    (local.get $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new $child
  ;; CHECK-NEXT:    (local.get $child)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $work (param $struct (ref $struct)) (param $child (ref $child))
    (drop
      (struct.new $struct
        (local.get $struct)
      )
    )
    (drop
      (struct.new $child
        (local.get $child)
      )
    )
  )
)

(module
  ;; As above, but the child also has a new field that is not in the parent. In
  ;; that case there is nothing stopping us from specializing that new field
  ;; to $child.

  ;; CHECK:      (type $struct (struct_subtype (field (mut (ref $struct))) data))
  (type $struct (struct_subtype (field (mut dataref)) data))

  ;; CHECK:      (type $child (struct_subtype (field (mut (ref $struct))) (field (mut (ref $child))) $struct))
  (type $child (struct_subtype (field (mut dataref)) (field (mut dataref)) $struct))

  ;; CHECK:      (type $ref|$struct|_ref|$child|_=>_none (func_subtype (param (ref $struct) (ref $child)) func))

  ;; CHECK:      (func $work (type $ref|$struct|_ref|$child|_=>_none) (param $struct (ref $struct)) (param $child (ref $child))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new $struct
  ;; CHECK-NEXT:    (local.get $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new $child
  ;; CHECK-NEXT:    (local.get $child)
  ;; CHECK-NEXT:    (local.get $child)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $work (param $struct (ref $struct)) (param $child (ref $child))
    (drop
      (struct.new $struct
        (local.get $struct)
      )
    )
    (drop
      (struct.new $child
        (local.get $child)
        (local.get $child)
      )
    )
  )
)

(module
  ;; A copy of a field does not prevent optimization (even though it assigns
  ;; the old type).

  ;; CHECK:      (type $struct (struct_subtype (field (mut (ref $struct))) data))
  (type $struct (struct_subtype (field (mut dataref)) data))

  ;; CHECK:      (type $ref|$struct|_=>_none (func_subtype (param (ref $struct)) func))

  ;; CHECK:      (func $work (type $ref|$struct|_=>_none) (param $struct (ref $struct))
  ;; CHECK-NEXT:  (struct.set $struct 0
  ;; CHECK-NEXT:   (local.get $struct)
  ;; CHECK-NEXT:   (local.get $struct)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (struct.set $struct 0
  ;; CHECK-NEXT:   (local.get $struct)
  ;; CHECK-NEXT:   (struct.get $struct 0
  ;; CHECK-NEXT:    (local.get $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $work (param $struct (ref $struct))
    (struct.set $struct 0
      (local.get $struct)
      (local.get $struct)
    )
    (struct.set $struct 0
      (local.get $struct)
      (struct.get $struct 0
        (local.get $struct)
      )
    )
  )
)

(module
  ;; CHECK:      (type $Y (struct_subtype  $X))
  (type $Y (struct_subtype $X))

  ;; CHECK:      (type $none_=>_none (func_subtype func))

  ;; CHECK:      (type $C (struct_subtype (field (ref $Y)) $A))
  (type $C (struct_subtype (field (ref $X)) $A))

  ;; CHECK:      (type $B (struct_subtype (field (ref $Y)) $A))
  (type $B (struct_subtype (field (ref $X)) $A))

  ;; CHECK:      (type $A (struct_subtype (field (ref $Y)) data))
  (type $A (struct_subtype (field (ref $X)) data))

  ;; CHECK:      (type $X (struct_subtype  data))
  (type $X (struct_subtype data))

  ;; CHECK:      (func $foo (type $none_=>_none)
  ;; CHECK-NEXT:  (local $unused (ref null $C))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new $B
  ;; CHECK-NEXT:    (struct.new_default $Y)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $foo
    ;; A use of type $C without ever creating an instance of it. We do still need
    ;; to update the type if we update the parent type, and we will in fact update
    ;; the parent $A's field from $X to $Y (see below), so we must do the same in
    ;; $C. As a result, all the fields with $X in them in all of $A, $B, $C will
    ;; be improved to contain $Y.
    (local $unused (ref null $C))

    (drop
      (struct.new $B
        (struct.new $Y) ;; This value is more specific than the field, which is an
                        ;; opportunity to subtype, which we do for $B. As $A, our
                        ;; parent, has no writes at all, we can propagate this
                        ;; info to there as well, which means we can perform the
                        ;; same optimization in $A as well.
      )
    )
  )
)

(module
  ;; As above, but remove the struct.new to $B, which means $A, $B, $C all have
  ;; no writes to them. There are no optimizations to do here.

  ;; CHECK:      (type $X (struct_subtype  data))
  (type $X (struct_subtype data))

  ;; CHECK:      (type $none_=>_none (func_subtype func))

  ;; CHECK:      (type $C (struct_subtype (field (ref $X)) $A))
  (type $C (struct_subtype (field (ref $X)) $A))

  ;; CHECK:      (type $B (struct_subtype (field (ref $X)) $A))
  (type $B (struct_subtype (field (ref $X)) $A))

  ;; CHECK:      (type $Y (struct_subtype  $X))
  (type $Y (struct_subtype $X))

  ;; CHECK:      (type $A (struct_subtype (field (ref $X)) data))
  (type $A (struct_subtype (field (ref $X)) data))

  ;; CHECK:      (func $foo (type $none_=>_none)
  ;; CHECK-NEXT:  (local $unused1 (ref null $C))
  ;; CHECK-NEXT:  (local $unused2 (ref null $B))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new_default $Y)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $foo
    (local $unused1 (ref null $C))
    (local $unused2 (ref null $B))
    (drop (struct.new $Y))
  )
)

(module
  ;; CHECK:      (type $X (struct_subtype  data))
  (type $X (struct_subtype data))
  ;; CHECK:      (type $none_=>_none (func_subtype func))

  ;; CHECK:      (type $B (struct_subtype (field (ref $Y)) $A))
  (type $B (struct_subtype (field (ref $Y)) $A))

  ;; CHECK:      (type $A (struct_subtype (field (ref $X)) data))
  (type $A (struct_subtype (field (ref $X)) data))

  ;; CHECK:      (type $Y (struct_subtype  $X))
  (type $Y (struct_subtype $X))

  ;; CHECK:      (func $foo (type $none_=>_none)
  ;; CHECK-NEXT:  (local $unused2 (ref null $B))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new $A
  ;; CHECK-NEXT:    (struct.new_default $X)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $foo
    ;; $B begins with its field of type $Y, which is more specific than the
    ;; field is in the supertype $A. There are no writes to $B, and so we end
    ;; up looking in the parent to see what to do; we should still emit a
    ;; reasonable type for $B, and there is no reason to make it *less*
    ;; specific, so leave things as they are.
    (local $unused2 (ref null $B))
    (drop
      (struct.new $A
        (struct.new $X)
      )
    )
  )
)
