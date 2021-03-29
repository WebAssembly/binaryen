;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --optimize-instructions --ignore-implicit-traps --enable-reference-types --enable-gc -S -o - \
;; RUN:   | filecheck %s

(module
  (type $A (struct (field i32)))
  (type $B (struct (field i32) (field f64)))
  (type $C (struct (field i64) (field f32)))

  (func $foo)

  ;; CHECK:      (func $ref-cast-iit (param $a (ref $A)) (param $b (ref $B)) (param $c (ref $C)) (param $a-rtt (rtt $A)) (param $b-rtt (rtt $B)) (param $c-rtt (rtt $C))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block (result (ref $A))
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (local.get $a-rtt)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (local.get $a)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block (result (ref $B))
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (local.get $a-rtt)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (local.get $b)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.cast
  ;; CHECK-NEXT:    (local.get $a)
  ;; CHECK-NEXT:    (local.get $b-rtt)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.cast
  ;; CHECK-NEXT:    (local.get $b)
  ;; CHECK-NEXT:    (local.get $c-rtt)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $ref-cast-iit
    (param $a (ref $A))
    (param $b (ref $B))
    (param $c (ref $C))

    (param $a-rtt (rtt $A))
    (param $b-rtt (rtt $B))
    (param $c-rtt (rtt $C))

    ;; a cast of A to an rtt of A: static subtyping matches.
    (drop
      (ref.cast
        (local.get $a)
        (local.get $a-rtt)
      )
    )
    ;; a cast of B to a supertype: static subtyping matches.
    (drop
      (ref.cast
        (local.get $b)
        (local.get $a-rtt)
      )
    )
    ;; a cast of A to a subtype: static subtyping does not match.
    (drop
      (ref.cast
        (local.get $a)
        (local.get $b-rtt)
      )
    )
    ;; a cast of B to an unrelated type: static subtyping does not match.
    (drop
      (ref.cast
        (local.get $b)
        (local.get $c-rtt)
      )
    )
  )

  ;; CHECK:      (func $ref-cast-iit-bad (param $a (ref $A)) (param $b (ref $B)) (param $c (ref $C)) (param $a-rtt (rtt $A)) (param $b-rtt (rtt $B)) (param $c-rtt (rtt $C))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.cast
  ;; CHECK-NEXT:    (block $block (result (ref $A))
  ;; CHECK-NEXT:     (call $foo)
  ;; CHECK-NEXT:     (local.get $a)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (block $block0 (result (rtt $A))
  ;; CHECK-NEXT:     (call $foo)
  ;; CHECK-NEXT:     (local.get $a-rtt)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.cast
  ;; CHECK-NEXT:    (local.get $a)
  ;; CHECK-NEXT:    (unreachable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.cast
  ;; CHECK-NEXT:    (unreachable)
  ;; CHECK-NEXT:    (local.get $a-rtt)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $ref-cast-iit-bad
    (param $a (ref $A))
    (param $b (ref $B))
    (param $c (ref $C))

    (param $a-rtt (rtt $A))
    (param $b-rtt (rtt $B))
    (param $c-rtt (rtt $C))

    ;; ignore due to the inability to reorder
    (drop
      (ref.cast
        (block (result (ref $A))
          (call $foo)
          (local.get $a)
        )
        (block (result (rtt $A))
          (call $foo)
          (local.get $a-rtt)
        )
      )
    )

    ;; ignore unreachability
    (drop
      (ref.cast
        (local.get $a)
        (unreachable)
      )
    )
    (drop
      (ref.cast
        (unreachable)
        (local.get $a-rtt)
      )
    )
  )
)
