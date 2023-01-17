;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; RUN: foreach %s %t wasm-opt --hybrid --closed-world --type-merging -all -S -o - | filecheck %s

(module
  (rec
    ;; CHECK:      (rec
    ;; CHECK-NEXT:  (type $A (struct (field anyref)))
    (type $A (struct_subtype (field anyref) data))
    (type $B (struct_subtype (field anyref) $A))
    ;; CHECK:       (type $F (struct_subtype (field anyref) $A))

    ;; CHECK:       (type $E (struct_subtype (field eqref) $A))

    ;; CHECK:       (type $D (struct_subtype (field (ref any)) $A))

    ;; CHECK:       (type $C (struct_subtype (field anyref) (field f64) $A))
    (type $C (struct_subtype (field anyref) (field f64) $A))
    (type $D (struct_subtype (field (ref any)) $A))
    (type $E (struct_subtype (field eqref) $A))
    (type $F (struct_subtype (field anyref) $A))
  )

  ;; CHECK:       (type $none_=>_none (func))

  ;; CHECK:      (func $foo (type $none_=>_none)
  ;; CHECK-NEXT:  (local $a (ref null $A))
  ;; CHECK-NEXT:  (local $b (ref null $A))
  ;; CHECK-NEXT:  (local $c (ref null $C))
  ;; CHECK-NEXT:  (local $d (ref null $D))
  ;; CHECK-NEXT:  (local $e (ref null $E))
  ;; CHECK-NEXT:  (local $f (ref null $F))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.cast null $A
  ;; CHECK-NEXT:    (local.get $a)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.cast null $F
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
    ;; $D cannot because it refines a field's nullability.
    (local $d (ref null $D))
    ;; $E cannot because it refines a field's heap type.
    (local $e (ref null $E))
    ;; $F cannot because it has a cast.
    (local $f (ref null $F))

    ;; A cast of $A has no effect.
    (drop
      (ref.cast null $A
        (local.get $a)
      )
    )
    ;; A cast of $F prevents it from being merged.
    (drop
      (ref.cast null $F
        (local.get $a)
      )
    )
  )
)

;; Multiple levels of merging.
(module
  ;; CHECK:      (rec
  ;; CHECK-NEXT:  (type $A (struct (field i32)))
  (type $A (struct_subtype (field i32) data))
  (type $B (struct_subtype (field i32) $A))
  (type $C (struct_subtype (field i32) $B))
  ;; CHECK:       (type $D (struct_subtype (field i32) (field f64) $A))
  (type $D (struct_subtype (field i32) (field f64) $A))
  (type $E (struct_subtype (field i32) (field f64) $D))
  (type $F (struct_subtype (field i32) (field f64) $E))
  (type $G (struct_subtype (field i32) (field f64) $F))

  ;; CHECK:       (type $none_=>_none (func))

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

;; As above but now $D is a subtype of $C, so there is a single subtype chain
;; in which we have two "merge points" that things get merged into. The results
;; should remain the same as before, everything merged into either $A or $D.
(module
  ;; CHECK:      (rec
  ;; CHECK-NEXT:  (type $A (struct (field i32)))
  (type $A (struct_subtype (field i32) data))
  ;; CHECK:       (type $B (struct_subtype (field i32) $A))
  (type $B (struct_subtype (field i32) $A))
  ;; CHECK:       (type $C (struct_subtype (field i32) $B))
  (type $C (struct_subtype (field i32) $B))
  ;; CHECK:       (type $D (struct_subtype (field i32) (field f64) $C))
  (type $D (struct_subtype (field i32) (field f64) $C)) ;; this line changed
  (type $E (struct_subtype (field i32) (field f64) $D))
  (type $F (struct_subtype (field i32) (field f64) $E))
  (type $G (struct_subtype (field i32) (field f64) $F))

  ;; CHECK:       (type $none_=>_none (func))

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
    (local $b (ref null $B))
    (local $c (ref null $C))
    (local $d (ref null $D))
    (local $e (ref null $E))
    (local $f (ref null $F))
    (local $g (ref null $G))
  )
)

(module
  ;; CHECK:      (rec
  ;; CHECK-NEXT:  (type $X (struct ))
  (type $X (struct))
  ;; CHECK:       (type $Y (struct_subtype  $X))
  (type $Y (struct_subtype $X))
  ;; CHECK:       (type $A (struct (field (ref null $X))))
  (type $A (struct (field (ref null $X))))
  (type $B (struct_subtype (field (ref null $Y)) $A))
  ;; CHECK:       (type $C (struct_subtype (field (ref $X)) $A))
  (type $C (struct_subtype (field (ref $Y)) $A))

  ;; CHECK:       (type $none_=>_none (func))

  ;; CHECK:      (func $foo (type $none_=>_none)
  ;; CHECK-NEXT:  (local $a (ref null $A))
  ;; CHECK-NEXT:  (local $b (ref null $A))
  ;; CHECK-NEXT:  (local $c (ref null $C))
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $foo
    ;; B can be merged into A even though it refines A's field because that
    ;; refinement will no longer happen after X and Y are also merged.
    (local $a (ref null $A))
    (local $b (ref null $B))
    ;; C cannot be merged because it refines the field's nullability.
    (local $c (ref null $C))
  )
)

(module
  ;; CHECK:      (rec
  ;; CHECK-NEXT:  (type $A (struct (field (ref null $A))))
  (type $A (struct         (ref null $A)))
  (type $B (struct_subtype (ref null $B) $A))

  ;; CHECK:       (type $none_=>_none (func))

  ;; CHECK:      (func $foo (type $none_=>_none)
  ;; CHECK-NEXT:  (local $a (ref null $A))
  ;; CHECK-NEXT:  (local $b (ref null $A))
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $foo
    ;; A recursive subtype can be merged even though its field is a refinement
    ;; as well.
    (local $a (ref null $A))
    (local $b (ref null $B))
  )
)

(module
  (rec
    ;; CHECK:      (rec
    ;; CHECK-NEXT:  (type $X (struct (field (ref null $A)) (field f32)))

    ;; CHECK:       (type $A (struct (field (ref null $X)) (field i32)))
    (type $A (struct         (ref null $X) i32))
    (type $B (struct_subtype (ref null $Y) i32 $A))
    (type $X (struct         (ref null $A) f32))
    (type $Y (struct_subtype (ref null $B) f32 $X))
  )

  ;; CHECK:       (type $none_=>_none (func))

  ;; CHECK:      (func $foo (type $none_=>_none)
  ;; CHECK-NEXT:  (local $a (ref null $A))
  ;; CHECK-NEXT:  (local $b (ref null $A))
  ;; CHECK-NEXT:  (local $x (ref null $X))
  ;; CHECK-NEXT:  (local $y (ref null $X))
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $foo
    ;; Two mutually referential chains, A->B and X->Y, can be merged into a pair
    ;; of mutually referential types.
    (local $a (ref null $A))
    (local $b (ref null $B))
    (local $x (ref null $X))
    (local $y (ref null $Y))
  )
)

(module
  (rec
    ;; CHECK:      (rec
    ;; CHECK-NEXT:  (type $X (struct (field (ref null $A))))

    ;; CHECK:       (type $A (struct (field (ref null $X))))
    (type $A (struct         (ref null $X)))
    (type $B (struct_subtype (ref null $Y) $A))
    (type $X (struct         (ref null $A)))
    (type $Y (struct_subtype (ref null $B) $X))
  )

  ;; CHECK:       (type $none_=>_none (func))

  ;; CHECK:      (func $foo (type $none_=>_none)
  ;; CHECK-NEXT:  (local $a (ref null $A))
  ;; CHECK-NEXT:  (local $b (ref null $A))
  ;; CHECK-NEXT:  (local $x (ref null $X))
  ;; CHECK-NEXT:  (local $y (ref null $X))
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $foo
    ;; As above, but now the A->B and X->Y chains are not differentiated by the
    ;; i32 and f32, so all four types can be merged into a single type.
    ;; TODO: This is not yet implemented. Merge the top level types.
    (local $a (ref null $A))
    (local $b (ref null $B))
    (local $x (ref null $X))
    (local $y (ref null $Y))
  )
)

(module
  ;; CHECK:      (type $X (struct (field anyref)))
  (type $X (struct anyref))
  ;; CHECK:      (type $A (struct (field (ref null $X))))

  ;; CHECK:      (type $Y (struct_subtype (field eqref) $X))
  (type $Y (struct_subtype eqref $X))
  (type $A (struct         (ref null $X)))
  ;; CHECK:      (type $B (struct_subtype (field (ref null $Y)) $A))
  (type $B (struct_subtype (ref null $Y) $A))
  (type $C (struct_subtype (ref null $Y) $A))

  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (func $foo (type $none_=>_none)
  ;; CHECK-NEXT:  (local $a (ref null $A))
  ;; CHECK-NEXT:  (local $b (ref null $B))
  ;; CHECK-NEXT:  (local $c (ref null $B))
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $foo
    ;; B and C cannot be merged into A because they refine A's field, but B and
    ;; C can still be merged with each other even though they are siblings.
    (local $a (ref null $A))
    (local $b (ref null $B))
    (local $c (ref null $C))
  )
)

;; Check that we refinalize properly.
(module
  ;; CHECK:      (rec
  ;; CHECK-NEXT:  (type $A (struct ))
  (type $A (struct))
  ;; CHECK:       (type $B (struct_subtype  $A))
  (type $B (struct_subtype $A))

  ;; CHECK:       (type $none_=>_ref?|$A| (func (result (ref null $A))))

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
  (rec
    ;; CHECK:      (rec
    ;; CHECK-NEXT:  (type $C (struct (field (mut i32))))

    ;; CHECK:       (type $D (struct_subtype (field (mut i32)) (field (mut i32)) $C))

    ;; CHECK:       (type $E (struct_subtype (field (mut i32)) (field (mut i32)) $D))

    ;; CHECK:       (type $H (struct_subtype (field (mut i32)) (field (mut i32)) (field (mut (ref null $D))) $D))

    ;; CHECK:       (type $A (struct_subtype (field (mut i32)) (field (mut i32)) (field (mut (ref null $D))) (field (mut i64)) (field (mut (ref null $I))) $H))

    ;; CHECK:       (type $I (array (mut (ref null $C))))
    (type $I (array (mut (ref null $C))))
    (type $C (struct (field (mut i32))))
    (type $D (struct_subtype (field (mut i32)) (field (mut i32)) $C))
    (type $E (struct_subtype (field (mut i32)) (field (mut i32)) $D))
    (type $F (struct_subtype (field (mut i32)) (field (mut i32)) $E))
    (type $D$to-merge (struct_subtype (field (mut i32)) (field (mut i32)) $F))
    ;; CHECK:       (type $G (func (param (ref $C)) (result (ref $D))))
    (type $G (func (param (ref $C)) (result (ref $D))))
    (type $H (struct_subtype (field (mut i32)) (field (mut i32)) (field (mut (ref null $E))) $D))
    (type $A (struct_subtype (field (mut i32)) (field (mut i32)) (field (mut (ref null $E))) (field (mut i64)) (field (mut (ref null $I))) $H))
    (type $A$to-merge (struct_subtype (field (mut i32)) (field (mut i32)) (field (mut (ref null $E))) (field (mut i64)) (field (mut (ref null $I))) $A))
  )

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
  ;; CHECK-NEXT:   (array.init_static $I)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $0 (type $G) (param $0 (ref $C)) (result (ref $D))
    (struct.new $A$to-merge
      (i32.const 1685)
      (i32.const 0)
      (global.get $global$0)
      (i64.const 0)
      (array.init_static $I)
    )
  )
)

;; Arrays
(module
  ;; CHECK:      (rec
  ;; CHECK-NEXT:  (type $refarray (array anyref))

  ;; CHECK:       (type $sub-refarray-nn (array_subtype (ref any) $refarray))

  ;; CHECK:       (type $intarray (array (mut i32)))
  (type $intarray (array (mut i32)))
  (type $sub-intarray (array_subtype (mut i32) $intarray))

  (type $refarray (array (ref null any)))
  (type $sub-refarray    (array_subtype (ref null any) $refarray))
  (type $sub-refarray-nn (array_subtype (ref      any) $refarray))

  ;; CHECK:       (type $none_=>_none (func))

  ;; CHECK:      (func $foo (type $none_=>_none)
  ;; CHECK-NEXT:  (local $a (ref null $intarray))
  ;; CHECK-NEXT:  (local $b (ref null $intarray))
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $foo
    ;; $A will remain the same.
    (local $a (ref null $intarray))
    ;; $B can be merged into $A.
    (local $b (ref null $sub-intarray))
  )

  ;; CHECK:      (func $bar (type $none_=>_none)
  ;; CHECK-NEXT:  (local $a (ref null $refarray))
  ;; CHECK-NEXT:  (local $b (ref null $refarray))
  ;; CHECK-NEXT:  (local $c (ref null $sub-refarray-nn))
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $bar
    (local $a (ref null $refarray))
    ;; $B can be merged into $A.
    (local $b (ref null $sub-refarray))
    ;; $C cannot be merged as the element type is more refined.
    (local $c (ref null $sub-refarray-nn))
  )
)

;; Function types
(module
  ;; CHECK:      (rec
  ;; CHECK-NEXT:  (type $func (func (param eqref)))
  (type $func (func (param eqref)))
  (type $sub-func (func_subtype (param eqref) $func))
  ;; CHECK:       (type $sub-func-refined (func_subtype (param anyref) $func))
  (type $sub-func-refined (func_subtype (param anyref) $func))

  ;; CHECK:       (type $none_=>_none (func))

  ;; CHECK:      (func $foo (type $none_=>_none)
  ;; CHECK-NEXT:  (local $a (ref null $func))
  ;; CHECK-NEXT:  (local $b (ref null $func))
  ;; CHECK-NEXT:  (local $c (ref null $sub-func-refined))
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $foo
    ;; $func will remain the same.
    (local $a (ref null $func))
    ;; $sub-func will be merged into $func.
    (local $b (ref null $sub-func))
    ;; $sub-func-refined will not be merged into $func because it refines a result.
    (local $c (ref null $sub-func-refined))
  )
)

;; Check that a ref.test inhibits merging (ref.cast is already checked above).
(module
  ;; CHECK:      (type $A (struct ))
  (type $A (struct))
  ;; CHECK:      (type $ref|$A|_=>_i32 (func (param (ref $A)) (result i32)))

  ;; CHECK:      (type $B (struct_subtype  $A))
  (type $B (struct_subtype $A))

  ;; CHECK:      (func $test (type $ref|$A|_=>_i32) (param $a (ref $A)) (result i32)
  ;; CHECK-NEXT:  (ref.test $B
  ;; CHECK-NEXT:   (local.get $a)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test (param $a (ref $A)) (result i32)
    (ref.test $B
      (local.get $a)
    )
  )
)

;; Check that a br_on_cast inhibits merging.
(module
  ;; CHECK:      (type $A (struct ))
  (type $A (struct))
  ;; CHECK:      (type $B (struct_subtype  $A))
  (type $B (struct_subtype $A))

  ;; CHECK:      (type $ref|$A|_=>_ref|$B| (func (param (ref $A)) (result (ref $B))))

  ;; CHECK:      (func $test (type $ref|$A|_=>_ref|$B|) (param $a (ref $A)) (result (ref $B))
  ;; CHECK-NEXT:  (block $__binaryen_fake_return (result (ref $B))
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (br_on_cast $__binaryen_fake_return $B
  ;; CHECK-NEXT:     (local.get $a)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (block $l (result (ref $A))
  ;; CHECK-NEXT:     (br_on_non_null $l
  ;; CHECK-NEXT:      (local.get $a)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (unreachable)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (unreachable)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test (param $a (ref $A)) (result (ref $B))
    (drop
      (br_on_cast 0 $B
        (local.get $a)
      )
    )
    ;; Also check that a different br_on* doesn't confuse us.
    (drop
      (block $l (result (ref $A))
        (br_on_non_null $l
          (local.get $a)
        )
        (unreachable)
      )
    )
    (unreachable)
  )
)

;; Check that a call_indirect inhibits merging.
(module
  ;; CHECK:      (type $A (func))
  (type $A (func))
  ;; CHECK:      (type $B (func_subtype $A))
  (type $B (func_subtype $A))

  (table 1 1 (ref null $A))

  ;; CHECK:      (table $0 1 1 (ref null $A))

  ;; CHECK:      (func $test (type $A)
  ;; CHECK-NEXT:  (call_indirect $0 (type $B)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test (type $A)
    (call_indirect (type $B)
      (i32.const 0)
    )
  )
)
