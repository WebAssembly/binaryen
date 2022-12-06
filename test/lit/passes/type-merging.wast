;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; RUN: foreach %s %t wasm-opt --nominal --type-merging -all -S -o - | filecheck %s

(module
  ;; CHECK:      (type $A (struct (field i32)))
  (type $A (struct_subtype (field i32) data))
  (type $B (struct_subtype (field i32) $A))
  ;; CHECK:      (type $D (struct_subtype (field i32) $A))

  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (type $C (struct_subtype (field i32) (field f64) $A))
  (type $C (struct_subtype (field i32) (field f64) $A))
  (type $D (struct_subtype (field i32) $A))

  ;; CHECK:      (func $foo (type $none_=>_none)
  ;; CHECK-NEXT:  (local $a (ref null $A))
  ;; CHECK-NEXT:  (local $b (ref null $A))
  ;; CHECK-NEXT:  (local $c (ref null $C))
  ;; CHECK-NEXT:  (local $d (ref null $D))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.cast_static $A
  ;; CHECK-NEXT:    (local.get $a)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.cast_static $D
  ;; CHECK-NEXT:    (local.get $a)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $foo
    ;; $A will remain the same.
    (local $a (ref null $A))
    ;; $B can be merged into $A.
    (local $b (ref null $B))
    ;; $C cannot because it adds a field.
    (local $c (ref null $C))
    ;; $D cannot because it has a cast.
    (local $d (ref null $D))

    ;; A cast of $A has no effect.
    (drop
      (ref.cast_static $A
        (local.get $a)
      )
    )
    ;; A cast of $D prevents it from being merged.
    (drop
      (ref.cast_static $D
        (local.get $a)
      )
    )
  )
)

;; Multiple levels of merging.
(module
  ;; CHECK:      (type $A (struct (field i32)))
  (type $A (struct_subtype (field i32) data))
  (type $B (struct_subtype (field i32) $A))
  (type $C (struct_subtype (field i32) $B))
  ;; CHECK:      (type $D (struct_subtype (field i32) (field f64) $A))
  (type $D (struct_subtype (field i32) (field f64) $A))
  (type $E (struct_subtype (field i32) (field f64) $D))
  (type $F (struct_subtype (field i32) (field f64) $E))
  (type $G (struct_subtype (field i32) (field f64) $F))

  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (func $foo (type $none_=>_none)
  ;; CHECK-NEXT:  (local $a (ref null $A))
  ;; CHECK-NEXT:  (local $b (ref null $A))
  ;; CHECK-NEXT:  (local $c (ref null $A))
  ;; CHECK-NEXT:  (local $d (ref null $D))
  ;; CHECK-NEXT:  (local $e (ref null $D))
  ;; CHECK-NEXT:  (local $f (ref null $D))
  ;; CHECK-NEXT:  (local $g (ref null $D))
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $foo
    (local $a (ref null $A))
    ;; $B can be merged into $A.
    (local $b (ref null $B))
    ;; $C can be merged into $B, so it will merge into $A.
    (local $c (ref null $C))
    ;; $D cannot be merged into $A as it adds a field.
    (local $d (ref null $D))
    ;; $E can be merged into $D.
    (local $e (ref null $E))
    ;; $F can be merged into $E, so it will merge into $D.
    (local $f (ref null $F))
    ;; $G can be merged into $F, so it will merge into $D.
    (local $g (ref null $G))
  )
)

(module
  ;; CHECK:      (type $A (struct (field (ref null $A))))
  (type $A (struct_subtype (field (ref null $A)) data))
  (type $B (struct_subtype (field (ref null $A)) $A))
  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (type $C (struct_subtype (field (ref null $A)) $A))
  (type $C (struct_subtype (field (ref null $B)) $A))

  ;; CHECK:      (func $foo (type $none_=>_none)
  ;; CHECK-NEXT:  (local $a (ref null $A))
  ;; CHECK-NEXT:  (local $b (ref null $A))
  ;; CHECK-NEXT:  (local $c (ref null $C))
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $foo
    ;; $A will remain the same.
    (local $a (ref null $A))
    ;; $B can be merged into $A.
    (local $b (ref null $B))
    ;; $C refines the field, so it cannot be merged. However, separately, in
    ;; the type definition of $C, its field of type $B should become $A. That
    ;; is, $B should no longer be used anywhere.
    (local $c (ref null $C))
  )
)

