;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; RUN: foreach %s %t wasm-opt --nominal --global-subtyping -all -S -o - | filecheck %s

(module
  ;; A struct with three fields. The first will have no writes, the second one
  ;; write of the same type, and the last a write of a subtype, which will allow
  ;; us to specialize that one.
  ;; CHECK:      (type $struct (struct_subtype (field (mut anyref)) (field (mut anyref)) (field (mut (ref $ref|$struct|_=>_none))) data))
  (type $struct (struct_subtype (field (mut anyref)) (field (mut anyref)) (field (mut anyref)) data))

  ;; CHECK:      (type $ref|$struct|_=>_none (func_subtype (param (ref $struct)) func))

  ;; CHECK:      (elem declare func $work)

  ;; CHECK:      (func $work (param $struct (ref $struct))
  ;; CHECK-NEXT:  (struct.set $struct 1
  ;; CHECK-NEXT:   (local.get $struct)
  ;; CHECK-NEXT:   (ref.null any)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (struct.set $struct 2
  ;; CHECK-NEXT:   (local.get $struct)
  ;; CHECK-NEXT:   (ref.func $work)
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
  )
)

(module
  ;; A struct with a nullable field and a write of a non-nullable value. We
  ;; must keep the type nullable, unlike in the previous module.

  ;; CHECK:      (type $struct (struct_subtype (field (mut (ref null $ref|$struct|_=>_none))) data))
  (type $struct (struct_subtype (field (mut anyref)) data))

  ;; CHECK:      (type $ref|$struct|_=>_none (func_subtype (param (ref $struct)) func))

  ;; CHECK:      (elem declare func $work)

  ;; CHECK:      (func $work (param $struct (ref $struct))
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
  ;; Multiple writes to a field, with a LUB that is not equal to any of them:
  ;; we write the type children of a struct. We can at least improve from
  ;; dataref to a ref of $struct.

  ;; CHECK:      (type $struct (struct_subtype (field (mut (ref $struct))) data))
  (type $struct (struct_subtype (field (mut dataref)) data))

  ;; CHECK:      (type $ref|$struct|_ref|$child-A|_ref|$child-B|_=>_none (func_subtype (param (ref $struct) (ref $child-A) (ref $child-B)) func))

  ;; CHECK:      (type $child-A (struct_subtype (field (mut (ref $struct))) $struct))
  (type $child-A (struct_subtype (field (mut dataref)) $struct))

  ;; CHECK:      (type $child-B (struct_subtype (field (mut (ref $struct))) $struct))
  (type $child-B (struct_subtype (field (mut dataref)) $struct))

  ;; CHECK:      (func $work (param $struct (ref $struct)) (param $child-A (ref $child-A)) (param $child-B (ref $child-B))
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

  ;; CHECK:      (type $struct (struct_subtype (field (mut (ref $child-A))) data))
  (type $struct (struct_subtype (field (mut dataref)) data))

  ;; CHECK:      (type $child-A (struct_subtype (field (mut (ref $child-A))) $struct))
  (type $child-A (struct_subtype (field (mut dataref)) $struct))

  (type $child-B (struct_subtype (field (mut dataref)) $struct))

  ;; CHECK:      (type $ref|$struct|_ref|$child-A|_=>_none (func_subtype (param (ref $struct) (ref $child-A)) func))

  ;; CHECK:      (func $work (param $struct (ref $struct)) (param $child-A (ref $child-A))
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

  ;; CHECK:      (func $work (param $struct (ref $struct)) (param $child (ref $child))
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

  ;; CHECK:      (func $work (param $struct (ref $struct)) (param $child (ref $child))
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
  ;; As in GP, write to the parent a child, and to the child a parent, but now
  ;; the writes happen in struct.new. Even with that precise info, however, we
  ;; can't make the parent field more specific than the child's.

  ;; CHECK:      (type $struct (struct_subtype (field (mut (ref $struct))) data))
  (type $struct (struct_subtype (field (mut dataref)) data))

  ;; CHECK:      (type $child (struct_subtype (field (mut (ref $struct))) $struct))
  (type $child (struct_subtype (field (mut dataref)) $struct))

  ;; CHECK:      (type $ref|$struct|_ref|$child|_=>_none (func_subtype (param (ref $struct) (ref $child)) func))

  ;; CHECK:      (func $work (param $struct (ref $struct)) (param $child (ref $child))
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