;; Check that we refinalize properly.
(module
  ;; CHECK:      (type $A (struct ))
  (type $A (struct))
  (type $B (struct_subtype $A))

  ;; CHECK:      (type $none_=>_ref?|$A| (func (result (ref null $A))))

  ;; CHECK:      (func $returner (type $none_=>_ref?|$A|) (result (ref null $A))
  ;; CHECK-NEXT:  (local $local (ref null $A))
  ;; CHECK-NEXT:  (local.get $local)
  ;; CHECK-NEXT: )
  (func $returner (result (ref null $B))
    (local $local (ref null $B))

    ;; After we change the local to use type $A, we need to update the local.get's
    ;; type as well, or we will error.
    (local.get $local)
  )
)

;; Test some real-world patterns, including fields to ignore, links between
;; merged types, etc.
;;
;; The result here is that we will merge $A$to-merge into $A, and $D$to-merge
;; into $D. While doing so we must update the fields and the expressions that
;; they appear in, and not error.
(module
  ;; CHECK:      (type $C (struct (field (mut i32))))

  ;; CHECK:      (type $D (struct_subtype (field (mut i32)) (field (mut i32)) $C))

  ;; CHECK:      (type $type$2 (array (mut (ref null $C))))
  (type $type$2 (array (mut (ref null $C))))
  (type $C (struct (field (mut i32))))
  (type $D (struct_subtype (field (mut i32)) (field (mut i32)) $C))
  (type $E (struct_subtype (field (mut i32)) (field (mut i32)) $D))
  (type $F (struct_subtype (field (mut i32)) (field (mut i32)) $E))
  (type $D$to-merge (struct_subtype (field (mut i32)) (field (mut i32)) $F))
  ;; CHECK:      (type $G (func (param (ref $C)) (result (ref $D))))
  (type $G (func (param (ref $C)) (result (ref $D))))
  ;; CHECK:      (type $H (struct_subtype (field (mut i32)) (field (mut i32)) (field (mut (ref null $D))) $D))
  (type $H (struct_subtype (field (mut i32)) (field (mut i32)) (field (mut (ref null $E))) $D))
  ;; CHECK:      (type $A (struct_subtype (field (mut i32)) (field (mut i32)) (field (mut (ref null $D))) (field (mut i64)) (field (mut (ref null $type$2))) $H))
  (type $A (struct_subtype (field (mut i32)) (field (mut i32)) (field (mut (ref null $E))) (field (mut i64)) (field (mut (ref null $type$2))) $H))
  (type $A$to-merge (struct_subtype (field (mut i32)) (field (mut i32)) (field (mut (ref null $E))) (field (mut i64)) (field (mut (ref null $type$2))) $A))

  ;; CHECK:      (global $global$0 (ref $D) (struct.new $D
  ;; CHECK-NEXT:  (i32.const 1705)
  ;; CHECK-NEXT:  (i32.const 0)
  ;; CHECK-NEXT: ))
  (global $global$0 (ref $F) (struct.new $D$to-merge
    (i32.const 1705)
    (i32.const 0)
  ))
  ;; CHECK:      (func $0 (type $G) (param $0 (ref $C)) (result (ref $D))
  ;; CHECK-NEXT:  (struct.new $A
  ;; CHECK-NEXT:   (i32.const 1685)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (global.get $global$0)
  ;; CHECK-NEXT:   (i64.const 0)
  ;; CHECK-NEXT:   (array.init_static $type$2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $0 (type $G) (param $0 (ref $C)) (result (ref $D))
    (struct.new $A$to-merge
      (i32.const 1685)
      (i32.const 0)
      (global.get $global$0)
      (i64.const 0)
      (array.init_static $type$2)
    )
  )
)
